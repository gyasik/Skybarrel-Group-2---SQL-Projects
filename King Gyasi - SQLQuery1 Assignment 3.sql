Use SkyBarrelBank_UAT

--1.A. ASK: The Director of Credit Analytics wants a report of ALL borrower who HAVE taken a loan with the bank. 

Select [BORROWERID]= DBI.[BorrowerID],
	   [BORROWER FULL NAME] = CONCAT_WS (' ', DBI.[BorrowerFirstName], DBI.[BorrowerMiddleInitial], '.', DBI.[BorrowerLastName]),
       [SSN] = CONCAT ('****', RIGHT(DBI.[TaxPayerID_SSN], 4)),
	   [LOAN PURCHASE YEAR] = YEAR (LOS.[PurchaseDate]), 
	   [PURCHASE AMOUNT IN THOUSANDS] = FORMAT (LOS.[PurchaseAmount]/1000, 'C0') + 'K'

	   FROM [dbo].[LoanSetupInformation] AS LOS
	   LEFT JOIN [dbo].[Borrower] AS DBI 
	   ON LOS.[BorrowerID] = DBI.[BorrowerID]

--1.B. ASK:Generate a similar list to the one above, this time, show all customers, EVEN THOSE WITHOUT LOANS. Return it with similar columns as above.     

Select [BORROWERID] = DBI.[BorrowerID],
	   [BORROWER FULL NAME] = CONCAT_WS (' ', DBI.[BorrowerFirstName], DBI.[BorrowerMiddleInitial], '.', DBI.[BorrowerLastName]),
       [SSN] = CONCAT ('****', RIGHT(DBI.[TaxPayerID_SSN], 4)),
	   [LOAN PURCHASE YEAR] = YEAR (LOS.[PurchaseDate]), 
	   [PURCHASE AMOUNT IN THOUSANDS] = FORMAT (LOS.[PurchaseAmount]/1000, 'C0') + 'K'

	   FROM [dbo].[LoanSetupInformation] AS LOS
	   FULL OUTER JOIN [dbo].[Borrower] AS DBI               ----<--DIFFERENCE = USE 'FULL OUTER JOIN'
	   ON LOS.[BorrowerID] = DBI.[BorrowerID]

--2.A. Aggregate the borrowers by country and show, per country


--SELECT [BorrowerID],
--	   [BORROWER FULL NAME] = CONCAT_WS (' ', [BorrowerFirstName], [BorrowerMiddleInitial], '.', [BorrowerLastName]),
	   
SELECT [CITIZENSHIP] = DBB.[Citizenship],
       [TOTAL PURCHASE AMOUNT] = FORMAT (SUM (LSS.[PurchaseAmount]), 'C0'),
	   [AVERAGE PURCHASE AMOUNT] = FORMAT (AVG (LSS.[PurchaseAmount]), 'C0'),
	   [COUNT OF BORROWERS] = COUNT (LSS.[BorrowerID]),
	   [AVERAGE LTV] = AVG (LSS.[LTV]),
	   [MINIMUM LTV] = MIN (LSS.[LTV]),
	   [MAXIMUM LTV] = MAX (LSS.[LTV]),
	   [AVERAGE AGE OF THE BORROWERS] =  AVG (FLOOR (DATEDIFF(day, DBB.[DoB], GETDATE()))/365)

	   FROM [dbo].[LoanSetupInformation] AS LSS
	   LEFT JOIN [dbo].[Borrower] AS DBB
	   ON DBB.[BorrowerID] = LSS.[BorrowerID]
	   GROUP BY [Citizenship]
	   ORDER BY  [TOTAL PURCHASE AMOUNT] desc


	          -----------------<<-CANNOT be Grouped by Purchae amount because it is aggregated, so I ordered by citizenship.
	   

--2.B. Aggregate the borrowers by gender (If the gender is missing or is blank, please replace it with X) and show, per country,  


SELECT [BORROWER GENDER] = ISNULL (NULLIF (DBA.[Gender], ''), 'X'),
	   [CITIZENSHIP] = DBA.[Citizenship],
       [TOTAL PURCHASE AMOUNT] = FORMAT (SUM (LSA.[PurchaseAmount]), 'C0'),
	   [AVERAGE PURCHASE AMOUNT] = FORMAT (AVG (LSA.[PurchaseAmount]), 'C0'),
	   [COUNT OF BORROWERS] = COUNT (LSA.[BorrowerID]),
	   [AVERAGE LTV] = AVG (LSA.[LTV]),
	   [MINIMUM LTV] = MIN (LSA.[LTV]),
	   [MAXIMUM LTV] = MAX (LSA.[LTV]),
	   [AVERAGE AGE OF THE BORROWERS] =  AVG (FLOOR (DATEDIFF(day, DBA.[DoB], GETDATE()))/365)

	   FROM [dbo].[LoanSetupInformation] AS LSA
	   LEFT JOIN [dbo].[Borrower] AS DBA
	   ON DBA.[BorrowerID] = LSA.[BorrowerID]
	   GROUP BY Gender, [Citizenship]
	   ORDER BY  [TOTAL PURCHASE AMOUNT] desc


---2.C. Aggregate the borrowers by gender (Only for F and M gender) and show, per country.

SELECT [YEAR OF PURCHASE] = YEAR (LSA.[PurchaseDate]), 
       [GENDER]=DBA.[Gender],
	   [CITIZENSHIP] = DBA.[Citizenship],
       [TOTAL PURCHASE AMOUNT] = FORMAT (SUM (LSA.[PurchaseAmount]), 'C0'),
	   [AVERAGE PURCHASE AMOUNT] = FORMAT (AVG (LSA.[PurchaseAmount]), 'C0'),
	   [COUNT OF BORROWERS] = COUNT (LSA.[BorrowerID]),
	   [AVERAGE LTV] = AVG (LSA.[LTV]),
	   [MINIMUM LTV] = MIN (LSA.[LTV]),
	   [MAXIMUM LTV] = MAX (LSA.[LTV]),
	   [AVERAGE AGE OF THE BORROWERS] =  AVG (FLOOR (DATEDIFF(day, DBA.[DoB], GETDATE()))/365)

	   FROM [dbo].[LoanSetupInformation] AS LSA
	   LEFT JOIN [dbo].[Borrower] AS DBA
	   ON DBA.[BorrowerID] = LSA.[BorrowerID]
	   WHERE GENDER = 'M' OR GENDER = 'F'
	   GROUP BY YEAR (LSA.[PurchaseDate]), Gender, [Citizenship]
	   ORDER BY YEAR (LSA.[PurchaseDate]) DESC
	   
--2.D. --Calculate the years to maturity for each loan( Only loans that have a maturity date in the future) and 

--then categorize them in bins of years (0-5, 6-10, 11-15, 16-20, 21-25, 26-30, >30).    

--Show the number of loans in each bins and the total purchase amount for each bin in billions 
--HINT:--SELECT FORMAT(10000457.004, '$0,,,.000B')
-------------------------------------------------------


----------------------
SELECT 
       [NO. OF LOANS] = COUNT ([LoanNumber]),
	   [TOTAL PURCHASE AMOUNT] = FORMAT (SUM ([PurchaseAmount])/1000000.000, 'C0') + 'B', 
       [YEARS LEFT TO MATURITY (BINS)] = CASE  
	   
										    WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) <= 5 THEN '0-5' 
										    WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 5 AND 11 THEN '6-10' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 12 AND 16 THEN '11-15' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 17 AND 21 THEN '16-20' 
										    WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 22 AND 26 THEN '21-25' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate])BETWEEN 27 AND 31 THEN '26-30' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate])> 30 THEN '>30' 
										
										ELSE 'NOT DEFINED'
										  END


FROM [dbo].[LoanSetupInformation]  
GROUP BY CASE
                                            WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) <= 5 THEN '0-5' 
										    WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 5 AND 11 THEN '6-10' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 12 AND 16 THEN '11-15' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 17 AND 21 THEN '16-20' 
										    WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate]) BETWEEN 22 AND 26 THEN '21-25' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate])BETWEEN 27 AND 31 THEN '26-30' 
											WHEN DATEDIFF(YEAR, GETDATE(), [MaturityDate])> 30 THEN '>30' 
										
										ELSE 'NOT DEFINED'
										  END




--Aggregate the Number Loans by Year of Purchase and the Payment frequency description column found in the LU_Payment_Frequency table    	 


SELECT 
       [NO. OF LOANS] = COUNT (LS.[LoanNumber]) OVER (PARTITION BY YEAR (LS.[PurchaseDate])),
	   [PAYMENT FREQUENCY DESCRIPTION] = LU.[PaymentFrequency_Description], 
	   [YEAR OF PURCHASE] = YEAR (LS.[PurchaseDate])

	   FROM [dbo].[LU_PaymentFrequency] AS LU
	   INNER JOIN [dbo].[LoanSetupInformation] AS LS
	   ON LS.[PaymentFrequency] = LU.[PaymentFrequency]
	

