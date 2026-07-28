#!/usr/bin/env python3
"""Small DataForSEO v3 CLI for Codex skills."""

from __future__ import annotations

import argparse
import base64
import json
import os
import pathlib
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from typing import Any


API_BASE = "https://api.dataforseo.com"
SANDBOX_BASE = "https://sandbox.dataforseo.com"
OPENAPI_URL = "https://raw.githubusercontent.com/dataforseo/OpenApiDocumentation/master/openapi_specification.yaml"
OK_MIN = 20000
OK_MAX = 29999


class DataForSeoError(RuntimeError):
    pass


def read_env_file(path: str | pathlib.Path) -> dict[str, str]:
    values: dict[str, str] = {}
    p = pathlib.Path(path).expanduser()
    if not p.exists():
        return values
    for raw in p.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip("'\"")
        values[key] = value
    return values


def candidate_env_files(explicit: str | None = None) -> list[pathlib.Path]:
    files: list[pathlib.Path] = []
    if explicit:
        files.append(pathlib.Path(explicit).expanduser())
    if os.environ.get("DATAFORSEO_ENV_FILE"):
        files.append(pathlib.Path(os.environ["DATAFORSEO_ENV_FILE"]).expanduser())
    deduped: list[pathlib.Path] = []
    seen: set[str] = set()
    for p in files:
        key = str(p)
        if key not in seen:
            deduped.append(p)
            seen.add(key)
    return deduped


def load_credentials(explicit_env_file: str | None = None) -> tuple[str, str, str]:
    merged = dict(os.environ)
    login = merged.get("DATAFORSEO_LOGIN") or merged.get("DATAFORSEO_USER") or merged.get("DATAFORSEO_USERNAME")
    password = merged.get("DATAFORSEO_PASSWORD") or merged.get("DATAFORSEO_PASS")
    if login and password:
        return login, password, "environment"
    source = "environment"
    for path in candidate_env_files(explicit_env_file):
        env_values = read_env_file(path)
        login = env_values.get("DATAFORSEO_LOGIN") or env_values.get("DATAFORSEO_USER") or env_values.get("DATAFORSEO_USERNAME")
        password = env_values.get("DATAFORSEO_PASSWORD") or env_values.get("DATAFORSEO_PASS")
        if login and password:
            merged.update(env_values)
            source = "explicit env file"
            break
    login = merged.get("DATAFORSEO_LOGIN") or merged.get("DATAFORSEO_USER") or merged.get("DATAFORSEO_USERNAME")
    password = merged.get("DATAFORSEO_PASSWORD") or merged.get("DATAFORSEO_PASS")
    if not login or not password:
        searched = "\n".join(f"  - {p}" for p in candidate_env_files(explicit_env_file))
        raise DataForSeoError(
            "Missing DataForSEO credentials. Set DATAFORSEO_LOGIN/DATAFORSEO_PASSWORD "
            "or DATAFORSEO_USER/DATAFORSEO_PASS. Searched:\n" + searched
        )
    return login, password, source


def auth_header(login: str, password: str) -> str:
    token = base64.b64encode(f"{login}:{password}".encode("utf-8")).decode("ascii")
    return f"Basic {token}"


def normalize_url(path: str, sandbox: bool) -> str:
    if path.startswith("http://") or path.startswith("https://"):
        parsed = urllib.parse.urlparse(path)
        if parsed.netloc in {"api.dataforseo.com", "sandbox.dataforseo.com"}:
            base = SANDBOX_BASE if sandbox else API_BASE
            return base + parsed.path + (f"?{parsed.query}" if parsed.query else "")
        return path
    if not path.startswith("/"):
        path = "/" + path
    if not path.startswith("/v3/"):
        path = "/v3" + path
    return (SANDBOX_BASE if sandbox else API_BASE) + path


def load_json_value(value: str | None, file_path: str | None) -> Any:
    if file_path:
        text = pathlib.Path(file_path).expanduser().read_text(encoding="utf-8")
    elif value:
        if value.startswith("@"):
            text = pathlib.Path(value[1:]).expanduser().read_text(encoding="utf-8")
        else:
            text = value
    else:
        return None
    return json.loads(text)


def api_request(
    method: str,
    path: str,
    body: Any = None,
    *,
    sandbox: bool = False,
    env_file: str | None = None,
    timeout: int = 120,
) -> Any:
    login, password, _source = load_credentials(env_file)
    url = normalize_url(path, sandbox)
    data = None if body is None else json.dumps(body).encode("utf-8")
    req = urllib.request.Request(url, data=data, method=method.upper())
    req.add_header("Authorization", auth_header(login, password))
    req.add_header("Content-Type", "application/json")
    req.add_header("Accept", "application/json")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as response:
            raw = response.read()
            content_type = response.headers.get("Content-Type", "")
    except urllib.error.HTTPError as exc:
        raw = exc.read()
        content_type = exc.headers.get("Content-Type", "")
        message = raw.decode("utf-8", errors="replace")
        raise DataForSeoError(f"HTTP {exc.code} for {url}: {message[:2000]}") from exc
    if "json" in content_type or raw[:1] in {b"{", b"["}:
        return json.loads(raw.decode("utf-8"))
    return raw.decode("utf-8", errors="replace")


def is_ok_status(code: Any) -> bool:
    return isinstance(code, int) and OK_MIN <= code <= OK_MAX


def validate_api_status(data: Any, *, allow_api_errors: bool = False) -> None:
    if allow_api_errors or not isinstance(data, dict):
        return
    code = data.get("status_code")
    if code is not None and not is_ok_status(code):
        raise DataForSeoError(f"DataForSEO status_code {code}: {data.get('status_message')}")
    for task in data.get("tasks") or []:
        task_code = task.get("status_code")
        if task_code is not None and not is_ok_status(task_code):
            task_id = task.get("id") or task.get("task_id") or "<no id>"
            raise DataForSeoError(f"Task {task_id} status_code {task_code}: {task.get('status_message')}")


def write_json(data: Any, out: str | None, pretty: bool = True) -> None:
    text = json.dumps(data, indent=2 if pretty else None, ensure_ascii=False)
    if out:
        pathlib.Path(out).expanduser().write_text(text + "\n", encoding="utf-8")
    else:
        print(text)


def redact_account(data: Any) -> Any:
    if isinstance(data, dict):
        redacted = {}
        for key, value in data.items():
            if key.lower() in {"login", "password", "authorization", "token"}:
                redacted[key] = "[REDACTED]"
            else:
                redacted[key] = redact_account(value)
        return redacted
    if isinstance(data, list):
        return [redact_account(item) for item in data]
    return data


def first_user_result(data: Any) -> dict[str, Any]:
    if not isinstance(data, dict):
        return {}
    for task in data.get("tasks") or []:
        result = task.get("result") or []
        if result and isinstance(result[0], dict):
            return result[0]
    return {}


def summarize_user_data(data: Any, source: str, login: str) -> dict[str, Any]:
    result = first_user_result(data)
    summary: dict[str, Any] = {
        "ok": True,
        "status_code": data.get("status_code") if isinstance(data, dict) else None,
        "status_message": data.get("status_message") if isinstance(data, dict) else None,
        "cost": data.get("cost") if isinstance(data, dict) else None,
        "credential_source": source,
        "credential_login_hint": login[:2] + "..." if login else "[REDACTED]",
    }
    for key in [
        "timezone",
        "money_balance",
        "balance",
        "api_balance",
        "backlinks_subscription_expiry_date",
        "llm_mentions_subscription_expiry_date",
    ]:
        if key in result:
            summary[key] = result[key]
    day_limits = (((result.get("rates") or {}).get("limits") or {}).get("day") or {})
    if isinstance(day_limits, dict):
        families = sorted(
            key
            for key, value in day_limits.items()
            if isinstance(value, dict) and not key.startswith("total")
        )
        if families:
            summary["rate_limit_families_present"] = families
    return summary


def iter_chunks(items: list[Any], size: int) -> list[list[Any]]:
    return [items[i : i + size] for i in range(0, len(items), size)]


def extract_task_records(response: dict[str, Any]) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for task in response.get("tasks") or []:
        records.append(
            {
                "id": task.get("id"),
                "tag": (task.get("data") or {}).get("tag") or task.get("tag"),
                "status_code": task.get("status_code"),
                "status_message": task.get("status_message"),
                "cost": task.get("cost"),
            }
        )
    return records


def cmd_auth_check(args: argparse.Namespace) -> None:
    login, _password, source = load_credentials(args.env_file)
    data = api_request("GET", "/v3/appendix/user_data", sandbox=args.sandbox, env_file=args.env_file, timeout=args.timeout)
    validate_api_status(data, allow_api_errors=args.allow_api_errors)
    if args.full:
        out = redact_account(data)
        out["_credential_source"] = source
        out["_credential_login_hint"] = login[:2] + "..." if login else "[REDACTED]"
    else:
        out = summarize_user_data(data, source, login)
    write_json(out, args.out)


def cmd_request(args: argparse.Namespace) -> None:
    body = load_json_value(args.data, args.data_file)
    data = api_request(args.method, args.path, body, sandbox=args.sandbox, env_file=args.env_file, timeout=args.timeout)
    validate_api_status(data, allow_api_errors=args.allow_api_errors)
    write_json(data, args.out, pretty=not args.compact)


def cmd_task_post(args: argparse.Namespace) -> None:
    payload = load_json_value(args.data, args.data_file)
    if isinstance(payload, dict):
        payload = [payload]
    if not isinstance(payload, list):
        raise DataForSeoError("task-post payload must be a JSON object or array of task objects")
    all_responses: list[Any] = []
    all_records: list[dict[str, Any]] = []
    for chunk in iter_chunks(payload, args.chunk_size):
        response = api_request("POST", args.path, chunk, sandbox=args.sandbox, env_file=args.env_file, timeout=args.timeout)
        validate_api_status(response, allow_api_errors=args.allow_api_errors)
        all_responses.append(response)
        all_records.extend(extract_task_records(response))
        if args.sleep:
            time.sleep(args.sleep)
    if args.ids_out:
        out_path = pathlib.Path(args.ids_out).expanduser()
        out_path.write_text("\n".join(json.dumps(record, ensure_ascii=False) for record in all_records) + "\n", encoding="utf-8")
    write_json({"responses": all_responses, "task_records": all_records}, args.out)


def cmd_task_get(args: argparse.Namespace) -> None:
    ids: list[str] = []
    if args.ids:
        ids.extend(args.ids)
    if args.ids_file:
        for line in pathlib.Path(args.ids_file).expanduser().read_text(encoding="utf-8").splitlines():
            if not line.strip():
                continue
            try:
                row = json.loads(line)
                ids.append(row["id"])
            except json.JSONDecodeError:
                ids.append(line.strip())
    results = []
    for task_id in ids:
        path = args.path_template.replace("{id}", task_id)
        response = api_request("GET", path, sandbox=args.sandbox, env_file=args.env_file, timeout=args.timeout)
        validate_api_status(response, allow_api_errors=args.allow_api_errors)
        results.append({"id": task_id, "response": response})
        if args.sleep:
            time.sleep(args.sleep)
    write_json(results, args.out)


def cmd_standard(args: argparse.Namespace) -> None:
    payload = load_json_value(args.data, args.data_file)
    if isinstance(payload, dict):
        payload = [payload]
    if not isinstance(payload, list):
        raise DataForSeoError("standard payload must be a JSON object or array of task objects")
    posted: list[dict[str, Any]] = []
    for chunk in iter_chunks(payload, args.chunk_size):
        response = api_request("POST", args.post_path, chunk, sandbox=args.sandbox, env_file=args.env_file, timeout=args.timeout)
        validate_api_status(response, allow_api_errors=args.allow_api_errors)
        posted.extend(extract_task_records(response))
        if args.post_sleep:
            time.sleep(args.post_sleep)
    wanted = {record["id"] for record in posted if record.get("id")}
    ready: set[str] = set()
    deadline = time.time() + args.timeout_seconds
    while wanted - ready:
        if time.time() > deadline:
            break
        response = api_request("GET", args.ready_path, sandbox=args.sandbox, env_file=args.env_file, timeout=args.timeout)
        validate_api_status(response, allow_api_errors=args.allow_api_errors)
        for task in response.get("tasks") or []:
            for item in task.get("result") or []:
                task_id = item.get("id")
                if task_id in wanted:
                    ready.add(task_id)
        if wanted - ready:
            time.sleep(args.poll_interval)
    results = []
    for task_id in sorted(ready):
        path = args.get_path_template.replace("{id}", task_id)
        response = api_request("GET", path, sandbox=args.sandbox, env_file=args.env_file, timeout=args.timeout)
        validate_api_status(response, allow_api_errors=args.allow_api_errors)
        results.append({"id": task_id, "response": response})
        if args.get_sleep:
            time.sleep(args.get_sleep)
    write_json({"posted": posted, "ready_ids": sorted(ready), "missing_ids": sorted(wanted - ready), "results": results}, args.out)


def cmd_endpoints(args: argparse.Namespace) -> None:
    with urllib.request.urlopen(OPENAPI_URL, timeout=args.timeout) as response:
        spec = response.read().decode("utf-8")
    terms = [term.lower() for term in args.query.split()] if args.query else []
    matches = []
    for line in spec.splitlines():
        stripped = line.strip()
        if not stripped.startswith("/v3/"):
            continue
        path = stripped.rstrip(":")
        haystack = path.lower()
        if all(term in haystack for term in terms):
            matches.append(path)
    for path in matches[: args.limit]:
        print(path)


def add_common(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--env-file", help="Path to .env with DATAFORSEO_LOGIN/PASSWORD or USER/PASS")
    parser.add_argument("--sandbox", action="store_true", help="Use sandbox.dataforseo.com")
    parser.add_argument("--timeout", type=int, default=120, help="HTTP timeout in seconds")
    parser.add_argument("--allow-api-errors", action="store_true", help="Do not exit on DataForSEO status_code errors")
    parser.add_argument("--out", help="Write JSON output to file")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="DataForSEO v3 helper CLI")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("auth-check", help="Call /v3/appendix/user_data with redaction")
    add_common(p)
    p.add_argument("--full", action="store_true", help="Print the full redacted account payload")
    p.set_defaults(func=cmd_auth_check)

    p = sub.add_parser("request", help="Call any DataForSEO v3 endpoint")
    add_common(p)
    p.add_argument("method", choices=["GET", "POST", "get", "post"])
    p.add_argument("path", help="Endpoint path, e.g. /v3/serp/google/organic/live/advanced")
    p.add_argument("--data", help="JSON payload string or @file")
    p.add_argument("--data-file", help="JSON payload file")
    p.add_argument("--compact", action="store_true", help="Print compact JSON")
    p.set_defaults(func=cmd_request)

    p = sub.add_parser("task-post", help="Post Standard tasks in chunks")
    add_common(p)
    p.add_argument("path", help="task_post endpoint path")
    p.add_argument("--data", help="JSON object/array string or @file")
    p.add_argument("--data-file", help="JSON payload file")
    p.add_argument("--chunk-size", type=int, default=100)
    p.add_argument("--sleep", type=float, default=0.0, help="Seconds between chunks")
    p.add_argument("--ids-out", help="Write task id records as JSONL")
    p.set_defaults(func=cmd_task_post)

    p = sub.add_parser("task-get", help="Collect task_get results for ids")
    add_common(p)
    p.add_argument("path_template", help="Path with {id}, e.g. /v3/serp/google/organic/task_get/advanced/{id}")
    p.add_argument("--ids", nargs="*", help="Task ids")
    p.add_argument("--ids-file", help="JSONL or plain text id file")
    p.add_argument("--sleep", type=float, default=0.0, help="Seconds between GET calls")
    p.set_defaults(func=cmd_task_get)

    p = sub.add_parser("standard", help="Post tasks, poll tasks_ready, collect task_get results")
    add_common(p)
    p.add_argument("--post-path", required=True)
    p.add_argument("--ready-path", required=True)
    p.add_argument("--get-path-template", required=True)
    p.add_argument("--data", help="JSON object/array string or @file")
    p.add_argument("--data-file", help="JSON payload file")
    p.add_argument("--chunk-size", type=int, default=100)
    p.add_argument("--poll-interval", type=float, default=15.0)
    p.add_argument("--timeout-seconds", type=int, default=600)
    p.add_argument("--post-sleep", type=float, default=0.0)
    p.add_argument("--get-sleep", type=float, default=0.0)
    p.set_defaults(func=cmd_standard)

    p = sub.add_parser("endpoints", help="Search official OpenAPI endpoint paths")
    p.add_argument("--query", default="", help="Space-separated terms all required in path")
    p.add_argument("--limit", type=int, default=200)
    p.add_argument("--timeout", type=int, default=60)
    p.set_defaults(func=cmd_endpoints)
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    try:
        args.func(args)
    except DataForSeoError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
