# Efficient DataForSEO Workflows

## Decision Rules

- Use `live` for ad hoc interactive work, low volume, and endpoint families that only expose live collection.
- Use Standard async (`task_post` then `tasks_ready`/`task_get`) for SERP, Keyword Data, Merchant, App Data, Business Data, OnPage, and other high-volume task systems.
- Use `postback_url`/`pingback_url` for production-scale jobs where polling would waste calls; use `tasks_ready` for Codex/manual jobs and moderate batches.
- Use Sandbox for unfamiliar endpoints, schema checks, and examples that should not spend credits. Do not use Sandbox or free calls as a substitute when the user needs real market, keyword, SERP, product, or visibility data.
- Use official docs for exact limits per endpoint. General guidance from DataForSEO: 2,000 requests/minute, up to 100 tasks in a Standard POST where supported, `tasks_ready` 20 requests/minute, `user_data` 6 requests/minute, `status`/`errors` 10 requests/minute, and 30 simultaneous requests for database-like APIs such as Labs, Backlinks, OnPage, Content Analysis, DataForSEO Trends, and AI Optimization.

## Cost Controls

- Treat cost controls as budget discipline, not a mandate to avoid paid data. Prefer a scoped paid pull over a free but weaker answer when the data quality difference matters.
- Start with `/v3/appendix/user_data`; inspect remaining balance/rates if relevant.
- For exploratory business research, run a 1-2 seed proof pass before expanding to a larger paid batch.
- Keep SERP `depth` at 10 unless the user needs deeper results; depth above 10 can add charges.
- Avoid HTML results unless raw markup is specifically needed.
- Avoid optional paid SERP parameters such as high priority, asynchronous AI overview, People Also Ask click depth, pixel rectangles, screenshots, and Lighthouse unless they directly answer the task.
- Use `stop_crawl_on_match` for rank checks when the goal is only to find a known domain.
- De-duplicate keywords/domains/URLs before sending tasks. Cache by endpoint + payload + date.
- Report `cost` from every response and estimate multiplied cost before broad batches.

## Market / Product Opportunity Flow

1. Define the market, geography, language, product category, and business constraint the user actually cares about.
2. Start from a small seed set: current products, competitor domains, category terms, customer problems, or locations.
3. Pull demand and economics from Google Ads keyword data, Labs keyword ideas/search intent, Trends/clickstream where useful, and Amazon/Merchant endpoints when product sales data matters.
4. Pull SERP or Merchant/Amazon competitor data only for the highest-potential clusters.
5. Score opportunities by demand, CPC/competition, commercial intent, SERP difficulty, seasonality, margin fit, fulfillment complexity, and whether the user can realistically win.
6. Return a short ranked table with evidence, caveats, raw JSON paths, and next test actions.

## Ads Research Flow

1. Separate live account optimization from external market research. Use ads-platform/Chrome evidence for existing-account changes; use DataForSEO for demand, CPC, competitor, SERP, and expansion data.
2. Pull Google Ads keyword volume/CPC/competition and related keyword ideas for the target service/product/location.
3. Check SERP ads or advertisers when competitor messaging or auction presence matters.
4. Group terms into campaign/ad-group themes, flag negative keyword candidates, and identify landing-page or offer gaps.
5. Do not recommend budget increases from DataForSEO alone; pair external demand with first-party Ads/GA4/booking evidence when changing live spend.

## Keyword Opportunity Flow

1. Normalize seed keywords, market, language, and date.
2. Pull keyword expansion from one or more:
   - Google Ads `keywords_for_keywords` or `keywords_for_site` for search volume/CPC/competition.
   - DataForSEO Labs `keyword_ideas`, `related_keywords`, `keyword_suggestions`, `search_intent`, and `bulk_keyword_difficulty`.
   - Google Trends/DataForSEO Trends or clickstream volume for demand shape.
3. De-duplicate and score by search volume, CPC, competition, relevance, intent, and trend direction.
4. For priority terms only, pull SERP `advanced` results to identify competitors, SERP features, local packs, ads, PAA, and content format.
5. Return a compact table plus raw JSON file paths.

## SERP / Competitor Flow

1. Choose engine and vertical: Google organic, AI Mode, Maps, Local Finder, News, Images, Jobs, Autocomplete, YouTube, Bing, etc.
2. Use `location_code` and `language_code` when possible; cache locations/languages.
3. Use `advanced` for structured SERP features; use `regular` for simple ranking snapshots; use `html` only for markup inspection.
4. Add `device`/`os` only when mobile/desktop differences matter.
5. Extract `items` into rank, type, title, URL/domain, snippet, displayed URL, SERP feature fields, and the original task data.
6. Summarize competitors by domain frequency, rank distribution, SERP features, and content intent.

## OnPage Audit Flow

1. Create a crawl with `/v3/on_page/task_post`, setting target, crawl limits, and only the options needed.
2. Poll `/v3/on_page/tasks_ready` or use callbacks.
3. Pull summary first, then specific data: `pages`, `links`, `resources`, `duplicate_tags`, `duplicate_content`, `non_indexable`, `redirect_chains`, `waterfall`, `keyword_density`, `microdata`.
4. Use `raw_html`, `page_screenshot`, `content_parsing`, and Lighthouse only for selected URLs or when the user asks for those artifacts.
5. Prioritize findings by traffic/rank/value when paired with SERP or keyword data.

## Backlink / Authority Flow

1. Start with `/v3/backlinks/summary/live` and `/history/live` for scope and trend.
2. Pull `referring_domains`, `backlinks`, `anchors`, and `domain_pages` with filters and limits.
3. For gap analysis, use `competitors`, `domain_intersection`, or `page_intersection`.
4. Normalize domains, dedupe linking pages, flag nofollow/sponsored/UGC, and group by authority/rank and topic.

## Local / Reviews / Business Flow

1. Use SERP Maps or Local Finder for location-specific ranking snapshots.
2. Use Business Listings search for entity discovery and Google Business endpoints for business info, updates, reviews, extended reviews, and Q&A.
3. Use Tripadvisor/Trustpilot when the user asks for travel, hospitality, reputation, or third-party reviews.
4. Store place ids, location codes, query, language, and timestamp with each result.

## AI Visibility Flow

1. Use AI Optimization LLM Mentions for brand/domain visibility and aggregated metrics.
2. Use ChatGPT/Claude/Gemini/Perplexity LLM responses when the user needs model-specific answer snapshots.
3. Pair AI Optimization results with Google AI Mode SERP and organic SERP data to compare answer visibility against search visibility.
4. Treat AI response snapshots as time-sensitive; always include model, location/language, prompt, and collection time.

## Bulk Standard Pattern

1. Build an array of task objects with unique `tag` values.
2. Post in chunks of at most 100 tasks unless the endpoint docs specify a smaller limit.
3. Save posted task ids, tags, endpoint, payload hash, and response cost.
4. Poll `tasks_ready` with backoff; do not exceed endpoint rate limits.
5. Collect with `task_get` using the desired result type (`regular`, `advanced`, `html`, or endpoint-specific form).
6. Retry transient transport failures with exponential backoff; inspect `/errors` or `tasks_fixed` for task-level failures.

## Output Shape

For user-facing answers, avoid dumping raw payloads. Provide:

- a concise answer and why the data supports it;
- a table of the highest-signal rows;
- methods: endpoint paths, location/language/device, date/time, and depth/limits;
- cost and task status summary;
- local raw JSON paths when files were saved.
