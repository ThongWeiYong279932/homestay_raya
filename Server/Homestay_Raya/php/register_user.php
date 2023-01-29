<?php
if (!isset($_POST{'register'})) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die(); 
}

include_once("dbconnect.php"); 

$email = $_POST['email'];
$name = $_POST['name']; 
$password = sha1($_POST['password']);
$phone = $_POST['phone']; 
$address = "na"; 
$otp = rand(10000,99999); 
 
$sqlregister = "INSERT INTO tbl_users (user_email, user_name, user_password, user_phone, user_address, user_otp) VALUES('$email','$name','$password','$phone','$address', $otp)"; 
try{
    if ($conn->query($sqlregister) === TRUE) { 
        $response = array('status' => 'success', 'data' => null); 
       sendJsonResponse($response); 
   }else{ 
        $response = array('status' => 'failed', 'data' => null); 
        sendJsonResponse($response); 
   }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
}
$conn->close();
  
function sendJsonResponse($sentArray) { 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray);
} 
?>