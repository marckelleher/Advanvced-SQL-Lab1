/*
Lab 1, Winter, 2018
CIS276 @PCC using MS SQL
2018.01.12 ALan Miles, Instructor
2018.01.12 Added formatting for all queries.
2018.01.16 Completed submission file.
*/

/*
*******************************************************************************************
CIS276 at PCC
LAB 1 using SQL SERVER 2012 and the SalesDB tables
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Marc Kelleher
                DATE:      1/12/18

*******************************************************************************************
*/
PRINT '================================================================================' + CHAR(10)
    + 'CIS276 Lab1' + CHAR(10)
    + '================================================================================' + CHAR(10)
GO


USE SalesDB
GO


PRINT '1. Who earns less than or equal to $2,500?' + CHAR(10)
/*
Projection: SALESPERSONS.Ename, SALESPERSONS.Salary 
Instructions: Display the name and salary of all salespersons 
whose salary is less than or equal to $2,500. 
Sort projection on salary high to low.
*/

SELECT CAST(SALESPERSONS.Ename AS CHAR(18)) AS "Salesperson", '$' + STR(SALESPERSONS.Salary,8,2) AS Salary 
FROM SALESPERSONS
WHERE Salary <= 2500
ORDER BY Salary DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '2. Which parts cost between one and fifteen dollars (inclusive)?' + CHAR(10)
/*
Projection: INVENTORY.PartID, INVENTORY.Description, INVENTORY.Price 
Instructions: Display the part id, Description, and Price of all parts 
where the Price is between the numbers given (inclusive). 
Show the output in descending order of Price.
Use the BETWEEN clause.
*/

SELECT CAST(INVENTORY.PartID AS CHAR(8)) AS "Part ID", CAST(INVENTORY.Description AS CHAR(18)) AS "Description", '$' + STR(INVENTORY.Price,6,2) AS "Price"
FROM INVENTORY
WHERE Price BETWEEN 1 AND 15
ORDER BY Price DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '3. What is the highest Priced part? What is the lowest Priced part?' + CHAR(10)
/*
Projection: INVENTORY.PartID, INVENTORY.Description, INVENTORY.Price 
Instructions: Display the part id, Description, and Price for the 
highest and lowest Priced parts in our INVENTORY.
*/

SELECT CAST(I.PartID AS CHAR(8)) AS "Part ID", CAST(I.Description AS CHAR(18)) AS Description, '$' + STR(I.Price,6,2) AS "Price"
FROM INVENTORY AS I
WHERE I.Price = (SELECT MAX(INVENTORY.Price) FROM INVENTORY) OR I.Price = (SELECT MIN(INVENTORY.Price) FROM INVENTORY);

GO


PRINT '================================================================================' + CHAR(10)
PRINT '4. Which part Descriptions begin with the letter T?' + CHAR(10)
/*
Projection: INVENTORY.PartID, INVENTORY.Description 
Instructions: Display the part id and Description of all parts where the 
Description begins with the letter 'T' (that's a capital 'T' or a lower case 't'). 
Show the output in descending order of Price.
*/

SELECT CAST(I.PartID AS CHAR(8)) AS "Part ID", CAST(I.Description AS CHAR(16)) AS Description
FROM INVENTORY AS I
WHERE Description LIKE 'T%' or Description LIKE 't%'
ORDER BY Price DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '5. Which parts need to be ordered from our supplier?' + CHAR(10)
/*
Projection: INVENTORY.PartID, INVENTORY.Description, and (INVENTORY.ReorderPnt - INVENTORY.StockQty) 
Instructions: Display the part id and Description of all parts where the stock quantity is less than the reorder point. 
For each part where this is true also display the amount that the stock quantity is below the reorder point. 
Display the parts in descending order of the computed difference.
*/

SELECT CAST(I.PartID AS CHAR(8)) AS "Part ID", CAST(I.Description AS CHAR(12)) AS Description, CAST(I.ReorderPnt - I.StockQty AS CHAR(4)) AS "Qty Below Order Point"
FROM INVENTORY AS I
WHERE I.StockQty < I.ReorderPnt
ORDER BY (I.ReorderPnt - I.StockQty) DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '6. Which sales people have NOT sold anything? Subquery version.' + CHAR(10)
/*
Projection: SALESPERSONS.Ename 
Instructions: Display all employees that are not involved with an order, 
i.e. where the EmpID of the salesperson does not appear in the ORDERS table. 
Display the names in alphabetical order. Do not use JOINs - use sub-queries only. 
OPTION: There are two ways to write the subquery version (correlated and non-correlated). 
If you supply both queries and they are both correct you may offset a points deduction elsewhere.
*/

SELECT CAST(S.Ename AS CHAR(18)) AS "Have Sold Nothing"
FROM SALESPERSONS AS S
WHERE NOT EXISTS (SELECT * FROM ORDERS WHERE S.EmpID = ORDERS.EmpID);

GO


PRINT '================================================================================' + CHAR(10)
PRINT '7. Which sales people have NOT sold anything? JOIN version (explicit or named JOIN).' + CHAR(10)
/*
Projection: SALESPERSONS.Ename 
Instructions: Display all employees that are not involved with an order, 
i.e. where the EmpID of the sales person does not appear in the ORDERS table. 
Display the names in alphabetical order. Do not use sub-queries - use only JOINs.
*/ 

SELECT CAST(S.Ename AS CHAR(18)) AS "Have Sold Nothing"
FROM SALESPERSONS AS S
FULL OUTER JOIN ORDERS ON S.EmpID = ORDERS.EmpID
WHERE ORDERS.EmpID IS NULL;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '8. Who placed the most orders?' + CHAR(10)
/*
Projection: CUSTOMERS.CustID, CUSTOMERS.Cname, COUNT(DISTINCT ORDERS.OrderID) 
Instructions: Display the customer id, customer name, and number of orders 
for the customer who has placed the most orders; i.e. the customer who appears the most
times in the ORDERS table.  Display only this record!
*/

SELECT TOP 1 CAST(C.CustID AS CHAR(8)) AS "Cust ID", CAST(C.Cname AS CHAR(24)) AS "Customer Name", CAST(COUNT(DISTINCT ORDERS.OrderID) AS CHAR(3)) AS "# of Orders"
FROM CUSTOMERS AS C
JOIN ORDERS ON C.CustID = ORDERS.CustID
GROUP BY C.CustID, C.Cname
ORDER BY COUNT(DISTINCT ORDERS.OrderID) DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '9. Who ordered the most quantity?' + CHAR(10)
/* 
Projection: CUSTOMERS.CustID, CUSTOMERS.Cname, SUM(ORDERITEMS.Qty)
Instructions: Display the customer id, customer name, and total quantity of parts ordered 
by the customer who has ordered the greatest quantity. 
For this query you will sum the quantity for all order items of all orders 
associated with each customer to determine which customer has ordered the most quantity.
*/

SELECT TOP 1 CAST(C.CustID AS CHAR(8)) AS "Cust ID", CAST(C.Cname AS CHAR(24)) AS "Customer Name", CAST(SUM(ORDERITEMS.Qty) AS CHAR (6)) AS "Ttl Qty Parts"
FROM CUSTOMERS AS C
JOIN ORDERS ON C.CustID = ORDERS.CustID
JOIN ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
GROUP BY C.CustID, C.Cname
ORDER BY SUM(ORDERITEMS.Qty) DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '10. Who ordered the highest total value?' + CHAR(10)
/*
Projection: CUSTOMERS.CustID, CUSTOMERS.Cname, SUM(INVENTORY.Price * ORDERITEMS.Qty) 
Instructions: Display the customer id, customer name, and total value of all orders 
for the customer whose orders total the highest value. 
To find the total value for a customer you need to sum the (Price times Qty) 
for each line item of each order associated with the customer.
*/

SELECT TOP 1 CAST(C.CustID AS CHAR(8)) AS "Cust ID", CAST(C.Cname AS CHAR(24)) AS "Customer Name", '$' + STR(SUM(INVENTORY.Price * ORDERITEMS.Qty),8,2) AS "Ttl Value All Orders"
FROM CUSTOMERS AS C
JOIN ORDERS ON C.CustID = ORDERS.CustID
JOIN ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
JOIN INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID
GROUP BY C.CustID, C.Cname
ORDER BY SUM(INVENTORY.Price * ORDERITEMS.Qty) DESC;

GO


--------------------------------------------------------------------------------
-- Program block
--------------------------------------------------------------------------------
DECLARE @v_now DATETIME;
BEGIN
    SET @v_now = GETDATE();
    PRINT '================================================================================'
    PRINT 'End of CIS276 Lab1';
    PRINT @v_now;
    PRINT '================================================================================';
END;
