CREATE OR REPLACE FUNCTION recommend_courses(p_user_id BIGINT, p_limit INT DEFAULT 5)
RETURNS TABLE(
    course_id BIGINT,
    title TEXT,
    category TEXT,
    score FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN

RETURN QUERY
WITH recent_activity AS (
    SELECT c.category_id, COUNT(*) AS activity_count
    FROM activity_logs al
    JOIN courses c ON al.course_id = c.id
    WHERE al.user_id = p_user_id
      AND al.activity_time >= NOW() - INTERVAL '30 days'
    GROUP BY c.category_id
),

category_interest AS (
    SELECT category_id,
           activity_count::float / SUM(activity_count) OVER() AS weight
    FROM recent_activity
),

course_popularity AS (
    SELECT course_id, COUNT(*) AS enroll_count
    FROM enrollments
    GROUP BY course_id
),

scored_courses AS (
    SELECT 
        c.id,
        c.title,
        cat.name AS category,
        COALESCE(ci.weight, 0) * 0.4 +
        COALESCE(c.rating/5, 0) * 0.3 +
        COALESCE(cp.enroll_count::float / 
            MAX(cp.enroll_count) OVER(), 0) * 0.3
        AS score
    FROM courses c
    JOIN categories cat ON c.category_id = cat.id
    LEFT JOIN category_interest ci ON ci.category_id = c.category_id
    LEFT JOIN course_popularity cp ON cp.course_id = c.id
    WHERE c.is_active = TRUE
      AND c.id NOT IN (
          SELECT course_id
          FROM enrollments
          WHERE user_id = p_user_id
      )
)

SELECT *
FROM scored_courses
ORDER BY score DESC
LIMIT p_limit;

END;
$$;