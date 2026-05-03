USE db_sanjay_543dd;

WITH base AS (
    SELECT cp.consumer_id, cp.state, ca.credit_score, ca.total_debt, ca.ml_response_score
    FROM consumer_profile cp
    JOIN credit_attributes ca
        ON cp.consumer_id = ca.consumer_id
),

state_filtered AS (
    SELECT *
    FROM base
    WHERE state IN ('CA', 'TX', 'FL')
),

score_filtered AS (
    SELECT *
    FROM state_filtered
    WHERE credit_score >= 680
),

debt_filtered AS (
    SELECT *
    FROM score_filtered
    WHERE total_debt BETWEEN 5000 AND 40000
),

decile_filtered AS (
    SELECT *
    FROM (
        SELECT *,
               NTILE(10) OVER (ORDER BY ml_response_score DESC) AS ml_decile
        FROM debt_filtered
    ) x
    WHERE ml_decile <= 3
),

suppression_filtered AS (
    SELECT d.*
    FROM decile_filtered d
    WHERE NOT EXISTS (
        SELECT 1
        FROM suppression_list s
        WHERE s.consumer_id = d.consumer_id
    )
),

recent_contact_filtered AS (
    SELECT s.*
    FROM suppression_filtered s
    WHERE NOT EXISTS (
        SELECT 1
        FROM campaign_history ch
        WHERE ch.consumer_id = s.consumer_id
          AND ch.campaign_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY)
    )
)

SELECT '01 Base population' AS step_name, COUNT(*) AS record_count FROM base
UNION ALL
SELECT '02 After state filter', COUNT(*) FROM state_filtered
UNION ALL
SELECT '03 After credit score filter', COUNT(*) FROM score_filtered
UNION ALL
SELECT '04 After debt filter', COUNT(*) FROM debt_filtered
UNION ALL
SELECT '05 After top 3 deciles', COUNT(*) FROM decile_filtered
UNION ALL
SELECT '06 After suppression', COUNT(*) FROM suppression_filtered
UNION ALL
SELECT '07 After recent contact exclusion', COUNT(*) FROM recent_contact_filtered;
