# 📚 Library Management System

This project implements a dynamic Library Management System (PHP, MySQL) for International University, VNU-HCM, allowing staff to browse, search, insert, update, and delete records across four core tables — category, author, storage, and book — through a single dynamically-generated form.

Using PHP (mysqli) and vanilla JavaScript, the interface generates column checkboxes on the fly based on the table selected, then routes each request through a shared backend (result.php) that validates the table/column input against a whitelist and executes prepared-statement SQL. A dedicated "Multiple" mode performs a live SQL JOIN across all four tables to surface enriched, cross-referenced book records in a single view.

🛑 [!NOTE]
Team & Role: This was a group project (3-person team, International University – VNU-HCM). This repo contains the full project as submitted by the team. My individual contribution was implementing the Insert function in result.php and helping build the HTML pages (research.html, about.html). Teammates contributed the database schema design and the remaining CRUD functions (Show / Search / Update / Delete) and multi-table JOIN logic.

---

## 🖥️ Live Preview

> Access locally via XAMPP: `http://localhost/project/research.html`

*(Screenshots go here — add images of the form, a search result, and the "Multiple" combined view)*

---

## ✨ Features

- **Dynamic form generation** — column checkboxes are generated on the fly with JavaScript based on the table selected (no page reload needed).
- **5 operations per table:**
  | Function | Description |
  |---|---|
  | `Show Table` | Displays all rows of the selected table with the selected columns |
  | `Search` | Filters rows using `LIKE` matching on chosen columns (prepared statements) |
  | `Insert` | Adds a new row using the values entered |
  | `Update` | Edits an existing row, identified by a fixed primary key field |
  | `Delete` | Removes a row, identified by a fixed primary key field |
- **"Multiple" mode (`enrol`)** — a virtual, read-only view that performs a live SQL `JOIN` across `book`, `author`, `category`, and `storage` to show enriched book records (e.g. book title + author bio + category info + storage location) in a single table.
- **SQL Injection protection** — all Search / Update / Delete / Insert queries use **prepared statements** (`mysqli` bind parameters), not raw string concatenation.
- **Safe table/column whitelisting** — incoming `table` and `columns[]` values from the form are validated against a hardcoded whitelist (`$allowed_tables`, `$allowed_columns`) before being used in any SQL, preventing arbitrary table/column injection.
- **Fixed primary-key handling** — Update/Delete always target a table's real primary key (`category_id`, `author_id`, `storage_id`, `book_id`), decoupled from which columns happen to be checked, to avoid accidentally modifying/deleting multiple rows that share a non-unique value.

---

## 🗂️ Data Model

| Table | Description | Primary Key |
|---|---|---|
| `category` | Book categories/genres (name, target audience, rating, keywords...) | `category_id` |
| `author` | Author profiles (pen name, nationality, active years...) | `author_id` |
| `storage` | Physical storage location/shelf info for books | `storage_id` |
| `book` | Book records, linked to `author` (by name), `category_id`, `storage_id` | `book_id` |
| `enrol` *(virtual)* | Not a real table — a JOIN of `book` + `author` + `category` + `storage` for combined browsing | — |

**Join logic used for "Multiple":**
```sql
SELECT ...
FROM book b
LEFT JOIN author  a ON b.author = a.name
LEFT JOIN category c ON b.category_id = c.category_id
LEFT JOIN storage  s ON b.storage_id = s.storage_id
```

---

## 🛠️ Tech Stack

- **Backend:** PHP 8 (`mysqli`, prepared statements)
- **Database:** MySQL / MariaDB (via XAMPP)
- **Frontend:** HTML5, CSS3, vanilla JavaScript (no frameworks)
- **Local server:** Apache (XAMPP)

---

## 📁 Project Structure

```
project/
├── research.html    # Main page — table/column/function selection form
├── about.html        # About page — library info
├── result.php         # Backend handler — validates input, builds & runs SQL, renders results
├── logo.svg            # University logo (SVG)
└── database/
    ├── 00_schema.sql          # CREATE TABLE statements for all tables
    ├── 01_seed_author.sql     # Sample data for `author`
    ├── 02_seed_category.sql   # Sample data for `category`
    ├── 03_seed_storage.sql    # Sample data for `storage`
    ├── 04_seed_book.sql       # Sample data for `book`
    └── run_all.sql            # Runs schema + all seed files in order
```

> Note: the web files (`research.html`, `about.html`, `result.php`, `logo.svg`) are kept flat at the project root — not inside `database/` — so their relative paths to each other resolve correctly when served by Apache. `database/` only holds SQL setup files, which are never accessed by the browser.

---

## 🚀 Getting Started

### Prerequisites
- [XAMPP](https://www.apachefriends.org/) (or any Apache + PHP 8 + MySQL stack)

### Setup

1. **Copy the project folder** into your XAMPP web root:
   ```
   C:\xampp\htdocs\project\
   ```

2. **Create the database** — open phpMyAdmin, create a database named `iudbs`, then run the setup script:
   - Go to the **SQL** tab (or **Import**) in phpMyAdmin
   - Run `database/run_all.sql` — this executes `00_schema.sql` (creates all tables) followed by the seed files (`01_seed_author.sql` → `04_seed_book.sql`) to populate sample data
   - Alternatively, run the files one by one in order (`00` → `04`) if your phpMyAdmin version doesn't support `SOURCE`/multi-file import directly

3. **Configure DB credentials** in `result.php` if different from default XAMPP settings:
   ```php
   $servername = "localhost";
   $username   = "root";
   $password   = "";
   $dbname     = "iudbs";
   ```

4. **Start Apache + MySQL** from the XAMPP Control Panel.

5. **Open the app:**
   ```
   http://localhost/project/research.html
   ```

---

## 🧠 Lessons Learned

While building and debugging this project, a few real issues came up that shaped the final design:

- **Table-not-found errors** — early on, the `category` table hadn't been created yet in the `iudbs` database, causing `mysqli_sql_exception: Table 'iudbs.category' doesn't exist`. This reinforced the importance of keeping the schema and the PHP `$allowed_columns` definitions in sync from day one.
- **Update/Delete targeting the wrong row** — the original logic picked *"whichever column was checked first"* as the row identifier. Since several sample rows shared the same `category` name (e.g. two "Fiction" rows), this could delete/update **multiple rows at once** unintentionally. Fixed by hardcoding a `$primary_keys` map so Update/Delete always key off the real primary key, independent of which checkboxes are ticked.
- **Frontend/backend column drift** — the `storage` table's `condition` column existed in the PHP whitelist but was missing from the JavaScript checkbox list, silently excluding it from every form submission. A reminder that generated form fields must always be checked against the backend's source of truth.
- **Broken internal links** — a leftover reference to a non-existent `search.html` page (from an earlier filename before the project was reorganized) caused a dead "Home" link on the About page.

---

## 📬 Contact

- International University, VNU-HCM Library: https://library.hcmiu.edu.vn/vi

---

## 📄 License

This project was built for academic purposes. Feel free to fork and adapt for learning.
