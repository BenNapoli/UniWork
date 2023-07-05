USE Ass1
go

DROP PROCEDURE IF EXISTS usp_createPackage
DROP PROCEDURE IF EXISTS is_Staff
DROP TYPE IF EXISTS serviceItemList
go


CREATE TYPE serviceItemListType AS TABLE
(	
	serviceItemsID INT, -- added after
	packageID INT, -- added after
	quantity INT
)
go

CREATE PROCEDURE is_Staff 
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
		SET @isStaff = 1
	END
	--if any other staff
	IF @pos = 'Manager'
	BEGIN 
		SET @isStaff = 1
	END
GO

CREATE PROCEDURE usp_createPackage 
(
	@staffID INT,
	@pName VARCHAR(50),
    @pStartDate DATE,
    @pEndDate DATE,
	@pDescription VARCHAR(MAX),
    @pAdvertisedPrice DECIMAL(18,2),
    @pAdvertisedCurrency CHAR(3),
	@serviceItemsList serviceItemListType READONLY, 
    @packageID INT OUTPUT
)
AS
BEGIN


	BEGIN TRY

		BEGIN TRANSACTION

		DECLARE @isStaff INT = 0
		EXECUTE is_Staff @staffID, @isStaff OUT

		IF @isStaff != '1' -- Not valid staff
		BEGIN 
			RAISERROR('Only valid staff can create a new package', 11, 1)
		END

		-- has to be unique as it is the sum of the others
		SELECT @packageID = SUM(packageID)
		FROM Package

								-- (packageID, staffID, pName, pStartDate, pEndDate, pDescription, pAdvertisedPrice, pAdvertisedCurrency, pInclusions, pExclusions, pStatus, pGracePeriod)
		INSERT INTO Package VALUES (@packageID, @staffID, @pName, @pStartDate, @pEndDate, @pDescription, @pAdvertisedPrice, @pAdvertisedCurrency, 'All', 'None', 'Available', '3')
		-- PackageID can be the sum of all bookings?

		------------------------------------------------------------------------------------------------------------------------------
		-- Service Items

		-- create a duplicate so that it is editable as need to insert correct reservationID
		DECLARE @serviceItemsListEditable serviceItemListType

		-- Duplicate the Table into an editable one
		INSERT INTO @serviceItemsListEditable(serviceItemsID, packageID, quantity)
		SELECT serviceItemsID, packageID, quantity
		FROM @serviceItemsList

			-- Update @serviceItemsID in each table
		UPDATE @serviceItemsListEditable
		SET packageID = @packageID
		WHERE packageID = 0

		-- insert table into booking
		INSERT INTO PackageServiceCount(serviceItemsID, packageID, quantity)
		SELECT serviceItemsID, packageID, quantity
		FROM @serviceItemsListEditable

	
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


END
