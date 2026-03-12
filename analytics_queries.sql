SELECT user_id, COUNT(*) AS activity_count
FROM activity_logs
GROUP BY user_id
ORDER BY activity_count DESC
LIMIT 5;