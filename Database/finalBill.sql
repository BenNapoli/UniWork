USE Ass1
go

DROP PROCEDURE IF EXISTS printFinalBill
DROP PROCEDURE IF EXISTS giveDiscount
DROP PROCEDURE IF EXISTS isHeadOffice
go


-- simply joins all the related tables and pints all information needed for the final bill
CREATE PROCEDURE printFinalBill
    @customerID INT 
AS
-- ((p.pAdvertisedPrice/100) * (100-c.cDiscount))
	-- Discount calculated on print as it can be added any time during the process
	SELECT p.pName AS PackageName, bQuantityBooked AS Quantity, p.pAdvertisedPrice AS Cost, p.pAdvertisedCurrency As Currency, r.rPaymentInfo As CardNumber
	FROM Customer c, Reservation r, Booking b, Package p
	WHERE c.customerID = @customerID 
		AND c.customerID = r.CustomerID
		AND r.reservationID = b.reservationID
		AND b.packageID = p.packageID;

	DECLARE @total DECIMAL(10,2) = 0
	DECLARE @discount DECIMAL(10,2) = 0
	DECLARE @paid DECIMAL(10,2) = 0

	-- get total without discount
	SELECT @Total = SUM(p.pAdvertisedPrice*b.bQuantityBooked)
	FROM Customer c, Reservation r, Booking b, Package p
	WHERE c.customerID = @customerID 
		AND c.customerID = r.CustomerID
		AND r.reservationID = b.reservationID
		AND b.packageID = p.packageID;

	-- Get discount for final bill
	SELECT @discount = cDiscount
    FROM Customer
	WHERE customerID = @customerID

	-- get deposit paid
	SELECT @paid = cDepositPaid
    FROM Customer
	WHERE customerID = @customerID

	-- Create and display a table
	CREATE TABLE FinalCost
	(
	total DECIMAL(10,2),
	percentDiscount DECIMAL(10,2),
	depositPaid DECIMAL(10,2),
	newTotal DECIMAL(10,2)
	)

	INSERT INTO FinalCost VALUES (@Total, @discount, @paid, (((@total/100) * (100-@discount)) - @paid))

	SELECT * FROM FinalCost

	DROP TABLE FinalCost
go


-- this procedure is used to check if the staff is head office or manager.
-- output is used when stopping over 25% discounts
CREATE PROCEDURE isHeadOffice 
	@staffIDIn INT, -- input parameter
    @isStaff INT OUTPUT  -- output parameter
AS
	DECLARE @pos VARCHAR(50) 

	-- Get position given staffID
    SELECT @pos = sPosition
    FROM Staff
	WHERE staffID = @staffIDIn

	-- if head office
	IF @pos = 'Head Office'
	BEGIN 
		SET @isStaff = 2
	END
	--if any other staff
	IF @pos = 'Manager'
	BEGIN 
		SET @isStaff = 1
	END
GO


CREATE PROCEDURE giveDiscount
    @discount INT,
	@staffID INT,
	@customerID INT 
AS
	--check to see if inputted is staff/headoffice
	DECLARE @isStaff INT = 0
	EXECUTE isHeadOffice @StaffID, @isStaff OUT

	-- cant discount over 100%
	IF @discount > 100 
	BEGIN 
		RAISERROR('Cannot have discount > 100', 11, 1)
	END

	-- cant discount under 0%
	IF @discount < 0 
	BEGIN 
		RAISERROR('Cannot have discount < 0', 11, 1)
	END
	
	-- discount between 25-100 (Head Office only)
	IF @discount >= 25 AND @discount < 101
	BEGIN 

		IF @isStaff != '2' -- if not head office
		BEGIN 
			RAISERROR('Need head office permission for discount 25 and over', 11, 1)
		END

		IF @isStaff = '2' -- if head office
		BEGIN 
			-- Discount stored in customer table so it can be applied to all charges at the end
			UPDATE Customer
			SET cDiscount = @discount
			WHERE customerID = @customerID;
		END
		

	END

	-- discount between 0-25 (all Staff)
	IF @discount < 25 AND @discount >= 0
	BEGIN 

		IF @isStaff != '1' AND @isStaff != '2'-- if not head office or staff
		BEGIN 
			RAISERROR('Need staff permission to give discount', 11, 1)
		END

		IF @isStaff = '1' OR @isStaff = '2' -- if either head office or staff
		BEGIN 
			UPDATE Customer
			SET cDiscount = @discount
			WHERE customerID = @customerID;
		END

	END

go
