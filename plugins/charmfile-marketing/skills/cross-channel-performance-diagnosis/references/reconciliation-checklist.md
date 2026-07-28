# Reconciliation Checklist

Before comparing sources, capture:

1. Business outcome: leads, purchases, bookings, revenue, profit, calls, forms, or another goal.
2. Date ranges, timezones, and whether each platform reports by interaction date or conversion date.
3. Currency and whether revenue includes tax, fees, discounts, refunds, cancellations, or offline adjustments.
4. Attribution model and window for each source.
5. Conversion definitions and whether they are primary, secondary, imported, modeled, or key events.
6. Source naming rules: auto-tagging, UTMs, campaign IDs, channel groupings, and account/campaign names.
7. Deduplication keys such as transaction ID, booking ID, lead ID, email hash, or order ID.
8. Known delays: ad platform conversion lag, GA4 processing, CRM sync, booking engine export timing, offline import timing.
9. Landing pages, products/services, geo, device, and campaign segments for the affected movement.

## Truth Table Columns

Use these when possible:

- source
- date range
- spend
- sessions or clicks
- leads/bookings/purchases
- revenue or conversion value
- CPA/CAC
- ROAS
- attribution basis
- caveat

## Interpretation Rules

- Do not force numbers to match when attribution definitions differ.
- Explain expected differences first, then suspicious differences.
- Treat user-facing revenue or booking systems as business truth when available, but use platform data to diagnose source and intent.
- When a platform is sampled, filtered, or visibly incomplete, mark confidence lower and request/export better evidence.
