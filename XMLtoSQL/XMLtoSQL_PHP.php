<?php

$host="hostname";
$username="username";
$password="password";
$database="database";

// Load XML file
$cd = dirname(__FILE__);

$xpath = simplexml_load_file($cd.'/CLData.xml');

# Opening db connection
try {
     $dbh = new PDO("mysql:host=$host;dbname=$database",$username,$password);
     $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
     // Writing data lines
     $i = 0;
     $fields = [];
     $values = [];
     
     $elements = $xpath->xpath('//missedConnection');

     if (!is_null($elements)) {
          foreach($elements as $element) {
               foreach ($element as $item => $value) {     
                    $fields[] = $item;
                    $values[] = htmlspecialchars($value, ENT_QUOTES);          
               }
                         
          $insertStatement = "INSERT INTO cldata \n (" . implode(',', $fields) . ")";          
          $valuesList = " \n VALUES ('" . implode("','", $values) . "')";
          
          $sql = $insertStatement . ' ' . $valuesList;   
          $dbh->query($sql);
          
          $fields = [];
          $values = [];
          $i++;
          }
     }
}
catch(PDOException $e) {  
    echo $e->getMessage();
    exit;
}

echo "\nSuccessfully imported $i XML data rows in MySQL!\n";

# Closing db connection
$dbh = null;

?>