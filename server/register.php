<?php
include_once "./server/validator.php";

$hostname = $env['DB_HOST'];
$username = $env['DB_USERNAME'];
$password = $env['DB_PASSWORD'];
$database = $env['DB_DATABASE'];

function register(array | null $data)
{
    header('Content-type: application/json');
    $res = [
        'status' => true,
        'message' => "User created",
        'data' => null
    ];

    if ($data === null) {
        http_response_code(400);
        $res['status'] = false;
        $res['message'] = "JSON Expected";
        echo json_encode($res);
        exit();
    }

    $verifier = validator($data, 'create');
    if (!$verifier['status']) {
        http_response_code(400);
        $verifier['data'] = null;
        echo json_encode($verifier);
        exit();
    }

    $conn = new mysqli($GLOBALS['hostname'], $GLOBALS['username'], $GLOBALS['password'], $GLOBALS['database']);
    if ($conn->connect_error) {
        $res['status'] = false;
        $res['message'] = "Connection failed: " . $conn->connect_error;
        http_response_code(500);
        echo json_encode($res);
        exit();
    }

    $sql = "INSERT INTO users (`Name`, `Username`, `Email`, `Password`) VALUES (?, ?, ?, ?)";
    $ps = $conn->prepare($sql);
    $ps->bind_param('ssss', $data['name'], $data['username'], $data['email'], $data['password']);

    try {
        $ps->execute();
    } catch (\Throwable $th) {
        http_response_code(409);
        $res['status'] = false;
        $res['message'] = "Error: " . $th->getMessage();
    }
    
    $ps->close();
    $conn->close();
    echo json_encode($res);
    exit();
}
