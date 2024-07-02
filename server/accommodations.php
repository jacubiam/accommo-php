<?php
$hostname = $env['DB_HOST'];
$username = $env['DB_USERNAME'];
$password = $env['DB_PASSWORD'];
$database = $env['DB_DATABASE'];

function accommodations_by_user()
{
    $res = [
        'status' => true,
        'message' => "Rooms fetched",
        'data' => []
    ];

    $conn = new mysqli($GLOBALS['hostname'], $GLOBALS['username'], $GLOBALS['password'], $GLOBALS['database']);
    if ($conn->connect_error) {
        $res['status'] = false;
        $res['message'] = "Connection failed: " . $conn->connect_error;
        $res['data'] = null;
        http_response_code(500);
        echo json_encode($res, JSON_UNESCAPED_SLASHES);
        exit();
    }

    $sql = "SELECT rooms.*, accommodations.`Check_in`, accommodations.`Check_out` FROM accommodations INNER JOIN rooms ON accommodations.`Room_ID` = rooms.`Room_ID` WHERE accommodations.`User_ID` = ?";
    $ps = $conn->prepare($sql);
    $ps->bind_param("s", $_GET['user_id']);
    $ps->execute();
    $rows = $ps->get_result();
    
    if ($rows->num_rows > 0) {
        $res['data'] = $rows->fetch_all(MYSQLI_ASSOC);
        foreach ($res['data'] as $key => $value) {
            $res['data'][$key]['Images'] = json_decode($value['Images']);
        }
    } else {
        $res['status'] = false;
        $res['message'] = "No data";
        $res['data'] = null;
    }

    $ps->close();
    $conn->close();
    echo json_encode($res, JSON_UNESCAPED_SLASHES);
    exit();
}
