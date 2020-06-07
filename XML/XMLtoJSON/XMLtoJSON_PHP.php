<?php

$cd = dirname(__FILE__);

// LOAD XML
$xpath = simplexml_load_file($cd.'/CLData.xml');

// PARSE XML
$node = $xpath->xpath('//missedConnection');

$data = (array)$node;

// WRITE JSON
$json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
file_put_contents($cd."/CLData_PHP.json", $json);

echo "Successfully migrated XML data to JSON!\n";

?>
