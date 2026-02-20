----------------------Business Insights---------------------
----"I need a list of all customers with their card category, annual fees, and total transaction amounts for Q1 2023. Show only customers who used their credit card (where total_trans > 0)
Select client_num,
	card_category,
	annual_fees,
	total_trans_amt
	From card_data
where qtr= 'Q1'
And current_year= 2023
And total_trans_amt >0;
	
select * from card_data;
select * from customer_data;

---Show me all male customers aged 40-60 who own a home AND a car. Include their income, job type, and customer satisfaction score.---
Select 
	client_num,
	gender,
	customer_age,
	income,
	customer_job,
	cust_satisfaction_score
	From customer_data
	where customer_age between 40 and 60
	And car_owner='yes'
	And house_owner= 'yes'
	And gender ='Male';

-----Which card categories generated the most revenue from annual fees? Give me the total annual fees per card category, sorted from highest to lowest."
select card_category,
	CONCAT('$', Round(Sum(annual_fees),2)) as total_revenue
	from card_data
	group by card_category
	order by Sum(annual_fees) desc;

-----How many customers activated their cards vs didn't activate? Show the count for each activation status.
select 
	case  
	when activation_30_days = 1 then 'Activated'
	else 'Not Activate'
	End as activation_status,
	Count(*) as total_customer
	From card_data
	group by activation_30_days;

-----Create a report linking customer demographics with their card spending. 
--Show: client_num, customer_age, income, card_category, total_trans, and avg_utilization. Filter for customers with average utilization > 50%."

Select c. client_num,
	c.customer_age,
	c.income,
	cd.card_category,
	cd.total_trans_amt,
	cd.avg_utilization_ratio
	from customer_data c
	join card_data cd
	on c.client_num= cd.client_num
	where cd.avg_utilization_ratio > 0.5;
		
--- show customers where their credit_limit is NOT proportional to their income (e.g., low income but very high credit limit, or vice versa).
---  This might indicate risky lending decisions."
select c.client_num,
	Concat('$' ,c. income) as total_income,
	concat('$', cd. credit_limit) as total_limit,
	cd.credit_limit - c.income as credit_gap
	from customer_data c
	join card_data cd
	on c.client_num= cd.client_num
	where cd. credit_limit > (c. income * 2);

---- Which job types generate the highest average transaction amounts? Show job type, average transaction amount, and count of customers per job type."
select c.customer_job,
	Round(AVG(total_trans_amt),2) as average_trans,
	Count(*) as total_customers
	from customer_data c
	join card_data cd
	on c.client_num= cd.client_num
	Group by c.customer_job 
	order by total_customers desc;

-----Show total revenue (annual_fees + interest_earned) by state. Which state has the most profitable customers?"
Select c.state_cd,
		SUM(cd.annual_fees + cd.interest_earned) as total_profit
		from customer_data c
	join card_data cd
	on c.client_num= cd.client_num
	group by c.state_cd
	order by total_profit desc;
	
----- Identify customers who are delinquent (delinquent = 1) AND have high credit utilization (avg_utilization > 70%). Also show if they're single,
---- have no house, and low income. We want to reach out to these high-risk customers.
Select c.client_num,
	c.house_owner,
	c.marital_status,
	c.income,
	cd. delinquent_acc,
	cd. avg_utilization_ratio
	From customer_data c
	join card_data cd
on c.client_num= cd.client_num
where c.house_owner= 'no'
And c.marital_status= 'Single'
And c.income < 30000
And cd. delinquent_acc= 1
And cd. avg_utilization_ratio > 0.70;

---Show customers who have a personal_loan = 'yes' and compare their total transaction amounts to customers without loans. 
-- Are loan customers spending more or less on their cards?
Select 
	Case
	when c.personal_loan = 'yes' then 'take loan'
	else 'Not taken'
	end as loan_status,
	Sum(cd. total_trans_amt) as total
	From customer_data c
	join card_data cd
on c.client_num= cd.client_num
	Group by c.personal_loan;

---Compare customers who use chip technology vs online transactions. Show average transaction amount, average utilization, and delinquency rate for each method. 
--Is chip more or less risky?

Select 
	Case
		when use_chip ilike '%Chip%' then 'Chip Trans'
		when use_chip ilike '%Online%' then 'Online Trans'
		when use_chip ilike '%Swipe%' then 'Swipe Tarns'
		else 'Others'
		end as transaction_method,
		round(avg(total_trans_amt),2) as avg_transactions,
		round(avg(avg_utilization_ratio),2) as average_utilizations,
		ROUND(
        100.0 * SUM(delinquent_acc)::NUMERIC / COUNT(*),
        2
    ) AS delinquency_rate_pct
FROM card_data
GROUP BY transaction_method
ORDER BY delinquency_rate_pct DESC;

----Which customer segments are most profitable based on annual_fees? Cross-reference with marital_status, education_level, and income brackets.
---  Which 'type' of customer should we target for premium cards?

Select c.income,
	c.marital_status,
	c.education_level,
	Sum(cd.annual_fees) as total_fee_revenue,
	count(*) as total_customer,
	Round(avg(cd.annual_fees),2) as per_cust_fees
	From customer_data c
	join card_data cd
on c.client_num= cd.client_num
Group by 1,2,3
order by total_fee_revenue desc;

----Rank customers by total value (annual_fees + interest_earned + total_transactional). Show their percentile rank, card category, and customer satisfaction. 
--Who are our top 10% most valuable customers, and are they satisfied?"
Select 
	c.client_num,
	cd.card_category,
	c.cust_satisfaction_score,
	(cd.annual_fees+ cd.interest_earned+cd.total_trans_amt) as total_value,
	Percent_Rank() over (order by(cd.annual_fees+ cd.interest_earned+cd.total_trans_amt)desc) as percentile_rank
From customer_data c
	join card_data cd
on c.client_num= cd.client_num
order by total_value desc;

SELECT 
    cd.card_category,
    AVG(c.cust_satisfaction_score) AS avg_satisfaction,
    SUM(cd.annual_fees + cd.interest_earned + cd.total_trans_amt) AS total_segment_value,
    NTILE(10) OVER (ORDER BY SUM(cd.annual_fees + cd.interest_earned + cd.total_trans_amt) DESC) AS value_percentile
FROM customer_data c
JOIN card_data cd ON c.client_num = cd.client_num
GROUP BY cd.card_category
ORDER BY total_segment_value DESC;

WITH customer_value AS (
    SELECT 
        c.client_num,
        cd.card_category,
        c.cust_satisfaction_score,
        (cd.annual_fees + cd.interest_earned + cd.total_trans_amt) AS total_value,
        PERCENT_RANK() OVER (
            ORDER BY (cd.annual_fees + cd.interest_earned + cd.total_trans_amt)
        ) AS percentile_rank
    FROM customer_data c
    JOIN card_data cd
        ON c.client_num = cd.client_num
)

SELECT *
FROM customer_value
WHERE percentile_rank >= 0.90
ORDER BY total_value DESC;

---- For each income bracket (you define: 0-50k, 50-100k, 100k+), calculate: average credit limit, average interest earned, and average delinquency rate. 
-- Which bracket is most profitable relative to risk?"

Select 
	Case
		when c.income > 100000 then '100K+'
		when c.income > 50000 then '50-100K'
		else '0-50K'
		end as income_category,
		Round(Avg(cd.credit_limit),2) as average_credit,
		Round(avg(cd.interest_earned),2) as avearge_interest,
		ROUND(AVG(cd.delinquent_acc * 1.0), 4) AS delinquency_rate
		FROM customer_data c
    JOIN card_data cd
        ON c.client_num = cd.client_num
		Group by 1
		order by avearge_interest desc;
		
-----Show how customer spending changes across weeks in Q1 2023. Use week_start_date to show: which week had the highest average spending?
-- Are customers spending more or less as Q1 progresses? (Bonus: identify any seasonal patterns)"
SELECT 
    cd.week_start_date,
    ROUND(AVG(cd.total_trans_amt), 2) AS avg_weekly_spend,
    SUM(cd.total_trans_amt) AS total_weekly_revenue,
    COUNT(*) AS total_transactions
FROM card_data cd
WHERE cd.week_start_date BETWEEN '2023-01-01' AND '2023-03-31' 
GROUP BY cd.week_start_date
ORDER BY cd.week_start_date ASC;
	
----- Based on annual_fees, interest_earned, and total_transactional data, estimate which customers have the highest lifetime value. 
--Cross-reference with their satisfaction score—are our most profitable customers actually satisfied?"

Select c.client_num,
	Sum(cd.annual_fees+cd.interest_earned+cd.total_trans_amt) as lifetime_value,
	c.cust_satisfaction_score
	FROM customer_data c
    JOIN card_data cd
        ON c.client_num = cd.client_num
		Group by c.client_num, c.cust_satisfaction_score
		Order by lifetime_value desc;
	
	WITH ltv_ranked AS (
    SELECT 
        c.client_num,
        SUM(cd.annual_fees + cd.interest_earned + cd.total_trans_amt) AS lifetime_value,
        ROUND(AVG(c.cust_satisfaction_score), 2) AS satisfaction,
        NTILE(10) OVER (
            ORDER BY SUM(cd.annual_fees + cd.interest_earned + cd.total_trans_amt) DESC
        ) AS ltv_decile
    FROM customer_data c
    JOIN card_data cd
        ON c.client_num = cd.client_num
    GROUP BY c.client_num
)

SELECT *
FROM ltv_ranked
WHERE ltv_decile = 1
ORDER BY lifetime_value DESC;

-----Customers with low satisfaction (cust_satisfaction <= 2.0) who also have high credit limits and high utilization might be at risk of closing their accounts. 
--Identify these customers and show: their age, income, job, and current metrics. What retention strategy should we use?"
With risk_customers as (
	Select 
	c.client_num,
        c.customer_age,
        c.income,
        c.personal_loan,
        c.cust_satisfaction_score,
        cd.credit_limit,
        cd.avg_utilization_ratio
		FROM customer_data c
    JOIN card_data cd ON c.client_num = cd.client_num
	WHERE c.cust_satisfaction_score <= 3
      AND cd.credit_limit > 10000 
      AND cd.avg_utilization_ratio > 0.30
)
SELECT * FROM risk_customers
ORDER BY credit_limit DESC;



SELECT 
    MIN(cust_satisfaction_score) as lowest_sat,
    MAX(cust_satisfaction_score) as highest_sat,
    MAX(credit_limit) as max_limit,
    MAX(avg_utilization_ratio) as max_util
FROM customer_data c
JOIN card_data cd ON c.client_num = cd.client_num;


SELECT c.client_num, c.cust_satisfaction_score, cd.credit_limit, cd.avg_utilization_ratio
FROM customer_data c
JOIN card_data cd ON c.client_num = cd.client_num
WHERE c.cust_satisfaction_score <= 2 
   OR cd.avg_utilization_ratio > 0.80;
   
-----Show customers who DON'T have a personal_loan (personal_loan = 'no') but have excellent credit profiles: high income, low delinquency, low utilization, high satisfaction.
--These are prime candidates for loan cross-selling."
Select 
	c.client_num,
    c.income,
    c.cust_satisfaction_score,
    cd.avg_utilization_ratio,
    cd.delinquent_acc,
    cd.credit_limit
	FROM customer_data c
JOIN card_data cd ON c.client_num = cd.client_num
WHERE c.personal_loan ILIKE 'no'
AND c.income > 70000
AND cd.avg_utilization_ratio < 0.30
AND cd.delinquent_acc = 0
AND c.cust_satisfaction_score >= 4
ORDER BY c.income DESC;

----Are customers with higher annual fees (premium cards) actually spending more or generating more interest than lower-fee customers? 
--- Is our premium card strategy working? Show the ROI comparison."
SELECT 
    cd.card_category,
	COUNT(*) as total_customers,
    ROUND(AVG(cd.annual_fees), 2) as avg_fee,
    ROUND(AVG(cd.total_trans_amt), 2) as avg_spend,
    ROUND(AVG(cd.interest_earned), 2) as avg_interest,
ROUND(AVG(cd.annual_fees + cd.interest_earned + (cd.total_trans_amt * 0.02)), 2) as est_rev_per_cust,
    ROUND(AVG(cd.delinquent_acc * 1.0), 4) as delinquency_rate
FROM card_data cd
GROUP BY 1
ORDER BY avg_fee DESC;

----Which state+age_group combination has the highest customer satisfaction AND highest spending? We want to expand marketing in that segment.
--- Show profitability, customer count, and satisfaction metrics."
SELECT 
    c.state_cd,
	CASE 
        WHEN c.customer_age < 30 THEN '18-30'
        WHEN c.customer_age BETWEEN 30 AND 50 THEN '31-50'
        ELSE '51+'
    END AS age_group,
	COUNT(*) AS total_customers,
    ROUND(AVG(c.cust_satisfaction_score), 2) AS avg_satisfaction,
    ROUND(AVG(cd.total_trans_amt), 2) AS avg_spending,
    SUM(cd.annual_fees + cd.interest_earned) AS total_profit
FROM customer_data c
JOIN card_data cd ON c.client_num = cd.client_num
GROUP BY 1, 2
HAVING COUNT(*) > 10
ORDER BY avg_satisfaction DESC, avg_spending DESC
LIMIT 10;


