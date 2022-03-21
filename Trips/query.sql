SELECT request_at AS day,
       round(count(CASE WHEN trips.status != 'completed' THEN 'ok' END) / count(*)::DECIMAL,2) AS cancellation_rate
FROM trips
WHERE client_id NOT IN (SELECT user_id FROM users WHERE users.banned = 'Yes')
GROUP BY day
ORDER BY day
