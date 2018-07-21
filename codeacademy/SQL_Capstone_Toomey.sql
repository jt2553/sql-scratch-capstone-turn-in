
SELECT COUNT(DISTINCT utm_campaign) AS 'Number of campaigns', COUNT(DISTINCT utm_source) AS 'Number of sources'
FROM page_visits;

SELECT DISTINCT utm_campaign AS 'Campaign', utm_source AS 'Source'
FROM page_visits
GROUP BY 1;

SELECT DISTINCT page_name AS 'Pages'
FROM page_visits;

/* Number of first touches for each campaign
*/
WITH first_touch AS (
    SELECT user_id,
    MIN(timestamp) as first_touch_at
FROM page_visits
GROUP BY user_id),

ft_attributed AS (
    SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)

SELECT fta.utm_source AS 'Source', 
    fta.utm_campaign AS 'Campaign', 
    COUNT(*) AS 'Count'
FROM ft_attributed fta
GROUP BY 2
ORDER BY 3 DESC;

/* Number of last touches for each campaign
*/
WITH last_touch AS (
    SELECT user_id,
    MAX(timestamp) as last_touch_at
FROM page_visits
GROUP BY user_id),

lt_attributed AS (
    SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)

SELECT lta.utm_source AS 'Source', 
    lta.utm_campaign AS 'Campaign', 
    COUNT(*) AS 'Count'
FROM lt_attributed lta
GROUP BY 2
ORDER BY 3 DESC;

/* 
Number of visitors making a purchase
*/
SELECT COUNT(DISTINCT(user_id)) as 'Number of visitors making a purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

/* 
 Number of last touches ON THE PURCHASE PAGE 
for each campaign
*/
WITH last_touch AS (
    SELECT user_id,
    MAX(timestamp) as last_touch_at
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY user_id),

lt_attributed AS (
    SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    pv.page_name
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
                                                                                                                   )
SELECT lta.utm_source AS 'Source', 
    lta.utm_campaign AS 'Campaign', 
    COUNT(*) AS 'Count'
FROM lt_attributed lta
GROUP BY 2
ORDER BY 3 DESC;
                      

