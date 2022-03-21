WITH counts AS (SELECT t.request_at,
                count(CASE WHEN u.banned = 'No'
                    THEN 'ok' END) AS total_requests,
                count(CASE WHEN t.status <> 'completed'
                      THEN 'x' END) AS cancelled_only,
                count(CASE WHEN t.status <> 'completed' AND u.banned = 'Yes'
                       THEN 'y' END) AS dup
                FROM trips t
                JOIN users u ON t.client_id = u.user_id
                GROUP BY t.request_at
                ORDER BY t.request_at
       ),
       diff AS (SELECT *,
                cancelled_only - dup AS cancelled_requests
                FROM counts
       )

SELECT  request_at AS "Day",
        round(cancelled_requests / total_requests::decimal,2) AS "Cancellation Rate"
FROM diff
