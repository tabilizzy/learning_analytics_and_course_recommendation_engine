# EduLearn Africa - Learning Analytics & Recommendation Engine

## Project Overview

This project implements the backend engine for EduLearn Africa, an online learning platform. The system tracks user activity, recommends courses based on interests, and generates analytics queries for dashboards. This project focuses on PostgreSQL-based implementation, indexing, query optimization, and documentation.

## Schema Design

### Tables
| Table            | Description                                |
| ---------------- | -------------------------------------------|
| `users`          | Stores learners account information        |
| `courses`        | stores course information                  |
| `categories`     | Represents course catergories              |
| `enrollments`    | Tracks which users enroll in which courses |
| `activity_logs`  | Records user interactions with courses     |
| `course_reviews` | Stores course feedback and ratings         |


### Users Table

| Column           | Type                                               |
| ---------------- | ---------------------------------------------------|
| `id`             | primary key , serial                               |
| `name`           | varchar not null                                   |
| `email`          | varchar not null and unique                        |
| `created_at`     | timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL       |

### Category Table

| Column           | Type                                               |
| ---------------- | ---------------------------------------------------|
| `id`             | primary key , serial                               |
| `name`           | varchar not null and unique                        |


## Course

| Column           | Type                                               |
| ---------------- | ---------------------------------------------------|
| `id`             | primary key , serial                               |
| `title`          | varchar not null                                   |
| `category_id`    | int , foreign key                                  |
| `rating    `     | decimal with range from -9.9  to 9.9               |
| `is_active   `   | boolean with true as it's default                  |



### Enrollments Table

| Column           | Type                                               |
| ---------------- | ---------------------------------------------------|
| `user_id`        | foreign key , int, primary key                     |
| `course_id`      | foreign key , int, primary key                     |
| `enrolled_at`     | timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL      |


### Activity logs Table

| Column           | Type                                               |
| ---------------- | ---------------------------------------------------|
| `id`             | primary key , serial                               |
| `user_id`        | foreign key, int                                   |
| `course_id`      | foreign key, int                                   |
| `activity_type`  | varchar                                            |
| `timestamp `     | timestamp DEFAULT CURRENT_TIMESTAMP                |


### Course reviews Table

| Column           | Type                                               |
| ---------------- | ---------------------------------------------------|
| `id`             | primary key , serial                               |
| `user_id`        | foreign key, int                                   |
| `course_id`      | foreign key, int                                   |
| `rating`         | int                                                |
| `comment`        | text                                               |
| `created_at`     | timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL       |


### Relationships

- A category can have many courses but a course can belong to one and one category

- A user can enroll in many courses and a course can be taken by one and many Users

- Activity_logs track user interactions with courses

- Course_reviews capture feedback from enrolled users

### ER Diagram

The `ER-digram ` is included in  `docs/erd.png` or [ER-diagram link](https://dbdiagram.io/d/69b26ecc77d079431b68c685)

## Core Features

List features here

## Getting Started

### Prerequisites

- PostgreSQL >= 12  
- pgAdmin or psql CLI  
- Git

### Setup
Add setup instructions
