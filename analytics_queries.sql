--5 Most active users

SELECT 
    user_id, 
	Users.name, 
	COUNT(*) AS activity_count
FROM activity_logs
NATURAL JOIN Users
GROUP BY user_id, Users.name
ORDER BY activity_count DESC
LIMIT 5;

--Most popular Categories in the last 30 days

SELECT cat.name, COUNT(*) AS activity_count
FROM activity_logs al
NATURAL JOIN course c 
NATURAL JOIN category cat 
WHERE al.activity_time >= NOW() - INTERVAL '30 days'
GROUP BY cat.name
ORDER BY activity_count DESC;


--30 Days User retention
WITH first_activity AS (
    SELECT user_id, MIN(activity_time) AS first_time
    FROM activity_logs
    GROUP BY user_id
),
returned_users AS (
    SELECT DISTINCT fa.user_id
    FROM first_activity fa
    JOIN activity_logs al
      ON fa.user_id = al.user_id
     AND al.activity_time > fa.first_time
     AND al.activity_time <= fa.first_time + INTERVAL '30 days'
)
SELECT 
    COUNT(DISTINCT returned_users.user_id)::float /
    COUNT(DISTINCT first_activity.user_id) * 100
    AS retention_rate_percentage
FROM first_activity
LEFT JOIN returned_users
ON first_activity.user_id = returned_users.user_id;

--Courses with highest dropout rate
--this calculates the dropout rate for various courses by comparing total enrollments to actual user activity
-- It identifies which courses are failing to keep students engaged by measuring the gap between signing up and actually participating.

WITH enrollment_counts AS (
    SELECT course_id, COUNT(*) AS enrolled
    FROM enrollments
    GROUP BY course_id
),
active_users AS (
    SELECT DISTINCT course_id, user_id
    FROM activity_logs
),
completion_ratio AS (
    SELECT 
        e.course_id,
        COUNT(DISTINCT a.user_id)::float / e.enrolled AS engagement_ratio
    FROM enrollment_counts e
    LEFT JOIN active_users a
    ON e.course_id = a.course_id
    GROUP BY e.course_id, e.enrolled
)
SELECT course_id,
       1 - engagement_ratio AS dropout_rate
FROM completion_ratio
ORDER BY dropout_rate DESC;

