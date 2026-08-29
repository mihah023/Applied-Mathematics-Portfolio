-- ============================================
-- 02_seed_category.sql
-- Seed data for the `category` table
-- (loaded before `book` since book.category_id references it)
-- ============================================

USE iudbs;

INSERT INTO `category`
(`category`, `sub_category`, `book_country`, `target_audience`, `recommended_age`, `description`, `average_rating`, `keyword`, `popular_book`)
VALUES
('Fiction', 'Novel', 'Vietnam', 'Adult', '18+', 'Contemporary Vietnamese fiction exploring modern life.', 4.50, 'love, drama, life', 'Nỗi Buồn Chiến Tranh'),
('Fiction', 'Short Story', 'USA', 'Adult', '16+', 'Collection of short stories from American authors.', 4.20, 'short, story, america', 'The Things They Carried'),
('Science Fiction', 'Space Opera', 'USA', 'Teen', '13+', 'Epic space adventures across galaxies.', 4.70, 'space, future, technology', 'Dune'),
('Science Fiction', 'Dystopian', 'UK', 'Teen', '14+', 'Dark futures and societal control.', 4.60, 'dystopia, control, future', '1984'),
('Fantasy', 'High Fantasy', 'UK', 'Teen', '12+', 'Magical worlds and epic quests.', 4.80, 'magic, quest, kingdom', 'The Lord of the Rings'),
('Fantasy', 'Urban Fantasy', 'USA', 'Adult', '16+', 'Magic hidden within modern cities.', 4.30, 'magic, city, hidden', 'American Gods'),
('Romance', 'Contemporary', 'Vietnam', 'Adult', '16+', 'Modern love stories set in Vietnam.', 4.10, 'love, romance, modern', 'Mắt Biếc'),
('Romance', 'Historical', 'UK', 'Adult', '16+', 'Love stories set in past eras.', 4.40, 'love, history, era', 'Pride and Prejudice'),
('Mystery', 'Detective', 'UK', 'Adult', '16+', 'Classic detective mystery novels.', 4.60, 'detective, crime, mystery', 'Sherlock Holmes'),
('Mystery', 'Thriller', 'USA', 'Adult', '18+', 'Suspenseful thrillers with plot twists.', 4.50, 'thriller, suspense, twist', 'Gone Girl'),
('Horror', 'Psychological', 'USA', 'Adult', '18+', 'Chilling psychological horror stories.', 4.20, 'horror, fear, mind', 'The Shining'),
('Horror', 'Supernatural', 'Japan', 'Adult', '18+', 'Supernatural and ghost horror tales.', 4.00, 'ghost, horror, supernatural', 'Ring'),
('History', 'World History', 'World', 'Adult', '16+', 'Comprehensive overview of world history.', 4.30, 'history, world, past', 'Sapiens'),
('History', 'Vietnam History', 'Vietnam', 'Adult', '14+', 'History of Vietnam through the centuries.', 4.40, 'vietnam, history, war', 'Việt Nam Sử Lược'),
('Biography', 'Memoir', 'USA', 'Adult', '16+', 'Personal life stories and memoirs.', 4.10, 'memoir, life, personal', 'Becoming'),
('Biography', 'Historical Figure', 'World', 'Adult', '14+', 'Biographies of influential historical figures.', 4.50, 'biography, history, figure', 'Steve Jobs'),
('Science', 'Physics', 'World', 'Adult', '16+', 'Introductory and advanced physics concepts.', 4.60, 'physics, science, universe', 'A Brief History of Time'),
('Science', 'Biology', 'World', 'Adult', '14+', 'Fundamentals of biological science.', 4.20, 'biology, science, life', 'The Selfish Gene'),
('Technology', 'Computer Science', 'World', 'Adult', '14+', 'Core concepts in computer science.', 4.70, 'computer, technology, coding', 'Clean Code'),
('Technology', 'AI & Data', 'World', 'Adult', '16+', 'Artificial intelligence and data science topics.', 4.60, 'ai, data, machine learning', 'Deep Learning'),
('Self-Help', 'Motivation', 'USA', 'Adult', '13+', 'Motivational and personal growth guides.', 4.10, 'motivation, growth, mindset', 'Atomic Habits'),
('Self-Help', 'Productivity', 'USA', 'Adult', '13+', 'Guides to improving personal productivity.', 4.30, 'productivity, habits, time', 'Getting Things Done'),
('Children', 'Picture Book', 'World', 'Children', '3+', 'Illustrated storybooks for young children.', 4.80, 'picture, kids, story', 'Where the Wild Things Are'),
('Children', 'Educational', 'Vietnam', 'Children', '6+', 'Educational books for young learners.', 4.40, 'education, kids, learning', 'Doraemon'),
('Poetry', 'Modern Poetry', 'Vietnam', 'Adult', '14+', 'Contemporary Vietnamese poetry collections.', 4.20, 'poetry, verse, modern', 'Truyện Kiều'),
('Poetry', 'Classic Poetry', 'World', 'Adult', '14+', 'Classic poems from world literature.', 4.50, 'poetry, classic, verse', 'The Odyssey'),
('Philosophy', 'Ethics', 'World', 'Adult', '16+', 'Explorations of ethical philosophy.', 4.30, 'ethics, philosophy, morality', 'Meditations'),
('Philosophy', 'Existentialism', 'France', 'Adult', '16+', 'Philosophical works on existentialism.', 4.40, 'existentialism, philosophy, meaning', 'The Stranger'),
('Comics', 'Manga', 'Japan', 'Teen', '13+', 'Japanese comic and manga series.', 4.60, 'manga, comic, japan', 'One Piece'),
('Comics', 'Graphic Novel', 'USA', 'Teen', '14+', 'Illustrated graphic novel storytelling.', 4.30, 'comic, graphic, story', 'Watchmen');
