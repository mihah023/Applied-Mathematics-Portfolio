-- ============================================
-- 00_schema.sql
-- Database schema for library management system
-- ============================================

CREATE DATABASE IF NOT EXISTS iudbs;
USE iudbs;

-- ---------------------------
-- Table: author
-- ---------------------------
CREATE TABLE author (
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    pen_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(20),
    field VARCHAR(50),
    address VARCHAR(200),
    email VARCHAR(100),
    nationality VARCHAR(50),
    active_year VARCHAR(30)
);

-- ---------------------------
-- Table: category
-- ---------------------------
CREATE TABLE `category` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category` VARCHAR(100) NOT NULL,
    `sub_category` VARCHAR(100),
    `book_country` VARCHAR(100),
    `target_audience` VARCHAR(100),
    `recommended_age` VARCHAR(50),
    `description` TEXT,
    `average_rating` DECIMAL(3,2),
    `keyword` VARCHAR(255),
    `popular_book` VARCHAR(255)
);

-- ---------------------------
-- Table: storage
-- ---------------------------
CREATE TABLE storage (
    storage_id INT PRIMARY KEY,
    block INT,
    capacity INT,
    current_quantity INT,
    `condition` VARCHAR(50),
    last_checked_day DATE,
    manager_name VARCHAR(100),
    category VARCHAR(100),
    shelf VARCHAR(10),
    floor INT
);

-- ---------------------------
-- Table: book
-- ---------------------------
CREATE TABLE book (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    edition INT,
    publisher VARCHAR(255),
    year INT,
    author VARCHAR(255),
    category_id INT,
    language VARCHAR(50),
    number_page INT,
    storage_id INT
);
