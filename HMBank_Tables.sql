CREATE DATABASE HMBank;
USE HMBank;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    DOB DATE,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    address VARCHAR(255)
);
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    account_type ENUM('savings', 'current', 'zero_balance'),
    balance DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer'),
    amount DECIMAL(12,2),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);
SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Transactions;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Transactions;
TRUNCATE TABLE Accounts;
TRUNCATE TABLE Customers;
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE Customers AUTO_INCREMENT = 1;
ALTER TABLE Accounts AUTO_INCREMENT = 1;
ALTER TABLE Transactions AUTO_INCREMENT = 1;

-- Task 2 (Select, Where, Between, AND, LIKE:)
-- Step 1(retrieve the name, account type and email of all customers)
select first_name, last_name, account_type, email
from Customers
join Accounts using(customer_id);

-- Step 2(all transaction corresponding customer)
select first_name, last_name, transaction_type, amount
from Customers
join Accounts using(customer_id)
join Transactions using(account_id);

-- Step 3(increase the balance of a specific account by a certain amount.)
update Accounts set balance = balance + 1000 where account_id = 1;

-- Step 4(Combine first and last names of customers as a full_name.)
select CONCAT(first_name, ' ', last_name) as full_name from Customers;

-- Step 5  (to remove accounts with a balance of zero where the account type is savings)
delete from Accounts
where balance = 0 and account_type = 'Savings';

-- Step 6  (customers living in a specific city)
select * from Customers
where address like '%Chennai%';

-- Step 7 (account balance for a specific account)
select account_id, balance
from Accounts
where account_id = 1;

-- Step 8 (current accounts with a balance greater than 1,000)
select * from Accounts
where balance > 1000;

-- Step 9 (retrieve all transactions for a specific account (Example → account_id = 1))
select * from Transactions
where account_id = 1;

-- Step 10 (interest accrued on savings accounts based on a given interest rate. (Example → 5% interest))
select account_id, balance, (balance * 0.05) AS interest
from Accounts
where account_type = 'Savings';

-- Step 11  (accounts where the balance is less than a specified overdraft limit. (Example → ₹5000))
select * from Accounts
where balance < 5000;

-- Step 12 (customers not living in a specific city. (Example → NOT Chennai))
select * from Customers
where address not like '%Chennai%';



-- Task3 (Aggregate functions, Having, Order By, GroupBy and Joins)
-- Step 1: (average account balance for all customers)
select avg(balance) as average_balance from Accounts;

-- Step 2:(Retrieve the top 10 highest account balances)
select * from Accounts order by balance desc
limit 10;

-- Step 3:(total deposits for all customers in a specific date)
select account_id, SUM(amount) as total_deposits from Transactions
where transaction_type = 'Deposit' and transaction_date = '2025-06-01' group by account_id;

-- Step 4:(oldest and newest customers)
select * from Customers
order by DOB asc
limit 1;  -- Oldest
select * from Customers
order by DOB desc
limit 1;  -- Newest

-- Step 5:(Retrieve transaction details along with the account type)
select Transactions.*, Accounts.account_type from Transactions
join Accounts using(account_id);

-- Step 6:(list of customers along with their account details)
select Customers.*, Accounts.account_id, Accounts.account_type, Accounts.balance
from Customers
join Accounts using(customer_id);

-- Step7:(Retrieve transaction details along with customer information for a specific account)
select Customers.first_name, Customers.last_name, Transactions.*
from Transactions
join Accounts using(account_id)
join Customers using(customer_id)
where Transactions.account_id = 1;

-- Step8 :(Identify customers who have more than one account)
select customer_id, COUNT(account_id) as number_of_accounts
from Accounts
group by customer_id having COUNT(account_id) > 1;

-- Step9 :(difference in transaction amounts between deposits and withdrawals)
select account_id,
       SUM(case when transaction_type = 'Deposit' then amount else 0 end) -
       SUM(case when transaction_type = 'Withdrawal' then amount else 0 end) as balance_difference
from Transactions
group by account_id;

-- Step10 :(average daily balance for each account over a specified period)
select account_id, avg(balance) as average_daily_balance
from Accounts
group by account_id;

-- Step11 :(total balance for each account type)
select account_type, SUM(balance) as total_balance
from Accounts
group by account_type;

-- Step12:(accounts with the highest number of transactions ordered by descending order)
select account_id, COUNT(transaction_id) as transaction_count
from Transactions
group by account_id
order by transaction_count desc;

-- Step13:(customers with high aggregate account balances, along with their account types)
select Customers.customer_id, first_name, last_name, account_type, SUM(balance) as total_balance
from Customers
join Accounts using(customer_id)
group by Customers.customer_id, account_type
order by total_balance desc;

-- Step14:(duplicate transactions based on transaction amount, date, and account)
select account_id, transaction_date, amount, COUNT(*) as duplicate_count
from Transactions
group by account_id, transaction_date, amount
having COUNT(*) > 1;



-- Task 4:(4: Subquery and its type)
-- Step 1:(Retrieve the customer(s) with the highest account balance)
select first_name, last_name, balance from Customers
join Accounts using (customer_id)
where balance = (select  MAX(balance) from Accounts);

-- Step 2:(2Calculate the average account balance for customers who have more than one account)
select customer_id, avg (balance) as avg_balance from Accounts
group by customer_id
having COUNT(account_id) > 1;

-- Step 3:( Retrieve accounts with transactions whose amounts exceed the average transaction amount)
select account_id, transaction_date, amount from Transactions
where amount > (select avg(amount) from Transactions);

-- Step 4:(customers who have no recorded transactions)
select distinct C.customer_id, C.first_name, C.last_name from Customers C join Accounts A on C.customer_id = A.customer_id left join Transactions T on A.account_id = T.account_id
where T.transaction_id IS null;

-- Step 5:(total balance of accounts with no recorded transactions)
select SUM(balance) as total_balance from Accounts A
left join  Transactions T on A.account_id = T.account_id
where T.transaction_id is null;

-- Step 6:( Retrieve transactions for accounts with the lowest balance)
select T.* from Transactions T join Accounts A using(account_id)
where A.balance = (select MIN(balance) from Accounts);

-- Step 7:(customers who have accounts of multiple types)
select customer_id, first_name, last_name from Customers join Accounts using(customer_id) group by customer_id
having COUNT(distinct account_type) > 1;

-- Step 8:(percentage of each account type out of the total number of accounts)
select account_type,  COUNT(*) * 100.0 / (select COUNT(*) from Accounts) as percentage from Accounts
group by account_type;

-- Step 9:(Retrieve all transactions for a customer with a given customer_id)
select T.* from Transactions T join Accounts A using(account_id)
where A.customer_id = customer_id;

-- Step 10:( total balance for each account type, including a subquery within the SELECT clause)
select account_type, (select SUM(balance) from Accounts A2 where A2.account_type = A1.account_type) as total_balance from Accounts A1
group by  account_type;


