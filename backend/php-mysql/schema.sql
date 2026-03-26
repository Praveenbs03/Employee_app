-- Create database
CREATE DATABASE IF NOT EXISTS employe_app
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE employe_app;

-- Employees table
CREATE TABLE IF NOT EXISTS employees (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  join_date DATE NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id)
);

-- Sample data
INSERT INTO employees (name, join_date, is_active) VALUES
  ('Alice Johnson', '2018-01-15', 1), -- flagged (active + > 5 years)
  ('Mark Adams', '2022-06-01', 1),    -- not flagged
  ('Sophia Lee', '2016-09-01', 0),    -- not flagged (inactive)
  ('David Kim', '2020-03-10', 1);     -- not flagged (depends on current date)

