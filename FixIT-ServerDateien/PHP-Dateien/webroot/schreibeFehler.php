<?php
//$mysqli = new mysqli("localhost","icanfixit","iu!vohj3th","icanfixit");

// Check connection
//if($mysqli === false){
//    die("ERROR: Could not connect. " . $mysqli->connect_error);
//}
require_once("mysqli.php");
// holt die Wert aus der Url
$id = $_GET["id"];
$datum = $_GET["datum"];
$raum = $_GET["raum"];
$beschreibung = $_GET["beschreibung"];
$gefixt = $_GET["gefixt"];
// query, das in der Datenbank ausgeführt werden soll
$sql = "INSERT INTO fehler (id,datum,raum,beschreibung,gefixt) VALUES ('".$id."','".$datum."','".$raum."','".$beschreibung."','".$gefixt."')";
if($mysqli->query($sql) === true){
    echo "Records inserted successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. " . $mysqli->error;
}
 
// Close connection
$mysqli->close();
?>
