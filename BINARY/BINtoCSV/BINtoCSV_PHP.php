<?php

$cd = dirname(__FILE__);
chdir("../BuildBINs");

// READ BINARY
$data = unserialize(file_get_contents($cd."/../BuildBINs/CLData_PHP.bin"));

// WRITE CSV
$fp = fopen($cd.'/CLData_PHP.csv', 'w');
fputcsv($fp, array_keys($data[0]));    
foreach ($data as $d) {    
    fputcsv($fp, array_values($d));                                                    
}
fclose($fp);

echo "Successfully migrated binary data to CSV!\n";

?>
