<?php
$dns = "mysql:host=localhost;dbname=icanfixit";
$user = "icanfixit";
$password = "iu!vohj3th";
try{
 $db = new PDO ($dns, $user, $password);
}catch( PDOException $e){
 $error = $e->getMessage();
 echo $error;
}

