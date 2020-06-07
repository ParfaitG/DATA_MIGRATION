<?php

$cd = dirname(__FILE__);
chdir("../BuildBINs");

// READ BINARY
$data = unserialize(file_get_contents("CLData_PHP.bin"));

// WRITE JSON
$json = json_encode($data, JSON_PRETTY_PRINT);

file_put_contents($cd."/CLData_PHP.json", $json);

echo "Successfully converted binary data to JSON!\n";

?>
