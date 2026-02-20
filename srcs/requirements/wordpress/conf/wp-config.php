<?php
// filepath: /home/mavissar/srcs/requirements/wordpress/conf/wp-config.php

define('DB_NAME', getenv('DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('DB_USER') ?: 'wpuser');
define('DB_PASSWORD', getenv('DB_PASSWORD') ?: 'wppass');
define('DB_HOST', getenv('DB_HOST') ?: 'mariadb:3306');

define('WP_HOME', getenv('WP_HOME') ?: '');
define('WP_SITEURL', getenv('WP_SITEURL') ?: '');

define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

$table_prefix = 'wp_';
define('WP_DEBUG', false);

if ( ! defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';