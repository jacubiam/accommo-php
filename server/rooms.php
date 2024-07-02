<?php
$hostname = $env['DB_HOST'];
$username = $env['DB_USERNAME'];
$password = $env['DB_PASSWORD'];
$database = $env['DB_DATABASE'];

function rooms_by_date()
{
    header('Content-type: application/json');
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

    $sql = "SELECT * FROM rooms WHERE NOT EXISTS (
        SELECT * FROM accommodations WHERE (accommodations.`Room_ID` = rooms.`Room_ID`) 
        AND  (accommodations.`Check_in` BETWEEN ? AND ?)
        UNION
        SELECT * FROM accommodations WHERE (accommodations.`Room_ID` = rooms.`Room_ID`) 
        AND (accommodations.`Check_out` BETWEEN ? AND ?)
        UNION
        SELECT * FROM accommodations WHERE (accommodations.`Room_ID` = rooms.`Room_ID`) 
        AND (accommodations.`Check_in` <= ? AND ? <= accommodations.`Check_out`)
    )";

    $ps = $conn->prepare($sql);
    $ps->bind_param("ssssss", $_GET['check_in'], $_GET['check_out'], $_GET['check_in'], $_GET['check_out'], $_GET['check_in'], $_GET['check_out']);
    $ps->execute();
    $rows = $ps->get_result();
    
    if ($rows->num_rows > 0) {
        $res['data'] = $rows->fetch_all(MYSQLI_ASSOC);
        foreach ($res['data'] as $k => $value) {
            $res['data'][$k]['Images'] = json_decode($value['Images']);
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
