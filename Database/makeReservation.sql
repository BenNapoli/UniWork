USE Ass1
go

DROP TYPE IF EXISTS packageListType
DROP TYPE IF EXISTS guestListType
go

DROP PROCEDURE IF EXISTS usp_makeReservation
DROP PROCEDURE IF EXISTS payDeposit
DROP PROCEDURE IF EXISTS printDepositRequirement
go

-- Create a pachage types to be passed through the procedure as a variable
CREATE TYPE packageListType AS TABLE 
(
  reservationID INT,
  packageID INT,
  bQuantityBooked INT,
  bBookingStartDate DATE,
  bBookingEndDate DATE
)
go

CREATE TYPE guestListType AS TABLE 
(
	customerID INT,
	cName VARCHAR(50),
	cPhoneNumber VARCHAR(20),
	cEmail VARCHAR(50),
	cAddress VARCHAR(100),
	cDiscount DECIMAL(10,2),
	cDepositPaid DECIMAL(10,2)
)
go


-- simply joins all the related tables and pints all information needed for the final bill
CREATE PROCEDURE usp_makeReservation 
	--customer variables
	@customerID INT,
	@cName VARCHAR(50),
	@cPhoneNumber VARCHAR(20),
	@cEmail VARCHAR(50),
	@cAddress VARCHAR(100),
	@rPaymentInfo VARCHAR(100),
	@packageList packageListType READONLY, -- lists
	@guestList guestListType READONLY,
	@reservationID INT OUTPUT  -- output parameter
AS

	BEGIN TRY

		BEGIN TRANSACTION

		-- insert customer
		INSERT INTO Customer VALUES (@customerID, @cName, @cPhoneNumber, @cEmail, @cAddress, '0', '0')

		-- insert guests
		INSERT INTO Customer(customerID, cName, cPhoneNumber, cEmail, cAddress, cDiscount, cDepositPaid)
		SELECT customerID, cName, cPhoneNumber, cEmail, cAddress, cDiscount, cDepositPaid
		FROM @guestList

		-- unique guarenteed
		SET @reservationID = @customerID + @cPhoneNumber

		INSERT INTO Reservation VALUES (@reservationID, @customerID, @rPaymentInfo)


		-- create a duplicate so that it is editable as need to insert correct reservationID
		DECLARE @packageListEditable packageListType

		-- Duplicate the Table into an editable one
		INSERT INTO @packageListEditable(reservationID, packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate)
		SELECT reservationID, packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate
		FROM @packageList

		-- Update ReservationID in each table
		UPDATE @packageListEditable
			SET reservationID = @reservationID
		WHERE reservationID = 0

		-- insert table into booking
		-- (bookingID IS auto, (reservationID, packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate)
		INSERT INTO Booking(reservationID, packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate)
		SELECT reservationID, packageID, bQuantityBooked, bBookingStartDate, bBookingEndDate
		FROM @packageListEditable

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT
		ERROR_NUMBER() AS ErrorNumber
		,ERROR_SEVERITY() AS ErrorSeverity
		,ERROR_STATE() AS ErrorState
		,ERROR_PROCEDURE() AS ErrorProcedure
		,ERROR_LINE() AS ErrorLine
		,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH

go


-- this procedure sums up all the costs in the table and displays the 25% deposit amount
CREATE PROCEDURE printDepositRequirement
    @customerID INT 
AS
	BEGIN TRY

		BEGIN TRANSACTION

		-- cant pay deposit 2ce
		DECLARE @cDepositPaid DECIMAL(10,2)

		SELECT @cDepositPaid = cDepositPaid
		FROM Customer
		WHERE customerID = @customerID
		IF @cDepositPaid != 0
		BEGIN
			RAISERROR('Deposit Already Paid', 16, 1)
		END

		DECLARE @total1 DECIMAL(10,2) = 0

		-- get total without discount
		SELECT @total1 = SUM(p.pAdvertisedPrice*b.bQuantityBooked)
		FROM Customer c, Reservation r, Booking b, Package p
		WHERE c.customerID = @customerID 
			AND c.customerID = r.CustomerID
			AND r.reservationID = b.reservationID
			AND b.packageID = p.packageID;

		-- Create and display a table
		CREATE TABLE FinalCost
		(
		total DECIMAL(10,2),
		depositDue DECIMAL(10,2)
		);

		-- insert values to be displayed
		INSERT INTO FinalCost VALUES (@total1, ((@total1/100)*25))

		-- display
		SELECT * FROM FinalCost

		--drop so that it can be used again
		DROP TABLE FinalCost

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT
		ERROR_NUMBER() AS ErrorNumber
		,ERROR_SEVERITY() AS ErrorSeverity
		,ERROR_STATE() AS ErrorState
		,ERROR_PROCEDURE() AS ErrorProcedure
		,ERROR_LINE() AS ErrorLine
		,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH

go


-- this procedure sums the total cost, gets 25%, pays with the imputted card, then updates both card information and the amount of deposit payed
CREATE PROCEDURE payDeposit
    @customerID INT,
	@rPaymentInfo VARCHAR(100)
AS
	BEGIN TRY

		BEGIN TRANSACTION

		-- cant pay deposit 2ce
		DECLARE @cDepositPaid DECIMAL(10,2)

		SELECT @cDepositPaid = cDepositPaid
		FROM Customer
		WHERE customerID = @customerID
		IF @cDepositPaid != 0
		BEGIN
			RAISERROR('Deposit Already Paid', 16, 1)
		END

		DECLARE @total2 DECIMAL(10,2) = 0

		-- get total without discount
		SELECT @total2 = SUM(p.pAdvertisedPrice*b.bQuantityBooked)
		FROM Customer c, Reservation r, Booking b, Package p
		WHERE c.customerID = @customerID 
			AND c.customerID = r.CustomerID
			AND r.reservationID = b.reservationID
			AND b.packageID = p.packageID;

		-- Create and display a table
		CREATE TABLE depositP
		(
		depositPaid DECIMAL(10,2),
		CardInfo VARCHAR(100)
		);
	
		-- Inser values to be displayed
		INSERT INTO depositP VALUES (((@total2/100)*25), @rPaymentInfo)
	
		-- display
		SELECT * FROM depositP
	
		-- update payment information
		UPDATE Reservation
		SET rPaymentInfo = @rPaymentInfo
		WHERE customerID = @customerID

		-- update deposit information
		UPDATE Customer
		SET cDepositPaid = ((@total2/100)*25)
		WHERE customerID = @customerID
	
		-- drop for reuse
		DROP TABLE depositP

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT
		ERROR_NUMBER() AS ErrorNumber
		,ERROR_SEVERITY() AS ErrorSeverity
		,ERROR_STATE() AS ErrorState
		,ERROR_PROCEDURE() AS ErrorProcedure
		,ERROR_LINE() AS ErrorLine
		,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
go
