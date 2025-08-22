IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'Banking')
	DROP DATABASE Banking





--------------------------------------------------------------------------------------------
CREATE DATABASE Banking
ON
PRIMARY 
( NAME=Banking,
  FILENAME='D:\Banking1.mdf',
  SIZE=100MB
),
FILEGROUP Bank_Customer_Details
(
  NAME=Bank_Customer_Details,
  FILENAME='D:\Bank_Customer_Details1.ndf',
  SIZE=100MB,
  FILEGROWTH = 25
),
FILEGROUP Banking_Transactions
(
  NAME=Banking_Transactions,
  FILENAME='D:\ing_Transactions1.ndf',
  SIZE=100MB
),
FILEGROUP Banking_Accounts
(
  NAME=Banking_Accounts,
  FILENAME='D:\Banking_Accounts1.ndf',
  SIZE=100MB
)
LOG 
ON
(
  NAME=Banking_2Log,
  FILENAME='D:\Banking2_Log.ldf',
  SIZE=25
)
 
USE Banking
GO
-------------------------------------------------------------------------------------------

CREATE SCHEMA BANK
GO
CREATE SCHEMA ACCOUNT
GO
CREATE SCHEMA TRANSACTIONS	
go



CREATE TABLE BANK.tblBank
(	
	bankId	    BIGINT IDENTITY(1000,1),
	bankDetails	VARCHAR(50)
) ON Bank_Customer_Details	


ALTER TABLE BANK.tblBank ADD CONSTRAINT PK_bankId PRIMARY KEY (bankId)


CREATE TABLE BANK.tbladdAddress
(	
	addId	    BIGINT IDENTITY(1000,1), 
	addLine1	VARCHAR(100),
	addLine2	VARCHAR(50),
	addCity	    VARCHAR(50),
	addPostCode	VARCHAR(15),
	addState	VARCHAR(50), 
	addCountry	VARCHAR(50)
) ON Bank_Customer_Details

ALTER TABLE BANK.tbladdAddress ADD CONSTRAINT PK_addId PRIMARY KEY (addId)


CREATE TABLE BANK.tblbtBranchType
(	
	btId	BIGINT IDENTITY(1000,1),
	btTypeCode	VARCHAR(4) ,
	btTypeDesc	VARCHAR(100)

) ON Bank_Customer_Details


ALTER TABLE BANK.tblbtBranchType ADD CONSTRAINT PK_btId PRIMARY KEY (btId)



CREATE TABLE BANK.tblbrBranch
(
brID				BIGINT IDENTITY (1000,1),
brBankId_fk			BIGINT,
brAddress_fk		BIGINT,
brBranchTypeCode_fk	BIGINT,
brBranchName		VARCHAR(100),
brBranchPhone1		VARCHAR(20),
brBranchPhone2		VARCHAR(20),
brBranchFax			VARCHAR(20),
brBranchemail		VARCHAR(50),
brBranchIFSC		VARCHAR(20)
)ON Bank_Customer_Details



ALTER TABLE BANK.tblbrBranch ADD CONSTRAINT PK_brID PRIMARY KEY (brID)
ALTER TABLE BANK.tblbrBranch ADD CONSTRAINT FK_brBankId FOREIGN KEY (brBankId_fk) REFERENCES BANK.tblBank (bankId)
ALTER TABLE BANK.tblbrBranch ADD CONSTRAINT FK_brAddress FOREIGN KEY (brAddress_fk) REFERENCES BANK.tbladdAddress (addId)
ALTER TABLE BANK.tblbrBranch ADD CONSTRAINT FK_brBranchTypeCode FOREIGN KEY (brBranchTypeCode_fk) REFERENCES BANK.tblbtBranchType (btId)



CREATE TABLE BANK.tblcstCustomer
(	
	cstId	         BIGINT  IDENTITY (1000,1),
	cstAddId_fk	     BIGINT,
	cstBranchId_fk	 BIGINT,
	cstFirstName	 VARCHAR(50),
	cstLastName	     VARCHAR(50),
	CstMiddleName	 VARCHAR(50),
	cstDOB	         DATE,
	cstSince	     DATETIME,
	cstPhone1	     VARCHAR(20),
	cstPhone2	     VARCHAR(20),
	cstFax	         VARCHAR(20),
	cstGender	     VARCHAR(10),
	cstemail	     VARCHAR(50)
) ON Bank_Customer_Details

ALTER TABLE BANK.tblcstCustomer ADD CONSTRAINT PK_cstId PRIMARY KEY (cstId)
ALTER TABLE BANK.tblcstCustomer ADD CONSTRAINT FK_cstAddId FOREIGN KEY (cstAddId_fk) REFERENCES BANK.tbladdAddress (addId)
ALTER TABLE BANK.tblcstCustomer ADD CONSTRAINT FK_cstBranchId FOREIGN KEY (cstBranchId_fk) REFERENCES BANK.tblbrBranch (brID)
---------------------------------------------------------------------

CREATE TABLE ACCOUNT.tblaccAccountType
(	
	accTypeId	BIGINT  IDENTITY (1000,1),
	accTypeCode	VARCHAR(10),
	accTypeDesc	VARCHAR(100)
) ON Banking_Accounts	

ALTER TABLE ACCOUNT.tblaccAccountType ADD CONSTRAINT PK_accTypeId PRIMARY KEY (accTypeId)

CREATE TABLE ACCOUNT.tblaccAccountStatus
(	
	accStatusId		BIGINT IDENTITY (1000,1),
	accStatusCode	VARCHAR(10),
	accStatusDesc	VARCHAR(50)
) ON Banking_Accounts	

ALTER TABLE ACCOUNT.tblaccAccountStatus ADD CONSTRAINT PK_accStatusId PRIMARY KEY (accStatusId)

CREATE TABLE ACCOUNT.tblaccAccount
(	
	accNumber			BIGINT IDENTITY (20000,1),
	accStatusCode_fk	BIGINT,
	accTypeCode_fk		BIGINT,
	accCustomerId_fk	BIGINT,
	accBalance			DECIMAL(26,4)
) ON Banking_Accounts	

ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT PK_accNumber PRIMARY KEY (accNumber)
ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT FK_accStatusCode FOREIGN KEY (accStatusCode_fk) REFERENCES ACCOUNT.tblaccAccountStatus (accStatusId)
ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT FK_accTypeCode FOREIGN KEY (accTypeCode_fk) REFERENCES ACCOUNT.tblaccAccountType (accTypeId)
ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT FK_accCustomerId FOREIGN KEY (accCustomerId_fk) REFERENCES BANK.tblcstCustomer (cstId)

-----------------------------------------------
CREATE TABLE TRANSACTIONS.tbltranTransactionType
(	
	tranCodeID		BIGINT IDENTITY (1000,1),
	tranTypeDesc	VARCHAR(50)
) ON Banking_Transactions	

ALTER TABLE TRANSACTIONS.tbltranTransactionType ADD CONSTRAINT PK_tranCodeID PRIMARY KEY (tranCodeID)	
	
CREATE TABLE TRANSACTIONS.tbltranTransaction
(	
	tranID					BIGINT IDENTITY (1000,1),
	tranCode				VARCHAR(50),
	tranAccountNumber_fk	BIGINT,
	tranCode_fk				BIGINT,
	tranDatetime			DateTime,
	tranTransactionAmount	Decimal(26,4),
	tranMerchant			VARCHAR(50),
	tranDescription			VARCHAR(50),
	RunningBalance	        DECIMAL(26,4)	 DEFAULT 	NULL
) ON Banking_Transactions	

ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT PK_tranID PRIMARY KEY (tranID)	
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT FK_tranAccountNumber FOREIGN KEY (tranAccountNumber_fk) REFERENCES ACCOUNT.tblaccAccount (accNumber)
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT FK_tranCode FOREIGN KEY (tranCode_fk) REFERENCES TRANSACTIONS.tbltranTransactionType (tranCodeID)
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT DF_tranDatetime  DEFAULT  GETDATE() FOR tranDatetime
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT DF_tranCode DEFAULT  NEWID() FOR tranCode 


-- SYNONYMS ARE PERMENANT ALTERNATE NAMES TO TABLES

CREATE SYNONYM synBank                  FOR BANK.tblBank
CREATE SYNONYM synAddress				FOR BANK.tbladdAddress
CREATE SYNONYM synBranchType			FOR BANK.tblbtBranchType
CREATE SYNONYM synBranch				FOR BANK.tblbrBranch
CREATE SYNONYM synCustomer				FOR BANK.tblcstCustomer
CREATE SYNONYM synAccountType			FOR ACCOUNT. tblaccAccountType
CREATE SYNONYM synAccountStatus			FOR ACCOUNT. tblaccAccountStatus
CREATE SYNONYM synAccount				FOR ACCOUNT. tblaccAccount
CREATE SYNONYM synTransactionType		FOR TRANSACTIONS.tbltranTransactionType  
CREATE SYNONYM synTransaction			FOR TRANSACTIONS.tbltranTransaction


-- This view is designed to get list of Banks. Can also be used for insertions.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwBankDetails')
   DROP VIEW vwBankDetails
GO

CREATE  VIEW vwBankDetails
AS
SELECT A.bankDetails AS [Bank Name]
FROM  dbo.synBank A WITH (READPAST)

INSERT INTO vwBankDetails VALUES ('HDFC')





BEGIN TRAN T1
INSERT INTO vwBankDetails VALUES ('ML BANK2')
INSERT INTO vwBankDetails VALUES ('ML BANK3')
INSERT INTO vwBankDetails VALUES ('ML BANK4')

INSERT INTO synBank VALUES ('ML BANK5')

COMMIT TRAN T1

SELECT * FROM vwBankDetails





IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwBranchDetails')
   DROP VIEW vwBranchDetails
GO

CREATE VIEW vwBranchDetails
AS
SELECT A.bankDetails AS [Bank Name],B.brBranchName AS [Branch Name],
B.brBranchIFSC AS [IFSC],B.brBranchPhone1 AS [Phone 1],
B.brBranchPhone2 AS [Phone 2],B.brBranchFax AS [Fax],B.brBranchemail 
AS [Email],
C.btTypeCode AS [Branch Type Code],C.btTypeDesc AS [Branch Type],
D.addLine1 AS [Address 1],D.addLine2 AS [Address 2],
D.addCity AS [City],D.addState AS [State],D.addCountry AS [Country],
D.addPostCode AS [Post Code]
FROM  dbo.synBank A (READPAST)
INNER JOIN dbo.synBranch B (READPAST) ON A.bankId=B.brBankId_fk
INNER JOIN dbo.synBranchType C (READPAST) ON B.brBranchTypeCode_fk=C.btId
INNER JOIN dbo.synAddress D (READPAST) ON B.brAddress_fk=D.addId
GO

select * from vwBranchDetails

IF EXISTS (SELECT * FROM SYS.objects WHERE name='TRIGGER_vwBranchDetails')
   DROP TRIGGER TRIGGER_vwBranchDetails
GO

CREATE TRIGGER TRIGGER_vwBranchDetails 
ON vwBranchDetails
INSTEAD OF INSERT
AS
BEGIN
	BEGIN TRANSACTION T1
    BEGIN TRY
		BEGIN
				--INSERT Branch Type
				INSERT INTO dbo.synBranchType  ( btTypeCode, btTypeDesc )
				SELECT [Branch Type Code],[Branch Name] FROM INSERTED

				--Get BRanch ID inserted above
				DECLARE @BranchTypeID BIGINT
				SET @BranchTypeID=@@IDENTITY

		END
	END TRY 
	BEGIN CATCH
		BEGIN
				SELECT 'Branch Type Insertion Failed due to data issue.Check Input Values'
				ROLLBACK TRANSACTION  --If Insertion fails rollback
		END
	END CATCH

	BEGIN TRANSACTION T2
	BEGIN TRY
		--INSERT ADDRESS
		INSERT INTO dbo.synAddress  ( addLine1 ,  addLine2 , addCity , addPostCode , addState , addCountry  )
		SELECT [Address 1],[Address 2],[City],[Post Code],[State],[Country] 
		FROM INSERTED

		--Get Address ID inserted above
		DECLARE @ADDRESSID BIGINT
		SET @ADDRESSID=@@IDENTITY
    END TRY 
	BEGIN CATCH 
		BEGIN
				SELECT 'Branch Address Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION  --If Insertion fails rollback
		END
	END CATCH
	BEGIN TRANSACTION T3
	BEGIN TRY 
		DECLARE @BankID BIGINT
		SET @BankID=(SELECT TOP 1 bankId FROM dbo.synBank WHERE bankDetails IN (SELECT [Bank Name] FROM Inserted))

		--Insert Branch
		INSERT INTO dbo.synBranch  
		( brBankId_fk ,  brAddress_fk , brBranchTypeCode_fk , brBranchName ,  brBranchPhone1 ,  brBranchPhone2 ,  brBranchFax , brBranchemail ,  brBranchIFSC) 
		SELECT @BankID,@ADDRESSID,@BranchTypeID,
		[Branch Name],[Phone 1],[Phone 2],Fax,Email,IFSC
		 FROM INSERTED

		IF @@TRANCOUNT >0 
			COMMIT TRANSACTION T1
		IF @@TRANCOUNT >0
			COMMIT TRANSACTION T2
		IF @@TRANCOUNT >0
			COMMIT TRANSACTION T3

    END TRY
	BEGIN CATCH
		BEGIN
				SELECT 'Branch details Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION   --If Insertion fails rollback
		END
	END CATCH
END


--INSERT DATA TO VIEW
INSERT INTO vwBranchDetails VALUES ('State Bank of Mysore','Mangalore Corporation','SBM0405','0824 247561','0824 247562','0824 247563','manglorecorporation@sbm.com','MT','Mortgage','KS Rao road','Opp Passport Seva Kendra, Balmatta','Mangalore','Karnataka','India','576001')

--Check Insertion
SELECT * FROM dbo.vwBranchDetails

----NOT GETTING IN TABLE NOT INSERTED????????????
 
/*
Created stored Procedure to help in insertion of Branch to a Bank through UI
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spInsertBranchDetails')
   DROP PROCEDURE spInsertBranchDetails
GO



CREATE PROCEDURE spInsertBranchDetails
(
@BankName VARCHAR(50),@BranchName VARCHAR(100),@IFSC VARCHAR(20),@Phone1 VARCHAR(20) ,@Phone2 VARCHAR(20) ,@Fax VARCHAR(20)  ,@Email VARCHAR(50)  ,
@BranchTypeCode VARCHAR(10) ,@BranchTypeDesc VARCHAR(100),@AddLine1 VARCHAR(100) ,@AddLine2 VARCHAR(50) ,@City VARCHAR(50),@State VARCHAR(50) ,@Country VARCHAR(50),@PostCode VARCHAR(15) 
)
AS
BEGIN
INSERT INTO vwBranchDetails VALUES 
(@BankName,@BranchName ,@IFSC ,@Phone1 ,@Phone2 ,@Fax,@Email  ,@BranchTypeCode ,@BranchTypeDesc ,@AddLine1  ,@AddLine2  ,@City ,@State  ,@Country ,@PostCode)
END



/*
--Check Insert through SP
EXEC spInsertBranchDetails @BankName='State Bank of Mysore',@BranchName='Bangalore Corporation',@IFSC='SBM0406',@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',
@Email='banglorecorporation@sbm.com',@BranchTypeCode='HL',@BranchTypeDesc='Home Loan',@AddLine1='Rajkumar road',@AddLine2='57th Main, Malleshwaram',@City='Bangalore',@State='Karnataka',@Country='India',@PostCode='574001'

--For Failure due to truncation of Branch Type code
EXEC spInsertBranchDetails @BankName='State Bank of Mysore',@BranchName='Bangalore Corporation',@IFSC='SBM0406',@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',
@Email='banglorecorporation@sbm.com',@BranchTypeCode='HLIDQS',@BranchTypeDesc='Home Loan',@AddLine1='Rajkumar road',@AddLine2='57th Main, Malleshwaram',@City='Bangalore',@State='Karnataka',@Country='India',@PostCode='574001'

--Check Insertion
SELECT * FROM vwBranchDetails

*/

/*
This view has been designed to view Customer Details

*/
IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwCustomerDetails')
   DROP VIEW vwCustomerDetails
GO

CREATE VIEW vwCustomerDetails
WITH SCHEMABINDING
AS
SELECT cstFirstName AS [First Name],	cstLastName AS [Last Name],	CstMiddleName AS [Middle Name],	cstDOB AS [DOB],cstSince AS [Customer Since],cstPhone1 AS [Phone 1],cstPhone2 AS [Phone 2],	cstFax AS [FAX],cstGender AS [Gender],cstemail AS [Email],
D.addLine1 AS [Address 1],D.addLine2 AS [Address 2],D.addCity AS [City],D.addState AS [State],D.addCountry AS [Country],D.addPostCode AS [Post Code]	
FROM BANK.tblcstCustomer C (READPAST)
INNER JOIN BANK.tbladdAddress D (READPAST) ON C.cstAddId_fk=D.addId
INNER JOIN BANK.tblbrBranch B (READPAST)  ON C.cstBranchId_fk=B.brID

GO

/*
--View the details
 SELECT * FROM vwCustomerDetails
*/

/*
Created stored Procedure to help in insertion of Branch to a Bank through UI
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spInsertCustomer')
   DROP PROCEDURE spInsertCustomer
GO






CREATE PROCEDURE spInsertCustomer
(
 @BranchName VARCHAR(100),@FirstName VARCHAR(50),@LastName VARCHAR(50),@MiddleName VARCHAR(50),@DOB DATE,@CustomerSince DATETIME,@Phone1 VARCHAR(20) ,@Phone2 VARCHAR(20) ,@Fax VARCHAR(20),@Gender VARCHAR(20),@Email VARCHAR(50)
,@AddLine1 VARCHAR(100) ,@AddLine2 VARCHAR(50) ,@City VARCHAR(50),@State VARCHAR(50) ,@Country VARCHAR(50),@PostCode VARCHAR(50) 
)
AS
BEGIN

		SET NOCOUNT ON

		BEGIN TRANSACTION 
		BEGIN TRY

				--Get BRanch ID inserted above
				DECLARE @BranchTypeID BIGINT
				SET @BranchTypeID=@@IDENTITY

				--INSERT ADDRESS
				INSERT INTO dbo.synAddress  ( addLine1 ,  addLine2 , addCity , addPostCode , addState , addCountry  ) VALUES (@AddLine1,@AddLine2,@City,@PostCode,@State,@Country)

				--Get Address ID inserted above
				DECLARE @ADDRESSID BIGINT
				SET @ADDRESSID=@@IDENTITY
		END TRY
		BEGIN CATCH
				SELECT 'Customer Address Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION --If Insertion fails rollback
		END CATCH

		BEGIN TRY

			DECLARE @BRANCHID BIGINT
			SET @BRANCHID=(SELECT TOP 1 brID FROM dbo.synBRANCH WHERE  brBranchName IN (@BranchName))

			--Insert Customer
			 INSERT INTO dbo.synCustomer  ( cstAddId_fk , cstBranchId_fk , cstFirstName , cstLastName ,  CstMiddleName ,  cstDOB ,  cstSince ,  cstPhone1 ,  cstPhone2 , cstFax ,  cstGender ,  cstemail )
			 VALUES   (@ADDRESSID,@BRANCHID, @FirstName ,@LastName ,@MiddleName ,@DOB ,@CustomerSince ,@Phone1  ,@Phone2  ,@Fax,@Gender,@Email)

			IF @@TRANCOUNT>0
		    COMMIT TRANSACTION

		END TRY
		BEGIN CATCH
				SELECT 'Customer details Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION  --If Insertion fails rollback
		END CATCH

END

/*
--Check Insert through SP
EXEC spInsertCustomer @BranchName='Golden Valley',@FirstName='Tom',@LastName='Keen',@MiddleName='Ruth',@DOB='09-11-1985',@CustomerSince=NULL,@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',@Gender='Male'
,@Email='Tkeen@hotmail.com',@AddLine1='GV road',@AddLine2='57th BLVD',@City='Crystal',@State='Minnesota',@Country='USA',@PostCode='574001'

--For Failure due to invalid  inputdata for customer Details
EXEC spInsertCustomer @BranchName='Golden Valley',@FirstName='Tom',@LastName='Keen',@MiddleName='Ruth',@DOB='09-11-1985',@CustomerSince=NULL,@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',@Gender='Male85098609870965'
,@Email='Tkeen@hotmail.com',@AddLine1='GV road',@AddLine2='57th BLVD',@City='Crystal',@State='Minnesota',@Country='USA',@PostCode='574001'

--For Failure due to invalid  inputdata for customer Address Details
EXEC spInsertCustomer @BranchName='Golden Valley',@FirstName='Tom',@LastName='Keen',@MiddleName='Ruth',@DOB='09-11-1985',@CustomerSince=NULL,@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',@Gender='Male'
,@Email='Tkeen@hotmail.com',@AddLine1='GV road',@AddLine2='57th BLVD',@City='Crystal',@State='Minnesota',@Country='USA',@PostCode='57400147690965876878657-50687005985907'

*/

/*
This view has been designed to view Account Details of customer

*/
IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwCustomerAccountDetails')
   DROP VIEW vwCustomerAccountDetails
GO

CREATE VIEW vwCustomerAccountDetails
WITH SCHEMABINDING
AS
SELECT cstId AS [Customer Id],cstFirstName AS [First Name],	cstLastName AS [Last Name],	CstMiddleName AS [Middle Name],	cstDOB AS [DOB],cstSince AS [Customer Since],cstPhone1 AS [Phone 1],cstPhone2 AS [Phone 2],	cstFax AS [FAX],cstGender AS [Gender],cstemail AS [Email],
E.addLine1 AS [Address 1],E.addLine2 AS [Address 2],E.addCity AS [City],E.addState AS [State],E.addCountry AS [Country],E.addPostCode AS [Post Code],
D.accNumber AS [Account Number],D.accBalance AS [Account Balance],B.accStatusDesc AS [Account Status],A.accTypeDesc AS [Account Type]
FROM BANK.tblcstCustomer C (READPAST)
INNER JOIN ACCOUNT.tblaccAccount D (READPAST) ON C.cstId=D.accCustomerId_fk
INNER JOIN ACCOUNT.tblaccAccountStatus B (READPAST)  ON D.accStatusCode_fk=B.accStatusId
INNER JOIN ACCOUNT.tblaccAccountType  A (READPAST)  ON D.accTypeCode_fk=A.accTypeId
INNER JOIN BANK.tbladdAddress E (READPAST) ON C.cstAddId_fk=E.addId
GO

/*
--View the details
 SELECT * FROM vwCustomerAccountDetails

*/

/*
Created stored Procedure to help creation of customer Account. Assuming in UI first a customer record will be created and then selecting the Customer they create the account.
Customer ID coulmn in above view can be used in Front end to pass the value of selected customer. Also account status and Type will be selected.
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spCreateAccount')
   DROP PROCEDURE spCreateAccount
GO




















CREATE PROCEDURE spCreateAccount
(
 @CustomerID BIGINT,@accStatus VARCHAR(50),@accType VARCHAR(100),@OpeningBalance DECIMAL(26,4)
)
AS
BEGIN

		SET NOCOUNT ON

		DECLARE @AccStatusID BIGINT
		DECLARE @AccTypeId BIGINT

		SELECT @AccStatusID=accStatusId FROM dbo.synAccountStatus (READPAST) WHERE accStatusDesc=@accStatus
		SELECT @AccTypeId=accTypeId FROM dbo.synAccountType (READPAST) WHERE accTypeDesc=@accType

		BEGIN TRANSACTION 
		BEGIN TRY

				--INSERT ADDRESS
				INSERT INTO dbo.synAccount  ( accStatusCode_fk , accTypeCode_fk , accCustomerId_fk , accBalance )
				VALUES (@AccStatusID,@AccTypeId,@CustomerID,@OpeningBalance)

				COMMIT TRANSACTION

		END TRY
		BEGIN CATCH
				SELECT 'Account creation Failed.Check Input values'
				ROLLBACK TRANSACTION  --If Insertion fails rollback
		END CATCH

END

/*
DECLARE @CustomerId BIGINT
SET @CustomerId=(SELECT TOP 1 cstid FROM syncustomer (READPAST))
EXEC spCreateAccount @CustomerId, @accStatus='Active',@accType='Current',@OpeningBalance=1000

SELECT * FROM vwCustomerAccountDetails

*/


 


IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwAccountTransactions')
   DROP VIEW vwAccountTransactions
GO

CREATE VIEW vwAccountTransactions
AS
	SELECT [Account number],[Transaction Description],[Transaction Date],[Transaction Reference],ISNULL([Deposit],0) AS [Credit],ISNULL([Withdrawal],0) AS [Debit],RunningBalance
	FROM 
	(
		SELECT  D.accNumber AS [Account number],T.tranDescription AS [Transaction Description],
		T.tranDatetime AS [Transaction Date],T.tranCode AS [Transaction Reference],TP.tranTypeDesc 
		AS [Transaction Type],T.tranTransactionAmount AS [Amount],T.RunningBalance
		FROM dbo.synAccount D (READPAST)  
		INNER JOIN dbo.synTransaction T (READPAST) ON D.accNumber=T.tranAccountNumber_fk
		INNER JOIN dbo.synTransactionType TP (READPAST) ON T.tranCode_fk=TP.tranCodeID
	) AS Summary
	PIVOT
	(
	MIN([Amount])
	FOR [Transaction Type] IN ([Deposit] ,[Withdrawal])
	) AS P

GO

-- PIVOT : REPRESENT COLUMN VALUES AS COLUMNS

SELECT * FROM vwAccountTransactions



 /*
 CREATE FOR Trigger to update the Account Balance in accounts table and also update the running balnce in Transaction table.
 
 */
IF EXISTS (SELECT * FROM SYS.objects WHERE name='TRIGGER_UpdateAccountBalance')
  DROP TRIGGER [TRANSACTIONS].[TRIGGER_UpdateAccountBalance]
GO
 
CREATE TRIGGER TRIGGER_UpdateAccountBalance 
ON TRANSACTIONS.tbltranTransaction
FOR  INSERT
AS
BEGIN
    DECLARE @AMOUNT DECIMAL (26,4),@AccNumber BIGINT,@TranType BIGINT
	SELECT @AccNumber=tranAccountNumber_fk, @AMOUNT=tranTransactionAmount,@TranType=tranCode_fk FROM Inserted

	--Update the account balnace in account table based on Transaction Type
	IF @TranType=1000 
		UPDATE ACCOUNt.tblaccAccount SET accBalance=accBalance+@AMOUNT WHERE accNumber IN (SELECT tranAccountNumber_fk FROM Inserted)
	ELSE 
		UPDATE ACCOUNt.tblaccAccount SET accBalance=accBalance-@AMOUNT WHERE accNumber IN (SELECT tranAccountNumber_fk FROM Inserted)

	--UPdate the running Balance in Transactions table

	UPDATE T SET RunningBalance=accBalance 
	FROM dbo.synTransaction T 
	INNER JOIN Inserted I ON T.tranID=I.tranID
	INNER JOIN dbo.synAccount A ON I.tranAccountNumber_fk=A.accNumber
END

/*
Created stored Procedure to help in performing a transaction.Account number and type of transaction are the main required fields.
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spPerformTrnasaction')
   DROP PROCEDURE spPerformTrnasaction
GO









CREATE PROCEDURE spPerformTrnasaction
(
 @AccountNumber BIGINT, @TransactionType VARCHAR(50),@Amount DECIMAL(26,4),@Merchant VARCHAR(50)=NULL,@Description VARCHAR(50)=NULL
)
AS
BEGIN

		SET NOCOUNT ON

		DECLARE @TranCode BIGINT
		SELECT @TranCode=tranCodeID FROM dbo.synTransactionType (READPAST) WHERE tranTypeDesc=@TransactionType

		DECLARE @AccountBalance  DECIMAL(26,4)
		SELECT @AccountBalance=accBalance FROM dbo.synAccount (READPAST) WHERE accNumber=@AccountNumber

		
		IF (( @TransactionType='Withdrawal' AND (@Amount < @AccountBalance )) OR @TransactionType='Deposit')
			BEGIN 
					BEGIN TRANSACTION 
					BEGIN TRY

							--INSERT ADDRESS
							INSERT INTO dbo.synTransaction  ( tranAccountNumber_fk , tranCode_fk , tranTransactionAmount , tranMerchant ,  tranDescription )
							VALUES  ( @AccountNumber,@TranCode,@Amount, @Merchant,@Description)
				
							COMMIT TRANSACTION
							DECLARE @TransactionId BIGINT
							SELECT @TransactionId=@@IDENTITY

							DECLARE @TranID VARCHAR(100)
							SELECT @TranID =CAST(tranCode AS VARCHAR(50)) FROM dbo.synTransaction (READPAST) WHERE tranID=@TransactionId

							SELECT 'Transaction Successful. Transaction Number for your reference is - '  +   @TranID

					END TRY
					BEGIN CATCH
						SELECT 'Transaction Failed. Please try again.'
						ROLLBACK TRANSACTION  --If Insertion fails rollback
					END CATCH
		   END
		   ELSE
				SELECT 'Insufficent Balance. Transaction Declined'
END

/*
SELECT * FROM vwAccountTransactions ORDER BY [Account Number],[TRANSACTION DATE] DESC 

EXEC spPerformTrnasaction  @AccountNumber=20000, @TransactionType ='Withdrawal',@Amount =250000
EXEC spPerformTrnasaction  @AccountNumber=20001, @TransactionType ='Deposit',@Amount =250000,@Merchant =NULL,@Description=NULL
EXEC spPerformTrnasaction  @AccountNumber=30001, @TransactionType ='Deposit',@Amount =250000,@Merchant ='Old Navy Visa',@Description='Payment Gateway'

*/


/*
CREATE FUNCTION TO GET ACCOUNT Statement for a CUSTOMER

*/
 
 IF EXISTS (SELECT * FROM SYS.objects WHERE name='fnGetAccountStatement')
   DROP FUNCTION fnGetAccountStatement
GO

 CREATE FUNCTION fnGetAccountStatement (@AccountNumber BIGINT, @StartDate DateTime, @EndDate DateTime)
 RETURNS @Temp TABLE 
 (
 [Account number] BIGINT ,
 [Transaction Description] VARCHAR(50),
 [Transaction Date] DateTime,
 [Transaction Reference] VARCHAR(50) ,
 [Credit] DECIMAL(26,4),
 [Withdrawal] DECIMAL(26,4),
 [RunningBalance] DECIMAL(26,4)
 )
 AS
 BEGIN
     IF DATEDIFF(MM,@StartDate,@EndDate) < 6 --Maximum statement returned is for six Months
	 INSERT INTO @Temp
	 SELECT * FROM vwAccountTransactions 
	 WHERE [Account number]=@AccountNumber
	 AND [Transaction Date] BETWEEN @StartDate AND DATEADD(DD,1,@EndDate)

	RETURN
 END

 /*
 SELECT * FROM vwAccountTransactions ORDER BY [Account Number],[TRANSACTION DATE] DESC 
 SELECT * FROM fnGetAccountStatement(20001,'2015-01-30','2015-10-30')
 SELECT * FROM fnGetAccountStatement(20001,'2015-06-30','2015-11-30') 	 ORDER BY  [Transaction Date] DESC 
 */

 /*
 Simple Example For Scalar valued Fucntion
 */
 IF EXISTS (SELECT * FROM SYS.objects WHERE name='fnGetAccountStatus')
   DROP FUNCTION fnGetAccountStatus
GO
CREATE FUNCTION fnGetAccountStatus (@AccountNumber BIGINT)
RETURNS  VARCHAR(100)
AS
BEGIN

	DECLARE @Status VARCHAR(100)
	SELECT @Status=accStatusDesc
	FROM dbo.synAccount (READPAST) 
	INNER JOIN dbo.synAccountStatus (READPAST) ON accStatusCode_fk=accStatusId
	WHERE accNumber=@AccountNumber

	RETURN @Status

END

/*
SELECT * FROM vwCustomerAccountDetails
SELECT dbo.fnGetAccountStatus (40002)

*/

--Some exmaples of Relational Queries
--These can be converted into views or functions based  on needs.


USE Banking
GO







/* COMMON REPORTING PERMUTATIONS */


--Complete Relation for tables specified
SELECT A.bankDetails AS Bank,B.brBranchName AS [Branch Name],C.btTypeDesc AS 'Branch Type',D.addCity AS [Branch City],E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance],H.accTypeDesc AS 'Account Type',I.accStatusDesc AS 'Account Status',J.tranCode AS 'Transaction Reference',J.tranTransactionAmount AS 'Transaction Amount',J.tranDatetime AS 'Transaction Date'
,K.tranTypeDesc AS 'Transaction Type'
FROM  dbo.synBank A
INNER JOIN dbo.synBranch B ON A.bankId=B.brBankId_fk
INNER JOIN dbo.synBranchType C ON B.brBranchTypeCode_fk=C.btId
INNER JOIN dbo.synAddress D ON B.brAddress_fk=D.addId
INNER JOIN dbo.synCustomer E ON B.brID=E.cstBranchId_fk
INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
INNER JOIN dbo.synAccountType H ON G.accTypeCode_fk=H.accTypeId
INNER JOIN dbo.synAccountStatus I ON G.accStatusCode_fk=I.accStatusId
INNER JOIN dbo.synTransaction J ON G.accNumber=J.tranAccountNumber_fk
INNER JOIN dbo.synTransactionType K ON J.tranCode_fk=K.tranCodeID
ORDER BY 1,2,3

--List all banks and thier branches with total number of accounts 
in each Branch
SELECT A.BankDetails,ISNULL(B.brBranchName,'') AS Branch ,
ISNULL(COUNT(D.accNumber),0) AS NumberOfAccounts
FROM synBank A
LEFT JOIN synBranch B ON A.BankID=B.brBankId_fk
LEFT JOIN synCustomer C ON B.brID = C.cstBranchId_fk
LEFT JOIN synAccount D ON C.cstId= D.accCustomerId_fk
GROUP BY A.BankDetails,B.brBranchName
ORDER BY NumberOfAccounts DESC 

--List total number of customers for each branch
SELECT A.brBranchName,COUNT(cstid)
FROM synBranch A 
INNER JOIN synCustomer B ON A.brID=B.cstBranchId_fk
GROUP BY A.brBranchName

--Find all customer accounts that does not have any transaction

SELECT A.cstFirstName + ' ' +A.cstLastName,B.accNumber
FROM syncustomer A 
INNER JOIN synAccount B ON A.cstID=B.accCustomerId_fk
LEFT JOIN syntransaction C ON B.accNumber=C.tranAccountNumber_fk
WHERE C.TranId IS NULL

--OR using subquery as below

SELECT A.cstFirstName + ' ' +A.cstLastName,B.accNumber
FROM syncustomer A 
INNER JOIN synAccount B ON A.cstID=B.accCustomerId_fk
WHERE B.accNumber NOT IN (SELECT  tranAccountNumber_fk FROM dbo.synTransaction)


--Rank the customers for each Bank & Branch based on number of transactions. 
Customer with maximum number of transaction gets 1 Rank(Position)
--Rank() skips the rank sequence when 2 rows have same value where as Dense_Rank() does not skip the rank sequence
SELECT A.bankDetails AS [Bank Name],B.brBranchName AS 'Branch Name',C.cstFirstName + ' '+c.cstLastName AS 'Customer Name',D.accNumber AS 'Account Number'
,COUNT(tranID) AS 'Transaction Count',RANK() OVER ( PARTITION BY   B.brBranchName ORDER BY COUNT(ISNULL(tranID,0)) DESC) AS [Position(Rank)]
,DENSE_RANK() OVER ( PARTITION BY   B.brBranchName ORDER BY COUNT(ISNULL(tranID,0)) DESC) AS [Position(Dense Rank)]
FROM dbo.synBank A
INNER JOIN dbo.synBranch B ON A.bankId=B.brBankId_fk
INNER JOIN dbo.synCustomer C ON B.brID=C.cstBranchId_fk
INNER JOIN dbo.synAccount D ON C.cstid=D.accCustomerId_fk
LEFT JOIN dbo.synTransaction E ON D.accNumber=E.tranAccountNumber_fk --Here left join will ensure all customer records are listed. If not then customers without transaction will be omitted.
GROUP BY A.bankDetails,B.brBranchName,C.cstFirstName + ' '+c.cstLastName,D.accNumber
ORDER BY A.bankDetails ,B.brBranchName 

--Above can be modified to within a given period by Trnasaction Date in WHERE clause. 

--Total Sum of DEDUCTS & Credit for each customer. 
Even if some customer had only credit and no deducts that customers also should be listed

--Using Joins & Subqueries
SELECT  CASE WHEN DEBIT.[Customer Name] IS NULL THEN  CREDIT.[Customer Name] ELSE DEBIT.[Customer Name] END AS [Customer Name]
,CASE WHEN DEBIT.[AcountNumber] IS NULL THEN  CREDIT.[AcountNumber] ELSE DEBIT.[AcountNumber] END AS AcountNumber
, ISNULL(TotalCredit,0) AS TotalCredit,ISNULL(TotalDebit,0) AS TotalDebit
 FROM 
(
	SELECT A.cstid,A.cstFirstName + ' ' + A.cstLastName AS [Customer Name],B.accNumber AS AcountNumber,SUM(C.tranTransactionAmount) AS TotalCredit
	FROM dbo.synCustomer A  
	INNER JOIN dbo.synAccount B  ON A.cstId=B.accCustomerId_fk
	INNER JOIN dbo.synTransaction   C ON B.accNumber=C.tranAccountNumber_fk
	INNER JOIN dbo.synTransactionType  D ON C.tranCode_fk=D.tranCodeID
	WHERE D.tranTypeDesc='Deposit'
	GROUP BY A.cstid,A.cstFirstName + ' ' + A.cstLastName,B.accNumber
)AS CREDIT
FULL OUTER  JOIN 
(
	SELECT A.cstid,A.cstFirstName + ' ' + A.cstLastName AS [Customer Name],B.accNumber AS AcountNumber,SUM(C.tranTransactionAmount) AS TotalDebit
	FROM dbo.synCustomer A  
	INNER JOIN dbo.synAccount B  ON A.cstId=B.accCustomerId_fk
	INNER JOIN dbo.synTransaction   C ON B.accNumber=C.tranAccountNumber_fk
	INNER JOIN dbo.synTransactionType  D ON C.tranCode_fk=D.tranCodeID
	WHERE D.tranTypeDesc='Withdrawal'
	GROUP BY A.cstid,A.cstFirstName + ' ' + A.cstLastName,B.accNumber
) AS DEBIT
ON CREDIT.CSTID=DEBIT.CSTID
ORDER BY 1

/*
Resultset

Customer Name			AcountNumber		TotalCredit		TotalDebit
Adarsh Hegde			30001				41000.9120		0.0000
Chaithra Kunjathaya		20001				64001.3680		0.0000
Gaurao Tarpe			20002				1300.4500		40.3500
Nathan Kamas			40002				0.0000			25000.0000
Nithin Kumar			30002				20500.4560		0.0000
Nithin Kumar			20000				25000.0000		800000.0000

*/

--Above can also be accomplished using PIVOT--Just using it as I have used it in past in my project.

SELECT [Customer Name],AcountNumber,ISNULL([Deposit],0) AS TotalCredit,ISNULL([Withdrawal],0) AS TotalDebit
FROM
(
    SELECT A.cstid,A.cstFirstName + ' ' + A.cstLastName AS [Customer Name],B.accNumber AS AcountNumber,D.tranTypeDesc AS TransactionType,C.tranTransactionAmount  AS TransactionAmount
	FROM dbo.synCustomer A  
	INNER JOIN dbo.synAccount B  ON A.cstId=B.accCustomerId_fk
	INNER JOIN dbo.synTransaction   C ON B.accNumber=C.tranAccountNumber_fk
	INNER JOIN dbo.synTransactionType  D ON C.tranCode_fk=D.tranCodeID
)AS TempTrnasactions
PIVOT
(
MAX(TransactionAmount) 
FOR TransactionType IN ([Deposit],[Withdrawal])
) AS P
ORDER BY 1





--LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS

SELECT E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance] 
FROM  dbo.synCustomer E
INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
WHERE 
G.accNumber NOT IN (SELECT tranAccountNumber_fk FROM  dbo.synTransaction ) --To make sure account Number not in Transactions

--OR Same can be achieved through EXCEPT clause- A-B set operation

SELECT E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance]
FROM  dbo.synCustomer E
INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
EXCEPT
SELECT E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance]
FROM  dbo.synCustomer E
INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
INNER JOIN dbo.synTransaction T ON    G.accNumber=T.tranAccountNumber_fk

--LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS
SELECT E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance],I.accStatusDesc AS 'Account Status'
FROM  dbo.synCustomer E
INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
INNER JOIN dbo.synAccountStatus I ON G.accStatusCode_fk=I.accStatusId
ORDER BY [Account Status],[Customer Name] 

--LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS AND TYPES WITH NO TRANSACTIONS
SELECT E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance],H.accTypeDesc AS 'Account Type',I.accStatusDesc AS 'Account Status'
FROM  dbo.synCustomer E
INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
INNER JOIN dbo.synAccountType H ON G.accTypeCode_fk=H.accTypeId
INNER JOIN dbo.synAccountStatus I ON G.accStatusCode_fk=I.accStatusId
WHERE 
G.accNumber NOT IN (SELECT tranAccountNumber_fk FROM  dbo.synTransaction ) --To make sure account Number not in Transactions
ORDER BY [Account Type],[Account Status]



--LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS
--Since allbanks, made use of LEFT JOIN
SELECT  bankDetails AS Bank, brBranchName AS [Branch Name], btTypeDesc AS 'Branch Type',   [Branch City],[Customer Name],
 addCity AS [Customer City], accNumber AS [Acount number], accBalance AS [Account Balance], accTypeDesc AS 'Account Type', accStatusDesc AS 'Account Status'
,[Deposit]AS 'Total Credits',[Withdrawal] AS 'Total Debits'
FROM  
(
SELECT A.bankDetails  ,B.brBranchName ,C.btTypeDesc  ,D.addCity AS [Branch City]  ,E.cstFirstName + ' ' +E.cstLastName AS [Customer Name],F.addCity  ,G.accNumber ,G.accBalance  ,H.accTypeDesc ,I.accStatusDesc , J.tranTransactionAmount ,K.tranTypeDesc
FROM dbo.synBank A (READPAST)
INNER JOIN dbo.synBranch B (READPAST) ON A.bankId=B.brBankId_fk
LEFT JOIN dbo.synBranchType C (READPAST) ON B.brBranchTypeCode_fk=C.btId
LEFT JOIN dbo.synAddress D (READPAST) ON B.brAddress_fk=D.addId
LEFT JOIN dbo.synCustomer E (READPAST) ON B.brID=E.cstBranchId_fk
LEFT JOIN dbo.synAddress F (READPAST) ON E.cstAddId_fk=F.addId
LEFT JOIN dbo.synAccount G (READPAST) ON  E.cstid=G.accCustomerId_fk
LEFT JOIN dbo.synAccountType H (READPAST)ON G.accTypeCode_fk=H.accTypeId
LEFT JOIN dbo.synAccountStatus I(READPAST) ON G.accStatusCode_fk=I.accStatusId
LEFT JOIN dbo.synTransaction J (READPAST) ON G.accNumber=J.tranAccountNumber_fk
LEFT JOIN dbo.synTransactionType K (READPAST) ON J.tranCode_fk=K.tranCodeID
)AS Summary
PIVOT 
(
SUM(tranTransactionAmount) FOR tranTypeDesc IN ([Deposit],[Withdrawal])
) AS P
ORDER BY Bank,[Branch Name],[CUstomer Name]





-- LIST OF ALL BANKS WITH CUSTOMERS BUT NO TRANSACTIONS
SELECT A.bankDetails AS Bank,B.brBranchName AS [Branch Name],C.btTypeDesc AS 'Branch Type',D.addCity AS [Branch City],E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance],H.accTypeDesc AS 'Account Type',I.accStatusDesc AS 'Account Status'
FROM  dbo.synBank A (READPAST)
INNER JOIN dbo.synBranch B  (READPAST) ON A.bankId=B.brBankId_fk
INNER JOIN dbo.synBranchType C  (READPAST) ON B.brBranchTypeCode_fk=C.btId
INNER JOIN dbo.synAddress D  (READPAST) ON B.brAddress_fk=D.addId
INNER JOIN dbo.synCustomer E  (READPAST) ON B.brID=E.cstBranchId_fk
INNER JOIN dbo.synAddress F (READPAST)  ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G  (READPAST) ON  E.cstid=G.accCustomerId_fk
INNER JOIN dbo.synAccountType H  (READPAST) ON G.accTypeCode_fk=H.accTypeId
INNER JOIN dbo.synAccountStatus I (READPAST)  ON G.accStatusCode_fk=I.accStatusId
WHERE G.accNumber NOT IN (SELECT tranAccountNumber_fk FROM dbo.synTransaction (READPAST) )
ORDER BY 1,2,3




--LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS
--A-B set operation as to find the zipcodes not present in customer address. Same also can be done using sub queries and NOT IN Condition
SELECT  addPostCode AS [Post Code]
FROM dbo.synAddress (READPAST)
EXCEPT
SELECT addPostCode AS [Post Code]
FROM dbo.synAddress (READPAST)
INNER JOIN dbo.synCustomer (READPAST) ON cstAddId_fk = addId

/* ANY OTHER QUERIES THAT YOU THINK - MIGHT BE USEFUL FOR 
		A. CUSTOMERS
		B. BANK MANAGERS
		C. BANK TELLERS
*/

-- MONTHLY STATEMENT transactions for the month for customer id
DECLARE @accid char(6)
SET @accid = '405637'
SELECT *
FROM accounts acc
JOIN trans t
ON acc.account_number = t.account_number
WHERE acc.account_number = @accid AND  
(t.transaction_date_time > '20120531' AND t.transaction_date_time < '20120630')
ORDER BY t.transaction_date_time

--- ACCOUNTS WITH DEPOSITS TXNs total deposits by month for any account with Deposit transactions in 2013
SELECT acc.account_number, MONTH(t.transaction_date_time) AS Month2013, SUM(t.transaction_amount) AS Total_Deposits
FROM trans t
JOIN transtype tt
ON t.transaction_type_code = tt.transaction_type_code
JOIN accounts acc
ON t.account_number = acc.account_number
WHERE (t.transaction_date_time > '20121231' AND t.transaction_date_time < '20140101')
	AND tt.transaction_type_description = 'Deposit'
GROUP BY acc.account_number, MONTH(t.transaction_date_time)


--- ALL ACCOUNTS total monthly deposits even if deposits = 0
SELECT acc.account_number, MONTH(t.transaction_date_time) AS Month2013, SUM(t.transaction_amount) AS Total_Deposits
FROM accounts acc
LEFT OUTER JOIN trans t
ON acc.account_number = t.account_number
JOIN transtype tt
ON t.transaction_type_code = tt.transaction_type_code
WHERE (t.transaction_date_time > '20121231' AND t.transaction_date_time < '20140101')
GROUP BY acc.account_number, MONTH(t.transaction_date_time), tt.transaction_type_description
HAVING 	tt.transaction_type_description = 'Deposit'



 ALTER PROCEDURE  spGetCustomerDetails (@AccountType VARCHAR(50)=NULL)
 AS
 BEGIN
	 DECLARE @SQL NVARCHAR(4000)
	 SET @SQL= 'SELECT E.cstFirstName + ' + ''' ''' + ' + E.cstLastName AS [Customer Name],F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance], I.accStatusDesc AS [Account Status] '
	 
	 IF ( @AccountType IS NOT NULL OR @AccountType <>'')
			SET @SQL =@SQL + ' , H.accTypeDesc AS [Account Type] '
	 
	 SET @SQL= @SQL + '  FROM  dbo.synCustomer E
						 INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
						 INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
						 INNER JOIN dbo.synAccountStatus I ON G.accStatusCode_fk=I.accStatusId
	                  '
      IF ( @AccountType IS NOT NULL OR @AccountType <>'')
	  SET @SQL= @SQL + ' INNER JOIN dbo.synAccountType H ON G.accTypeCode_fk=H.accTypeId WHERE H.accTypeDesc = '''  +  @AccountType + ''''  

	  EXEC SP_EXECUTESQL @SQL
 
 END

EXEC spGetCustomerDetails  
EXEC spGetCustomerDetails 'Saving'





-- PIVOT	: TO ASSIGN NEW COLUMNS TO COLUMN VALUES
-- UNPIVOT	: TO ASSIGN COLUMN VALUES TO EXISTING COLUMNS

-- SEQUENCE  : USED TO GENERATE ALPHA NUMERIC VALUES

-- DENSE_RANK, RANK, SPACE

SELECT 'SQL'+SPACE(2)+'COURSE'

-- PARTITION BY : USED TO GROUP THE DATA FOR ROW_NUMBER, DENSE_RANK, RANK

----------





TABLES: FOR DATA STORAGE
VIEWS : FOR REPORTING
FUNCTIONS: PARAMETERIZED REPORTING
PROCEDURES: FOR DATA VALIDATIONS
TRIGGERS : FOR UPDATABLE VIEWS




/*
interview questions : to be sent today
certification material : to be sent today
latest certification dump : to be sent this weekend
*/






