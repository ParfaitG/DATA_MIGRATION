<?php

$cd = dirname(__FILE__);

# OPEN DATABASE
try {
    $dbh = new PDO("sqlite:".$cd."/CLData.db");  
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $sql = "SELECT * FROM cldata";
    $sth = $dbh->query($sql);
    $sth->setFetchMode(PDO::FETCH_ASSOC);
    $data = $sth->fetchAll();
}
catch(PDOException $e) {  
    echo $e->getMessage();  
} 

// WRITE CSV
$fs = fopen($cd.'/CLData_PHP.csv', 'w');

// HEADERS
fputcsv($fs, array_keys($data[0]));

// DATA ROWS
foreach($data as $row) {
    fputcsv($fs, $row);
}
fclose($fs);

// CLOSE DATABASE
$dbh = null;

echo "Successfully migrated SQL data to CSV!\n";

?>
