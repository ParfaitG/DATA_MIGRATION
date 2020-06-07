<?php

$cd = dirname(__FILE__);

// Load Object
$data = unserialize(file_get_contents($cd."/../BuildBINs/CLData_PHP.bin"));

// Initialize XML
$dom = new DOMDocument('1.0', 'UTF-8');
$dom->formatOutput = true;
$dom->preserveWhiteSpace = false;

$root = $dom->createElement("CLData");
$root = $dom->appendChild($root);

// Build XML nodes
foreach($data as $d) {
   $mcNode = $dom->createElement('missedConnection');    

   foreach($d as $k=>$v) {
      $childNode = $dom->createElement($k, htmlspecialchars($v));
      $mcNode->appendChild($childNode);
   }

   $root->appendChild($mcNode);
}

// Save XML
file_put_contents($cd. "/CLData_PHP.xml", $dom->saveXML());

echo "Successfully migrated binary data into XML!\n";

?>
