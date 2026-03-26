<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/../db.php';

try {
    $now = new DateTime('now');
    $employees = [];

    if (extension_loaded('pdo_mysql')) {
        $pdo = dbPdo();
        $stmt = $pdo->query('SELECT id, name, join_date, is_active FROM employees ORDER BY id');
        $rows = $stmt->fetchAll();

        foreach ($rows as $row) {
            $employees[] = computeEmployeeRow($row, $now);
        }
    } else if (extension_loaded('mysqli')) {
        $mysqli = dbMysqli();
        $result = $mysqli->query('SELECT id, name, join_date, is_active FROM employees ORDER BY id');

        if ($result === false) {
            throw new RuntimeException('Query failed: ' . $mysqli->error);
        }

        while ($row = $result->fetch_assoc()) {
            $employees[] = computeEmployeeRow($row, $now);
        }
    } else {
        throw new RuntimeException('Neither PDO MySQL nor MySQLi is available.');
    }

    echo json_encode($employees, JSON_UNESCAPED_UNICODE);
} catch (Throwable $e) {
    http_response_code(500);
    $msg = $e->getMessage();
    $hint = null;
    if (stripos($msg, 'pdo_mysql') !== false || stripos($msg, 'could not find driver') !== false) {
        $hint = 'PHP PDO MySQL driver is missing. Enable `pdo_mysql` in php.ini (or install php-mysql).';
    } else if (stripos($msg, 'mysqli') !== false || stripos($msg, 'MySQLi') !== false) {
        $hint = 'PHP MySQLi extension is missing. Enable `mysqli` in php.ini (or install php-mysql).';
    } else if (stripos($msg, 'Neither PDO MySQL nor MySQLi') !== false) {
        $hint = 'Install/enable PHP MySQL support (`pdo_mysql` and/or `mysqli`).';
    }

    echo json_encode([
        'error' => 'Server error',
        'message' => $msg,
        'hint' => $hint,
    ]);
}

function computeEmployeeRow(array $row, DateTime $now): array
{
    $joinDateStr = $row['join_date'];
    $joinDate = DateTime::createFromFormat('Y-m-d', (string)$joinDateStr);

    $isActive = ((int)$row['is_active']) === 1;

    $flagged = false;
    $yearsAtOrg = null;

    if ($joinDate instanceof DateTime) {
        // Flag if active AND joined more than 5 years ago (strictly greater).
        $threshold = (clone $joinDate)->modify('+5 years');
        $flagged = $isActive && $threshold < $now;

        $diff = $now->diff($joinDate);
        $yearsAtOrg = (int)$diff->y; // full years for display
    }

    return [
        'id' => (int)$row['id'],
        'name' => (string)$row['name'],
        'join_date' => $joinDate instanceof DateTime ? $joinDate->format('Y-m-d') : (string)$joinDateStr,
        'is_active' => $isActive,
        'flagged' => $flagged,
        'yearsAtOrg' => $yearsAtOrg,
    ];
}

