<?php
$env;
if (is_file('./.env')) {
    $env = parse_ini_file('./.env');
} else {
    exit();
}

//We set the root position
$root = $env['SV_ROOT'];
$path = str_replace($root,'',$_SERVER['REQUEST_URI']);

switch ($path) {
    case '':
    case '/':
        require './pages/index.html';
        break;
    case '/user':
        require './pages/users.html';
        break;
    case str_starts_with($path, '/api/'):
        require './api/api.php';
        break;
    default:
        echo "404 NOT FOUND";
        break;
}
