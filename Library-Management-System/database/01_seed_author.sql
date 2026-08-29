-- ============================================
-- 01_seed_author.sql
-- Seed data for the `author` table
-- ============================================

USE iudbs;

INSERT INTO author (author_id, name, pen_name, date_of_birth, gender, field, address, email, nationality, active_year) VALUES
(1, 'F. Scott Fitzgerald', NULL, '1896-09-24', 'male', 'Fiction', 'New York, USA', 'fitzgerald@gmail.com', 'USA', '1920-1940'),
(2, 'George Orwell', NULL, '1903-06-25', 'male', 'Fiction', 'London, UK', 'orwell@gmail.com', 'UK', '1930-1950'),
(3, 'Agatha Christie', NULL, '1890-09-15', 'female', 'Fiction', 'Torquay, UK', 'christie@gmail.com', 'UK', '1920-1976'),
(4, 'J.K. Rowling', 'Robert Galbraith', '1965-07-31', 'female', 'Fiction', 'London, UK', 'rowling@gmail.com', 'UK', '1997-present'),
(5, 'Walter Isaacson', NULL, '1952-05-20', 'male', 'Non-fiction', 'New York, USA', 'isaacson@gmail.com', 'USA', '2000-present'),
(6, 'James Clear', NULL, '1986-01-22', 'male', 'Non-fiction', 'Columbus, USA', 'clear@gmail.com', 'USA', '2010-present'),
(7, 'Stephen King', NULL, '1947-09-21', 'male', 'Fiction', 'Maine, USA', 'king@gmail.com', 'USA', '1970-present'),
(8, 'Paulo Coelho', NULL, '1947-08-24', 'male', 'Fiction', 'Rio de Janeiro, Brazil', 'coelho@gmail.com', 'Brazil', '1987-present'),
(9, 'Rick Riordan', NULL, '1964-06-05', 'male', 'Fiction', 'San Antonio, USA', 'riordan@gmail.com', 'USA', '2005-present'),
(10, 'Margaret Atwood', NULL, '1939-11-18', 'female', 'Fiction', 'Toronto, Canada', 'atwood@gmail.com', 'Canada', '1969-present'),
(11, 'Yuval Noah Harari', NULL, '1976-02-24', 'male', 'Non-fiction', 'Jerusalem, Israel', 'harari@gmail.com', 'Israel', '2011-present'),
(12, 'Malcolm Gladwell', NULL, '1963-09-03', 'male', 'Non-fiction', 'New York, USA', 'gladwell@gmail.com', 'Canada', '2000-present'),
(13, 'Dan Brown', NULL, '1964-06-22', 'male', 'Fiction', 'New Hampshire, USA', 'brown@gmail.com', 'USA', '2000-present'),
(14, 'Suzanne Collins', NULL, '1962-08-10', 'female', 'Fiction', 'Hartford, USA', 'collins@gmail.com', 'USA', '2003-present'),
(15, 'Ernest Hemingway', NULL, '1899-07-21', 'male', 'Fiction', 'Illinois, USA', 'hemingway@gmail.com', 'USA', '1926-1961'),
(16, 'Leo Tolstoy', NULL, '1828-09-09', 'male', 'Fiction', 'Tula, Russia', 'tolstoy@gmail.com', 'Russia', '1865-1910'),
(17, 'Albert Einstein', NULL, '1879-03-14', 'male', 'Non-fiction', 'Princeton, USA', 'einstein@gmail.com', 'Germany', '1905-1955'),
(18, 'Isaac Newton', NULL, '1642-12-25', 'male', 'Non-fiction', 'London, UK', 'newton@gmail.com', 'UK', '1665-1727');
