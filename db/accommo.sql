-- Active: 1716754658456@@127.0.0.1@3306@accommo_php
CREATE DATABASE Accommo_php
    DEFAULT CHARACTER SET = 'utf8mb4';

USE Accommo_php;

CREATE TABLE Users (
    User_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Username VARCHAR(100) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Password VARCHAR(25) NOT NULL
);

CREATE TABLE Rooms (
    Room_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Price DOUBLE NOT NULL,
    Dimensions VARCHAR(15) NOT NULL,
    Beds INT NOT NULL,
    Bathrooms INT NOT NULL,
    Facilities VARCHAR(150) NOT NULL,
    Images JSON NOT NULL
);

CREATE TABLE Accommodations (
    Accommo_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Room_ID INT NOT NULL,
    User_ID INT NOT NULL,
    Check_in DATE NOT NULL,
    Check_out DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Foreign Key (Room_ID) REFERENCES Rooms(Room_ID) ON DELETE CASCADE,
    Foreign Key (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE
);

--Accommodaton trigger to check if the checkout is greater that the check in, at least in one hour
DELIMITER $
CREATE OR REPLACE TRIGGER acommodations_date_before_insert
BEFORE INSERT ON accommodations FOR EACH ROW
BEGIN
    DECLARE check_in BIGINT;
    DECLARE check_out BIGINT;
    DECLARE check_btwn BIGINT;

    IF NEW.Check_in >= NEW.Check_out OR NEW.Check_in < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = "The accommodation period is not correct";
    END IF;

    SELECT COUNT(*) INTO check_in FROM accommodations WHERE (accommodations.`Room_ID` = NEW.`Room_ID`)
    AND (accommodations.`Check_in` BETWEEN NEW.`Check_in` AND NEW.`Check_out`);

    SELECT COUNT(*) INTO check_out FROM accommodations WHERE (accommodations.`Room_ID` = NEW.`Room_ID`) 
    AND (accommodations.`Check_out` BETWEEN NEW.`Check_in` AND NEW.`Check_out`);

    SELECT COUNT(*) INTO check_btwn FROM accommodations WHERE (accommodations.`Room_ID` = NEW.`Room_ID`)
    AND (accommodations.`Check_in` <= NEW.`Check_in` AND NEW.`Check_out` <= accommodations.`Check_out`);

    IF check_in > 0 OR check_out > 0 OR check_btwn > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = "This room is not available in that period";
    END IF;
END $
DELIMITER ;


--Dumping Users
INSERT INTO users (`Name`, `Username`, `Email`, `Password`) 
VALUES ("Juan Perez", "JP", "user@example.com","12345678");
INSERT INTO users (`Name`, `Username`, `Email`, `Password`) 
VALUES ("Nayib Bukele", "Nayib", "nb@example.com","123123");
INSERT INTO users (`Name`, `Username`, `Email`, `Password`) 
VALUES ("Fernando Aguilar", "ferjo", "ferjo@example.com","1111 2223");
INSERT INTO users (`Name`, `Username`, `Email`, `Password`) 
VALUES ("Joaquin Juarez", "jacubiam", "jc@example.com","1111 7777");
INSERT INTO users (`Name`, `Username`, `Email`, `Password`) 
VALUES ("Vladimir Putin", "vlad", "vlad@example.com","00001111");
INSERT INTO users (`Name`, `Username`, `Email`, `Password`) 
VALUES ("Joe Biden", "OldJoe", "joe@example.com","x1x1x1");
INSERT INTO users (`Name`, `Username`, `Email`, `Password`) 
VALUES ("admin", "admin", "admin@example.com","xsuperuser69x");


--Dumping Rooms
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (80.99,"6mx10m",2,1,"TV and Sofas", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137323/kodigo/accommo_php/indoors-4234071_1280_jiledg.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137348/kodigo/accommo_php/bed-4416515_1280_jmhpim.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (50,"6mx6m",1,1,"Chairs and TV", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137579/kodigo/accommo_php/bedroom-5664223_1280_rwihdv.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (100.00,"8mx10m",2,2,"Wardrobes, TV and Sofas", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137578/kodigo/accommo_php/bedroom-1330846_1280_rrnfvz.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (120.00,"8mx10m",2,2,"Wardrobes, Large Windows TV and Sofas", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137579/kodigo/accommo_php/hotel-595121_1280_oxoa2t.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717186569/kodigo/accommo_php/bathroom-4_b6iwr8.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (140.00,"10mx10m",2,2,"Rural views TV and Sofas", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-room-2619509_1280_w0bagn.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/bedroom-6577523_1280_xybbtm.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (60.00,"6mx8m",1,1,"Small and Comfortable", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330845_1280_y7ekdj.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330834_1280_prcmsh.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (60.00,"6mx8m",1,1,"Small and Comfortable", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330845_1280_y7ekdj.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330834_1280_prcmsh.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (60.00,"6mx8m",1,1,"Small and Comfortable", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330845_1280_y7ekdj.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330834_1280_prcmsh.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (60.00,"6mx8m",1,1,"Small and Comfortable", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330845_1280_y7ekdj.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330834_1280_prcmsh.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (60.00,"6mx8m",1,1,"Small and Comfortable", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330845_1280_y7ekdj.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330834_1280_prcmsh.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (60.00,"6mx8m",1,1,"Small and Comfortable", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330845_1280_y7ekdj.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-1330834_1280_prcmsh.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (160.00,"12mx20m",3,2,"Internet, Cable, Living Room and a lot of spaces", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137581/kodigo/accommo_php/room-2269591_1280_cg4irg.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137580/kodigo/accommo_php/hotel-room-2619509_1280_w0bagn.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (90.00,"8mx10m",1,1,"Internet, Cable, TV and Balcony", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137581/kodigo/accommo_php/travel-1677347_1280_mtp2m2.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717186569/kodigo/accommo_php/bathroom-1_gozwog.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (120.00,"10mx10m",2,1,"Internet, Cable, and a large living room", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137582/kodigo/accommo_php/hotel-1749602_1280_rbe15e.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717186569/kodigo/accommo_php/bathroom-3_nauybc.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (140.00,"12mx10m",2,2,"Internet, Cable, Rooftop and a glass dome", 
JSON_ARRAY(
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137582/kodigo/accommo_php/room-2269594_1280_lk58kr.jpg",
    "https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717186569/kodigo/accommo_php/bathroom-3563272_1280_bmbbhu.jpg"
));
INSERT INTO rooms (`Price`, `Dimensions`, `Beds`, `Bathrooms`, `Facilities`, `Images`)
VALUES (140.00,"12mx10m",2,2,"Internet, Cable, Rooftop and a glass dome", 
JSON_ARRAY(
    'https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717137582/kodigo/accommo_php/room-2269594_1280_lk58kr.jpg',
    'https://res.cloudinary.com/dk2oxzxoo/image/upload/v1717186569/kodigo/accommo_php/bathroom-3563272_1280_bmbbhu.jpg'
));



--Dumping Accommos
INSERT INTO accommodations (`Room_ID`, `User_ID`,`Check_in` ,`Check_out`) VALUES (1, 2, "2024-07-01", "2024-07-30");
INSERT INTO accommodations (`Room_ID`, `User_ID`, `Check_in`,`Check_out`) VALUES (2, 4, "2024-08-01", "2024-08-05");
INSERT INTO accommodations (`Room_ID`, `User_ID`, `Check_in`,`Check_out`) VALUES (3, 6, "2024-08-05", "2024-08-10");
INSERT INTO accommodations (`Room_ID`, `User_ID`, `Check_in`,`Check_out`) VALUES (4, 5, "2024-08-05", "2024-08-15");



--Select tests
SELECT * FROM users;
SELECT * FROM rooms;
SELECT * FROM accommodations;

SELECT * FROM rooms WHERE NOT EXISTS (
    SELECT * FROM accommodations WHERE (accommodations.`Room_ID` = rooms.`Room_ID`) 
    AND  (accommodations.`Check_in` BETWEEN "2024-08-05" AND "2024-08-15")
    UNION
    SELECT * FROM accommodations WHERE (accommodations.`Room_ID` = rooms.`Room_ID`) 
    AND (accommodations.`Check_out` BETWEEN "2024-08-05" AND "2024-08-15")
    UNION
    SELECT * FROM accommodations WHERE (accommodations.`Room_ID` = rooms.`Room_ID`) 
    AND (accommodations.`Check_in` <= "2024-08-05" AND "2024-08-15" <= accommodations.`Check_out`)
);

SELECT rooms.* FROM accommodations INNER JOIN rooms ON accommodations.`Room_ID` = rooms.`Room_ID` WHERE accommodations.`User_ID` = 2;

