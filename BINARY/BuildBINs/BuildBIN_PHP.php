<?php

$cd = dirname(__FILE__);
chdir("../../CSV/CSVtoXML");

# READ CSV DATA
$raw = array_map('str_getcsv', file("CLData.csv"));
foreach($raw as $key => $data ) { $raw[$key] = array_combine($raw[0], $raw[$key]); }
$data = array_values(array_slice($raw, 1));

# SAVE OBJECT
file_put_contents($cd."/CLData_PHP.bin", serialize($data));

# LOAD OBJECT
$new_data = unserialize(file_get_contents($cd."/CLData_PHP.bin"));

echo var_dump(array_slice($new_data, 0, 5));

echo "Successfully created binary data!\n"

?>
