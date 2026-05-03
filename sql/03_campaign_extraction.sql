USE db_sanjay_543dd;

WITH scored_population AS (
    SELECT
        cp.consumer_id,
        cp.first_name,
        cp.last_name,
        cp.state,
        ca.credit_score,
        ca.ml_response_score,
        ca.total_debt,
        NTILE(10) OVER (ORDER BY ca.ml_response_score DESC) AS ml_decile
    FROM consumer_profile cp
    JOIN credit_attributes ca
        ON cp.consumer_id = ca.consumer_id
    WHERE cp.state IN ('CA', 'TX', 'FL')
      AND ca.credit_score >= 680
      AND ca.total_debt BETWEEN 5000 AND 40000
),

recent_contacts AS (
    SELECT DISTINCT consumer_id
    FROM campaign_history
    WHERE campaign_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY)
),

eligible_population AS (
    SELECT sp.*
    FROM scored_population sp
    WHERE sp.ml_decile <= 3
      AND NOT EXISTS (
          SELECT 1
          FROM suppression_list s
          WHERE s.consumer_id = sp.consumer_id
      )
      AND NOT EXISTS (
          SELECT 1
          FROM recent_contacts rc
          WHERE rc.consumer_id = sp.consumer_id
      )
)

SELECT *
FROM eligible_population
ORDER BY ml_response_score DESC;
