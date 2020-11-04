<?php
$mysqli = new mysqli("localhost","icanfixit","iu!vohj3th","icanfixit");

// Check connection
if($mysqli === false){
    die("ERROR: Could not connect. " . $mysqli->connect_error);
}

