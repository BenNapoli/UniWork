USE Ass1
go

-----------------------------------------------------------------------------------------------------
-- TEST 1 (Works fine)
-----------------------------------------------------------------------------------------------------

-- Prepair package list to be inserted
DECLARE @packageList packageListType
                             -- when reservation id is calculated it is added to all in Table
                             -- ((reservationID placeholder), packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate)
INSERT INTO @packageList VALUES ('0', '1112', '1', '2023-01-01', '2023-01-02')
INSERT INTO @packageList VALUES ('0', '1113', '2', '2023-01-01', '2023-01-02')

-- Prepair Guest list to be inserted
DECLARE @guestList guestListType
                            --(customerID, cName, cPhoneNumber, cEmail, cAddress, cDiscount)
INSERT INTO @guestList VALUES ('13', 'Benny', '0411111113', 'benny@gmail.com', '129 Sugar St, Newcastle, NSW, Australia, 2288', '0', '0')
INSERT INTO @guestList VALUES ('14', 'Jerremy', '0411111114', 'Jerremy@gmail.com', '126 Sugar St, Newcastle, NSW, Australia, 2288', '0', '0')

-- declare out
DECLARE @reservationID INT
-- execute make reservation with lists being passed in
EXEC usp_makeReservation '12', 'Barney', '0411111112', 'barney@gmail.com', '122 Sugar St, Newcastle, NSW, Australia, 2288', 'Mastercard 1212121212', @packageList, @guestList, @reservationID OUT
-- print reservation number
SELECT @reservationID AS reservationID

go


-- See deposit amount to be paid
EXECUTE printDepositRequirement @customerID = '12'


-- new Customer must pay deposit
EXECUTE payDeposit @customerID = '12', @rPaymentInfo = 'Mastercard 1212121212'


-- Test final bill to see all info is in
-- must first execute finalBill.sql
EXECUTE printFinalBill @customerID = '12'

-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- TEST 2 try and book over the limit of rooms on the date
-----------------------------------------------------------------------------------------------------

-- Prepair package list to be inserted
DECLARE @packageList packageListType
                             -- when reservation id is calculated it is added to all in Table
                             -- ((reservationID placeholder), packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate)
INSERT INTO @packageList VALUES ('0', '1112', '11', '2023-01-01', '2023-01-02')
INSERT INTO @packageList VALUES ('0', '1113', '20', '2023-01-01', '2023-01-02')

-- Prepair Guest list to be inserted
DECLARE @guestList guestListType
                            --(customerID, cName, cPhoneNumber, cEmail, cAddress, cDiscount)
INSERT INTO @guestList VALUES ('16', 'kella', '0411111116', 'kella@gmail.com', '129 Sugar St, Newcastle, NSW, Australia, 2288', '0', '0')
INSERT INTO @guestList VALUES ('17', 'David', '0411111117', 'david@gmail.com', '126 Sugar St, Newcastle, NSW, Australia, 2288', '0', '0')

-- declare out
DECLARE @reservationID INT
-- execute make reservation with lists being passed in
EXEC usp_makeReservation '15', 'Jones', '0411111115', 'jones@gmail.com', '122 Sugar St, Newcastle, NSW, Australia, 2288', 'Mastercard 1212333312', @packageList, @guestList, @reservationID OUT

go

-- this shows you it has all been rolled back
 SELECT * FROM Booking
 go


 -----------------------------------------------------------------------------------------------------
-- TEST 3 USE WITH PACKAGE CREATED (you must create the package first in create_package) and copy the packageID of created into this
-----------------------------------------------------------------------------------------------------
 -- use this to find package you created
 SELECT * FROM Package
 go


-- Prepair package list to be inserted
DECLARE @packageList packageListType
                             -- when reservation id is calculated it is added to all in Table
                             -- ((reservationID placeholder), packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate)
INSERT INTO @packageList VALUES ('0', '13374', '1', '2023-01-01', '2023-01-02')
---------------------------------------^^^^^EDIT THIS TO CHANGE PACKAGEID

-- Prepair Guest list to be inserted
DECLARE @guestList guestListType
                            --(customerID, cName, cPhoneNumber, cEmail, cAddress, cDiscount)
INSERT INTO @guestList VALUES ('7364', 'Temmy', '0411111163', 'temmy@gmail.com', '1 Sugar St, Newcastle, NSW, Australia, 2288', '0', '0')
INSERT INTO @guestList VALUES ('735', 'jarky', '0411111733', 'Jarky@gmail.com', '6 Sugar St, Newcastle, NSW, Australia, 2288', '0', '0')

-- declare out
DECLARE @reservationID INT
-- execute make reservation with lists being passed in
EXEC usp_makeReservation '364', 'bevel', '0411118562', 'Bevel@gmail.com', '2 Sugar St, Newcastle, NSW, Australia, 2288', 'Mastercard 1212188882', @packageList, @guestList, @reservationID OUT
-- print reservation number
SELECT @reservationID AS reservationID

go


-- See deposit amount to be paid
EXECUTE printDepositRequirement @customerID = '364'


-- new Customer must pay deposit
EXECUTE payDeposit @customerID = '364', @rPaymentInfo = 'Mastercard 1212188882'


-- Test final bill to see all info is in
-- must first execute finalBill.sql
EXECUTE printFinalBill @customerID = '364'

-- Manager can give this level of discount
EXECUTE giveDiscount @discount = '24', @staffID = '111111', @customerID = '364' 
-- Test final bill to see all info is in
-- must first execute finalBill.sql
EXECUTE printFinalBill @customerID = '364'
