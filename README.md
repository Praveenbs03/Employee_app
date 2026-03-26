# employe_app (Employees)

Flutter app to display employees from a PHP + MySQL backend.

Any employee who is **active** and has been with the organization for **more than 5 years** is flagged with a **green** indicator.

## Recommended Backend (Laravel + MySQL/SQLite)

Laravel backend is located in `backend/employees_api_laravel/`.

For an easy demo, it uses **SQLite** by default (no MySQL password needed). A SQLite DB will be created automatically at:

`backend/employees_api_laravel/database/database.sqlite`

### Start Laravel server

From project root:

`cd backend\employees_api_laravel`

`php artisan serve --port=8001 --host=127.0.0.1`

### Endpoint

- `http://127.0.0.1:8001/api/employees`

## Optional Backend (PHP + MySQL)

Backend files live in: `backend/php-mysql/`

### 1) Create DB + table

Run `backend/php-mysql/schema.sql` in your MySQL client.

### 2) Configure DB connection

Set these environment variables for your PHP process:

- `DB_HOST` (default `127.0.0.1`)
- `DB_NAME` (default `employe_app`)
- `DB_USER` (default `root`)
- `DB_PASS` (default empty)

### 3) Start PHP server

From the project root:

`php -S localhost:8000 -t backend/php-mysql`

Endpoint:

- `http://localhost:8000/api/employees.php`

## Flutter

### 1) Install dependencies

`flutter pub get`

### 2) Run the app

`flutter run`

### 3) API URL

In the app, open the settings icon and set the API URL if needed.

- Android emulator (default): `http://10.0.2.2:8000/api/employees.php`
- Real device: use your PC IP (example `http://192.168.1.10:8000/api/employees.php`)

### Laravel in Flutter (if you want)

- Web (Chrome): `http://localhost:8001/api/employees` (this is the default for web)
- Android emulator (change API URL in the app): `http://10.0.2.2:8001/api/employees`
