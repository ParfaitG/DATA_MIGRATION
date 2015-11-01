<?php

// Load XML file
$cd = dirname(__FILE__);

// create a dom document with encoding utf8 
$domtree = new DOMDocument('1.0', 'UTF-8');
$domtree->formatOutput = true;
$domtree->preserveWhiteSpace = false;

/* create the root element of the xml tree */
$xmlRoot = $domtree->createElement("CLData");
$xmlRoot = $domtree->appendChild($xmlRoot);


# Opening db connection
try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$database",$username,$password);    
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $sql = "SELECT * FROM cldata";
    $STH = $dbh->query($sql);
    $STH->setFetchMode(PDO::FETCH_ASSOC);
}
 
catch(PDOException $e) {  
    echo $e->getMessage();
    exit;
}

while($row = $STH->fetch()) {  
  
     $mcNode = $domtree->createElement('missedConnection');
     $mcNode = $xmlRoot->appendChild($mcNode);
     
     $userNode = $domtree->createElement('user', $row['user']);
     $userNode = $mcNode->appendChild($userNode);

     $cityNode = $domtree->createElement('city', $row['city']);
     $cityNode = $mcNode->appendChild($cityNode);
     
     $categoryNode = $domtree->createElement('category', $row['category']);
     $categoryNode = $mcNode->appendChild($categoryNode);
    
     $postNode = $domtree->createElement('post', htmlentities($row['post']));
     $postNode = $mcNode->appendChild($postNode);
    
     $timeNode = $domtree->createElement('time', $row['time']);
     $timeNode = $mcNode->appendChild($timeNode);
     
     $linkNode = $domtree->createElement('link', htmlentities($row['link']));
     $linkNode = $mcNode->appendChild($linkNode);

}

file_put_contents($cd. "/CLDataOutput.xml", $domtree->saveXML());

echo "\nSuccessfully migrated SQL data into XML!\n";

# Closing db connection
$dbh = null;
exit;


?>