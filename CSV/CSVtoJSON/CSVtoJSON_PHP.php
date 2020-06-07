<?php

$cd = dirname(__FILE__);

// READ CSV
$raw = array_map('str_getcsv', file($cd."/CLData.csv"));
foreach($raw as $key => $data ) { $raw[$key] = array_combine($raw[0], $raw[$key]); }

$data = array_values(array_slice($raw, 1));

// WRITE JSON
$json = json_encode($data, JSON_PRETTY_PRINT);

file_put_contents($cd."/CLData_PHP.json", $json);

echo "Successfully migrated CSV data to JSON!\n";

?>
