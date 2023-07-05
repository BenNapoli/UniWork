
DROP DATABASE IF EXISTS Ass1
go

CREATE DATABASE Ass1
go

USE Ass1
go

DROP TABLE IF EXISTS Customer
DROP TABLE IF EXISTS Hotel
DROP TABLE IF EXISTS Reservation
DROP TABLE IF EXISTS FacilityTypes
DROP TABLE IF EXISTS Facilities
DROP TABLE IF EXISTS Staff
DROP TABLE IF EXISTS ServiceItems
DROP TABLE IF EXISTS Package
DROP TABLE IF EXISTS PackageServiceCount
DROP TABLE IF EXISTS Booking

DROP TRIGGER IF EXISTS checkAvailability

go

CREATE TABLE Customer (
  customerID INT PRIMARY KEY NOT NULL,
  cName VARCHAR(50),
  cPhoneNumber VARCHAR(20),
  cEmail VARCHAR(50),
  cAddress VARCHAR(100),
  cDiscount DECIMAL(10,2),
  cDepositPaid DECIMAL(10,2)
);

go

CREATE TABLE Hotel (
  hotelID INT PRIMARY KEY NOT NULL,
  hName VARCHAR(50),
  hAddress VARCHAR(100),
  hCountry VARCHAR(50), 
  hPhoneNumber VARCHAR(20),
  hDescription VARCHAR(200)
);

go

CREATE TABLE Reservation (
  reservationID INT PRIMARY KEY NOT NULL,
  customerID INT NOT NULL,
  rPaymentInfo VARCHAR(100),
  FOREIGN KEY(customerID) REFERENCES Customer(customerID) ON UPDATE CASCADE ON DELETE NO ACTION,
);

go

CREATE TABLE FacilityTypes (
  facilityTypesID INT PRIMARY KEY NOT NULL,
  fName VARCHAR(50)
);

go

CREATE TABLE Facilities (
  facilitiesID INT PRIMARY KEY NOT NULL,
  facilityTypesID INT NOT NULL,
  hotelID INT NOT NULL,
  fName VARCHAR(50),
  fDescription TEXT,
  fcurrency VARCHAR(20),
  FOREIGN KEY(hotelID) REFERENCES Hotel(hotelID) ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY(facilityTypesID) REFERENCES FacilityTypes(facilityTypesID) ON UPDATE CASCADE ON DELETE NO ACTION,
);

go

CREATE TABLE Staff (
  staffID INT PRIMARY KEY NOT NULL,
  sPosition VARCHAR(50) NOT NULL,
  sName VARCHAR(50)
);

go
  
CREATE TABLE Package (
  packageID INT PRIMARY KEY NOT NULL,
  staffID INT NOT NULL,
  pName VARCHAR(50),
  pStartDate DATE,
  pEndDate DATE,
  pDescription VARCHAR(MAX),
  pAdvertisedPrice DECIMAL(10,2) NOT NULL, --seasonal
  pAdvertisedCurrency VARCHAR(10) NOT NULL,
  pInclusions VARCHAR(100),
  pExclusions VARCHAR(100),
  pStatus VARCHAR(20),
  pGracePeriod INT,
  FOREIGN KEY(staffID) REFERENCES Staff(staffID) ON UPDATE CASCADE ON DELETE NO ACTION,
);

go

CREATE TABLE ServiceItems (
  serviceItemsID INT PRIMARY KEY NOT NULL,
  facilitiesID INT NOT NULL,
  sRestriction TEXT,
  sNotes VARCHAR(100),
  sComments VARCHAR(100),
  sStatus VARCHAR(20),
  sAvailableTimes VARCHAR(100),
  sBaseCost DECIMAL(10,2),
  sCapacity INT NOT NULL,
  FOREIGN KEY(facilitiesID) REFERENCES Facilities(facilitiesID) ON UPDATE CASCADE ON DELETE NO ACTION,
);

go

CREATE TABLE PackageServiceCount (
  packageID INT NOT NULL,
  serviceItemsID INT NOT NULL,
  Quantity INT NOT NULL,
  CONSTRAINT U_PackageServiceCount UNIQUE (packageID, serviceItemsID),
  FOREIGN KEY(packageID) REFERENCES Package(packageID) ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY(serviceItemsID) REFERENCES ServiceItems(serviceItemsID) ON UPDATE CASCADE ON DELETE NO ACTION,
 );

 go

CREATE TABLE Booking (
  bookingID INT IDENTITY(11111111,5) PRIMARY KEY NOT NULL,
  reservationID INT NOT NULL,
  packageID INT NOT NULL,
  bQuantityBooked INT NOT NULL,
  bBookingStartDate DATE NOT NULL,
  bBookingEndDate DATE,
  FOREIGN KEY(reservationID) REFERENCES Reservation(reservationID) ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY(packageID) REFERENCES Package(packageID) ON UPDATE CASCADE ON DELETE NO ACTION,
  ------------------------------------------------------------------------------------------------------------
  -- not needed because booking gets referenced and is therefore already connected, by adding facilities it creates a loop
  ------------------------------------------------------------------------------------------------------------
);
 
 go

----------------------------------------
  -- Insert Dummy data
----------------------------------------

                          --(customerID, cName, cPhoneNumber, cEmail, cAddress, cDiscount, cDepositPaid)
INSERT INTO Customer Values ('1', 'Ben', '0411111111', 'ben@gmail.com', '123 Sugar St, Newcastle, NSW, Australia, 2288', '0', '1000') -- should probably edit to make phone number the primary key
INSERT INTO Customer Values ('2', 'Ying', '0422222222', 'ying@gmail.com', '321 King St, Newcastle, NSW, Australia, 2288', '0', '500')
INSERT INTO Customer Values ('3', 'James', '04333333333', 'james@gmail.com', '136 Queen St, Newcastle, NSW, Australia, 2288', '0', '500')

INSERT INTO Customer Values ('4', 'Lan', '0411111111', 'lan@gmail.com', '321 Sugar St, Newcastle, NSW, Australia, 2288', '0', '375')
INSERT INTO Customer Values ('5', 'Alanna', '0422222222', 'alanna@gmail.com', '123 King St, Newcastle, NSW, Australia, 2288', '0', '1125')
INSERT INTO Customer Values ('6', 'Dawby', '04333333333', 'dawby@gmail.com', '631 Queen St, Newcastle, NSW, Australia, 2288', '0', '50')

INSERT INTO Customer Values ('7', 'Hellen', '0411111111', 'hellen@gmail.com', '123 sinapore St, Newcastle, Singapore, 99988', '0', '250')
INSERT INTO Customer Values ('8', 'Gemma', '0422222222', 'gemma@gmail.com', '321 sinaporeian St, Newcastle, Singapore, 99988', '0', '1000')
INSERT INTO Customer Values ('9', 'Dar', '04333333333', 'dar@gmail.com', '136 sinapore St, Newcastle, Singapore, 99988', '0', '350')
go

                      -- (hotelID, hName, hAddress, hCountry, hPhoneNumber, hDescription)
INSERT INTO Hotel Values ('11', 'Star Hotel', '123 greggle St, Newcastle, NSW, 2288', 'Australia', '0411111112', 'This is a 5 star hotel on the foreshore')
INSERT INTO Hotel Values ('22', 'Polygon Hotel', '123 pebble St, Newcastle, NSW, 2288', 'Australia', '0411111113', 'This is a 5 star hotel in the middle of town')
INSERT INTO Hotel Values ('33', 'Square Hotel', '123 sinapore St, Singapore, 99988', 'Asia', '0411111114', 'This is a 5 star hotel in the bush in singapore')
go

                            -- (reservationID, customerID, rPaymentInfo)
INSERT INTO Reservation Values ('111', '1', 'Mastercard 1111111111')
INSERT INTO Reservation Values ('222', '2', 'Mastercard 2222222222')
INSERT INTO Reservation Values ('333', '3', 'Mastercard 3333333333')

INSERT INTO Reservation Values ('444', '4', 'Mastercard 4444444444')
INSERT INTO Reservation Values ('555', '5', 'Mastercard 5555555555')
INSERT INTO Reservation Values ('666', '6', 'Mastercard 6666666666')

INSERT INTO Reservation Values ('777', '7', 'Mastercard 7777777777')
INSERT INTO Reservation Values ('888', '8', 'Mastercard 8888888888')
INSERT INTO Reservation Values ('999', '9', 'Mastercard 9999999999')
go

                              -- (facilityTypesID, fName)
INSERT INTO FacilityTypes Values ('1111', 'Standard Room')
INSERT INTO FacilityTypes Values ('2222', 'Swiming Pool')
INSERT INTO FacilityTypes Values ('3333', 'Family Room')
go

                           -- (facilitiesID, facilityTypesID, hotelID, fName, fDescription, fcurrency)
INSERT INTO Facilities Values ('11111', '1111', '11', 'Room with 2 beds', 'Our standard room comes with 2 beds, a coffee machine and a GREAT shower', 'AUD')
INSERT INTO Facilities Values ('22222', '3333', '11', 'Room with 4 beds', 'Our large room comes with 4 beds, a coffee machine and a GREAT shower AND a TV', 'AUD')

INSERT INTO Facilities Values ('33333', '1111', '22', 'Room with 2 beds', 'Our standard room comes with 2 beds, a coffee machine and a GREAT shower', 'AUD')
INSERT INTO Facilities Values ('44444', '2222', '22', 'Our hotel has a swimming pool', 'This hotel sports a 60 metre swimming pool and a diving board', 'AUD')

INSERT INTO Facilities Values ('55555', '1111', '33', 'Room with 2 beds', 'Our standard room comes with 2 beds, a coffee machine and a GREAT shower', 'EUR')
INSERT INTO Facilities Values ('66666', '3333', '33', 'Room with 4 beds', 'Our large room comes with 4 beds, a coffee machine and a GREAT shower AND a TV', 'EUR')
go

                      -- (staffID, sPosition, sName)
INSERT INTO Staff Values ('111111', 'Manager', 'Joey')
INSERT INTO Staff Values ('222222', 'Head Office', 'Siena')
INSERT INTO Staff Values ('333333', 'Manager', 'Will')
go

                         -- (packageID, staffID, pName, pStartDate, pEndDate, pDescription, pAdvertisedPrice, pAdvertisedCurrency, pInclusions, pExclusions, pStatus, pGracePeriod)
 INSERT INTO Package Values ('1112', '222222', 'Star package 1', '2023-01-01', '2023-02-01', 'Cheap standard room', '1000', 'AUD', 'All', 'None', 'Available', '3')
 INSERT INTO Package Values ('1113', '222222', 'Star package 2', '2023-01-01', '2023-03-01', 'Cheap large room', '2000', 'AUD', 'All', 'None', 'Available', '2')

 INSERT INTO Package Values ('1114', '222222', 'Polygon package 1', '2023-01-01', '2023-03-01', 'Cheap standard room', '1500', 'AUD', 'All', 'None', 'Available', '1')
 INSERT INTO Package Values ('1115', '222222', 'Polygon package 2', '2023-08-01', '2023-09-01', 'Specialty Pool Access', '200', 'AUD', 'All', 'None', 'Available', '11')

 INSERT INTO Package Values ('1116', '222222', 'Square package 1', '2023-01-01', '2023-08-01', 'Cheap standard room', '1000', 'EUR', 'All', 'None', 'Available', '6')
 INSERT INTO Package Values ('1117', '222222', 'Square package 2', '2023-09-01', '2023-11-01', 'Cheap large room', '1400', 'EUR', 'All', 'None', 'Available', '10')

 go

                             -- (serviceItemsID, facilitiesID, sRestriction, sNotes, sComments, sStatus, sAvailableTimes, sBaseCost, sCapacity)
INSERT INTO ServiceItems Values ('1111111', '11111', 'No under 12 guests', 'no notes', 'no comments', 'Available', 'Monday-Friday', '100', '10')
INSERT INTO ServiceItems Values ('2222222', '22222', 'No under 18 guests', 'no notes', 'no comments', 'Available', 'Tuesday-Friday', '200', '10')

INSERT INTO ServiceItems Values ('3333333', '33333', 'No under 22 guests', 'no notes', 'no comments', 'Available', 'Monday-Sunday', '150', '10')
INSERT INTO ServiceItems Values ('4444444', '44444', 'No under 8 guests', 'no notes', 'no comments', 'Available', 'Monday-Wednesday', '20', '20')

INSERT INTO ServiceItems Values ('5555555', '55555', 'No under 13 guests', 'no notes', 'no comments', 'Available', 'Monday-Tuesday', '100', '10')
INSERT INTO ServiceItems Values ('6666666', '66666', 'No under 19 guests', 'no notes', 'no comments', 'Available', 'Monday-Friday', '140', '10')

go
                                    -- (packageID, serviceItemsID, Quantity)
INSERT INTO PackageServiceCount Values ('1112', '1111111', '1')
INSERT INTO PackageServiceCount Values ('1113', '2222222', '1')

INSERT INTO PackageServiceCount Values ('1114', '3333333', '1')
INSERT INTO PackageServiceCount Values ('1115', '4444444', '1')

INSERT INTO PackageServiceCount Values ('1116', '5555555', '1')
INSERT INTO PackageServiceCount Values ('1117', '6666666', '1')

go


 -- (bookingID IS AUTO,     (reservationID, packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate)
 INSERT INTO Booking Values ('111', '1112', '1', '2023-01-01', '2023-01-02')
 INSERT INTO Booking Values ('111', '1112', '1', '2023-01-01', '2023-01-02')
 INSERT INTO Booking Values ('111', '1113', '1', '2023-01-01', '2023-01-02')
 INSERT INTO Booking Values ('222', '1112', '2', '2023-01-03', '2023-01-04')
 INSERT INTO Booking Values ('333', '1113', '1', '2023-01-05', '2023-01-06')

 INSERT INTO Booking Values ('444', '1114', '1', '2023-01-07', '2023-01-08')
 INSERT INTO Booking Values ('555', '1114', '3', '2023-01-09', '2023-01-10')
 INSERT INTO Booking Values ('666', '1115', '1', '2023-01-11', '2023-01-12')

 INSERT INTO Booking Values ('777', '1116', '1', '2023-01-13', '2023-01-14')
 INSERT INTO Booking Values ('888', '1116', '4', '2023-01-15', '2023-01-16')
 INSERT INTO Booking Values ('999', '1117', '1', '2023-01-17', '2023-01-18')

 go
  

----------------------------------------
  -- Check that all is inserted
----------------------------------------

 SELECT * FROM Customer
 go

 SELECT * FROM Hotel
 go

 SELECT * FROM Reservation
 go

 SELECT * FROM FacilityTypes
 go

 SELECT * FROM Facilities
 go

 SELECT * FROM Staff
 go

 SELECT * FROM ServiceItems
 go

 SELECT * FROM Package
 go

 SELECT * FROM Booking
 go


 -- ADDITIONAL CODE, THIS WAS AN ATTEMPT FOR EXTRA MARKS AND DOES NOT WORK CORRECTLY.

 -- trigger so that you cannot book too many hotel rooms
 -- only works for single day bookings...

CREATE TRIGGER checkAvailability
ON Booking
FOR INSERT, UPDATE
AS
BEGIN
	
	-- get max ammount that can be booked
	DECLARE @max INT = 0

	SELECT @max = s.sCapacity
	FROM Inserted i, Package p, ServiceItems s, PackageServiceCount ps
	WHERE p.packageID = i.packageID 
		AND p.packageID = ps.packageID
		AND ps.serviceItemsID = s.serviceItemsID

	-- get total already booked
	DECLARE @totalBooked INT = 0

	SELECT @totalBooked = SUM((b.bQuantityBooked*ps.quantity))-- packagesbooked x how many in each package
	FROM Booking b, Inserted i, PackageServiceCount ps
	WHERE b.bBookingStartDate = i.bBookingStartDate 
		AND b.packageID = i.packageID
		AND b.packageID = ps.packageID

	IF (@max - @totalBooked) < 0
	BEGIN
		RAISERROR('Cannot book more then max available on certain date', 16, 1)
		ROLLBACK TRANSACTION
	END

END



