<?php

// Set current directory
$cd = dirname(__FILE__);

// Loading XML source
$xml = simplexml_load_file($cd.'/CLData.xml');

// Initializing variables
$data = [];
$i = 1;

$node = $xml->xpath('//missedConnection');
$columns = array('user', 'category', 'city', 'post', 'time', 'link');

// Extracting node values
foreach ($node as $n){
     
     foreach ($columns as $col){
	  $child = $xml->xpath('//missedConnection['. $i .']/'. $col);
	  
	  if (count($child) > 0) {
	       foreach($child as $value) {                    
		    $data[$i-1][$col] =  (string)$value;   
	       }
	  }	  
	  else {
		$data[$i-1][$col] = '';
	  }
     }
     
     $i++;
}

// Encode json and export to external file
$json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
file_put_contents($cd."/Cldata_PHP.json", $json);

echo "\nSuccessfully migrated XML data into JSON!\n";

?>
