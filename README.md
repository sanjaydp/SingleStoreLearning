# SingleStore Campaign Audience Extraction Workflow

A small SQL-first project that simulates a consumer-credit campaign extraction workflow using **SingleStore**.  
The project demonstrates how to translate campaign requirements into SQL, apply score deciles, suppressions, recent-contact exclusions, waterfall counts, and validation checks.

## Why I built this

This project was built to better understand a SQL-heavy campaign/order-pulling workflow similar to what consumer credit intelligence and marketing analytics teams use.

The goal is to simulate:

- Consumer profile + credit attribute data
- Client-defined campaign filters
- ML score decile selection
- Suppression list exclusion
- Recent-contact exclusion
- Waterfall count analysis
- Final validation checks

## Tech Stack

- SingleStore
- SQL
- Window functions
- Anti-join logic using `NOT EXISTS`
- Waterfall analysis using CTEs
- Validation queries

## Business Scenario

Client request:

> Pull consumers in CA, TX, and FL with credit score >= 680, total debt between $5,000 and $40,000, top 3 ML response-score deciles, excluding suppressed consumers and anyone contacted in the last 60 days.

## Tables

### `consumer_profile`
Stores demographic and location attributes.

### `credit_attributes`
Stores credit score, ML response score, and debt attributes.

### `suppression_list`
Stores consumers that must be excluded from campaign output.

### `campaign_history`
Stores prior campaign contact, response, and conversion records.

## Workflow

1. Load sample consumer and credit data.
2. Apply geography, credit score, and debt filters.
3. Use `NTILE(10)` to create ML score deciles.
4. Keep top 3 deciles.
5. Exclude suppression-list records.
6. Exclude consumers contacted in the last 60 days.
7. Produce final campaign output.
8. Run waterfall count analysis.
9. Validate that suppressed and recently contacted consumers did not leak into the output.

## Waterfall Output

The demo produced the following waterfall:

| Step | Record Count |
|---|---:|
| Base population | 10 |
| After state filter | 9 |
| After credit score filter | 7 |
| After debt filter | 6 |
| After top 3 deciles | 3 |
| After suppression | 3 |
| After recent contact exclusion | 1 |

## Validation Results

| Check | Result |
|---|---:|
| Suppression leak count | 0 |
| Recent-contact leak count | 0 |

## Key SQL Concepts Demonstrated

- Multi-table joins
- CTE-based query organization
- `NTILE(10)` for decile segmentation
- `NOT EXISTS` anti-join suppression logic
- Date filtering using `DATE_SUB`
- Waterfall analysis
- Data quality validation

## Notes on SingleStore

While creating this project, I adjusted the table design to follow SingleStore's shard-key requirements.  
For example, tables using `SHARD KEY (consumer_id)` also include `consumer_id` in the primary key where required.

This helped demonstrate how table design and distributed query execution considerations matter in SingleStore.

## How to Run

Run the SQL files in this order:

```text
sql/01_create_tables.sql
sql/02_insert_sample_data.sql
sql/03_campaign_extraction.sql
sql/04_waterfall_analysis.sql
sql/05_validation_checks.sql
```
