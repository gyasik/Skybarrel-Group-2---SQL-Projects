---SQL ASSINMENT 1
---TASK---
---CREATE 2 SCHEMAS: DBO (ALREADY CREATED), BORROWER, LOAN
---Tables: This project requirements include the creation of 10 DATABASETABLES for storing of data.    
--CREATE SCHEMA -> TABLES -> COLUMNS -> ASSIGN PK -> ADD CONSTRAINTS---

CREATE DATABASE UNION_BANK;

USE UNION_BANK;


	
----BORROWER TABLES ---


CREATE SCHEMA BORROWER;

CREATE TABLE BORROWER.BORROWER
	(
		BORROWERID             INT NOT NULL,
		BORROWER_FIRST_NAME    VARCHAR (255) NOT NULL, 
		BORROWER_MIDDLE_NAME   CHAR (1) NOT NULL,
		BORROWER_LAST_NAME     VARCHAR (255) NOT NULL,
		DOB                    DATETIME NOT NULL,
		GENDER                 CHAR (1) NULL,
		TAXPAYERID_SSN         VARCHAR (9) NULL,
		PHONE_NUMBER           VARCHAR (10) NOT NULL,
		EMAIL                  VARCHAR (255) NOT NULL,
		CITIZENSHIP            VARCHAR (225) NULL,
		BENEFICIARY_NAME       VARCHAR (225) NULL,
		IS_US_CITIZEN          BIT NULL,
		CREATEDATE             DATETIME NOT NULL,

	);

-----ADD PRIMARY KEEY (BORROWERID)----
ALTER TABLE BORROWER.BORROWER
ADD CONSTRAINT PK_BORROWER_BORROWERID PRIMARY KEY (BORROWERID); 

-----ADD CONSTRAINTS------

ALTER TABLE BORROWER.BORROWER 
ADD CONSTRAINT CHK_BORROWER_DOB CHECK (DOB <= DATEADD(YEAR, -18, GETDATE())); 

ALTER TABLE [BORROWER].[BORROWER]
ADD CONSTRAINT CHK_EMAIL CHECK (EMAIL LIKE '%@%');

ALTER TABLE [BORROWER].[BORROWER]
ADD CONSTRAINT CHK_PHONE_NUMBER CHECK (LEN(PHONE_NUMBER)=10)

ALTER TABLE [BORROWER].[BORROWER]
ADD CONSTRAINT CHK_TAXPAYERID_SSN CHECK (LEN(TAXPAYERID_SSN)=9)

ALTER TABLE [BORROWER].[BORROWER]
ADD CONSTRAINT DF_BORROWER_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE; 

ALTER TABLE [BORROWER].[BORROWER]
ADD CONSTRAINT UC_BORROWERID UNIQUE (BORROWERID);


USE UNION_BANK;

CREATE SCHEMA BORROWER;

CREATE TABLE BORROWER.BORROWERADDRESS
	(
	 ADDRESSID         INT NOT NULL,
	 BORROWERID        INT NOT NULL,
	 STREET_ADDRESS    VARCHAR (255) NOT NULL,
	 ZIP               VARCHAR (5) NOT NULL,
	 CREATEDATE        DATETIME NOT NULL
	
	);

-----ADD PRIMARY KEEY (ADDRESSID)-----
ALTER TABLE [BORROWER].[BORROWERADDRESS]
ADD CONSTRAINT PK_BORROWERADDRESS_ADDERSSID PRIMARY KEY (ADDRESSID);



-----ADD CONSTRAINTS------
ALTER TABLE [BORROWER].[BORROWERADDRESS]
ADD CONSTRAINT DF_BORROWERADDRESS_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE; 

ALTER TABLE [BORROWER].[BORROWERADDRESS]
ADD CONSTRAINT FK_BORROWERADDRESS_BORROWERID FOREIGN KEY (BORROWERID) REFERENCES BORROWER.BORROWER(BORROWERID); 

ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT FK_BORROWERADDRESS_ZIP FOREIGN KEY (ZIP) REFERENCES DBO.US_ZIPCODES; --- NEED DBO TABLES AND COLUMNS

ALTER TABLE [BORROWER].[BORROWERADDRESS]
ADD CONSTRAINT UC_BORROWERADDRESS_ADDRESSID_BORROWERID UNIQUE (ADDRESSID, BORROWERID); 














---SPLIT----[Kiki]---



	------LOAN TABLES ----

CREATE SCHEMA LOAN;

CREATE TABLE LOAN.LOAN_SETUP_INFORMATION
	(

	);
	
	
CREATE TABLE LOAN.LOAN_PERIOD
	(
	
	
	);

-----SPLIT---[Kiki?]----

CREATE TABLE LOAN.LU_DELINQUENCY 
	(
		
	
	);

CREATE TABLE LOAN.LU_PAYMENT_FREQUENCY
	(
	           
	
	);

CREATE TABLE LOAN.UNDERWRITER
	(
		
	
	);


---SPLIT----[NAME OR TEAM MEMBER RESPONSIBLE]-----


-----DBO SCHEMA AREADY CREATED BY DEFAULT SO LETS CREATE OUR DBO TABLES ---


CREATE TABLE DBO.CALENDAR
	(
	
	
	);

CREATE TABLE DBO.ZIP_CODES
	(
	
	
	);


CREATE TABLE DBO.STATE
	(
	
	
	);

