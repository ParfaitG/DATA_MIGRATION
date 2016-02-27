<?php

// Database credentials
$host="localhost";
$database="****";
$username="****";
$password="****";

// Set current directory
$cd = dirname(__FILE__);

// Import content to string
$jsonString = file_get_contents($cd."/Cldata.json");

// Convert string to array (removing encoding issues)
$data = json_decode(preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $jsonString), true);

try {
        # Open db connection
        $dbh = new PDO("mysql:host=$host;dbname=$database",$username,$password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        foreach ($data as $rows) {
            
            # Preparing query statement
            $sth = $dbh->prepare("INSERT INTO cldata (user, category, city, post, time, link)
                                  VALUES (?, ?, ?, ?, ?, ?)");
            
            # Binding parameters
            $sth->bindParam(1, $rows['user'], PDO::PARAM_STR, 50);
            $sth->bindParam(2, $rows['category'], PDO::PARAM_STR, 50);
            $sth->bindParam(3, $rows['city'], PDO::PARAM_STR, 50);
            $sth->bindParam(4, $rows['post'], PDO::PARAM_STR, 50);
            $sth->bindParam(5, $rows['time'], PDO::PARAM_STR, 50);
            $sth->bindParam(6, $rows['link'], PDO::PARAM_STR, 50);
            
            # Execute append query            
            $sth->execute();
        }
}

catch(PDOException $e) {  
    echo $e->getMessage();
    exit;
}

# Closing db connection
$dbh = null;

echo "Successfully migrated json data to sql! \n";

?>