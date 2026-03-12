-- Insert Categories
INSERT INTO Category (name) 
VALUES ('Development'), ('Business'), ('Design'), ('Marketing'), ('Lifestyle');

-- Insert 100 Users
INSERT INTO Users (name, email, created_at)
SELECT 
    'User_' || i AS name,
    'user' || i || '@example.com' AS email,
    NOW() - (random() * INTERVAL '365 days')
FROM generate_series(1, 100) AS i;

INSERT INTO Course (title, category_id, rating, is_active)
SELECT 
    'Course ' || i AS title,
    floor(random() * 5 + 1)::int AS category_id,
    (random() * 4 + 1)::numeric(2,1) AS rating,
    random() > 0.1 -- 90% are active
FROM generate_series(1, 50) AS i;

-- Random Enrollments (Approx 2 per user)
INSERT INTO enrollments (user_id, course_id, enrolled_at)
SELECT 
    floor(random() * 100 + 1)::int, 
    floor(random() * 50 + 1)::int,
    NOW() - (random() * INTERVAL '100 days')
FROM generate_series(1, 200)
ON CONFLICT DO NOTHING; -- Prevents duplicate user/course pairs

-- Random Reviews
INSERT INTO course_reviews (user_id, course_id, rating, comment)
SELECT 
    floor(random() * 100 + 1)::int,
    floor(random() * 50 + 1)::int,
    floor(random() * 5 + 1)::int,
    'This is a random feedback comment #' || i
FROM generate_series(1, 150);

INSERT INTO activity_logs (user_id, course_id, activity_type, timestamp)
SELECT 
    floor(random() * 100 + 1)::int AS user_id,
    floor(random() * 50 + 1)::int AS course_id,
    (ARRAY['video_watched', 'quiz_completed', 'lesson_started', 'resource_downloaded'])[floor(random() * 4 + 1)] AS activity_type,
    NOW() - (random() * INTERVAL '30 days') AS timestamp
FROM generate_series(1, 1000) AS i;
