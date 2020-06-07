<?php

$cd = dirname(__FILE__);

// LOAD XML
$xpath = simplexml_load_file($cd.'/CLData.xml');
  
// PARSE XML
$node = $xpath->xpath('//missedConnection');

// WRITE TO CSV
$fs = fopen($cd.'/CLData_PHP.csv', 'w');
 
$headers = array_keys((array)$node[0]);
fputcsv($fs, $headers);
 
foreach($node as $n) {
   fputcsv($fs, (array)$n);   
}

fclose($fs);

echo "Successfully migrated XML data to CSV!\n";

?>
