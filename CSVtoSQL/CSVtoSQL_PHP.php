<?php

$host="hostname";
$username="username";
$password="password";
$database="database";

// Set current directory
$cd = dirname(__FILE__);

try {
     $dbh = new PDO("mysql:host=$host;dbname=$database",$username,$password);
     $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
    // Read CSV file
    $handle = fopen($cd."/CLData.csv", "r");    
    
    $row = 0;
    $fields = [];
    $values = [];
    
    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
        
        $row++;
        // OBTAIN FIELDS
        if($row == 1) {
            $row++;
            $fields[] = $data[0];
            $fields[] = $data[1];
            $fields[] = $data[2];
            $fields[] = $data[3];
            $fields[] = $data[4];
            $fields[] = $data[5];
            continue;
        }
        
        // OBTAIN VALUES
        $values[] = addslashes($data[0]);
        $values[] = addslashes($data[1]);
        $values[] = addslashes($data[2]);
        $values[] = addslashes($data[3]);
        $values[] = addslashes($data[4]);
        $values[] = addslashes($data[5]);
        
        $insertStatement = "INSERT INTO cldata \n (" . implode(',', $fields) . ")";          
        $valuesList = " \n VALUES ('" . implode("','", $values) . "')";
        
        $sql = $insertStatement . ' ' . $valuesList;   
        $dbh->query($sql);
        
        $values = [];
    }
}

catch(PDOException $e) {  
    echo $e->getMessage();
    exit;
}

# Closing db connection and csv file
$dbh = null;
fclose($handle);

echo "\nSuccessfully migrated CSV data into SQL!\n";


?>