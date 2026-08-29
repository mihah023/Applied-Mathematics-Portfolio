-- ============================================
-- 03_seed_storage.sql
-- Seed data for the `storage` table
-- (loaded before `book` since book.storage_id references it)
-- ============================================

USE iudbs;

INSERT INTO storage (storage_id, block, capacity, current_quantity, `condition`, last_checked_day, manager_name, category, shelf, floor) VALUES
(1, 1, 15, 5, 'new', '2024-12-15', 'Lucas', 'Novel', 'A', 1),
(2, 2, 15, NULL, 'used', '2024-12-15', 'Lucas', 'Novel', 'A', 1),
(3, 3, 15, NULL, 'used', '2024-12-15', 'Lucas', 'Novel', 'A', 1),
(4, 4, 20, NULL, 'used', '2024-12-15', 'Lucas', 'Novel', 'A', 1),
(5, 5, 20, NULL, 'used', '2024-12-15', 'Lucas', 'Novel', 'A', 1),

(6, 1, 15, 4, 'used', '2024-12-16', 'Lucas', 'Mystery', 'B', 1),
(7, 2, 15, NULL, 'used', '2024-12-16', 'Lucas', 'Mystery', 'B', 1),
(8, 3, 15, 5, 'used', '2024-12-16', 'Lucas', 'Fantasy', 'B', 1),
(9, 4, 20, NULL, 'new', '2024-12-16', 'Lucas', 'Fantasy', 'B', 1),
(10, 5, 20, 1, 'used', '2024-12-16', 'Lucas', 'Biography', 'B', 1),

(11, 1, 15, 1, 'used', '2024-12-17', 'Lucas', 'Self-Help', 'C', 1),
(12, 2, 15, NULL, 'used', '2024-12-17', 'Lucas', 'Self-Help', 'C', 1),
(13, 3, 15, NULL, 'used', '2024-12-17', 'Lucas', 'Self-Help', 'C', 1),
(14, 4, 20, NULL, 'damaged', '2024-12-17', 'Lucas', 'Self-Help', 'C', 1),
(15, 5, 20, NULL, 'new', '2024-12-17', 'Lucas', 'Children''s Books', 'C', 1),

(16, 1, 15, 2, 'used', '2024-12-18', 'Maria', 'Thriller', 'A', 2),
(17, 2, 15, 2, 'used', '2024-12-18', 'Maria', 'Philosophy', 'A', 2),
(18, 3, 15, 2, 'used', '2024-12-18', 'Maria', 'History', 'A', 2),
(19, 4, 20, 2, 'used', '2024-12-18', 'Maria', 'Psychology', 'A', 2),
(20, 5, 20, 2, 'used', '2024-12-18', 'Maria', 'Science Fiction', 'A', 2),

(21, 1, 15, 2, 'used', '2024-12-18', 'Maria', 'Romance', 'B', 2),
(22, 2, 15, NULL, 'used', '2024-12-18', 'Maria', 'Romance', 'B', 2),
(23, 3, 15, NULL, 'used', '2024-12-18', 'Maria', 'Graphic Novels', 'B', 2),
(24, 4, 20, NULL, 'used', '2024-12-18', 'Maria', 'Health', 'B', 2),
(25, 5, 20, 0, 'new', '2024-12-18', 'Maria', 'Economics', 'B', 2),

(26, 1, 15, 2, 'new', '2024-12-18', 'Anna', 'Technology', 'C', 2),
(27, 2, 15, NULL, 'damaged', '2024-12-18', 'Anna', 'Sports', 'C', 2),
(28, 3, 15, NULL, 'used', '2024-12-18', 'Anna', 'Travel', 'C', 2),
(29, 4, 20, NULL, 'used', '2024-12-18', 'Anna', 'Poetry', 'C', 2),
(30, 5, 20, NULL, 'used', '2024-12-18', 'Anna', 'Cookbooks', 'C', 2);
