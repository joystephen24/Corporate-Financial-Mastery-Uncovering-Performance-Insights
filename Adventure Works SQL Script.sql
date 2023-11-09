/* AdventureWorks Customer Lookup Table Script*/
SELECT [CustomerKey]
	  ,CASE
           WHEN [Gender] = 'M' THEN 'Mr.'
           WHEN [Gender] = 'F' AND [MaritalStatus] = 'M' THEN 'Mrs.'
           WHEN [Gender] = 'F' AND [MaritalStatus] = 'S' THEN 'Ms.'
           ELSE ''
       END AS Prefix
	  ,[FirstName]
      ,[LastName]
      ,CONCAT(
          CASE
              WHEN [Gender] = 'M' THEN 'Mr.'
              WHEN [Gender] = 'F' AND [MaritalStatus] = 'M' THEN 'Mrs.'
              WHEN [Gender] = 'F' AND [MaritalStatus] = 'S' THEN 'Ms.'
              ELSE ''
          END,
          ' ',
          [FirstName],
          ' ',
          [LastName]
       ) AS FullName
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[EmailAddress]
      ,[YearlyIncome] AS AnnualIncome
      ,[TotalChildren]
      ,[EnglishEducation] AS EducationLevel
      ,[EnglishOccupation] AS Occupation
	  ,CASE
           WHEN [HouseOwnerFlag] = 1 THEN 'Y'
           WHEN [HouseOwnerFlag] = 0 THEN 'N'
       END AS HomeOwner
      ,UPPER(REPLACE(SUBSTRING([EmailAddress], CHARINDEX('@', [EmailAddress]) + 1, CHARINDEX('.', [EmailAddress]) - CHARINDEX('@', [EmailAddress]) - 1), '-', ' ')) AS DomainName
  FROM [AdventureWorksDW2022_1].[dbo].[DimCustomer];


/* AdventureWorks Product Category Lookup Table Script*/
SELECT [ProductCategoryID] AS ProductCategoryKey
      ,[Name] AS CategoryName
  FROM [AdventureWorks2022].[Production].[ProductCategory]
 ORDER BY [ProductCategoryID];


/* AdventureWorks Product Subcategory Lookup Table Script*/
SELECT [ProductSubcategoryID] AS ProductSubcategoryKey
      ,[ProductCategoryID] AS ProductCategoryKey
      ,[Name] AS SubcategoryName
  FROM [AdventureWorks2022].[Production].[ProductSubcategory];


/*AdventureWorks Product Lookup Table Script*/
SELECT pd.[ProductID] AS ProductKey
      ,pd.[ProductSubcategoryID] AS ProductSubcategoryKey
      ,pd.[ProductNumber] AS ProductSKU
	  ,pd.[Name] AS ProductName
      ,pm.[Name] AS ModelName
	  ,pdesc.Description AS ProductDescription
      ,pd.[Color] AS ProductColor
      ,pd.[Size] AS ProductSize
      ,pd.[Style] AS ProductStyle
      ,pd.[StandardCost] AS ProductCost
      ,pd.[ListPrice] AS ProductPrice
FROM 
    [AdventureWorks2022].[Production].[Product] pd
INNER JOIN 
    [AdventureWorks2022].[Production].[ProductModel] pm ON pd.ProductModelID = pm.ProductModelID
INNER JOIN 
    [AdventureWorks2022].[Production].[ProductModelProductDescriptionCulture] pmdesc ON pm.ProductModelID = pmdesc.ProductModelID
INNER JOIN 
    [AdventureWorks2022].[Production].[ProductDescription] pdesc ON pmdesc.ProductDescriptionID = pdesc.ProductDescriptionID
WHERE 
    pd.[ProductSubcategoryID] IS NOT NULL
    AND pmdesc.CultureID = 'en'
ORDER BY 
    ProductSubcategoryKey;

/* One other way:
SELECT pd.[ProductID] AS ProductKey
      ,pd.[ProductSubcategoryID] AS ProductSubcategoryKey
      ,pd.[ProductNumber] AS ProductSKU
	  ,pd.[Name] AS ProductName
      ,pm.[Name] AS ModelName
	  ,pdesc.Description AS ProductDescription
      ,pd.[Color] AS ProductColor
      ,pd.[Size] AS ProductSize
      ,pd.[Style] AS ProductStyle
      ,pd.[StandardCost] AS ProductCost
      ,pd.[ListPrice] AS ProductPrice
  FROM [AdventureWorks2022].[Production].[Product] pd,
       [AdventureWorks2022].[Production].[ProductModel] pm,
	   [AdventureWorks2022].[Production].[ProductModelProductDescriptionCulture] pmdesc,
	   [AdventureWorks2022].[Production].[ProductDescription] pdesc
 WHERE pd.[ProductSubcategoryID] IS NOT NULL
   AND pd.ProductModelID = pm.ProductModelID
   AND pm.ProductModelID = pmdesc.ProductModelID
   AND pmdesc.ProductDescriptionID = pdesc.ProductDescriptionID
   AND pmdesc.CultureID = 'en'
  ORDER BY ProductSubcategoryKey;*/


/*AdventureWorks Territory Lookup Table Script*/
SELECT st.[TerritoryID] AS SalesTerritoryKey
      ,st.[Name] AS Region
      ,cr.Name AS Country
      ,st.[Group] AS Continent
  FROM [AdventureWorks2022].[Sales].[SalesTerritory] st
INNER JOIN 
    [AdventureWorks2022].[Person].[CountryRegion] cr 
    ON st.CountryRegionCode = cr.CountryRegionCode
 ORDER BY SalesTerritoryKey;

/*AdventureWorks Sales Table Script*/
SELECT CONVERT(varchar, [OrderDate], 103) AS OrderDate -- DD/MM/YYYY format (103 style)
      ,CONVERT(varchar, [DueDate], 103) AS StockDate -- DD/MM/YYYY format (103 style)
      ,[SalesOrderNumber] AS OrderNumber
	  ,[ProductKey]
	  ,[CustomerKey]
	  ,[SalesTerritoryKey] AS TerritoryKey
      ,[SalesOrderLineNumber] AS OrderLineItem
      ,[OrderQuantity]
  FROM [AdventureWorksDW2022_1].[dbo].[FactInternetSales]
 ORDER BY OrderDate;
