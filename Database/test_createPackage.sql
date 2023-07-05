USE Ass1
go

-----------------------------------------------------------------------------------------------------
-- TEST 1 
-----------------------------------------------------------------------------------------------------

-- Prepare serviceItemList list to be inserted
DECLARE @serviceItemList serviceItemListType

                                -- packageid added in method
                                -- (serviceItemsID, packageID, quantity)
INSERT INTO @serviceItemList VALUES ('1111111', '0', '1')
INSERT INTO @serviceItemList VALUES ('2222222', '0', '1')



-- declare out
DECLARE @packageID INT
-- execute make reservation with lists being passed in
                   -- (staffID, pName, pStartDate, pEndDate, pDescription, pAdvertisedPrice, pAdvertisedCurrency)
EXEC usp_createPackage '111111', 'Star package 3', '2023-02-01', '2023-02-02', 'Cheap standard room + Big room', '2900', 'AUD', @serviceItemList, @packageID OUT

-- print Package number
SELECT @packageID AS packageID

go

 SELECT * FROM Package
 go

 SELECT * FROM PackageServiceCount
 go

 SELECT * FROM ServiceItems
 go




 -----------------------------------------------------------------------------------------------------
-- TEST 2
-----------------------------------------------------------------------------------------------------

-- Prepare serviceItemList list to be inserted
DECLARE @serviceItemList2 serviceItemListType

                                -- packageid added in method
                                -- (serviceItemsID, packageID, quantity)
INSERT INTO @serviceItemList2 VALUES ('1111111', '0', '3')
INSERT INTO @serviceItemList2 VALUES ('2222222', '0', '2')

-- declare out
DECLARE @packageID INT
-- execute make reservation with lists being passed in
                   -- (staffID, pName, pStartDate, pEndDate, pDescription, pAdvertisedPrice, pAdvertisedCurrency)
EXEC usp_createPackage '222222', 'Star ALL INCLUSIVE PACKAGE', '2023-02-01', '2023-02-02', '3 small rooms 2 big rooms', '5800', 'AUD', @serviceItemList2, @packageID OUT

-- print Package number
SELECT @packageID AS packageID

go

 SELECT * FROM Package
 go

 SELECT * FROM PackageServiceCount
 go

 SELECT * FROM ServiceItems
 go


 -----------------------------------------------------------------------------------------------------
-- TEST 3 INVALID STAFF ID
-----------------------------------------------------------------------------------------------------

-- Prepare serviceItemList list to be inserted
DECLARE @serviceItemList3 serviceItemListType

                                -- packageid added in method
                                -- (serviceItemsID, packageID, quantity)
INSERT INTO @serviceItemList3 VALUES ('1111111', '0', '3')
INSERT INTO @serviceItemList3 VALUES ('2222222', '0', '2')





-- declare out
DECLARE @packageID INT
-- execute make reservation with lists being passed in
                   -- (staffID, pName, pStartDate, pEndDate, pDescription, pAdvertisedPrice, pAdvertisedCurrency)
EXEC usp_createPackage '1', 'Star ALL INCLUSIVE PACKAGE', '2023-02-01', '2023-02-02', '3 small rooms 2 big rooms', '5800', 'AUD', @serviceItemList3, @packageID OUT
