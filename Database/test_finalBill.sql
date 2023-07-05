USE Ass1
go

-- Print all customer bills
EXECUTE printFinalBill @customerID = '1'
EXECUTE printFinalBill @customerID = '2'
EXECUTE printFinalBill @customerID = '3'
EXECUTE printFinalBill @customerID = '4'
EXECUTE printFinalBill @customerID = '5'
EXECUTE printFinalBill @customerID = '6'
EXECUTE printFinalBill @customerID = '7'
EXECUTE printFinalBill @customerID = '8'
EXECUTE printFinalBill @customerID = '9'

-- run these 2 together to show discount. Both customers bought same package
EXECUTE printFinalBill @customerID = '1'
EXECUTE printFinalBill @customerID = '2'

-- cannot be above 100
EXECUTE giveDiscount @discount = '101', @staffID = '222222', @customerID = '1' 

-- head office can give any discount
EXECUTE giveDiscount @discount = '50', @staffID = '222222', @customerID = '1' 

-- staff that is not head office trying to give over 25% discount
EXECUTE giveDiscount @discount = '50', @staffID = '111111', @customerID = '1' 

-- Manager can give this level of discount
EXECUTE giveDiscount @discount = '24', @staffID = '111111', @customerID = '1' 

-- Reset to 0
EXECUTE giveDiscount @discount = '0', @staffID = '111111', @customerID = '1'

-- cannot be below 0
EXECUTE giveDiscount @discount = '-1', @staffID = '111111', @customerID = '1'

-- Invalid Staff cannot give discount
EXECUTE giveDiscount @discount = '24', @staffID = '1', @customerID = '1' 


