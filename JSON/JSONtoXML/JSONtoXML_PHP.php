<?php

// Import JSON
$cd = dirname(__FILE__);
$jsonString = file_get_contents($cd."/CLData.json");
$data = json_decode($jsonString, true);

// Initialize XML
$dom= new DOMDocument('1.0', 'UTF-8');
$dom->formatOutput = true;
$dom->preserveWhiteSpace = false;

$root = $dom->createElement("CLData");
$root = $dom->appendChild($root);

// Build XML nodes
foreach ($data as $d) {    
    $mcNode = $dom->createElement('missedConnection');
    $root->appendChild($mcNode);

    foreach($d as $k => $v) {
        $childNode = $dom->createElement($k, htmlspecialchars($v));
        $mcNode->appendChild($childNode);
    }
}

// Write XML
file_put_contents($cd. "/CLData_PHP.xml", $dom->saveXML());

echo "Successfully migrated JSON data to XML!\n";

?>
