<?php

$cd = dirname(__FILE__);

// Read CSV file
$raw = array_map('str_getcsv', file($cd."/CLData.csv"));
foreach($raw as $key => $data ) { $raw[$key] = array_combine($raw[0], $raw[$key]); }
$data = array_values(array_slice($raw, 1));

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

echo "Successfully migrated CSV data to XML!\n";

?>
