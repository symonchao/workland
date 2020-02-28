<?php
return [
    'default' => 'mysql',
    'connections' => [
        'mysql' => [
            'driver' => 'mysql',
            'host' => env('DB_HOST'),
            'port' => env('DB_PORT', 3306),
            'database' => env('DB_DATABASE'),
            'username' => env('DB_USERNAME'),
            'password' => env('DB_PASSWORD'),
            'charset' => 'utf8mb4',
            'collation' => 'utf8mb4_unicode_ci',
            'strict' => env('DB_STRICT_MODE', true),
            'engine' => env('DB_ENGINE', 'InnoDB ROW_FORMAT=DYNAMIC'),
        ],
    ],
    'migrations' => 'migrations',
];
