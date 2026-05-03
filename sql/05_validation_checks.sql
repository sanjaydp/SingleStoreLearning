USE db_sanjay_543dd;

-- Suppression leak check
WITH final_output AS (
    SELECT sp.*
    FROM (
        SELECT
            cp.consumer_id,
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
    ) sp
    WHERE sp.ml_decile <= 3
      AND NOT EXISTS (
          SELECT 1 FROM suppression_list s
          WHERE s.consumer_id = sp.consumer_id
      )
      AND NOT EXISTS (
          SELECT 1 FROM campaign_history ch
          WHERE ch.consumer_id = sp.consumer_id
            AND ch.campaign_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY)
      )
)
SELECT COUNT(*) AS suppression_leak_count
FROM final_output f
JOIN suppression_list s
    ON f.consumer_id = s.consumer_id;

-- Recent-contact leak check
WITH final_output AS (
    SELECT sp.*
    FROM (
        SELECT
            cp.consumer_id,
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
    ) sp
    WHERE sp.ml_decile <= 3
      AND NOT EXISTS (
          SELECT 1 FROM suppression_list s
          WHERE s.consumer_id = sp.consumer_id
      )
      AND NOT EXISTS (
          SELECT 1 FROM campaign_history ch
          WHERE ch.consumer_id = sp.consumer_id
            AND ch.campaign_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY)
      )
)
SELECT COUNT(*) AS recent_contact_leak_count
FROM final_output f
JOIN campaign_history ch
    ON f.consumer_id = ch.consumer_id
WHERE ch.campaign_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY);
