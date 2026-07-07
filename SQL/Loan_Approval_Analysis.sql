CREATE DATABASE mortgage_analysis;
USE mortgage_analysis;

CREATE TABLE loans(
Loan_ID varchar(50),
Gender varchar(50),
Married varchar(50),
Dependents varchar(50),
Education varchar(50),
Self_Employed varchar(50),
ApplicantIncome varchar(50),
CoapplicantIncome varchar(50),
LoanAmount varchar(50),
Loan_Amount_Term varchar(50),
Credit_History varchar(50),
Property_Area varchar(50),
Loan_Status varchar(50)
);
-----------------------------------------------------------------------------------------
/*  QUERY 1 - What Percentage of applications are approved vs rejected */

SELECT Loan_Status,
Count(*) AS Applications,
ROUND(COUNT(*)*100/ (Select COUNT(*) FROM loans),2) AS Percentage
FROM loans
GROUP BY Loan_Status; 

/*FROM THIS we found how much % appln rejected and approved, Approx 69% approved and 315% rejected*/
-------------------------------------------------------------------------------------

/* QUERY 2 - Does having a good credit history improve approval chances?*/

SELECT Credit_History, Loan_status, Count(*) as TOTAL
FROM Loans
GROUP BY Credit_History, Loan_Status
Order BY Credit_History; 

/*FROM THIS QUERY- NULL is missing DATA, 1 is good credit history and 0 is poor credit history
Applicants with a good credit history (1) have an approval rate of about 80%, while applicants with a poor credit history (0) have an approval rate of only about 8%*/
-------------------------------------------------------------------------------------------

/*QUERY 3 - Do Graduates get appoved more often?*/

SELECT Education, COUNT(*) as Total, 
SUM(CASE WHEN Loan_Status='Y' THEN 1 ELSE 0 END) As Approved,
SUM(CASE WHEN Loan_Status='N' THEN 1 ELSE 0 END) As Rejected,
ROUND(SUM(CASE WHEN Loan_Status = 'Y' THEN 1 ELSE 0 END)*100/COUNT(*), 2) as Approval_Rate
From loans
GROUP BY Education;

/*FROM THIS we found, Graduates have a higher approval rate of approx 71% whereas Non-Grad have approval rate of 61% */
---------------------------------------------------------------------------------------------------

/*QUERY 4 - Which area has the highest approval rate*/

SELECT Property_Area, COUNT(*) as Total_Applicants,
SUM(CASE WHEN Loan_Status = 'Y' THEN 1 ELSE 0 END) as approved,
SUM(CASE WHEN Loan_Status = 'N' THEN 1 Else 0 END) AS rejected,
ROUND(SUM(CASE WHEN Loan_Status = 'Y' Then 1 ELSE 0 END)*100/COUNT(*), 2) as approval_rate
from Loans
group by Property_Area;

/*FROM THIS we understood that Applicants from SemiUrban areas have the highest loan approval rate, suggesting that this segment presents a lower perceived lending risk
compared to urban or rural applicants*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------

/*QUERY 5 - Married Applicants considered less risky?*/

Select Married, COUNT(*) as Total_Applicants,
SUM(CASE WHEN Loan_status = 'Y' THEN 1 ELSE 0 END) as Approved,
SUM(CASE WHEN Loan_status = 'N' THEN 1 ELSE 0 END) as Rejected,
ROUND(SUM(CASE WHEN Loan_status = 'Y' THEN 1 ELSE 0 END)*100/COUNT(*), 2) As Approval_Rate
From Loans
GROUP BY Married;

/*FROM THIS we understood that Married applicants demonstrate a higher loan approval rate than unmarried ones, suggesting lenders may perceive them as more financially stable
or lower risk borrowers*/
-------------------------------------------------------------------------------------------------------------------------------------

/*Query 6 - is there any approval difference between genders?*/

SELECT Gender, COUNT(*) as Total_Applicants, 
SUM(CASE WHEN Loan_status = 'Y' THEN 1 ELSE 0 END) as Approved,
SUM(CASE WHEN Loan_status = 'N' THEN 1 ELSE 0 END) as Rejected,
ROUND(SUM(CASE WHEN Loan_status = 'Y' THEN 1 ELSE 0 END)*100/COUNT(*), 2) Approval_Rate
from Loans
GROUP BY Gender;

/*FROM THIS - we found both approval rates are approximately same, Suggesting Gender is not a major factor in lending decision*/
-----------------------------------------------------------------------------------------------------------------------------------------

/* QUERY 7 - Do higher-income applicants get approved often?*/

SELECT CASE 
		WHEN CAST(ApplicantIncome as UNSIGNED)< 3000 THEN 'LOW INCOME'
        WHEN CAST(ApplicantIncome as UNSIGNED) BETWEEN 3000 AND 6000 THEN 'MEDIUM INCOME'
        ELSE 'HIGH INCOME'
        END AS Income_group,
        COUNT(*) as Total_Applicants,
        SUM(CASE WHEN Loan_Status = 'Y' THEN 1 ELSE 0 END) AS Approved,
        ROUND(SUM(CASE WHEN Loan_Status = 'Y' THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS Approval_Rate
        FROM loans
        GROUP BY Income_group;
        
        /*FROM THIS - Income level Does not appear to significantly influence loan approval decisions in this dataset, They are relatively consistent among all income groups*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Query - 8 Hidden Risk Analysis - Are we rejecting people who earn a lot but have poor credit history?*/

SELECT Credit_History,
	CASE WHEN CAST(ApplicantIncome AS UNSIGNED)< 3000 THEN 'LOW INCOME'
        WHEN CAST(ApplicantIncome as UNSIGNED) BETWEEN 3000 AND 6000 THEN 'MEDIUM INCOME'
        ELSE 'HIGH INCOME'
        END AS Income_group,
        COUNT(*) as Total_Applicants,
        SUM(CASE WHEN Loan_Status = 'Y' THEN 1 ELSE 0 END) AS Approved,
        ROUND(SUM(CASE WHEN Loan_Status = 'Y' THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS Approval_Rate
        FROM loans
        GROUP BY Credit_History, Income_group
        ORDER BY Credit_History, Approval_Rate DESC;
	
    /* From this - Yes, Credit History significantly overweighs income in loan approval decisions, Whereas applicants with good credit histories maintain approval rate above 75% 
        regardless of the income group they belong*/
------------------------------------------------------------------------------------------------------------------------------------------------
        
	/*Query 9 - Which Geographic segment requests the largest loans and are they being approved?*/
        
SELECT Property_Area,
		ROUND(AVG(CAST(LoanAmount as UNSIGNED)), 0) as Avg_loan_requested,
		ROUND(SUM(CASE WHEN Loan_status = 'Y' THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS Approval_Rate
        FROM loans
        GROUP BY Property_area;

/* From this we found most amount of Loans are requested in Rural areas then in SemiUrban Areas whereas the highest approval is from SemiUrban Areas*/


	

