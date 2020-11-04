<?php
$mysqli = new mysqli("localhost", "root", "theresia", "fixit");

// Check connection
if($mysqli === false){
    die("ERROR: Could not connect. " . $mysqli->connect_error);
}

$id = $_GET["id"];

$sql = "INSERT INTO fehler (id,datum,melder,raum,beschreibung,gefixt) VALUES ($id,'20200415','Martin','K21','tot',0)";
if($mysqli->query($sql) === true){
    echo "Records inserted successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. " . $mysqli->error;
}
 
// Close connection
$mysqli->close();
?>
