/*Create databse */
IF NOT EXISTS (
		SELECT *
		FROM sys.databases
		WHERE NAME = N'BlackPaper'
		)
	EXEC('CREATE DATABASE [BlackPaper]')
GO
/*Create Schema*/
USE [BlackPaper]
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.schemas
		WHERE NAME = N'Customer'
		)
	EXEC ('CREATE SCHEMA [Customer] AUTHORIZATION [dbo]');
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.schemas
		WHERE NAME = N'Product'
		)
	EXEC ('CREATE SCHEMA [Product] AUTHORIZATION [dbo]');
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.schemas
		WHERE NAME = N'Cart'
		)
	EXEC ('CREATE SCHEMA [Cart] AUTHORIZATION [dbo]');
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.schemas
		WHERE NAME = N'Sale'
		)
	EXEC ('CREATE SCHEMA [Sale] AUTHORIZATION [dbo]');
GO

/**********************************************************/
/*	            Create Customer Table					  */
/**********************************************************/
IF OBJECT_ID('customer.tb_Customer') IS NULL
BEGIN
CREATE TABLE [customer].[tb_Customer](
 [CustomerId] INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,[FirstName] NVARCHAR(250) NOT NULL
,[LastName] NVARCHAR(250) NOT NULL
,[Email] NVARCHAR(20) NOT NULL
,[Password] NVARCHAR(20) NOT NULL
,[IsActive] BIT NOT NULL
,[CreatedBy] NVARCHAR(250)  NULL
,[CreatedDate] DATETIME NOT NULL
,[ModifiedDate] DATETIME NOT NULL
) 
END
GO
IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Customer_IsActive_customer')
ALTER TABLE [customer].[tb_Customer] ADD CONSTRAINT [DF_tb_Customer_IsActive_customer]  DEFAULT ((1)) FOR [IsActive]
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Customer_CreatedDate_customer')
ALTER TABLE [customer].[tb_Customer] ADD  CONSTRAINT [DF_tb_Customer_CreatedDate_customer]  DEFAULT (GETDATE()) FOR [CreatedDate]
GO
IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Customer_ModifiedDate_customer')
ALTER TABLE [customer].[tb_Customer] ADD  CONSTRAINT [DF_tb_Customer_ModifiedDate_customer]  DEFAULT (GETDATE()) FOR [ModifiedDate]
GO

/**********************************************************/
/*	            Create Product Table					  */
/**********************************************************/
IF OBJECT_ID('product.tb_Product') IS NULL
BEGIN
CREATE TABLE [product].[tb_Product](
 [ProductId] INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,[ProductName] NVARCHAR(250) NOT NULL
,[ProductDescription] NVARCHAR(800) NOT NULL
,[ImageUrl] NVARCHAR(800) NOT NULL
,[Price] DECIMAL NOT NULL
,[IsActive] BIT NOT NULL
,[CreatedDate] DATETIME NOT NULL
,[ModifiedDate] DATETIME NOT NULL
) 
END
GO
IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Product_IsActive_product')
ALTER TABLE [product].[tb_Product] ADD CONSTRAINT [DF_tb_Product_IsActive_product]  DEFAULT ((1)) FOR [IsActive]
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Product_CreatedDate_product')
ALTER TABLE [product].[tb_Product] ADD  CONSTRAINT [DF_tb_Product_CreatedDate_product]  DEFAULT (GETDATE()) FOR [CreatedDate]
GO
IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Product_ModifiedDate_product')
ALTER TABLE [product].[tb_Product] ADD  CONSTRAINT [DF_tb_Product_ModifiedDate_product]  DEFAULT (GETDATE()) FOR [ModifiedDate]
GO
/**********************************************************/
/*	            Create Order Table					  */
/**********************************************************/
IF OBJECT_ID('sale.tb_Order') IS NULL
BEGIN
CREATE TABLE [sale].[tb_Order](
 [OrderId] INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,[CustomerID] INT NOT NULL
,[ProductName] NVARCHAR(250) NOT NULL
,[ProductColor] NVARCHAR(250) NOT NULL
,[OrderNumber]  AS (ISNULL(N'ON'+CONVERT([nvarchar](23),[OrderID]),N'*** ERROR ***'))
,[OrderDate] DATETIME NOT NULL
,[Status] TINYINT NOT NULL
,[CurrencyRateID] INT NULL
,[SubTotal] MONEY NOT NULL
,[VatAmt] MONEY NOT NULL
,[Freight] MONEY NOT NULL
,[TotalDue]  AS (ISNULL(([SubTotal]+[VatAmt]),(0)))
,[IsActive] BIT NOT NULL
,[ModifiedDate] DATETIME NOT NULL
) 
END
GO
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_Order_Customer_CustomerID')
ALTER TABLE [sale].[tb_Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer_CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [customer].[tb_Customer] ([CustomerID])
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Order_IsActive_sale')
ALTER TABLE [sale].[tb_Order] ADD CONSTRAINT [DF_tb_Order_IsActive_sale]  DEFAULT ((1)) FOR [IsActive]
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Order_CreatedDate_sale')
ALTER TABLE [sale].[tb_Order] ADD  CONSTRAINT [DF_tb_Order_CreatedDate_sale]  DEFAULT (GETDATE()) FOR [OrderDate]
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_Order_ModifiedDate_sale')
ALTER TABLE [sale].[tb_Order] ADD  CONSTRAINT [DF_tb_Order_ModifiedDate_sale]  DEFAULT (GETDATE()) FOR [ModifiedDate]
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_Order_SubTotal')
ALTER TABLE [sale].[tb_Order] ADD  CONSTRAINT [DF_Order_SubTotal]  DEFAULT ((0.00)) FOR [SubTotal]
GO
IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_Order_VatAmt')
ALTER TABLE [sale].[tb_Order] ADD  CONSTRAINT [DF_Order_VatAmt]  DEFAULT ((0.00)) FOR [VatAmt]
GO
/**********************************************************/
/*	            Create OrderDetail Table				  */
/**********************************************************/
IF OBJECT_ID('sale.tb_OrderDetail') IS NULL
BEGIN
CREATE TABLE [sale].[tb_OrderDetail](
 [OrderId] INT  NOT NULL
,[OrderDetailId] INT IDENTITY(1,1)  NOT NULL
,[ProductID] INT NOT NULL
,[OrderQty] SMALLINT NOT NULL
,[UnitPrice] MONEY NOT NULL
,[UnitPriceDiscount] MONEY NOT NULL
,[LineTotal] AS (ISNULL(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0)))
,[ModifiedDate] DATETIME NOT NULL
 CONSTRAINT [PK_OrderDetail_OrderID_OrderDetailID] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[OrderDetailID] ASC

)ON [PRIMARY]
) 
END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_OrderDetail_Product_ProductID')
ALTER TABLE [sale].[tb_OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Product_ProductID] FOREIGN KEY([ProductID])
REFERENCES [product].[tb_Product] ([ProductId])
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_OrderDetail_Order_OrderID')
ALTER TABLE [sale].[tb_OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Order_OrderID] FOREIGN KEY([OrderID])
REFERENCES [sale].[tb_Order] ([OrderID])
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_OrderDetail_UnitPriceDiscount_sale')
ALTER TABLE [sale].[tb_OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_UnitPriceDiscount_sale]  DEFAULT ((0.0)) FOR [UnitPriceDiscount]
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'CK_OrderDetail_OrderQty')
ALTER TABLE [sale].[tb_OrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_OrderDetail_OrderQty] CHECK  (([OrderQty]>(0)))
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'CK_OrderDetail_UnitPrice')
ALTER TABLE [sale].[tb_OrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_OrderDetail_UnitPrice] CHECK  (([UnitPrice]>=(0.00)))
GO
IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'CK_OrderDetail_UnitPriceDiscount')
ALTER TABLE [sale].[tb_OrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_OrderDetail_UnitPriceDiscount] CHECK  (([UnitPriceDiscount]>=(0.00)))
GO

IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'DF_tb_OrderDetail_ModifiedDate_sale')
ALTER TABLE [sale].[tb_OrderDetail] ADD  CONSTRAINT [DF_tb_OrderDetail_ModifiedDate_sale]  DEFAULT (GETDATE()) FOR [ModifiedDate]
GO


/*************************************************************************************************************/
/*										 Manage Customer Procedure											 */
/*************************************************************************************************************/
IF OBJECT_ID('customer.pr_AddCustomer','P') IS NOT NULL
DROP PROCEDURE customer.pr_AddCustomer
GO

CREATE PROCEDURE customer.pr_AddCustomer
(
	 @FirstName NVARCHAR(250) 
	,@LastName NVARCHAR(250) 
	,@Email NVARCHAR(20) 
	,@Password NVARCHAR(20)
	,@CustomerId INT = NULL OUTPUT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
	INSERT INTO customer.tb_Customer
	(
		 FirstName
		,LastName
		,Email
		,Password
		
		
	)
	SELECT
		 @FirstName
		,@LastName
		,@Email
		,@Password
		
		
	SET @CustomerId = SCOPE_IDENTITY();
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

IF OBJECT_ID('customer.pr_GetAllCustomer','P') IS NOT NULL
DROP PROCEDURE customer.pr_GetAllCustomer
GO

CREATE PROCEDURE customer.pr_GetAllCustomer
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY 
	SELECT 
		 CustomerId
		,FirstName
		,LastName
		,Email
	FROM customer.tb_Customer
	WHERE IsActive = 1
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

IF OBJECT_ID('customer.pr_GetCustomerById','P') IS NOT NULL
DROP PROCEDURE customer.pr_GetCustomerById
GO
CREATE PROCEDURE customer.pr_GetCustomerById
(
	@CustomerId INT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
		SELECT 
		 CustomerId
		,FirstName
		,LastName
		,Email
	FROM customer.tb_Customer
	WHERE CustomerId = @CustomerId 
	AND IsActive = 1
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

IF OBJECT_ID('customer.pr_DeleteCustomer','P') IS NOT NULL
DROP PROCEDURE customer.pr_DeleteCustomer
GO

CREATE PROCEDURE customer.pr_DeleteCustomer
(
	@CustomerId INT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
	UPDATE customer.tb_Customer
	SET IsActive = 0,
		ModifiedDate = GETDATE()
	WHERE CustomerId = @CustomerId
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

IF OBJECT_ID('customer.pr_UpdateCustomer','P') IS NOT NULL
DROP PROCEDURE customer.pr_UpdateCustomer
GO

CREATE PROCEDURE customer.pr_UpdateCustomer
(
	 @FirstName NVARCHAR(250) 
	,@LastName NVARCHAR(250) 
	,@Email NVARCHAR(20) 
	,@Password NVARCHAR(20)
	,@CustomerId INT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
	UPDATE customer.tb_Customer
	SET  FirstName = @FirstName
		,LastName = @LastName
		,Email = @Email
		,Password = @Password
		,ModifiedDate = GETDATE()
	WHERE CustomerId = @CustomerId;
	
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

/*************************************************************************************************************/
/*										 Manage Product Procedure											 */
/*************************************************************************************************************/
IF OBJECT_ID('product.pr_AddProduct','P') IS NOT NULL
DROP PROCEDURE product.pr_AddProduct
GO

CREATE PROCEDURE product.pr_AddProduct
(
	 @ProductName NVARCHAR(250) 
	,@ProductDescription NVARCHAR(800) 
	,@ImageUrl NVARCHAR(800)
	,@Price DECIMAL
	,@ProductId INT = NULL OUTPUT

)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
	INSERT INTO product.tb_Product
	(
			 ProductName 
			,ProductDescription 
			,ImageUrl 
			,Price 
	)
	SELECT
			 @ProductName 
			,@ProductDescription 
			,@ImageUrl 
			,@Price 

	
	SET @ProductId = SCOPE_IDENTITY();
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO


IF OBJECT_ID('product.pr_GetAllProduct','P') IS NOT NULL
DROP PROCEDURE product.pr_GetAllProduct
GO

CREATE PROCEDURE product.pr_GetAllProduct
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY 
	SELECT 
		 ProductId
		,ProductName
		,ImageUrl 
		,Price 
		 ProductDescription
	FROM product.tb_Product
	WHERE IsActive = 1
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

IF OBJECT_ID('product.pr_GetProductById','P') IS NOT NULL
DROP PROCEDURE product.pr_GetProductById
GO
CREATE PROCEDURE product.pr_GetProductById
(
	@ProductId INT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
		SELECT 
		 ProductId
		,ProductName
		,ImageUrl
		,Price
		,ProductDescription
	FROM product.tb_Product
	WHERE ProductId = @ProductId 
	AND IsActive = 1
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

IF OBJECT_ID('product.pr_DeleteProduct','P') IS NOT NULL
DROP PROCEDURE product.pr_DeleteProduct
GO

CREATE PROCEDURE product.pr_DeleteProduct
(
	@ProductId INT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
	UPDATE product.tb_Product
	SET IsActive = 0,
		ModifiedDate = GETDATE()
	WHERE ProductId = @ProductId
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

IF OBJECT_ID('product.pr_UpdateProduct','P') IS NOT NULL
DROP PROCEDURE product.pr_UpdateProduct
GO

CREATE PROCEDURE product.pr_UpdateProduct
(
	 @ProductName NVARCHAR(250) 
	,@ProductDescription NVARCHAR(800) 
	,@ImageUrl NVARCHAR(250) 
	,@Price DECIMAL 
	,@ProductId INT = NULL OUTPUT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
	UPDATE product.tb_Product
	SET  ProductName = @ProductName
		,ProductDescription = @ProductDescription
		,ImageUrl = @ImageUrl 
		,Price = @Price
		,ModifiedDate = GETDATE()
	WHERE ProductId = @ProductId;
	
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage varchar(MAX) = ERROR_MESSAGE(),
		 @ErrorSeverity int = ERROR_SEVERITY(),
		 @ErrorState smallint = ERROR_STATE()
 
 RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState);
            
END CATCH
GO

/*************************************************************************************************************/
/*										 Manage Orders Procedure											 */
/*************************************************************************************************************/