<?php

// Set current directory
$cd = dirname(__FILE__);

// Create a DOM document 
$domtree = new DOMDocument('1.0', 'UTF-8');
$domtree->formatOutput = true;
$domtree->preserveWhiteSpace = false;

// Create the root element of the XML tree
$xmlRoot = $domtree->createElement("CLData");
$xmlRoot = $domtree->appendChild($xmlRoot);

// Read CSV file
$handle = fopen($cd."/CLData.csv", "r");    

// Write to XML nodes
$row = 0;
while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
    $row++;
    if($row == 1){ $row++; continue; }
        
    $mcNode = $domtree->createElement('missedConnection');
    $mcNode = $xmlRoot->appendChild($mcNode);
    
    $userNode = $domtree->createElement('user', $data[0]);
    $userNode = $mcNode->appendChild($userNode);
    
    $cityNode = $domtree->createElement('city', $data[1]);
    $cityNode = $mcNode->appendChild($cityNode);
    
    $categoryNode = $domtree->createElement('category', $data[2]);
    $categoryNode = $mcNode->appendChild($categoryNode);
   
    $postNode = $domtree->createElement('post', htmlentities($data[3]));
    $postNode = $mcNode->appendChild($postNode);
   
    $timeNode = $domtree->createElement('time', $data[4]);
    $timeNode = $mcNode->appendChild($timeNode);
    
    $linkNode = $domtree->createElement('link', htmlentities($data[5]));
    $linkNode = $mcNode->appendChild($linkNode);
    
}

// Output XML content to file
file_put_contents($cd. "/CLData_PHPOutput.xml", $domtree->saveXML());
fclose($handle);

echo "\nSuccessfully migrated CSV data into XML!\n";


?>