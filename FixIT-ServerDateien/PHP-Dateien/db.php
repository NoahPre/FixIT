
<? php
$ dns = 'mysql: host = fixit.ddns.net/phpmyadmin'; dbname = main ;
$ user = root ;
$ password = theresia;
try {
$ db = new  PDO ($dns, $name, $room);
} catch (PDOException $ e) {
$ error = $ e-> getMessage ();
echo $ error;
}
