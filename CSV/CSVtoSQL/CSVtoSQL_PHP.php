<?php

$cd = dirname(__FILE__);

try {
    // Read CSV file
    $raw = array_map('str_getcsv', file($cd."/CLData.csv"));
    foreach($raw as $key => $data ) { $raw[$key] = array_combine($raw[0], $raw[$key]); }

    $data = array_values(array_slice($raw, 1));  
    
    // Open DB connection
    $dbh = new PDO("sqlite:".$cd."/Cldata.db");

    // Append to DB
    $fields = array_keys($data[0]);
    $qmarks = array_fill(0, count($data[0]), '?');

    $dbh->query("DELETE FROM cldata;");

    $sql = "INSERT INTO cldata (" . implode(",", $fields) . ")";          
    $sql = $sql . " VALUES (" . implode(",", $qmarks) . ")";

    $dbh->beginTransaction();
    foreach($data as $d) {
        $stmt = $dbh->prepare($sql);
        $stmt->execute(array_values($d));
    }
    $dbh->commit();
}

catch(PDOException $e) {  
    echo $e->getMessage()."\n";
    exit;
}

// Close DB connection
$dbh = null;

echo "Successfully migrated CSV data into SQL database!\n";

?>
