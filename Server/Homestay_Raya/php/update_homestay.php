<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	include_once("dbconnect.php");
	$userid = $_POST['userid'];
	$homestayid = $_POST['homestayid'];
	$hsname= ucwords(addslashes($_POST['hsname']));
	$hsdesc= ucfirst(addslashes($_POST['hsdesc']));
	$hsprice= $_POST['hsprice'];
	$deposit= $_POST['deposit'];
	$roomno= $_POST['roomno'];
  
	$sqlupdate = "UPDATE `tbl_homestay` SET `homestay_name`='$hsname',`homestay_desc`='$hsdesc',`homestay_price`='$hsprice',`homestay_deposit`='$deposit',`homestay_roomno`='$roomno' WHERE `homestay_id` = '$homestayid' AND `user_id` = '$userid'";
	
  try {
		if ($conn->query($sqlupdate) === TRUE) {
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}
?>