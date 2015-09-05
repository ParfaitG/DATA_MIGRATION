<?php

$cd = dirname(__FILE__);

// Loading XML source
$xpath = simplexml_load_file($cd.'/CLData.xml');
$todaydate = date("Ymd"); 

$i = 1;
$values = [];


// Writing column headers
$columns = array('user', 'category', 'city', 'post', 'time', 'link');

$fs = fopen($cd.'/../CLData'. $todaydate .'.csv', 'w');
fputcsv($fs, $columns);      
fclose($fs);


// Writing data lines
$node = $xpath->xpath('//missedConnection');

foreach ($node as $n){
     
     foreach ($columns as $col){
	  $child = $xpath->xpath('//missedConnection['. $i .']/'. $col);
	  
	  if (count($child) > 0) {
	       foreach($child as $value) {		    
		    $values[] = $value;         
	       }
	  }	  
	  else {
		$values[] = '';
	  }
     }  
	 
     $fs = fopen($cd.'/../CLData_'. $todaydate .'.csv', 'a');
     fputcsv($fs, $values);      
     fclose($fs);  

     $values = [];
     $i++;

}

echo "\nSuccessfully converted XML data to CSV!\n";

?>