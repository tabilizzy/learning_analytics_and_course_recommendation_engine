

-- 1. USERS TABLE

CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);


-- 2. CATEGORY TABLE

CREATE TABLE Category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);


-- 3. COURSES TABLE

CREATE TABLE Course (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    category_id INT,
    rating DECIMAL(2,1),
    is_active BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_courses_category
        FOREIGN KEY (category_id)
        REFERENCES Category(id)
        ON DELETE SET NULL
);


-- 4. ENROLLMENTS TABLE
-- (Junction table for users ↔ courses)

CREATE TABLE enrollments (
    user_id INT,
    course_id INT,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, course_id),

    CONSTRAINT fk_enrollments_user
        FOREIGN KEY (user_id)
        REFERENCES Users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id)
        REFERENCES Course(id)
        ON DELETE CASCADE
);


-- 5. ACTIVITY LOGS TABLE

CREATE TABLE activity_logs (
    id SERIAL PRIMARY KEY,
    user_id INT,
    course_id INT,
    activity_type VARCHAR(100),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_logs_user
        FOREIGN KEY (user_id)
        REFERENCES Users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_logs_course
        FOREIGN KEY (course_id)
        REFERENCES Course(id)
        ON DELETE CASCADE
);

-- 6. COURSE REVIEWS TABLE

CREATE TABLE course_reviews (
    id SERIAL PRIMARY KEY,
    user_id INT,
    course_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id)
        REFERENCES Users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_reviews_course
        FOREIGN KEY (course_id)
        REFERENCES Course(id)
        ON DELETE CASCADE
);