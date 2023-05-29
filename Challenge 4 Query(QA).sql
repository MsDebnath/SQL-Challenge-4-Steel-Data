/*1. What are the names of all the customers who live in New York?*/

SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, 
	City
FROM customers
WHERE city = 'New York';

/*2. What is the total number of accounts in the Accounts table?*/

SELECT COUNT(DISTINCT AccountID) AS Total_accounts
FROM Accounts;

/*3. What is the total balance of all checking accounts?*/

SELECT AccountType, 
	SUM(Balance) AS Total_balance
FROM Accounts
WHERE AccountType = 'Checking';

/*4. What is the total balance of all accounts associated with customers who live in Los Angeles?*/

SELECT c.city,
	SUM(a.balance) AS Total_balance
FROM Accounts a
	JOIN Customers c USING(CustomerID)
WHERE c.city = 'Los Angeles';

/*5. Which branch has the highest average account balance?*/

SELECT b.BranchName,
	ROUND(AVG(a.balance),2) AS Highest_average_balance
FROM Accounts a
	INNER JOIN Branches b USING(BranchID)
GROUP BY b.BranchName
ORDER BY AVG(a.balance) DESC
LIMIT 1;

/*6. Which customer has the highest current balance in their accounts?*/

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName ,
	MAX(a.balance) AS Highest_current_balance
FROM Accounts a
	INNER JOIN Customers c USING(CustomerID)
GROUP BY CustomerName
ORDER BY MAX(a.balance) DESC
LIMIT 1;

/*7. Which customer has made the most transactions in the Transactions table?*/

WITH Ranked AS(
	SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
			COUNT(t.AccountID) AS total_transaction,
            DENSE_RANK() OVER (ORDER BY COUNT(t.AccountID) DESC) AS RN
	FROM Transactions t
		INNER JOIN Accounts a USING(AccountID)
        INNER JOIN Customers c USING(CustomerID)
	GROUP BY CustomerName
        )
SELECT CustomerName, total_transaction
FROM Ranked
WHERE RN = 1;

/*8.Which branch has the highest total balance across all of its accounts?*/

SELECT b.BranchName, 
	SUM(a.Balance) AS Highest_TotalBalance
FROM Accounts a
	INNER JOIN Branches b USING(BranchID)
GROUP BY b.BranchName
ORDER BY SUM(a.Balance) DESC
LIMIT 1;

/*9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?*/

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
	SUM(a.Balance) AS Highest_TotalBalance
FROM Accounts a
	INNER JOIN Customers c USING(CustomerID)
WHERE a.AccountType IN ('Checking', 'Savings')
GROUP BY CustomerName
ORDER BY SUM(a.Balance) DESC
LIMIT 1;

/*10. Which branch has the highest number of transactions in the Transactions table?*/

WITH Ranked AS(
	SELECT b.BranchName,
			COUNT(t.AccountID) AS total_transaction,
            DENSE_RANK() OVER (ORDER BY COUNT(t.AccountID) DESC) AS RN
	FROM Transactions t
		INNER JOIN Accounts a USING(AccountID)
        INNER JOIN Branches b USING(BranchID)
	GROUP BY b.BranchName
        )
SELECT BranchName, total_transaction
FROM Ranked
WHERE RN = 1;

