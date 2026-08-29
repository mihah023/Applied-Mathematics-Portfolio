-- ============================================
-- run_all.sql
-- Runs schema + all seed files in the correct order.
-- Usage (from the sql/ directory):
--   mysql -u root -p < run_all.sql
-- or inside the MariaDB/MySQL client:
--   SOURCE run_all.sql;
-- ============================================

SOURCE 00_schema.sql;
SOURCE 01_seed_author.sql;
SOURCE 02_seed_category.sql;
SOURCE 03_seed_storage.sql;
SOURCE 04_seed_book.sql;
