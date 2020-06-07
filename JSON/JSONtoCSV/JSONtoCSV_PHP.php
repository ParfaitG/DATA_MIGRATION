<?php

// READ JSON
$cd = dirname(__FILE__);

$jsonString = file_get_contents($cd."/CLData.json");
$data = json_decode($jsonString, true);

// WRITE CSV
$fp = fopen($cd.'/CLData_PHP.csv', 'w');
fputcsv($fp, array_keys($data[0]));    
foreach ($data as $d) {    
    fputcsv($fp, array_values($d));                                                    
}
fclose($fp);

echo "Successfully migrated JSON data to CSV!\n";

?>
