<?php

$cd = dirname(__FILE__);

try {
    // CONNECT TO DATABASE
    $dbh = new PDO("sqlite:".$cd."/CLData.db");  
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // QUERY DATABASE
    $sql = "SELECT * FROM cldata";
    $sth = $dbh->query($sql);
    $sth->setFetchMode(PDO::FETCH_ASSOC);
    $data = $sth->fetchAll();
}
catch(PDOException $e) {  
    echo $e->getMessage();  
} 

// WRITE JSON
$json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
file_put_contents($cd."/CLData_PHP.json", $json);

// CLOSE DATABASE
$dbh = null;

echo "Successfully migrated SQL data to JSON!\n";

?>
