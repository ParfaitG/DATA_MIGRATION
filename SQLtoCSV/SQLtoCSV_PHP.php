<?php

$host="hostname";
$username="username";
$password="password";
$database="database";

$cd = dirname(__FILE__);
$todaydate = date("Ymd");

# Open database connection
try {
    $dbh = new PDO("mysql:host=$host;dbname=$database",$username,$password);    
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $sql = "SELECT * FROM cldata";
    $STH = $dbh->query($sql);
    $STH->setFetchMode(PDO::FETCH_ASSOC);
    
}
catch(PDOException $e) {  
    echo $e->getMessage();  
} 

// Writing column headers
$columns = array('user', 'category', 'city', 'post', 'time', 'link');

$fs = fopen($cd.'/CLData_'. $todaydate .'.csv', 'w');
fputcsv($fs, $columns);      
fclose($fs);

// Writing data rows
while($row = $STH->fetch()) {
     
    $fs = fopen($cd.'/CLData_'. $todaydate .'.csv', 'a');
        fputcsv($fs, $row);
    fclose($fs);

}

# Close database connection
$dbh = null;

echo "\nSuccessfully migrated SQL data to CSV!\n";

?>
