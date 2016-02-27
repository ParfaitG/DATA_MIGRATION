<?php

// Set current directory
$cd = dirname(__FILE__);

// Import content to string
$jsonString = file_get_contents($cd."/Cldata.json");

// Convert string to array (removing encoding issues)
$data = json_decode(preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $jsonString), true);

// Create a dom document 
$domtree = new DOMDocument('1.0', 'UTF-8');
$domtree->formatOutput = true;
$domtree->preserveWhiteSpace = false;

// Create the root element of the xml tree 
$xmlRoot = $domtree->createElement("CLData");
$xmlRoot = $domtree->appendChild($xmlRoot);

// Iterate through json array to create elements and values
foreach ($data as $d) {    
        
    $mcNode = $domtree->createElement('missedConnection');
    $mcNode = $xmlRoot->appendChild($mcNode);
    
    $userNode = $domtree->createElement('user', $d['user']);
    $userNode = $mcNode->appendChild($userNode);

    $categoryNode = $domtree->createElement('category', $d['category']);
    $categoryNode = $mcNode->appendChild($categoryNode);
    
    $cityNode = $domtree->createElement('city', $d['city']);
    $cityNode = $mcNode->appendChild($cityNode);       
   
    $timeNode = $domtree->createElement('time', $d['time']);
    $timeNode = $mcNode->appendChild($timeNode);
    
    $postNode = $domtree->createElement('post', htmlentities($d['post']));
    $postNode = $mcNode->appendChild($postNode);
    
    $linkNode = $domtree->createElement('link', htmlentities($d['link']));
    $linkNode = $mcNode->appendChild($linkNode);
    
}

// Output XML content to file
file_put_contents($cd. "/CLData_PHP.xml", $domtree->saveXML());

echo "Successfully migrated json data to xml! \n";

?>