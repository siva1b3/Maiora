USE [MyDataBase]
GO 

DROP TABLE IF EXISTS [dbo].[Orders]

SET ANSI_NULLS
ON 

SET QUOTED_IDENTIFIER 
ON 

CREATE TABLE [dbo].[Orders] (
    [OrderIndexID] [INT] IDENTITY(1000,1) NOT NULL,
    [OrderId] [VARCHAR](50) NOT NULL,
    [OrderItemId] [BIGINT]  NOT NULL,
    [QuantityOrdered] [INT] NOT NULL,
    [ItemPrice] [DECIMAL](18, 2) NOT NULL,
    [PromotionDiscount] [NVARCHAR](MAX) NULL,
    [batch_id] [INT] NOT NULL,
    [region] [VARCHAR](50) NOT NULL,
    [total_sales] [DECIMAL](18, 2) NOT NULL,
    [net_sales] [DECIMAL](18, 2) NOT NULL,
    CONSTRAINT [PK_Orders__OrderIndexID]
    PRIMARY KEY CLUSTERED ([OrderIndexID] ASC)
) ON [PRIMARY]
GO


SELECT [OrderIndexID]
    ,[OrderId]
    ,[OrderItemId]
    ,[QuantityOrdered]
    ,[ItemPrice]
    ,[PromotionDiscount]
    ,[batch_id]
    ,[region]
    ,[total_sales]
    ,[net_sales]
FROM [dbo].[Orders]

-- a. Count the total number of records. 

SELECT COUNT(1) AS CountRows FROM [dbo].[Orders]

-- b. Find the total sales amount by region. 

SELECT SUM(total_sales) AS SumInEachRegion,[region]
FROM [dbo].[Orders]
GROUP BY [region]

-- c. Find the average sales amount per transaction.

SELECT AVG(total_sales) AS AvgSales
FROM [dbo].[Orders]

-- d. Ensure there are no duplicate OrderId values. 

SELECT OrderIndexID
    ,OrderId
    ,OrderItemId
    ,QuantityOrdered
    ,ItemPrice
    ,PromotionDiscount
    ,batch_id
    ,region
    ,total_sales
    ,net_sales
    ,SortID
FROM (SELECT *,ROW_NUMBER() OVER(PARTITION BY OrderId ORDER BY OrderIndexID DESC) AS SortID FROM [dbo].[Orders]) AS TEMP
WHERE SortID = 1




