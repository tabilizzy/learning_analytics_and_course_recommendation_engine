

-- Insert Categories
INSERT INTO Category (name)
VALUES 
('Technology'),
('Business'),
('Design'),
('Marketing'),
('Lifestyle');


-- Insert 100 Users
INSERT INTO Users (name, email, created_at)
SELECT 
    'User_' || i,
    'user' || i || '@example.com',
    NOW() - (random() * INTERVAL '365 days')
FROM generate_series(1,100) AS i;


-- Insert 50 Courses 
INSERT INTO Course (title, category_id, rating, is_active, created_at)
SELECT 
    'Course ' || i,
    floor(random() * 5 + 1)::int,
    
    -- Realistic skewed rating distribution
    CASE 
        WHEN random() < 0.60 THEN 5
        WHEN random() < 0.80 THEN 4
        WHEN random() < 0.90 THEN 3
        WHEN random() < 0.97 THEN 2
        ELSE 1
    END,
    
    random() > 0.1, -- 90% active
    
    NOW() - (random() * INTERVAL '180 days')
FROM generate_series(1,50) AS i;


-- Insert Enrollments 
INSERT INTO enrollments (user_id, course_id, enrolled_at)
SELECT DISTINCT
    floor(random() * 100 + 1)::int,
    floor(random() * 50 + 1)::int,
    NOW() - (random() * INTERVAL '120 days')
FROM generate_series(1,300)
ON CONFLICT DO NOTHING;


-- Insert Reviews ONLY for enrolled courses
INSERT INTO course_reviews (user_id, course_id, rating, comment, created_at)
SELECT 
    e.user_id,
    e.course_id,
    
    CASE 
        WHEN random() < 0.60 THEN 5
        WHEN random() < 0.80 THEN 4
        WHEN random() < 0.90 THEN 3
        WHEN random() < 0.97 THEN 2
        ELSE 1
    END,
    
    'Review for course ' || e.course_id || ' by user ' || e.user_id,
    
    NOW() - (random() * INTERVAL '90 days')
FROM enrollments e
ORDER BY random()
LIMIT 150;


-- Insert Activity Logs ONLY for enrolled courses
INSERT INTO activity_logs (user_id, course_id, activity_type, activity_time)
SELECT 
    e.user_id,
    e.course_id,
    (ARRAY[
        'video_watched',
        'quiz_completed',
        'lesson_started',
        'resource_downloaded'
    ])[floor(random() * 4 + 1)],
    NOW() - (random() * INTERVAL '30 days')
FROM enrollments e,
     generate_series(1,5) -- multiple activities per enrollment
LIMIT 1000;


