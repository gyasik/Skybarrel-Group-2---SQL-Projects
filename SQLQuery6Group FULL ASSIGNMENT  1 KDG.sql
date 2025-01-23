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
---All borrower should be at least 18 years of as of the date of entry  [DOB]
---The email should containt the '@' symbol in the inserted value    [EMAIL]
---The number of digits entered here MUST be 10.  No less no more    [PHONE NUMBER]
---The number of digits entered here MUST be 9. No less no more    [SSN]
---If no value is inserted, then the Create date should default to the current time when the insertion is done    [CREATEDATE]
---Should be the UNIQUE IDENTIFIER OF A RECORD on this table. A borrower Can only have one BorrowerID and a BorrowerID can only be assigned to ONE borrower    [BORROWID]

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
---If no value is inserted, then the Create date should default to the current time when the insertion is done    [CREATEDATE]	
---This column should contain the same values as those in the BorrowerID of the Borrower table. In essence, the BorrowerID in both tables should create a relationship in both tables.     [BORROWID]
---This column should contain the same values as those in the ZIP of the US_Zip_Codes table. In essence, the ZIP in both tables should create a relationship in both tables.     [ZIP]
---This combination Should be the UNIQUE  IDENTIFIER OF A RECORD on this table. [ADDRESSID AND BORROWID]     

ALTER TABLE [BORROWER].[BORROWERADDRESS]
ADD CONSTRAINT DF_BORROWERADDRESS_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE; 

ALTER TABLE [BORROWER].[BORROWERADDRESS]
ADD CONSTRAINT FK_BORROWERADDRESS_BORROWERID FOREIGN KEY (BORROWERID) REFERENCES BORROWER.BORROWER(BORROWERID); 

ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT FK_BORROWERADDRESS_ZIP FOREIGN KEY (ZIP) REFERENCES DBO.US_ZIPCODES; 

ALTER TABLE [BORROWER].[BORROWERADDRESS]
ADD CONSTRAINT UC_BORROWERADDRESS_ADDRESSID_BORROWERID UNIQUE (ADDRESSID, BORROWERID); 


----LOAN SETUP INFORMATION TABLE---

CREATE SCHEMA LOAN

CREATE TABLE LOAN.LOANSETUPINFORMATION
(
  IsSurrogateKey               INT NOT NULL,
  LoanNumber                   VARCHAR (10) NOT NULL,
  PurchaseAmount               NUMERIC (18,2) NOT NULL,
  PurchaseDate                 DATETIME NOT NULL,
  LoanTerm                     INT NOT NULL,
  BorrowerID                   INT NOT NULL,
  UnderWriterID                INT NOT NULL,
  ProductID                    CHAR (2) NOT NULL,
  InterestRate                 DECIMAL (3,2) NOT NULL,
  PaymentFrequency             INT NOT NULL,
  AppraisalValue               NUMERIC (10,2) NOT NULL,
  CreateDate                   DATETIME NOT NULL,
  LTV                          DECIMAL (4,2) NOT NULL,
  FirstInterestPaymentDate     DATETIME NULL,
  MaturityDate                 DATETIME NOT NULL
);


-----ADD PRIMARY KEEY (LOANNUMBER)---
ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT PK_LOANSETUPINFORMATION_LOANNUMBER PRIMARY KEY (LOANNUMBER);


---ADD CONSTRAINTS----

---This column should only take the values 35, 30, 15 and 10    [LOAN TERM]
---The values on this column should be ONLY between 0.01 and 0.30    [INTERESTRATE]
---If no value is inserted, then the Create date should default to the current time when the insertion is done [CREATEDATE]   
---This column should contain the same values as those in the BorrowerID of the Borrower table. In essence, the BorrowerID in both tables should create a relationship in both tables.     [BORROWID]
---Is a foreign key referencing the column PaymentFrequency in the  LU_PaymentFrequency Table     [PAYMENTFREQUENCY]
---Is a foreign key referencing the column UnderwriterID in the  UnderwriterID Table     [UNDERWRITERID]
---Should be the UNIQUE IDENTIFIER OF A RECORD on this table.     [LOANNUMBER]


ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT CHK_LOANSETUPINFORMATION_LOANTERM CHECK (LOANTERM IN (35, 30, 15, 10));

ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT CHK_LOANSETUPINFORMATION_INTERESTRATE CHECK (INTERESTRATE BETWEEN 0.01 AND 0.30);

ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT DF_LOANSETUPINFORMATION_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE; 

ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT FK_LOANSETUPINFORMATION_BORROWERID FOREIGN KEY (BORROWERID) REFERENCES [BORROWER].[BORROWER] (BORROWERID);

ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT FK_LOANSETUPINFORMATION_PAYMENTFREQUENCY FOREIGN KEY (PAYMENTFREQUENCY) REFERENCES [LOAN].[LU_PAYMENTFREQUENCY] (PAYMENTFREQUENCY);

ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT FK_LOANSETUPINFORMATION_UNDERWRITERID FOREIGN KEY (UNDERWRITERID) REFERENCES [LOAN].[UNDERWRITER] (UNDERWRITERID);

ALTER TABLE [LOAN].[LOANSETUPINFORMATION]
ADD CONSTRAINT UC_LOANSETUPINFORMATION_LOANNUMBER UNIQUE (LOANNUMBER); 




---LOAN PERIODIC TABLE ----
CREATE TABLE LOAN.LOANPERIODIC
(
  IsSurrogateKey                 INT NOT NULL,
  LoanNumber                     VARCHAR (10) NOT NULL,
  CycleDate                      DATETIME NOT NULL,
  ExtraMonthlyPayment            NUMERIC (18,2) NOT NULL,
  UnpaidPrincipalBalance         NUMERIC (18,2) NOT NULL,
  BeginningScheduleBalance       NUMERIC NOT NULL,
  PaidInstallment                NUMERIC (18,2) NOT NULL,
  InterestPortion                NUMERIC (18,2) NOT NULL,
  PrincipalPortion               NUMERIC (18,2) NOT NULL,
  EndScheduleBalance             NUMERIC (18,2) NOT NULL,
  ActualScheduleBalance          NUMERIC (18,2) NOT NULL,
  TotalInterestedAccrued         NUMERIC (18,2) NOT NULL,
  TotalPrincipalAccrued          NUMERIC (18,2) NOT NULL,
  DefaultPentalty                NUMERIC (18,2) NOT NULL,
  DelinquencyCode                NUMERIC (10,0) NOT NULL,
  CreateDate                     DATETIME NOT NULL
);


-----ADD PRIMARY KEEY (LOANNUMBER)---
ALTER TABLE [LOAN].[LOANPERIODIC]
ADD CONSTRAINT PK_LOANPERIODIC_LOANNUMBER PRIMARY KEY (LOANNUMBER);


-----ADD CONSTRAINTS------

---(Interestportion+Principalportion) =   Paidinstallment    [INTERESTPORTION, PRINCIPALPORTION, PAIDINSTALLMENT]]
---If no value is inserted, then the Create date should default to the current time when the insertion is done    [CREATEDATE]
---If no value is inserted, then the default value should be zero    [EXTRAMONTHLYPAYMENT]
---Is a foreign key referencing the the column LoanNumber in the  LoanSetupInformation Table [LOANNUMBER]     
---Is a foreign key referencing the the column DelinquencyCode in the  LU_delinquency Table     [DELIQUENCYCODE]
---This combination Should be the UNIQUE  IDENTIFIER OF A RECORD on this table.     [LOANNUMBER, CYCLEDATE]

ALTER TABLE [LOAN].[LOANPERIODIC]
ADD CONSTRAINT CHK_LOANPERIODIC_InterestPortion_PrincipalPortion_PaidInstallment CHECK(PaidInstallment = InterestPortion + PrincipalPortion); 

ALTER TABLE LOAN.LOANPERIODIC
ADD CONSTRAINT DF_LOANPERIODIC_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE;

ALTER TABLE LOAN.LOANPERIODIC
ADD CONSTRAINT DF_LOANPERIODIC_EXTRAMONTHLYPAYMENT DEFAULT 0 FOR EXTRAMONTHLYPAYMENT;

ALTER TABLE LOAN.LOANPERIODIC
ADD CONSTRAINT FK_LOANPERIODIC_LOANNUMBER FOREIGN KEY (LoanNumber) REFERENCES LOAN.LOANSETUPINFORMATION; 

ALTER TABLE LOAN.LOANPERIODIC
ADD CONSTRAINT FK_LOANPERIODIC_DelinquencyCode FOREIGN KEY (LoanNumber) REFERENCES[LOAN].[LU_DELINQUENCY];

ALTER TABLE [LOAN].[LOANPERIODIC]
ADD CONSTRAINT UC_LOANPERIODIC_LOANNUMBER_CUYCLEDATE UNIQUE (LOANNUMBER, CYCLEDATE);



----LU DELIQUENCY TABLE----

CREATE TABLE LOAN.LU_DELINQUENCY
(
  DelinquencyCode               INT NOT NULL,
  Delinquency                   VARCHAR (255) NOT NULL,
  PaymentFrequency              INT NOT NULL,
  PaymentIsMadeEvery            INT NOT NULL,
  PaymentFrequency_Description  VARCHAR (255) NOT NULL
  
  );
  
-----ADD PRIMARY KEEY (DELINQUENCYCODE)
ALTER TABLE [LOAN].[LU_DELINQUENCY]
ADD CONSTRAINT PK_LOANDELINQUENCY_DELINQUENCYCODE PRIMARY KEY (DELINQUENCYCODE);

-----ADD CONSTRAINTS------
---Should be the UNIQUE IDENTIFIER OF A RECORD on this table.    [DELINQUENCYCODE]
ALTER TABLE [LOAN].[LU_DELINQUENCY]
ADD CONSTRAINT UC_LU_DELINQUENCY_DELINQUENCYCODE UNIQUE (DELINQUENCYCODE);






---LU PAYMENT FREQUENCY TABLE----
CREATE TABLE LOAN.LU_PAYMENTFREQUENCY
(
  PaymentFrequency                   INT NOT NULL, 
  PaymentIsMadeEvery                 INT NOT NULL,
  PaymentFrequency_Description       VARCHAR (255) NOT NULL
);


-----ADD PRIMARY KEEY (PAYMENTFREQUENCY)
ALTER TABLE [LOAN].[LU_PAYMENTFREQUENCY]
ADD CONSTRAINT PK_LU_PAYMENTFREQUENCY_PAYMENTFREQUENCY PRIMARY KEY (PAYMENTFREQUENCY);


-----ADD CONSTRAINTS------
---Should be the UNIQUE IDENTIFIER OF A RECORD on this table.     [PAYMENTFREQUENCY]
ALTER TABLE [LOAN].[LU_PAYMENTFREQUENCY]
ADD CONSTRAINT UC_LU_PAYMENTFREQUENCY_PAYMENTFREQUENCY UNIQUE (PAYMENTFREQUENCY);





----UNDERWRITER TABLE---

CREATE TABLE LOAN.UNDERWRITER
(
  UnderwriterID                 INT NOT NULL,
  UnderwriterFirstName          VARCHAR (255) NULL,
  UnderwriterMiddleName         CHAR (1) NULL,
  PhoneNumber                   VARCHAR (1) NULL,
  Email                         VARCHAR (255) NOT NULL,
  CreateDate                    DATETIME NOT NULL,
  UnderwriterLastName           VARCHAR (255) NOT NULL
  );

  -----ADD PRIMARY KEY (UNDERWRITERID)---
ALTER TABLE [LOAN].[UNDERWRITER]
ADD CONSTRAINT PK_UNDERWRITER_UNDERWRITERID PRIMARY KEY (UNDERWRITERID);


------ADD CONSTRAINTS----
---The email should containt the '@' symbol in the inserted value    [EMAIL]
---If no value is inserted, then the Create date should default to the current time when the insertion is done    [CREATEDATE]
---Should be the UNIQUE IDENTIFIER OF A RECORD on this table.     [UNDERWRITERID]

ALTER TABLE [LOAN].[UNDERWRITER]
ADD CONSTRAINT CHK_EMAIL CHECK (EMAIL LIKE '%@%');

ALTER TABLE [LOAN].[UNDERWRITER]
ADD CONSTRAINT DF_UNDERWRITER_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE;

ALTER TABLE [LOAN].[UNDERWRITER]
ADD CONSTRAINT UC_UNDERWRITER_UNDERWRITERID UNIQUE (UNDERWRITERID);






-----DBO SCHEMA AREADY CREATED BY DEFAULT SO LETS CREATE OUR DBO TABLES ---

----DBO CALENDAR TABLE ----

CREATE TABLE DBO.CALENDAR
	(
	CalendarDate     DATETIME NULL      ---TABLE HAS ONLY ONE COLUMN THAT IS NULLABLE, THEREFORE A PK CANNOT BE ADDED
	);



------DBO ZIP CODES TABLE -----

CREATE TABLE DBO.US_ZIP_CODES
	(
	IsSurrogateKey     INT NOT NULL,
	ZIP                VARCHAR NOT NULL,
	Latitude           FLOAT NULL,
	Longitude          FLOAT NULL,
	City		       VARCHAR NULL,
	StateID            CHAR (2) NULL,
	Population_        INT NULL,
	Density            DECIMAL (18,0) NULL,   
	County_fips        VARCHAR (10) NULL,
	County_name        VARCHAR (255) NULL,
	County_name_all    VARCHAR (255) NULL,
	County_fips_all    VARCHAR (50) NULL,
	Timezone           VARCHAR (255) NULL,
	CreateDate         DATETIME NOT NULL
	);

---ADD PRIMARY KEY----
ALTER TABLE [dbo].[US_ZIP_CODES]
ADD CONSTRAINT PK_US_ZIP_CODES_IsSurrogateKey PRIMARY KEY (IsSurrogateKey);


----ADD CONSTRAINTS-----

---If no value is inserted, then the Create date should default to the current time when the insertion is done    [CREATEDATE]
---Is a foreign key referencing the column UnderwriterID in the UnderwriterID Table [STATEID]
---Should be teh UNIQUE IDENTIFIER OF A RECORD on this Table [ZIP]

ALTER TABLE [dbo].[US_ZIP_CODES]
ADD CONSTRAINT DF_US_ZIP_CODE_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE;

ALTER TABLE [dbo].[US_ZIP_CODES]
ADD CONSTRAINT FK_US_ZIP_CODE_STATEID FOREIGN KEY (STATEID) REFERENCES [LOAN].[UNDERWRITER] (UNDERWRITERID); 
----ERROR indicates that the DATATYPE FOR UNDERWRITERID (INT) AND ZIPCODES (VARCHAR) ARE DIFFERENT
----PROPOSED SOLUTION: 
---ALTER TABLE LOAN.UNDERWRITTER
---ALTER COLUMN UNDERWRITERID <VARCHAR> ...THEN RE-RUN CODE.

ALTER TABLE [dbo].[US_ZIP_CODES]
ADD CONSTRAINT UC_US_ZIP_CODES_ZIP UNIQUE (ZIP);



----DBO STATE TABEL -----
CREATE TABLE DBO.STATE
	(
	StateId            CHAR (2) NOT NULL,
	StaetName          VARCHAR (255) NOT NULL,
	CreateDate         DATETIME NOT NULL

	);

-----ADD PRIMARY KEY----

ALTER TABLE [dbo].[STATE]
ADD CONSTRAINT PK_STATE_StateID PRIMARY KEY (StateID);

----ADD CONSTRAINTS----
---If no value is inserted, then the Create date should default to the current time when the insertion is done   [CREATEDATE]
---Should be the UNIQUE IDENTIFIER OF A RECORD on this table.    [STATEID]
---This column can only take unique values, no duplicates.     [STATENAME]


ALTER TABLE [dbo].[STATE]
ADD CONSTRAINT DF_STATE_CREATEDATE DEFAULT (GETDATE()) FOR CREATEDATE;

ALTER TABLE [dbo].[STATE]
ADD CONSTRAINT UC_STATE_StateID UNIQUE (StateID);

ALTER TABLE [dbo].[STATE]
ADD CONSTRAINT UC_STATE_StateName UNIQUE (StateName);

