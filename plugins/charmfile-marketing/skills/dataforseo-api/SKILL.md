---
name: dataforseo-api
description: Use DataForSEO API v3 for live market, product, ads, and SEO research. Trigger when Codex needs external demand data, products to sell, market sizing, keyword volume/CPC, Google Ads keyword research, SERP or competitor analysis, local SEO/maps/reviews, backlinks, on-page audits, merchant/Amazon/app data, content analysis, domain analytics, AI/LLM visibility, or efficient paid SEO data pipelines with batching, polling, sandbox, and cost controls.
---

# DataForSEO API

Use this skill to plan and run DataForSEO v3 calls without leaking credentials or wasting paid requests. Be cost-aware, not cost-avoidant: paid Live or Standard calls are acceptable when they provide materially better evidence than free, sandbox, or generic web data.

## Quick Start

- Use `scripts/dfs.py` for authenticated API calls, endpoint discovery, batching `task_post` payloads, polling `tasks_ready`, and collecting `task_get` results.
- Read `references/workflows.md` when deciding Live vs Standard, designing a market/product/ads/SEO/SERP/on-page/backlink/local/AI workflow, or controlling cost.
- Read `references/api-map.md` when choosing endpoint families or locating official docs. For exact endpoint parameters, fetch the linked official docs or OpenAPI spec before making a paid request.

## Credentials

Load credentials in this order:

1. Keychain-backed injection:
   `codex-secrets run DATAFORSEO_LOGIN DATAFORSEO_PASSWORD -- <command>`.
2. Environment variables: `DATAFORSEO_LOGIN`/`DATAFORSEO_PASSWORD`, or
   `DATAFORSEO_USER`/`DATAFORSEO_PASS`.
3. An explicitly selected `DATAFORSEO_ENV_FILE` or `--env-file` when the user
   intentionally manages credentials that way.

Never paste or store the actual login/password in the skill, output files, prompts, or logs. The helper redacts auth material in credential checks.

## Default Use

Use DataForSEO as the default data source when a user asks for current search demand, product opportunity, local market visibility, SEO evidence, competitor discovery, ad keyword opportunity, CPC/competition, backlinks, SERP shape, on-page crawl evidence, or AI search visibility. Prefer scoped paid DataForSEO evidence over weaker free workarounds when real volume, CPC, SERP, competitor, product, or visibility data is needed. Do not use it for ordinary web browsing, generic brainstorming, or tasks that can be answered from the user's first-party tools alone.

Keep Codex as the operator. A subagent may help critique a research plan or summarize raw exports, but the parent Codex thread scopes paid API calls, runs them, and reports the cost.

## Research Modes

- **Market/product opportunity**: combine Google Ads keyword volume/CPC, Labs keyword ideas/search intent, Trends or clickstream when useful, Amazon or Merchant endpoints for product demand, and SERP checks for competitor strength.
- **Ads research**: pull keyword volume, CPC, competition, related terms, SERP ads/advertisers where relevant, then return action-ready campaign/ad-group/negative-keyword implications.
- **SEO/competitor research**: pair keyword expansion with SERP advanced results, ranked keywords, domain intersections, backlinks, and OnPage crawl data only when the site needs technical verification.
- **Local business research**: use Maps/Local Finder and Business Data for local rankings, listings, reviews, Q&A, and competitor presence by location.
- **AI visibility**: use AI Optimization LLM Mentions, AI Keyword Data, and model-specific response snapshots; always include model/source, prompt/query, location/language, and collection time.

## Efficient Default Pattern

1. Clarify the SEO question and the smallest data needed to answer it.
2. Check account access with the free `auth-check` command when credentials or account state are uncertain; do not repeat it as ceremony before every paid pull.
3. Use Sandbox when validating request shape or unfamiliar endpoints. Skip Sandbox when the endpoint and payload are familiar and the task needs real live data.
4. Prefer Live endpoints for small, interactive pulls; prefer Standard `task_post` + `tasks_ready`/`task_get` or callbacks for bulk work.
5. Batch Standard POST calls up to 100 tasks where the endpoint supports it. Add a unique `tag` to every task.
6. Cache locations, languages, raw JSON responses, and expensive endpoint results by keyword/domain/location/date.
7. Request `advanced` results only when SERP feature structure matters; avoid HTML, screenshots, Lighthouse, pixel rectangles, large depths, and high priority unless the user explicitly needs them.
8. Report total `cost` fields from responses and summarize any non-success API or task status codes.

## Helper Examples

```bash
# Free compact auth and account check; redacts login-like fields.
python3 scripts/dfs.py auth-check

# Full redacted account/rate payload only when needed.
python3 scripts/dfs.py auth-check --full --out dataforseo-user-data.json

# Discover endpoint names from the official OpenAPI spec.
python3 scripts/dfs.py endpoints --query "keyword_ideas"

# Discover product, ads, and AI visibility endpoints.
python3 scripts/dfs.py endpoints --query "amazon product competitors"
python3 scripts/dfs.py endpoints --query "google_ads search_volume live"
python3 scripts/dfs.py endpoints --query "ai_optimization llm_mentions"

# One small Live SERP request.
python3 scripts/dfs.py request POST /v3/serp/google/organic/live/advanced \
  --data '[{"keyword":"bike rentals waikiki","location_code":2840,"language_code":"en","depth":10}]' \
  --out serp.json

# Standard async SERP flow: post, poll Tasks Ready, collect advanced results.
python3 scripts/dfs.py standard \
  --post-path /v3/serp/google/organic/task_post \
  --ready-path /v3/serp/google/organic/tasks_ready \
  --get-path-template '/v3/serp/google/organic/task_get/advanced/{id}' \
  --data-file serp_tasks.json \
  --out serp_results.json

# Use sandbox for request-shape checks.
python3 scripts/dfs.py request POST /v3/dataforseo_labs/google/related_keywords/live \
  --sandbox --data '[{"keyword":"seo api","location_code":2840,"language_code":"en"}]'
```

## Response Handling

Treat HTTP 2xx as transport success only. DataForSEO responses also include API `status_code`, per-task `status_code`, `status_message`, `cost`, `tasks_count`, and `tasks_error`. Preserve raw JSON, then produce a compact analysis layer with:

- request purpose, endpoint, location/language/device, and collection time;
- total cost and any paid options used;
- failed, delayed, or missing tasks by id/tag;
- extracted rows relevant to the user, not the entire raw payload unless asked.

## Safety

- Do not run broad paid pulls without a tight scope, budget expectation, or sandbox/schema pass.
- Do not optimize for `$0` at the cost of weak or dummy data. If a scoped paid pull is the right evidence, run the paid pull and report the cost.
- Use one or two seed terms/domains first, then expand only if the first result proves the direction is useful.
- Do not poll `tasks_ready` faster than necessary; use callbacks for high-volume systems.
- Do not include DataForSEO credentials in generated scripts for user projects; load from env or a local secret file.
- Do not save transient keyword volumes, CPCs, SERP rows, account data, or product-market reads as durable memory.
