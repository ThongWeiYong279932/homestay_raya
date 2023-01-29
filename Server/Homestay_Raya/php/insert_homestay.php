<?php 
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die(); 
} 
include_once("dbconnect.php"); 
 
$userid = $_POST['userid']; 
$hsname = $_POST['hsname']; 
$hsdesc = addslashes($_POST['hsdesc']); 
$hsprice = $_POST['hsprice']; 
$hsroom = $_POST['roomno']; 
$hsdeposit = $_POST['deposit']; 
$hsstate = addslashes($_POST['state']); 
$hsloc = addslashes($_POST['local']); 
$hslat = $_POST['lat'];
$hslon = $_POST['lon'];
$image = $_POST['image']; 
 
$sqlinsert = "INSERT INTO tbl_homestay(user_id, homestay_name, 
homestay_desc, homestay_price, homestay_deposit, homestay_roomno, homestay_state, 
homestay_local, homestay_lat, homestay_long) 
VALUES ('$userid','$hsname','$hsdesc',$hsprice,$hsdeposit,
$hsroom,'$hsstate','$hsloc','$hslat','$hslon')"; 
if ($conn->query($sqlinsert) === TRUE) { 
    $response = array('status' => 'success', 'data' => null); 
    $decoded_string = base64_decode($image); 
    $filename = mysqli_insert_id($conn); 
    $path = '../assets/images/homestay/'.$filename.'.png'; 
    file_put_contents($path, $decoded_string); 
    sendJsonResponse($response); 
} else { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
}  
function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
} 
 
?> 
