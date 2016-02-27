<?php

// Set current directory
$cd = dirname(__FILE__);

// Read CSV file
$handle = fopen($cd."/Cldata.csv", "r");

$data=[];
$i=0;
while (($file = fgetcsv($handle, 1000, ",")) !== FALSE) {
    if ($i==0) {$i++; continue;}
    
    $data[$i-1]['user'] = $file[0];
    $data[$i-1]['category'] = $file[1];
    $data[$i-1]['city'] = $file[2];
    $data[$i-1]['post'] = $file[3];
    $data[$i-1]['time'] = $file[4];
    $data[$i-1]['link'] = $file[5];
    $i++;
}

$json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

file_put_contents($cd."/Cldata_PHP.json", $json);
fclose($handle);

echo "\nSuccessfully migrated CSV data into JSON!\n";

?>
