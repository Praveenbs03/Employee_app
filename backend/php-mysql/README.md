# PHP + MySQL Backend (employees API)

This backend exposes:

- `GET /api/employees.php` -> returns all employees
- Each employee includes `flagged` which is `true` when:
  - `is_active = true`
  - `join_date` is **more than 5 years** ago (strictly greater)

## 1) Create the database/tables

Run `schema.sql` in your MySQL client:

- Create database `employe_app`
- Create table `employees`
- Insert sample rows

## 2) Configure DB credentials

Set environment variables for the PHP process (examples):

- `DB_HOST` (default: `127.0.0.1`)
- `DB_NAME` (default: `employe_app`)
- `DB_USER` (default: `root`)
- `DB_PASS` (default: empty)

## 3) Run a local PHP server

From the project root, point the document root to this folder:

`php -S localhost:8000 -t backend/php-mysql`

Then call:

- `http://localhost:8000/api/employees.php`

## 4) Flutter note

If you run on Android emulator, change the Flutter API URL to:

- `http://10.0.2.2:8000/api/employees.php`

