<?php

$path = str_replace('/api','',$path);
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (preg_match('/^\/rooms\?check_in=\d{4}-\d{1,2}-\d{1,2}&check_out=\d{4}-\d{1,2}-\d{1,2}$/', $path)) {
        include_once "./server/rooms.php";
        rooms_by_date();
    }

    if (preg_match('/^\/accommodations\?user_id=\w+$/', $path)) {
        include_once "./server/accommodations.php";
        accommodations_by_user();      
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($path === '/register') {
        $raw = file_get_contents('php://input');
        $post = json_decode($raw, true);
        include_once "./server/register.php";
        register($post);
    }
}
