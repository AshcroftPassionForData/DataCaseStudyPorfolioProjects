SELECT*
FROM AdventureWorksDW2022.dbo.DimDate;


Select* 
FROM AdventureWorksDW2022.dbo.DimEmployee;

Select* 
FROM AdventureWorksDW2022.dbo.DimDepartmentGroup;

Select* 
FROM AdventureWorksDW2022.dbo.DimProduct;

Select* 
FROM AdventureWorksDW2022.dbo.DimGeography;

Select* 
FROM AdventureWorksDW2022.dbo.DimSalesReason;

Select* 
FROM AdventureWorksDW2022.dbo.DimPromotion;

SELECT EnglishCountryRegionName, SpanishCountryRegionName, FrenchCountryRegionName
FROM AdventureWorksDW2022.dbo.DimGeography;


Select* 
FROM AdventureWorksDW2022.dbo.FactInternetSales;

SELECT ProductKey, CustomerKey, TotalProductCost, SalesAmount, TaxAmt
FROM AdventureWorksDW2022.dbo.FactInternetSales;

-- I Perform Data Wrangling, Cleaning, and Data Transfoemation Using SQL

SELECT*
FROM AdventureWorksDW2022.dbo.FactSalesQuota;

-- In the below query checked if Date and CalendarYear Contains any values:
SELECT*
FROM AdventureWorksDW2022.dbo.FactSalesQuota
WHERE [Date] IS NULL
OR [CalendarYear] IS NULL

-- The query below delete all rows that contain NULL Values
DELETE from AdventureWorksDW2022.dbo.FactSalesQuota
WHERE [SalesQuotaKey] IS NULL
OR [EmployeeKey] IS NULL
OR [DateKey] IS NULL
OR [CalendarYear] IS NULL
OR [CalendarQuarter] IS NULL
OR [SalesAmountQuota] IS NULL
OR [Date] IS NULL

---Lets Find  a specific column in our table where Sales Amt Quata is "565000" 
SELECT * FROM AdventureWorksDW2022.dbo.FactSalesQuota
WHERE SalesAmountQuota = 565000.00


SELECT DISTINCT [SalesAmountQuota] FROM AdventureWorksDW2022.dbo.FactSalesQuota

SELECT SalesAmountQuota  
FROM AdventureWorksDW2022.dbo.FactSalesQuota


-- We check investgate the customer table
SELECT *
FROM AdventureWorksDW2022.dbo.DimCustomer


-- We look for specific coulmnns in the customer table
SELECT Title, MiddleName, Suffix, AddressLine2
FROM AdventureWorksDW2022.dbo.DimCustomer

-- We look for NULL values of a specific columns from a customer table
SELECT * FROM AdventureWorksDW2022.dbo.DimCustomer
WHERE [Title] IS NULL
OR [MiddleName] IS NULL
OR [Suffix] IS NULL
OR [AddressLine2] IS NULL


-- The query below delete all rows that contain NULL Values
DELETE from AdventureWorksDW2022.dbo.DimCustomer
WHERE [Title] IS NULL
OR [MiddleName] IS NULL
OR [Suffix] IS NULL
OR [AddressLine2] IS NULL

-- NB the above is okay just we working on a restrcited data, where delete is impossible

SELECT 
PostTime,
TSQL,
DatabaseLogID

FROM AdventureWorksDW2022.dbo.DatabaseLog

-- I standardise Date Format
SELECT 
PostTime, CONVERT (Date, PostTime)
FROM AdventureWorksDW2022.dbo.DatabaseLog

SELECT * 

FROM AdventureWorksDW2022.dbo.FactInternetSales

-- Now I Standardise Date Format from our OrderDate, DueDate, and ShipDate
SELECT 
OrderDate, CONVERT (Date, OrderDate), DueDate, CONVERT (Date, DueDate), ShipDate, CONVERT (Date, ShipDate)

FROM AdventureWorksDW2022.dbo.FactInternetSales

ALTER Table FactInternetSales
add OrderDate1 Date, DueDate1 Date, ShipDate1 Date;

-- The above code works just that I don't have the permsission to ALTER the Table @ the Moment
Update FactInternetSales
SET OrderDate1 = CONVERT (Date, OrderDate), DueDate1  =  CONVERT (Date, DueDate), 
SET ShipDate1 = CONVERT (Date, ShipDate


---- Let Populate FACTINTERNET TABLE & ShipDate Data
SELECT*
FROM AdventureWorksDW2022.dbo.FactInternetSales


SELECT ShipDate
FROM AdventureWorksDW2022.dbo.FactInternetSales
WHERE ShipDate IS NULL

--- Nw let Populate all the information form the our Table where is NULL

SELECT *
FROM AdventureWorksDW2022.dbo.FactInternetSales
WHERE ShipDate IS NULL

SELECT*
FROM AdventureWorksDW2022.dbo.FactInternetSales
order by SalesOrderNumber


--- Below we populate two specific column names against itself
SELECT a.SalesOrderNumber, a.ProductStandardCost, b.SalesOrderNumber, b.ProductStandardCost
FROM AdventureWorksDW2022.dbo.FactInternetSales a
JOIN AdventureWorksDW2022.dbo.FactInternetSales b
    on a.SalesOrderNumber = b.SalesOrderNumber
	AND a.[ProductKey] <> b.[ProductKey]
--WHERE a.SalesOrderNumber IS NULL


-- Breaking out address into individual coulmns (House Numebr, Street Name)
SELECT *
FROM AdventureWorksDW2022.dbo.DimCustomer

SELECT 
 --- The code below helps you search for a sepcific character or word.
 --- It go through the AddressLine1 column and search for se
SUBSTRING(AddressLine1, 1, CHARINDEX('.',  Addressline1)) as address
FROM AdventureWorksDW2022.dbo.DimCustomer

---  Now let me do a case statement for maritalStatus and Gender

SELECT Gender
, CASE when Gender  = 'M' THEN 'Male'
       When Gender  = 'F' THEN  'Female'
	   ELSE Gender
	   END
FROM AdventureWorksDW2022.dbo.DimCustomer

--- Let Update the coulmn
Update DimCustomer
SET Gender = CASE when Gender  = 'M' THEN 'Male'
       When Gender  = 'F' THEN  'Female'
	   ELSE Gender
	   END
--- The purpose of this project Update and deletion is not allow 
--- due to the level of permission I have.