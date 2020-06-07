<?php

$cd = dirname(__FILE__);

// INITIALIZE XML DOCUMENT
// create a dom document with encoding utf8 
$dom = new DOMDocument('1.0', 'UTF-8');
$dom->formatOutput = true;
$dom->preserveWhiteSpace = false;

$root = $dom->createElement("CLData");
$root = $dom->appendChild($root);

// CONNECT TO DATABASE
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
    exit;
}

// BUILD XML BY DATA ROWS
foreach($data as $d) {
     $mcNode = $dom->createElement('missedConnection');
     $mcNode = $root->appendChild($mcNode);
     
     foreach($d as $k=>$v) {
         $childNode = $dom->createElement($k, htmlspecialchars($v));
         $mcNode->appendChild($childNode);
     }
}

file_put_contents($cd. "/CLData_PHP.xml", $dom->saveXML());

// CLOSE DB CONNECTION
$dbh = null;

echo "Successfully migrated SQL data to XML!\n";

?>
