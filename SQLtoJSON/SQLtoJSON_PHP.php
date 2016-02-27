<?php

// Database credentials
$host="localhost";
$database="****";
$username="***";
$password="****";

// Set current directory
$cd = dirname(__FILE__);

try {
        # Open db connection
        $dbh = new PDO("mysql:host=$host;dbname=$database",$username,$password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	# Query database table
        $sql = "SELECT * FROM cldata";
        $STH = $dbh->query($sql);
        $STH->setFetchMode(PDO::FETCH_ASSOC);
}
catch(PDOException $e) {  
    echo $e->getMessage();  
} 

$i = 0;
// Writing data rows
while($row = $STH->fetch()) {
     
    $data[$i]['user'] =  $row['user'];
    $data[$i]['category'] =  $row['category'];
    $data[$i]['city'] =  $row['city'];
    $data[$i]['time'] =  $row['time'];
    $data[$i]['post'] =  $row['post'];
    $data[$i]['link'] =  $row['link'];
    
    $i++;
}

// Output to JSON file
$json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
file_put_contents($cd."/Cldata_PHP.json", $json);

echo "\nSuccessfully migrated SQL data into JSON!\n";

?>
