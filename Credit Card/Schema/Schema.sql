Create Table customer_data(
	Client_Num Int,
Customer_Age Int,
Gender Varchar(10),
Dependent_Count Text,
Education_Level Text,
Marital_Status Varchar(20),
state_cd Text,
Zipcode Int,
Car_Owner Varchar (10),
House_Owner Varchar(10),
Personal_loan Varchar(10),
contact Text,
Customer_Job Text,
Income Decimal (10,2),
Cust_Satisfaction_Score Numeric(3,2)

);

Select * from customer_data;


Create Table card_data(
Client_Num Text,
Card_Category Text,
Annual_Fees Text,
Activation_30_Days Text,
Customer_Acq_Cost Text,
Week_Start_Date Text,
Week_Num Text,
Qtr Text,
current_year Text,
Credit_Limit Text,
Total_Revolving_Bal Text,
Total_Trans_Amt Text,
Total_Trans_Vol Text,
Avg_Utilization_Ratio Text,
Use_Chip text,
Exp_Type text,
Interest_Earned Text,
Delinquent_Acc Text
);

Select * from card_data;

COPY card_data
FROM '‪C:\Users\England\Documents\Downloads\credit_card.csv'
Delimiter ','
CSV Header 



