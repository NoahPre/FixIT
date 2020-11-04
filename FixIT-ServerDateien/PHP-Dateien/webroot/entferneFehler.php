<?php
require_once("mysqli.php");
// die id des Fehlers der gelöscht werden soll
$id = $_GET["id"];
// query, das in der Datenbank ausgeführt werden soll
$sql = "DELETE FROM fehler WHERE id = " . $id . ";";
if($mysqli->query($sql) === true){
    echo "Records deleted successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. " . $mysqli->error;
}
 
// Close connection
$mysqli->close();
?>
