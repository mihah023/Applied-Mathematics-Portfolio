
USE iudbs;

INSERT INTO book (book_id, title, edition, publisher, year, author, category_id, language, number_page, storage_id) VALUES
(1, 'The Great Gatsby', 1, 'Charles Scribner\'s Sons', 1925, 'F. Scott Fitzgerald', 1, 'English', 180, 1),
(2, 'Animal Farm', 1, 'Secker & Warburg', 1945, 'George Orwell', 1, 'English', 112, 1),
(3, 'The Mysterious Affair at Styles', 1, 'Mead & Company', 1920, 'Agatha Christie', 3, 'English', 300, 6),
(4, 'Murder on the Orient Express', 1, 'HarperCollins', 1934, 'Agatha Christie', 3, 'English', 298, 6),
(5, 'Harry Potter and the Sorcerer\'s Stone', 1, 'Bloomsbury', 1997, 'J.K. Rowling', 4, 'English', 223, 8);

INSERT INTO book (book_id, title, edition, publisher, year, author, category_id, language, number_page, storage_id) VALUES
(6, 'Harry Potter and the Chamber of Secrets', 1, 'Bloomsbury', 1998, 'J.K. Rowling', 4, 'English', 251, 8),
(7, 'Steve Jobs', 1, 'Simon & Schuster', 2011, 'Walter Isaacson', 5, 'English', 656, 6),
(8, 'Leonardo da Vinci', 1, 'Simon & Schuster', 2017, 'Walter Isaacson', 5, 'English', 624, 10),
(9, 'Atomic Habits', 2, 'Avery', 2019, 'James Clear', 6, 'English', 320, 11),
(10, 'The Shining', 2, 'Penguin Random House', 2006, 'Stephen King', 16, 'English', 447, 16);

INSERT INTO book (book_id, title, edition, publisher, year, author, category_id, language, number_page, storage_id) VALUES
(21, 'The Da Vinci Code', 7, 'Anchor Books', 2006, 'Dan Brown', 16, 'English', 454, 16),
(22, 'Angels & Demons', 6, 'Anchor Books', 2006, 'Dan Brown', 3, 'English', 616, 6),
(23, 'The Hunger Games', 6, 'Scholastic Inc', 2010, 'Suzanne Collins', 2, 'English', 374, 20),
(24, 'Catching Fire', 5, 'Scholastic Inc', 2011, 'Suzanne Collins', 2, 'English', 391, 20),
(25, 'The Old Man and the Sea', 5, 'Scribner', 2003, 'Ernest Hemingway', 1, 'English', 128, 1);

INSERT INTO book (book_id, title, edition, publisher, year, author, category_id, language, number_page, storage_id) VALUES
(26, 'A Farewell to Arms', 4, 'Scribner', 2012, 'Ernest Hemingway', 15, 'English', 355, 21),
(27, 'War and Peace', 4, 'Penguin Classics', 2000, 'Leo Tolstoy', 7, 'Russian', 1225, 18),
(28, 'Anna Karenina', 6, 'Penguin Classics', 2001, 'Leo Tolstoy', 15, 'Russian', 864, 21),
(29, 'Relativity: The Special and the General Theory', 10, 'Pi Press', 2005, 'Albert Einstein', 6, 'German', 148, 26),
(30, 'Philosophiae Naturalis Principia Mathematica', 5, 'Cambridge University Press', 2009, 'Isaac Newton', 6, 'Latin', 531, 26);
