#!/usr/bin/env python3
"""Deterministic Charmfile repository validation."""

from __future__ import annotations

import json
import os
import re
import sys
import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PLUGINS = ROOT / "plugins"
MARKETPLACE = ROOT / ".agents" / "plugins" / "marketplace.json"
INSTALL_SKILL = ROOT / ".agents" / "skills" / "install-charmfile"
RELEASE_VERSION = "0.1.0-rc.4"
SIDECAR_VERSION = "0.6.1"

EXPECTED_PLUGINS = {
    "charmfile-browser",
    "charmfile-core",
    "charmfile-memory",
    "charmfile-frontend",
    "charmfile-marketing",
    "charmfile-research",
    "charmfile-infrastructure",
    "charmfile-threejs",
}

REQUIRED_FILES = {
    ".gitattributes",
    "INSTALL.md",
    "README.md",
    "AGENTS.md",
    "LICENSE",
    "NOTICE",
    "PRIVACY.md",
    "SECURITY.md",
    "SUPPORT.md",
    "CONTRIBUTING.md",
    "CHANGELOG.md",
    "THIRD_PARTY_NOTICES.md",
    "RELEASE_CHECKLIST.md",
    "docs/SIDECAR_CLOUD_SYNC.md",
    "plugins/charmfile-memory/skills/obsidian-sidecar-setup/references/cloud-sync-contract.md",
}

SEMVER = re.compile(
    r"^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$"
)
SKILL_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
SECRET_PATTERNS = [
    re.compile(r"\bsk-[A-Za-z0-9_-]{16,}\b"),
    re.compile(r"\bgh[oprsu]_[A-Za-z0-9]{20,}\b"),
    re.compile(
        r"(?i)(api[_-]?key|access[_-]?token|refresh[_-]?token|client[_-]?secret)"
        r"\s*[:=]\s*['\"]?[A-Za-z0-9_./+-]{16,}"
    ),
]
PRIVATE_PATTERNS = [
    re.compile("/" + "Users/"),
    re.compile("/" + r"home/[A-Za-z0-9._-]+/"),
    re.compile(r"(?i)\bpersonal" + r"-vps\b"),
    re.compile(r"(?i)\bvultr" + r"1\b"),
]


class ValidationError(RuntimeError):
    pass


def fail(message: str) -> None:
    raise ValidationError(message)


def load_json(path: Path) -> dict:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"invalid JSON at {path.relative_to(ROOT)}: {exc}")


def parse_skill_frontmatter(path: Path) -> tuple[str, str]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    if not lines or lines[0] != "---":
        fail(f"missing YAML frontmatter: {path.relative_to(ROOT)}")
    try:
        end = lines.index("---", 1)
    except ValueError:
        fail(f"unterminated YAML frontmatter: {path.relative_to(ROOT)}")
    metadata: dict[str, str] = {}
    for line in lines[1:end]:
        if not line.strip() or line.startswith((" ", "\t")):
            continue
        if ":" not in line:
            fail(f"invalid frontmatter line in {path.relative_to(ROOT)}: {line}")
        key, value = line.split(":", 1)
        metadata[key.strip()] = value.strip().strip("\"'")
    name = metadata.get("name", "")
    description = metadata.get("description", "")
    if not name or not description:
        fail(f"skill requires name and description: {path.relative_to(ROOT)}")
    if not SKILL_NAME.fullmatch(name):
        fail(f"invalid skill name {name!r}: {path.relative_to(ROOT)}")
    return name, description


def validate_marketplace() -> dict[str, dict]:
    data = load_json(MARKETPLACE)
    if data.get("name") != "charmfile":
        fail("marketplace name must be charmfile")
    entries = data.get("plugins")
    if not isinstance(entries, list):
        fail("marketplace plugins must be a list")
    by_name: dict[str, dict] = {}
    for entry in entries:
        name = entry.get("name")
        if name in by_name:
            fail(f"duplicate marketplace plugin: {name}")
        by_name[name] = entry
        source = entry.get("source") or {}
        expected_path = f"./plugins/{name}"
        if source.get("source") != "local" or source.get("path") != expected_path:
            fail(f"invalid marketplace source for {name}")
        policy = entry.get("policy") or {}
        if policy.get("installation") != "AVAILABLE":
            fail(f"{name} must be AVAILABLE")
        if policy.get("authentication") not in {"ON_INSTALL", "ON_USE"}:
            fail(f"{name} has invalid authentication policy")
        if not entry.get("category"):
            fail(f"{name} is missing a category")
    if set(by_name) != EXPECTED_PLUGINS:
        fail(
            "marketplace plugin mismatch: "
            f"expected {sorted(EXPECTED_PLUGINS)}, got {sorted(by_name)}"
        )
    return by_name


def validate_plugins(marketplace: dict[str, dict]) -> int:
    discovered = {path.name for path in PLUGINS.iterdir() if path.is_dir()}
    if discovered != EXPECTED_PLUGINS:
        fail(
            "plugin directory mismatch: "
            f"expected {sorted(EXPECTED_PLUGINS)}, got {sorted(discovered)}"
        )

    skill_names: set[str] = set()
    skill_count = 0
    for plugin_name in sorted(discovered):
        plugin_dir = PLUGINS / plugin_name
        manifest_path = plugin_dir / ".codex-plugin" / "plugin.json"
        manifest = load_json(manifest_path)
        if manifest.get("name") != plugin_name:
            fail(f"manifest name mismatch in {plugin_name}")
        if not SEMVER.fullmatch(str(manifest.get("version", ""))):
            fail(f"invalid semver in {plugin_name}")
        if manifest.get("version") != RELEASE_VERSION:
            fail(
                f"{plugin_name} version must match release {RELEASE_VERSION}"
            )
        if manifest.get("skills") != "./skills/":
            fail(f"{plugin_name} must declare ./skills/")
        if manifest.get("license") != "Apache-2.0":
            fail(f"{plugin_name} must declare Apache-2.0")
        author = manifest.get("author") or {}
        interface = manifest.get("interface") or {}
        for value_name, value in {
            "description": manifest.get("description"),
            "author.name": author.get("name"),
            "interface.displayName": interface.get("displayName"),
            "interface.shortDescription": interface.get("shortDescription"),
            "interface.longDescription": interface.get("longDescription"),
            "interface.developerName": interface.get("developerName"),
            "interface.category": interface.get("category"),
        }.items():
            if not isinstance(value, str) or not value.strip():
                fail(f"{plugin_name} is missing {value_name}")
        if plugin_name not in marketplace:
            fail(f"{plugin_name} is absent from marketplace")

        skills_dir = plugin_dir / "skills"
        skill_dirs = [path for path in skills_dir.iterdir() if path.is_dir()]
        if not skill_dirs:
            fail(f"{plugin_name} contains no skills")
        for skill_dir in sorted(skill_dirs):
            skill_path = skill_dir / "SKILL.md"
            if not skill_path.is_file():
                fail(f"missing SKILL.md in {skill_dir.relative_to(ROOT)}")
            name, _description = parse_skill_frontmatter(skill_path)
            if name != skill_dir.name:
                fail(
                    f"skill folder/name mismatch: {skill_dir.name} contains {name}"
                )
            if name in skill_names:
                fail(f"duplicate skill name: {name}")
            skill_names.add(name)
            skill_count += 1
    return skill_count


def validate_agentic_installer() -> None:
    skill_path = INSTALL_SKILL / "SKILL.md"
    if not skill_path.is_file():
        fail("missing source-visible install-charmfile skill")
    name, _description = parse_skill_frontmatter(skill_path)
    if name != "install-charmfile":
        fail("agentic installer skill name must be install-charmfile")
    contract = INSTALL_SKILL / "references" / "install-contract.md"
    if not contract.is_file():
        fail("agentic installer is missing its install contract")


def iter_text_files() -> list[Path]:
    paths: list[Path] = []
    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue
        relative = path.relative_to(ROOT)
        if any(part in {".git", "dist", "__pycache__"} for part in relative.parts):
            continue
        try:
            path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        paths.append(path)
    return paths


def validate_content() -> None:
    for relative in REQUIRED_FILES:
        if not (ROOT / relative).is_file():
            fail(f"missing required file: {relative}")

    for path in iter_text_files():
        text = path.read_text(encoding="utf-8")
        relative = path.relative_to(ROOT)
        if ("[" + "TODO:") in text or ("Local" + " developer") in text:
            fail(f"placeholder remains in {relative}")
        for pattern in PRIVATE_PATTERNS:
            if pattern.search(text):
                fail(f"private path or host pattern in {relative}: {pattern.pattern}")
        for pattern in SECRET_PATTERNS:
            if pattern.search(text):
                fail(f"credential-shaped value in {relative}: {pattern.pattern}")

    for path in PLUGINS.rglob("*"):
        if not path.is_file():
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        if re.search(r"(?i)\bwix\b", text):
            fail(f"Wix-specific content is packaged in {path.relative_to(ROOT)}")

    if any(path.name == ".env" for path in ROOT.rglob(".env")):
        fail("plaintext .env file found")

    memory_contract = (
        PLUGINS
        / "charmfile-memory"
        / "skills"
        / "obsidian-sidecar-setup"
        / "references"
        / "install-contract.md"
    ).read_text(encoding="utf-8")
    if f"SIDECAR_VERSION={SIDECAR_VERSION}" not in memory_contract:
        fail(
            "memory install contract must pin the reviewed Sidecar "
            f"{SIDECAR_VERSION} release"
        )

    executable_paths = [
        ROOT / "scripts" / "install-charmfile",
        ROOT
        / "plugins"
        / "charmfile-core"
        / "skills"
        / "charmfile-setup"
        / "scripts"
        / "charmfile",
        ROOT
        / "plugins"
        / "charmfile-core"
        / "skills"
        / "charmfile-setup"
        / "assets"
        / "charmfile-codex",
        ROOT
        / "plugins"
        / "charmfile-core"
        / "skills"
        / "charmfile-setup"
        / "assets"
        / "charmfile-launcher",
        ROOT
        / "plugins"
        / "charmfile-browser"
        / "skills"
        / "browser-setup"
        / "scripts"
        / "charmfile-browser",
        ROOT
        / "plugins"
        / "charmfile-browser"
        / "skills"
        / "playwright-live-chrome"
        / "scripts"
        / "chrome-session.zsh",
    ]
    for executable in executable_paths:
        if not executable.is_file() or not os.access(executable, os.X_OK):
            fail(f"required executable bit is missing: {executable.relative_to(ROOT)}")

    profile_text = (
        PLUGINS
        / "charmfile-core"
        / "skills"
        / "charmfile-setup"
        / "assets"
        / "charmfile.config.toml"
    ).read_text(encoding="utf-8")
    try:
        profile = tomllib.loads(profile_text)
    except tomllib.TOMLDecodeError as exc:
        fail(f"portable profile is invalid TOML: {exc}")
    for forbidden in (
        'approval_policy = "never"',
        'sandbox_mode = "danger-full-access"',
        "model = ",
        "[projects.",
        "bearer_token",
        "http_headers",
    ):
        if forbidden in profile_text:
            fail(f"portable profile contains forbidden setting: {forbidden}")
    if profile.get("approval_policy") != "on-request":
        fail("portable profile must use on-request approval")
    if profile.get("sandbox_mode") != "workspace-write":
        fail("portable profile must use workspace-write sandboxing")
    expected_mcp = {
        "openaiDeveloperDocs": {
            "url": "https://developers.openai.com/mcp"
        }
    }
    if profile.get("mcp_servers") != expected_mcp:
        fail("portable profile must contain only the public OpenAI docs MCP recipe")


def main() -> int:
    try:
        marketplace = validate_marketplace()
        skill_count = validate_plugins(marketplace)
        validate_agentic_installer()
        validate_content()
    except ValidationError as exc:
        print(f"[fail] {exc}", file=sys.stderr)
        return 1
    print(f"[ok] marketplace: {len(marketplace)} plugins")
    print(f"[ok] plugin skills: {skill_count}")
    print("[ok] source-visible agentic installer skill")
    print("[ok] personal-path, secret, placeholder, and excluded-integration scans")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
