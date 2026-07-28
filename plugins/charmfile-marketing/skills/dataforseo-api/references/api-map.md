# DataForSEO API Map

Use this as a navigation layer. For exact fields, enums, examples, and pricing notes, fetch the official endpoint page or OpenAPI schema before sending paid requests.

## Official Sources

- API home and LLM-friendly docs: https://docs.dataforseo.com/v3/ and https://docs.dataforseo.com/v3/llms.txt/
- Authentication: https://docs.dataforseo.com/v3/auth/
- OpenAPI spec: https://github.com/dataforseo/OpenApiDocumentation
- Rate/request limits: https://dataforseo.com/help-center/rate-limits-and-request-limits
- Sandbox: https://docs.dataforseo.com/v3/appendix/sandbox/
- API errors: https://docs.dataforseo.com/v3/appendix-errors/
- User data/account usage: https://docs.dataforseo.com/v3/appendix-user-data/

## Shared Concepts

- Base URL: `https://api.dataforseo.com/v3/`; sandbox host: `https://sandbox.dataforseo.com/v3/`.
- Auth: Basic Auth with DataForSEO API login and API password.
- Response success: top-level `status_code: 20000`; task creation/completion statuses may be in `tasks[].status_code`.
- Standard async endpoints usually follow `task_post`, `tasks_ready`, and `task_get/.../{id}`.
- Live endpoints usually return data in one POST and are best for small or interactive pulls.
- Location/language endpoints are per search engine or product family; cache them.

## Endpoint Families

| Family | Use For | Common Paths |
|---|---|---|
| Appendix | Account usage, errors, service status, webhook resend, sandbox docs | `/v3/appendix/user_data`, `/v3/appendix/errors`, `/v3/appendix/status` |
| SERP API | Organic SERPs, AI Mode, Maps, Local Finder, News, Images, Jobs, Autocomplete, YouTube, Bing/Yahoo/Baidu/Naver/Seznam | `/v3/serp/google/organic/live/advanced`, `/v3/serp/google/organic/task_post`, `/v3/serp/google/maps/live/advanced`, `/v3/serp/youtube/organic/live/advanced` |
| AI Optimization API | LLM scraper, LLM responses, LLM mentions, AI keyword data for ChatGPT, Claude, Gemini, Perplexity | `/v3/ai_optimization/llm_mentions/search/live`, `/v3/ai_optimization/chat_gpt/llm_responses/live`, `/v3/ai_optimization/ai_keyword_data/keywords_search_volume/live` |
| Keywords Data API | Google/Bing Ads keyword volume, keyword ideas from site/keywords, Google Trends, DataForSEO Trends, clickstream volume | `/v3/keywords_data/google_ads/search_volume/live`, `/v3/keywords_data/google_ads/keywords_for_keywords/live`, `/v3/keywords_data/google_trends/explore/live` |
| DataForSEO Labs API | Keyword ideas, related/suggested keywords, difficulty, search intent, ranked keywords, competitors, intersections, traffic estimates, Amazon/app intelligence | `/v3/dataforseo_labs/google/keyword_ideas/live`, `/v3/dataforseo_labs/google/related_keywords/live`, `/v3/dataforseo_labs/google/ranked_keywords/live`, `/v3/dataforseo_labs/google/domain_intersection/live` |
| Domain Analytics API | Technologies and Whois | `/v3/domain_analytics/technologies/domain_technologies/live`, `/v3/domain_analytics/whois/overview/live` |
| Backlinks API | Backlink summaries, histories, backlinks, anchors, pages, referring domains/networks, competitor and intersection analysis | `/v3/backlinks/summary/live`, `/v3/backlinks/backlinks/live`, `/v3/backlinks/referring_domains/live`, `/v3/backlinks/domain_intersection/live` |
| OnPage API | Crawls, page/resource/link analysis, duplicate tags/content, non-indexable pages, waterfall, screenshots, parsing, Lighthouse | `/v3/on_page/task_post`, `/v3/on_page/tasks_ready`, `/v3/on_page/summary`, `/v3/on_page/pages`, `/v3/on_page/links`, `/v3/on_page/lighthouse/live/json` |
| Content Analysis API | Web content search, summary, sentiment, rating distribution, phrase/category trends | `/v3/content_analysis/search/live`, `/v3/content_analysis/summary/live`, `/v3/content_analysis/sentiment_analysis/live` |
| Merchant API | Google Shopping and Amazon product/seller/product-info data | `/v3/merchant/google/products/task_post`, `/v3/merchant/amazon/products/task_post` |
| App Data API | Google Play/App Store app search, app info, reviews, listings | `/v3/app_data/google/app_searches/task_post`, `/v3/app_data/apple/app_info/task_post` |
| Business Data API | Business listings, Google Business info/updates/hotels/reviews/Q&A, Trustpilot, Tripadvisor, social media | `/v3/business_data/business_listings/search/live`, `/v3/business_data/google/my_business_info/live`, `/v3/business_data/google/reviews/task_post` |
| Databases | Bulk database downloads for backlinks, SERPs, keywords, products, listings, Whois, business listings | Use only after checking the docs and cost model; database access patterns differ from task/live endpoints. |

## OpenAPI Discovery

Use the helper when a user asks for a product area but not a path:

```bash
python3 scripts/dfs.py endpoints --query "business_data google reviews"
python3 scripts/dfs.py endpoints --query "on_page duplicate"
python3 scripts/dfs.py endpoints --query "ai_optimization llm_mentions"
```

If the helper output is insufficient, fetch the raw OpenAPI spec and search paths:

```bash
curl -fsSL https://raw.githubusercontent.com/dataforseo/OpenApiDocumentation/master/openapi_specification.yaml \
  | rg '^  /v3/.*keyword'
```
