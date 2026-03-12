-- =====================================================
-- INDEXING & PERFORMANCE OPTIMIZATION
-- EduLearn Africa
-- =====================================================

-- =====================================================
-- 1. USERS
-- =====================================================

-- Fast lookup by email (login / authentication)
CREATE INDEX IF NOT EXISTS idx_users_email
ON users(email);

-- Useful for growth trend analytics
CREATE INDEX IF NOT EXISTS idx_users_created_at
ON users(created_at);


-- =====================================================
-- 2. COURSES
-- =====================================================

-- Category filtering (recommendations + analytics)
CREATE INDEX IF NOT EXISTS idx_courses_category
ON courses(category_id);

-- Active courses only (partial index improves performance)
CREATE INDEX IF NOT EXISTS idx_courses_active
ON courses(id)
WHERE is_active = TRUE;

-- Sort by rating (recommendation ranking)
CREATE INDEX IF NOT EXISTS idx_courses_rating
ON courses(rating DESC);

-- Course creation trend analytics
CREATE INDEX IF NOT EXISTS idx_courses_created_at
ON courses(created_at);


-- =====================================================
-- 3. ENROLLMENTS
-- =====================================================

-- Fast lookup of user enrollments (exclude enrolled courses)
CREATE INDEX IF NOT EXISTS idx_enrollments_user
ON enrollments(user_id);

-- Course popularity calculation
CREATE INDEX IF NOT EXISTS idx_enrollments_course
ON enrollments(course_id);

-- Enrollment growth trend
CREATE INDEX IF NOT EXISTS idx_enrollments_enrolled_at
ON enrollments(enrolled_at);


-- =====================================================
-- 4. ACTIVITY LOGS (Most Critical Table)
-- =====================================================

-- Recommendation engine (recent user activity)
CREATE INDEX IF NOT EXISTS idx_activity_user_time
ON activity_logs(user_id, activity_time DESC);

-- Category popularity + engagement analytics
CREATE INDEX IF NOT EXISTS idx_activity_course
ON activity_logs(course_id);

-- Time-based filtering (DAU / MAU / retention)
CREATE INDEX IF NOT EXISTS idx_activity_time
ON activity_logs(activity_time DESC);

-- Composite index for heavy analytics queries
CREATE INDEX IF NOT EXISTS idx_activity_course_time
ON activity_logs(course_id, activity_time DESC);


-- =====================================================
-- 5. COURSE REVIEWS
-- =====================================================

-- Course rating aggregation
CREATE INDEX IF NOT EXISTS idx_reviews_course
ON course_reviews(course_id);

-- User review lookup
CREATE INDEX IF NOT EXISTS idx_reviews_user
ON course_reviews(user_id);

-- Review trend analytics
CREATE INDEX IF NOT EXISTS idx_reviews_created_at
ON course_reviews(created_at);


-- =====================================================
-- 6. FULL-TEXT SEARCH (Bonus Feature)
-- =====================================================

-- Enables fast search on course titles
CREATE INDEX IF NOT EXISTS idx_courses_title_trgm
ON courses
USING gin (title gin_trgm_ops);


-- =====================================================
-- 7. OPTIONAL: COVERING INDEXES (Advanced Optimization)
-- =====================================================

-- Optimizes recommendation queries (reduces heap access)
CREATE INDEX IF NOT EXISTS idx_courses_covering
ON courses(category_id, rating, is_active);

-- Optimizes popularity calculation queries
CREATE INDEX IF NOT EXISTS idx_enrollment_covering
ON enrollments(course_id, user_id);


-- 8. OPTIONAL: MATERIALIZED VIEW INDEXING
-- (If you implement materialized analytics views)
-- =====================================================

-- Example:
-- CREATE INDEX idx_mv_category_growth
-- ON mv_category_growth(month, category_id);