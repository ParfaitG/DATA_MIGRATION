<?php

// Load XML file
$cd = dirname(__FILE__);

$xpath = simplexml_load_file($cd.'/CLData.xml');
$data = (array)$xpath->xpath('//missedConnection');

try {
    // Open DB connection
    $dbh = new PDO("sqlite:".$cd."/CLData.db");

    // Append to DB
    $fields = array_keys((array)$data[0]);
    $qmarks = array_fill(0, count($data[0]), '?');

    $dbh->query("DELETE FROM cldata;");

    $sql = "INSERT INTO cldata (" . implode(",", $fields) . ")";          
    $sql = $sql . " VALUES (" . implode(",", $qmarks) . ")";
    
    $dbh->beginTransaction();
    foreach($data as $d) {
        $stmt = $dbh->prepare($sql);
        $stmt->execute(array_values((array)$d));
    }
    $dbh->commit();
}

catch(PDOException $e) {  
    echo $e->getMessage()."\n";
    exit;
}

// Close DB connection
$dbh = null;

echo "Successfully migrated XML data into SQL database!\n";

?>
