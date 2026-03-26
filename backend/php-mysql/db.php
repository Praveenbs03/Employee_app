<?php
declare(strict_types=1);

function dbCreds(): array
{
    return [
        'host' => getenv('DB_HOST') !== false ? getenv('DB_HOST') : '127.0.0.1',
        'dbName' => getenv('DB_NAME') !== false ? getenv('DB_NAME') : 'employe_app',
        'user' => getenv('DB_USER') !== false ? getenv('DB_USER') : 'root',
        'pass' => getenv('DB_PASS') !== false ? getenv('DB_PASS') : 'MySQL@2026',
        'charset' => 'utf8mb4',
    ];
}

function dbPdo(): PDO
{
    if (!extension_loaded('pdo_mysql')) {
        throw new RuntimeException('PHP PDO MySQL driver is missing (pdo_mysql).');
    }

    $creds = dbCreds();
    $dsn = "mysql:host={$creds['host']};dbname={$creds['dbName']};charset={$creds['charset']}";

    $options = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ];

    return new PDO($dsn, $creds['user'], $creds['pass'], $options);
}

function dbMysqli(): mysqli
{
    if (!extension_loaded('mysqli')) {
        throw new RuntimeException('PHP MySQLi extension is missing (mysqli).');
    }

    $creds = dbCreds();

    $mysqli = new mysqli(
        $creds['host'],
        $creds['user'],
        $creds['pass'],
        $creds['dbName']
    );

    if ($mysqli->connect_errno) {
        throw new RuntimeException('MySQL connect failed: ' . $mysqli->connect_error);
    }

    $mysqli->set_charset($creds['charset']);
    return $mysqli;
}

// Backwards compatibility for existing code.
function db(): PDO
{
    return dbPdo();
}

