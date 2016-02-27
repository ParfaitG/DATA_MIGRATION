<?php

// Set current directory
$cd = dirname(__FILE__);

// Import content to string
$jsonString = file_get_contents($cd."/Cldata.json");

// Convert string to array (removing encoding issues)
$data = json_decode(preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $jsonString), true);

// Exporting to csv
$fp = fopen($cd.'/Cldata_PHP.csv', 'w');
fputcsv($fp, array('user', 'category', 'city', 'time', 'post', 'link'));    
foreach ($data as $rows) {    
    fputcsv($fp, $rows);                                                    
}
fclose($fp);

echo "Successfully migrated json data to csv! \n";

?>