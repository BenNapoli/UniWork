ERROR HANDLING WAS ONLY A SMALL PART OF THIS ASSIGNMENTS SO THE ERROR HANDLING
DOES NOT DETECT ALL ERRORS ON DUMMY INPUT.

# Assignment 1

COMP3350/6350 Assignment 1

Run in this order
1. CreateDB
2. FinalBill
3. Test_FinalBill
4. Create_Package
5. Test_CreatePackage
6. MakeReservation
7. Test_MakeReservation

(NOTE Test_MakeReservation relies on FinalBill for a display)

-------------------------------------------------------------------------------
Create Database
-------------------------------------------------------------------------------
To create database simply select all in create database and run it. (Sometimes 
if you have already created Ass1 you must individually drop it)

-------------------------------------------------------------------------------
Final Bill
-------------------------------------------------------------------------------
Final bill is achieved through procedures. As no new data has to be added it was 
more convenient to create a stored procedure that creates a final bill.

the final bill had 2 methods
- Print final bill
- give discount

To observe it working print the bill for a customer, give them a discount then
print the bill again.

Error checking
- cannot give more the 100% discount
- cannot give less then 0% discount
- cannot give more then 25% if not head office
- cannot give any discount if not valid staffID

-------------------------------------------------------------------------------
Make Reservation
-------------------------------------------------------------------------------
PARTS OF RUNNING THIS REQURES YOU TO FIRST RUN FINAL BILL

Make resevation has 3 test cases to run
  One is regular to show the procedure works
  Two Demonstrates that you cannot book over the limit ammount (10)
  Three is open so you can test it with the package you created in create a package
  
 Error checking
 - cannot repeat customerID
 - cannot book over the limit of dates due to checkavailability trigger in createDB

-------------------------------------------------------------------------------
Create Package
-------------------------------------------------------------------------------
Create package has 3 test cases
  One is regular to show the procedure works
  Two Demonstrates that you can have a high number of serviceItems
  Three Demonstarted that you cannot create a package with an invalid staff id
  
 Error checking
 - cannot use invalid StaffID
  
