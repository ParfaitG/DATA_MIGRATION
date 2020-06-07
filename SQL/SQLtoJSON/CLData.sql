
# ORIGINAL MYSQL EXAMPLE CREATE TABLE, CHANGE TO PREFERRED RDMS AS NEEDED

CREATE TABLE CLData (

    `user`  INTEGER,
    `category` VARCHAR(100),
    `city`  VARCHAR(100),
    `post` VARCHAR(100),
    `time` VARCHAR(100),
    `link`  VARCHAR(255),
    INDEX (`user`)    

);