# MSSQL-Server 2025 Query Practice

## Q. Write a SQL Query to remove duplicates from Table?

```sql
Input:

CREATE TABLE Employee
    ( 
      [ID] INT identity(1, 1), 
      [FirstName] Varchar(100), 
      [LastName] Varchar(100), 
      [Country] Varchar(100), 
    ) 
    GO 
    
    Insert into Employee ([FirstName], [LastName], [Country] ) values
    ('Raj','Gupta','India'),
    ('Raj','Gupta','India'),
    ('Mohan','Kumar','USA'),
    ('James','Barry','UK'),
    ('James','Barry','UK'),
    ('James','Barry','UK')
```

<details><summary><b>Answer</b></summary>

```sql
-- SQL delete duplicate Rows using Group By and having clause
SELECT [FirstName], 
    [LastName], 
    [Country], 
    COUNT(*) AS CNT
FROM [SampleDB].[dbo].[Employee]
GROUP BY [FirstName], 
      [LastName], 
      [Country]
HAVING COUNT(*) > 1;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. Write a SQL query to find the 3th highest salary from employee table?

```js
Input: 100, 90, 90, 80, 80, 75
Output: 80
```

<details><summary><b>Answer</b></summary>

```sql
-- Method 1: OFFSET-FETCH (SQL Server 2012+) — clean and index-friendly
SELECT DISTINCT Salary
FROM Employee
ORDER BY Salary DESC
OFFSET 2 ROWS          -- skip the top 2 (offset = N-1 for Nth highest)
FETCH NEXT 1 ROWS ONLY;

-- Method 2: Subquery with TOP
SELECT TOP 1 Salary
FROM (
    SELECT DISTINCT TOP 3 Salary
    FROM Employee
    ORDER BY Salary DESC
) AS Top3
ORDER BY Salary ASC;

-- Method 3: DENSE_RANK window function (handles ties correctly)
SELECT Salary
FROM (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employee
) AS Ranked
WHERE SalaryRank = 3;
```

**&#9885; [Try this example on DB Fiddle](https://www.db-fiddle.com/f/kypbSttwBuXHzC7AFEfmMJ/1)**

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. SQL queries

```sql
-- 2> Write a SQL query to find top n records?
-- Example: finding top 5 records from employee table
SELECT TOP 5 * FROM employee ORDER BY salary DESC;

-- 3> Write a SQL query to find the count of employees working in department 'Admin'
SELECT COUNT(*) FROM employee WHERE department = 'Admin';

-- 4> Write a SQL query to fetch department wise count employees sorted by department count in desc order.
SELECT department, COUNT(*) AS employeecount
FROM employee
GROUP BY department
ORDER BY employeecount DESC;

-- 5> Write a query to fetch only the first name (string before first space) from the FullName column of user_name table.
-- CHARINDEX finds the position of the space; SUBSTRING extracts up to that point
SELECT DISTINCT
    SUBSTRING(full_names, 1, CHARINDEX(' ', full_names + ' ') - 1) AS first_name
FROM user_name;

-- 6> Write a SQL query to find all the employees from employee table who are also managers
SELECT e1.first_name, e1.last_name
FROM employee e1
JOIN employee e2 ON e1.employee_id = e2.manager_id;

-- 7> Write a SQL query to find all employees who have bonus record in bonus table
-- Using EXISTS (preferred: short-circuits on first match; safe with NULLs)
SELECT e.*
FROM employee e
WHERE EXISTS (
    SELECT 1 FROM bonus b WHERE b.employee_ref_id = e.employee_id
);
-- Alternative: LEFT JOIN
SELECT e.*
FROM employee e
JOIN bonus b ON e.employee_id = b.employee_ref_id;

-- 8> Write a SQL query to find only odd rows from employee table
SELECT * FROM employee WHERE employee_id % 2 <> 0;

-- 9> Write a SQL query to fetch first_name from employee table in upper case
SELECT UPPER(first_name) AS First_Name FROM employee;

-- 10> Write a SQL query to get combined name (first name and last name) of employees
SELECT CONCAT(first_name, ' ', last_name) AS Name FROM employee;
-- Alternative using + operator (MSSQL also supports this for strings):
SELECT first_name + ' ' + last_name AS Name FROM employee;

-- 11> Write a SQL query to print details of employees named 'Jennifer' and 'James'.
SELECT * FROM employee WHERE first_name IN ('Jennifer', 'James');

-- 12> Write a SQL query to fetch records of employees whose salary lies between 100000 and 500000
SELECT first_name, last_name, salary
FROM employee
WHERE salary BETWEEN 100000 AND 500000;

-- 13> Write a SQL query to get records of employees who joined in Jan 2017
-- Sargable range predicate (allows index seek on joining_date):
SELECT first_name, last_name, joining_date
FROM employee
WHERE joining_date >= '2017-01-01' AND joining_date < '2017-02-01';

-- 14> Write a SQL query to get the list of employees with the same salary
SELECT e1.first_name, e1.last_name, e1.salary
FROM employee e1
JOIN employee e2 ON e1.salary = e2.salary AND e1.employee_id <> e2.employee_id;

-- 15> Write a SQL query to show all departments along with the number of people working there.
SELECT department, COUNT(*) AS [Number of employees]
FROM employee
GROUP BY department
ORDER BY COUNT(*) DESC;

-- 16> Write a SQL query to show the last record from a table.
SELECT * FROM employee WHERE employee_id = (SELECT MAX(employee_id) FROM employee);

-- 17> Write a SQL query to show the first record from a table.
SELECT * FROM employee WHERE employee_id = (SELECT MIN(employee_id) FROM employee);

-- 18> Write a SQL query to get last five records from an employee table (in natural order).
SELECT * FROM (
    SELECT TOP 5 * FROM employee ORDER BY employee_id DESC
) AS Last5
ORDER BY employee_id ASC;

-- 19> Write a SQL query to find employees having the highest salary in each department.
SELECT first_name, last_name, department, MAX(salary) AS [Max Salary]
FROM employee
GROUP BY department, first_name, last_name
ORDER BY MAX(salary) DESC;

-- Alternative using window function (returns all columns of top earner per dept):
WITH DeptMax AS (
    SELECT *, RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employee
)
SELECT first_name, last_name, department, salary AS [Max Salary]
FROM DeptMax WHERE rnk = 1;

-- 20> Write a SQL query to fetch three max salaries from employee table.
SELECT DISTINCT TOP 3 salary FROM employee ORDER BY salary DESC;
-- OR using DENSE_RANK:
WITH RankedSalaries AS (
    SELECT DISTINCT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employee
)
SELECT salary FROM RankedSalaries WHERE rnk <= 3;

-- 21> Write a SQL query to fetch departments along with the total salaries paid for each.
SELECT department, SUM(salary) AS [Total Salary]
FROM employee
GROUP BY department
ORDER BY SUM(salary);

-- 22> Write a SQL query to find the employee with the highest salary.
SELECT first_name, last_name
FROM employee
WHERE salary = (SELECT MAX(salary) FROM employee);

-- 23> Write an SQL query that makes recommendations using pages that friends liked.
-- (Assume: friends(user_id, friend_id), page_likes(user_id, page_id))
-- Return pages liked by friends but not already liked by the user (user_id = 1).
SELECT DISTINCT fl.page_id
FROM friends f
JOIN page_likes fl ON f.friend_id = fl.user_id
WHERE f.user_id = 1
  AND fl.page_id NOT IN (
      SELECT page_id FROM page_likes WHERE user_id = 1
  );

-- 24> Write a SQL query to find the employee (first name, last name, department and bonus) with highest bonus.
SELECT TOP 1 e.first_name, e.last_name, e.department, b.bonus_amount
FROM employee e
JOIN bonus b ON e.employee_id = b.employee_ref_id
ORDER BY b.bonus_amount DESC;

-- 25> Write a SQL query to find employees with the same salary
SELECT e1.first_name, e1.last_name, e1.salary
FROM employee e1
JOIN employee e2 ON e1.salary = e2.salary AND e1.employee_id <> e2.employee_id;

-- 26> Write SQL to find out what percent of students attend school on their birthday
-- from attendance_events and all_students tables.
SELECT
    ROUND(
        100.0 * COUNT(ae.student_id)
        / (SELECT COUNT(student_id) FROM attendance_events),
        2
    ) AS BirthdayAttendancePct
FROM attendance_events ae
JOIN all_students s ON s.student_id = ae.student_id
WHERE MONTH(ae.date_event) = MONTH(s.date_of_birth)
  AND DAY(ae.date_event)   = DAY(s.date_of_birth);

-- 27> Given timestamps of logins, count how many users were active on all 7 days of a week.
-- Users active on consecutive days: find pairs where login_time is exactly 1 day apart.
SELECT a.login_time, COUNT(DISTINCT a.user_id) AS ActiveUsers
FROM login_info a
JOIN login_info b ON a.user_id = b.user_id
WHERE b.login_time = DATEADD(DAY, 1, a.login_time)   -- DATEADD replaces MySQL INTERVAL
GROUP BY a.login_time;

-- 28> Find the overall friend acceptance rate for a given date from user_action table.
SELECT
    ROUND(
        1.0 * (
            SELECT COUNT(*) FROM (SELECT DISTINCT acceptor_id, requestor_id FROM request_accepted) a
        ) /
        NULLIF((
            SELECT COUNT(*) FROM (SELECT DISTINCT requestor_id, sent_to_id FROM friend_request) b
        ), 0),
        2
    ) AS AcceptanceRate;

-- 29> How many total users follow sport accounts?
SELECT COUNT(DISTINCT fr.follower_id) AS count_all_sports_followers
FROM sport_accounts sa
JOIN all_users u  ON sa.sport_player_id = u.user_id
JOIN follow_relation fr ON u.user_id    = fr.target_id;

-- 30> How many active users follow each type of sport?
SELECT sa.sport_category, COUNT(u.user_id) AS ActiveFollowers
FROM all_users u
JOIN sport_accounts sa   ON u.user_id = sa.sport_player_id
JOIN follow_relation fr  ON u.user_id = fr.follower_id
WHERE u.active_last_month = 1
GROUP BY sa.sport_category;

-- 31> What percent of active accounts are fraud from ad_accounts table?
SELECT
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN a.account_status = 'fraud'  THEN a.account_id END)
              / NULLIF(COUNT(DISTINCT CASE WHEN a.account_status = 'active' THEN a.account_id END), 0),
        2
    ) AS FraudPct
FROM ad_accounts a;

-- 32> How many accounts became fraud today for the first time from ad_accounts table?
SELECT COUNT(account_id) AS [First time fraud accounts]
FROM (
    SELECT a.account_id, COUNT(a.account_status) AS status_count
    FROM ad_accounts a
    JOIN ad_accounts b ON a.account_id = b.account_id
    WHERE CAST(b.[date] AS DATE) = CAST(GETDATE() AS DATE)   -- CURDATE() → CAST(GETDATE() AS DATE)
      AND a.account_status = 'fraud'
    GROUP BY a.account_id
    HAVING COUNT(a.account_status) = 1
) AS ad_accnt;

-- 33> Determine avg time spent per user per day from event_session_details.
SELECT [date], user_id,
    AVG(timespend_sec) AS [avg time spent per user per day]
FROM event_session_details
GROUP BY [date], user_id
ORDER BY [date];

-- 34> Find top 10 users that sent the most messages from messages_detail table.
SELECT TOP 10 user_id, messages_sent
FROM messages_detail
ORDER BY messages_sent DESC;

-- 35> Find distinct first names from full user names in user_name table.
-- CHARINDEX finds the space; SUBSTRING extracts everything before it.
SELECT DISTINCT
    SUBSTRING(full_names, 1, CHARINDEX(' ', full_names + ' ') - 1) AS first_name
FROM user_name;

-- 36> Calculate click-through rate (clicks / impressions) per app from dialoglog table.
SELECT
    app_id,
    ISNULL(
        1.0 * SUM(CASE WHEN type = 'click'      THEN 1 ELSE 0 END)
            / NULLIF(SUM(CASE WHEN type = 'impression' THEN 1 ELSE 0 END), 0),
        0
    ) AS [CTR(click through rate)]
FROM dialoglog
GROUP BY app_id;

-- 37> Find the overall acceptance rate of friend requests.
-- (total acceptances / total requests), rounded to 2 decimal places.
SELECT
    ISNULL(
        ROUND(
            1.0 * (SELECT COUNT(*) FROM (SELECT DISTINCT acceptor_id, requestor_id FROM request_accepted) a)
                / NULLIF((SELECT COUNT(*) FROM (SELECT DISTINCT requestor_id, sent_to_id FROM friend_request) b), 0),
            2
        ),
        0
    ) AS AcceptanceRate;

-- 38> From new_request_accepted, find the user with the most friends.
SELECT TOP 1 id
FROM (
    SELECT requestor_id AS id FROM new_request_accepted
    UNION ALL
    SELECT acceptor_id  AS id FROM new_request_accepted
) AS combined
GROUP BY id
ORDER BY COUNT(*) DESC;

-- 39> From count_request, find total requests sent and total failed per country.
SELECT
    country_code,
    Total_request_sent,
    Total_percent_of_request_sent_failed,
    CAST(
        (Total_request_sent * Total_percent_of_request_sent_failed) / 100.0
    AS DECIMAL(18,2)) AS Total_request_sent_failed
FROM (
    SELECT
        country_code,
        SUM(count_of_requests_sent) AS Total_request_sent,
        ISNULL(
            CAST(REPLACE(CAST(SUM(percent_of_request_sent_failed) AS NVARCHAR), '%', '') AS DECIMAL(5,1)),
            0
        ) AS Total_percent_of_request_sent_failed
    FROM count_request
    GROUP BY country_code
) AS Table1;

-- 40> Create a histogram of duration (x-axis = bucket, y-axis = distinct user count).
SELECT
    (timespend_sec / 500) * 500 AS bucket,   -- integer division buckets of 500 sec
    COUNT(DISTINCT user_id)     AS count_of_users
FROM event_session_details
GROUP BY (timespend_sec / 500) * 500
ORDER BY bucket;

-- 41> Calculate percentage of confirmed messages.
SELECT ROUND(
    100.0 * COUNT(cn.phone_number) / NULLIF(COUNT(cfn.phone_number), 0),
    2
) AS ConfirmedPct
FROM confirmation_no cfn
LEFT JOIN confirmed_no cn ON cn.phone_number = cfn.phone_number;

-- 42> Find users with 4 or more interactions on 2013-03-23 from user_interaction table.
SELECT table1.user_id, SUM(number_of_interactions) AS Number_of_interactions
FROM (
    SELECT user_1 AS user_id, COUNT(user_1) AS number_of_interactions
    FROM user_interaction
    GROUP BY user_1
    UNION ALL
    SELECT user_2 AS user_id, COUNT(user_2) AS number_of_interactions
    FROM user_interaction
    GROUP BY user_2
) AS table1
GROUP BY table1.user_id
HAVING SUM(number_of_interactions) >= 4;

-- 43> Find the names of all salespersons that have an order with Samsonic.
SELECT s.name
FROM salesperson s
JOIN orders o   ON s.id   = o.salesperson_id
JOIN customer c ON o.cust_id = c.id
WHERE c.name = 'Samsonic';

-- 44> Find the names of all salespersons that do NOT have any order with Samsonic.
SELECT s.Name
FROM Salesperson s
WHERE s.ID NOT IN (
    SELECT o.salesperson_id
    FROM Orders o
    JOIN Customer c ON o.cust_id = c.ID
    WHERE c.Name = 'Samsonic'
);

-- 45> Find salespeople that have 2 or more orders.
SELECT s.name AS salesperson, COUNT(o.number) AS [number of orders]
FROM salesperson s
JOIN orders o ON s.id = o.salesperson_id
GROUP BY s.name
HAVING COUNT(o.number) >= 2;

-- 46> Return name, phone number and most recent login date for users active in the last 30 days.
SELECT u.name, u.phone_num, MAX(uh.[date]) AS MostRecentLogin
FROM [User] u
JOIN UserHistory uh ON u.user_id = uh.user_id
WHERE uh.action = 'logged_on'
  AND uh.[date] >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))  -- replaces DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY u.name, u.phone_num;

-- 47> Find user_ids in User table that are not in UserHistory table.
SELECT u.user_id
FROM [User] u
LEFT JOIN UserHistory uh ON u.user_id = uh.user_id
WHERE uh.user_id IS NULL;

-- 48> Return the maximum value from a table without using MAX or MIN.
SELECT TOP 1 numbers
FROM compare
ORDER BY numbers DESC;

-- 49> Find how many users inserted more than 1000 but less than 2000 images in their presentations.
SELECT COUNT(*) AS UserCount
FROM (
    SELECT user_id, COUNT(event_date_time) AS image_per_user
    FROM event_log
    GROUP BY user_id
) AS image_counts
WHERE image_per_user > 1000 AND image_per_user < 2000;

-- 50> Select the most recent login time per user from login_info table.
SELECT *
FROM login_info
WHERE login_time IN (
    SELECT MAX(login_time)
    FROM login_info
    GROUP BY user_id
)
ORDER BY login_time DESC;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. Count the Employees

The data for the number employed at several famous IT companies is maintained in the COMPANY table. Write a query to print the IDs of the companies that have more than 10000 employees, in ascending order of ID.

**Input Format:**

| Name    | Type    | Description |
|---------|---------|-------------|
|  ID     | Integer | A company ID in the inclusive range, [1, 1000]. This is the primary key.|
|  NAME   | String  | A company name. This field contains between 1 and 100 characters (inclusive).|
|EMPLOYEES| Integer | The total number of employees in the company. |

**Output Format:**

The result should contain the IDs of all the companies that have more than 10000 employees, in scending order in the following format:

```sql
COMPANY.ID
```

**Sample Input:**

| ID | NAME       |EMPLOYEES|
|----|------------|-------|
| 1  | Adobe      | 28085 |
| 2  | Flipkart   | 35543 |
| 3  | Amazon     | 1089  |
| 4  | Paytm      | 9982  |
| 5  | BookMyShow | 5589  |
| 6  | Oracle     | 4003  |
| 7  | NIIT       | 57782 |
| 8  | Samsung    | 2000  |
| 9  | TCS        | 10046 |
| 10 | Wipro      | 3500  |

**Sample Output:**

```js
1
2
7
9
```

**Explanation:**

Adobe, Filpkart, NIIT and TCS have greater then 10000 employees, so their IDs are printed.

<details><summary><b>Answer</b></summary>

```sql
SELECT ID
FROM COMPANY
WHERE EMPLOYEES > 10000
ORDER BY ID ASC;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to delete duplicate rows but keep one?

```sql
-- Table has duplicate rows on (FirstName, LastName, Country)
-- Keep only the row with the lowest ID per group
```

<details><summary><b>Answer</b></summary>

```sql
-- Method 1: CTE with ROW_NUMBER (recommended)
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY FirstName, LastName, Country
               ORDER BY ID
           ) AS rn
    FROM Employee
)
DELETE FROM CTE WHERE rn > 1;

-- Method 2: DELETE with a correlated subquery
DELETE FROM Employee
WHERE ID NOT IN (
    SELECT MIN(ID)
    FROM Employee
    GROUP BY FirstName, LastName, Country
);
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the running total of sales by date?

```sql
-- Table: DailySales (SaleDate DATE, Amount DECIMAL(10,2))
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    SaleDate,
    Amount,
    SUM(Amount) OVER (
        ORDER BY SaleDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM DailySales
ORDER BY SaleDate;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the second highest salary without using TOP or LIMIT?

<details><summary><b>Answer</b></summary>

```sql
-- Using DENSE_RANK (handles ties; most robust approach)
SELECT DISTINCT Salary
FROM (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM Employee
) AS Ranked
WHERE rnk = 2;

-- Using a correlated subquery
SELECT MAX(Salary) AS SecondHighest
FROM Employee
WHERE Salary < (SELECT MAX(Salary) FROM Employee);
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to pivot monthly sales into columns?

```sql
-- Table: MonthlySales (SalesYear INT, Quarter NVARCHAR(5), Revenue DECIMAL(10,2))
-- Output: one row per year with columns Q1, Q2, Q3, Q4
```

<details><summary><b>Answer</b></summary>

```sql
SELECT *
FROM (
    SELECT SalesYear, Quarter, Revenue
    FROM MonthlySales
) AS src
PIVOT (
    SUM(Revenue)
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS pvt
ORDER BY SalesYear;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find all employees who earn more than the average salary of their department?

<details><summary><b>Answer</b></summary>

```sql
-- Method 1: Window function (single scan — most efficient)
SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM (
    SELECT *,
           AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary
    FROM Employee
) AS e
WHERE Salary > DeptAvgSalary
ORDER BY Department, Salary DESC;

-- Method 2: Correlated subquery
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Department, e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE Department = e.Department
)
ORDER BY e.Department;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find gaps in a sequence of IDs?

```sql
-- Table: Orders (OrderID INT PRIMARY KEY)
-- Find missing OrderIDs in the sequence
```

<details><summary><b>Answer</b></summary>

```sql
-- Method 1: LAG to detect jumps
SELECT
    prev_id + 1  AS GapStart,
    curr_id - 1  AS GapEnd
FROM (
    SELECT
        OrderID                                    AS curr_id,
        LAG(OrderID, 1, 0) OVER (ORDER BY OrderID) AS prev_id
    FROM Orders
) AS gaps
WHERE curr_id - prev_id > 1;

-- Method 2: Generate all IDs using a tally and find missing ones
WITH Tally AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Tally
    WHERE n < (SELECT MAX(OrderID) FROM Orders)
)
SELECT n AS MissingOrderID
FROM Tally
WHERE n NOT IN (SELECT OrderID FROM Orders)
OPTION (MAXRECURSION 0);
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to get the cumulative percentage contribution of each product to total revenue?

```sql
-- Table: ProductRevenue (ProductName NVARCHAR(100), Revenue DECIMAL(10,2))
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    ProductName,
    Revenue,
    ROUND(100.0 * Revenue / SUM(Revenue) OVER (), 2)                   AS PctOfTotal,
    ROUND(100.0 * SUM(Revenue) OVER (
        ORDER BY Revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) / SUM(Revenue) OVER (), 2)                                        AS CumulativePct
FROM ProductRevenue
ORDER BY Revenue DESC;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to transpose rows to columns without using PIVOT?

```sql
-- Table: Scores (StudentName NVARCHAR(50), Subject NVARCHAR(50), Score INT)
-- Output columns: StudentName, Math, Science, English
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    StudentName,
    MAX(CASE WHEN Subject = 'Math'    THEN Score END) AS Math,
    MAX(CASE WHEN Subject = 'Science' THEN Score END) AS Science,
    MAX(CASE WHEN Subject = 'English' THEN Score END) AS English
FROM Scores
GROUP BY StudentName
ORDER BY StudentName;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the employee who has been with the company the longest but has never received a bonus?

```sql
-- Tables: Employee (EmployeeID, FirstName, LastName, HireDate)
--         Bonus    (BonusID, EmployeeID, BonusAmount, BonusYear)
```

<details><summary><b>Answer</b></summary>

```sql
SELECT TOP 1
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsAtCompany
FROM Employee e
WHERE NOT EXISTS (
    SELECT 1 FROM Bonus b WHERE b.EmployeeID = e.EmployeeID
)
ORDER BY e.HireDate ASC;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find customers who placed orders every month for the last 6 months?

```sql
-- Table: Orders (OrderID, CustomerID, OrderDate DATE, TotalAmount DECIMAL)
```

<details><summary><b>Answer</b></summary>

```sql
DECLARE @MonthsBack INT = 6;
DECLARE @StartDate  DATE = DATEADD(MONTH, -@MonthsBack, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));

SELECT CustomerID
FROM Orders
WHERE OrderDate >= @StartDate
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) = @MonthsBack;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to display the hierarchy of employees using a recursive CTE?

```sql
-- Table: Employee (EmployeeID INT, Name NVARCHAR(100), ManagerID INT NULL)
-- ManagerID is NULL for the top-level CEO
```

<details><summary><b>Answer</b></summary>

```sql
WITH OrgHierarchy AS (
    -- Anchor: top-level employees (no manager)
    SELECT
        EmployeeID,
        Name,
        ManagerID,
        0                         AS Level,
        CAST(Name AS NVARCHAR(MAX)) AS HierarchyPath
    FROM Employee
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive: employees reporting to the previous level
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        h.Level + 1,
        CAST(h.HierarchyPath + ' > ' + e.Name AS NVARCHAR(MAX))
    FROM Employee e
    INNER JOIN OrgHierarchy h ON e.ManagerID = h.EmployeeID
)
SELECT
    REPLICATE('  ', Level) + Name AS OrgChart,
    Level,
    HierarchyPath
FROM OrgHierarchy
ORDER BY HierarchyPath
OPTION (MAXRECURSION 100);
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to calculate a 3-day moving average of daily sales?

```sql
-- Table: DailySales (SaleDate DATE, Revenue DECIMAL(10,2))
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    SaleDate,
    Revenue,
    AVG(Revenue) OVER (
        ORDER BY SaleDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg3Day,
    COUNT(*)     OVER (
        ORDER BY SaleDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS DaysInWindow   -- shows actual days when window is smaller than 3 (start of data)
FROM DailySales
ORDER BY SaleDate;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query using MERGE to upsert product stock levels?

```sql
-- Target: Products    (ProductID, ProductName, Stock)
-- Source: StockUpdate (ProductID, ProductName, NewStock)
-- If product exists → update Stock; if not → insert it
```

<details><summary><b>Answer</b></summary>

```sql
MERGE Products AS tgt
USING StockUpdate AS src
    ON tgt.ProductID = src.ProductID
WHEN MATCHED THEN
    UPDATE SET
        tgt.Stock       = src.NewStock,
        tgt.UpdatedAt   = GETUTCDATE()
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Stock)
    VALUES (src.ProductID, src.ProductName, src.NewStock)
OUTPUT
    $action             AS MergeAction,
    inserted.ProductID  AS ProductID,
    inserted.Stock      AS NewStock,
    deleted.Stock       AS OldStock;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find pairs of employees in the same department with a salary difference of less than 5000?

<details><summary><b>Answer</b></summary>

```sql
SELECT
    e1.EmployeeID  AS Emp1ID,
    e1.FirstName   AS Emp1Name,
    e2.EmployeeID  AS Emp2ID,
    e2.FirstName   AS Emp2Name,
    e1.Department,
    ABS(e1.Salary - e2.Salary) AS SalaryDiff
FROM Employee e1
JOIN Employee e2
    ON  e1.Department = e2.Department
    AND e1.EmployeeID < e2.EmployeeID          -- avoid (A,B) and (B,A) duplicates
    AND ABS(e1.Salary - e2.Salary) < 5000
ORDER BY e1.Department, SalaryDiff;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the top 3 products by revenue in each category?

```sql
-- Table: Sales (SaleID, CategoryID, ProductName, Revenue DECIMAL(10,2))
```

<details><summary><b>Answer</b></summary>

```sql
WITH RankedProducts AS (
    SELECT
        CategoryID,
        ProductName,
        SUM(Revenue) AS TotalRevenue,
        DENSE_RANK() OVER (
            PARTITION BY CategoryID
            ORDER BY SUM(Revenue) DESC
        ) AS RevenueRank
    FROM Sales
    GROUP BY CategoryID, ProductName
)
SELECT CategoryID, ProductName, TotalRevenue, RevenueRank
FROM RankedProducts
WHERE RevenueRank <= 3
ORDER BY CategoryID, RevenueRank;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to identify sessions where a user was inactive for more than 30 minutes between page views?

```sql
-- Table: PageViews (UserID INT, PageViewTime DATETIME)
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    UserID,
    PrevViewTime            AS SessionEnd,
    PageViewTime            AS NewSessionStart,
    DATEDIFF(MINUTE, PrevViewTime, PageViewTime) AS InactiveMinutes
FROM (
    SELECT
        UserID,
        PageViewTime,
        LAG(PageViewTime) OVER (PARTITION BY UserID ORDER BY PageViewTime) AS PrevViewTime
    FROM PageViews
) AS gaps
WHERE DATEDIFF(MINUTE, PrevViewTime, PageViewTime) > 30
ORDER BY UserID, NewSessionStart;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to parse a JSON column and return its values as relational columns?

```sql
-- Table: Events (EventID INT, Payload NVARCHAR(MAX))
-- Payload sample: {"user":"Alice","action":"login","ip":"10.0.0.1"}
```

<details><summary><b>Answer</b></summary>

```sql
-- Method 1: JSON_VALUE (scalar extraction)
SELECT
    EventID,
    JSON_VALUE(Payload, '$.user')   AS UserName,
    JSON_VALUE(Payload, '$.action') AS Action,
    JSON_VALUE(Payload, '$.ip')     AS IPAddress
FROM Events
WHERE ISJSON(Payload) = 1;

-- Method 2: OPENJSON with explicit schema (batch shredding)
SELECT e.EventID, j.UserName, j.Action, j.IPAddress
FROM Events e
CROSS APPLY OPENJSON(e.Payload)
WITH (
    UserName  NVARCHAR(100) '$.user',
    Action    NVARCHAR(50)  '$.action',
    IPAddress NVARCHAR(50)  '$.ip'
) AS j
WHERE ISJSON(e.Payload) = 1;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the longest consecutive sequence of days a user logged in?

```sql
-- Table: UserLogins (UserID INT, LoginDate DATE)
-- Each row represents one login; assume one row per user per day (no duplicates)
```

<details><summary><b>Answer</b></summary>

```sql
WITH Groups AS (
    -- Subtract a sequential row number from the date to get a 'group' constant
    -- for consecutive dates (the difference stays the same for a run)
    SELECT
        UserID,
        LoginDate,
        DATEADD(
            DAY,
            -ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY LoginDate),
            LoginDate
        ) AS grp
    FROM UserLogins
),
Streaks AS (
    SELECT
        UserID,
        MIN(LoginDate) AS StreakStart,
        MAX(LoginDate) AS StreakEnd,
        COUNT(*)       AS ConsecutiveDays
    FROM Groups
    GROUP BY UserID, grp
)
SELECT TOP 1 WITH TIES
    UserID,
    StreakStart,
    StreakEnd,
    ConsecutiveDays
FROM Streaks
ORDER BY ConsecutiveDays DESC;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find customers who have not placed any order in the last 90 days but had placed orders before that?

```sql
-- Table: Orders (OrderID, CustomerID, OrderDate DATE)
```

<details><summary><b>Answer</b></summary>

```sql
DECLARE @Cutoff DATE = DATEADD(DAY, -90, CAST(GETDATE() AS DATE));

SELECT DISTINCT CustomerID
FROM Orders
WHERE CustomerID NOT IN (
    -- customers who have a recent order
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE OrderDate >= @Cutoff
)
  AND CustomerID IN (
    -- customers who had at least one order before the cutoff
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE OrderDate < @Cutoff
);
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to implement a CASE-based grade classification on exam scores?

```sql
-- Table: ExamResults (StudentID INT, StudentName NVARCHAR(100), Score INT)
-- Grade: A ≥ 90 | B ≥ 80 | C ≥ 70 | D ≥ 60 | F < 60
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    StudentID,
    StudentName,
    Score,
    CASE
        WHEN Score >= 90 THEN 'A'
        WHEN Score >= 80 THEN 'B'
        WHEN Score >= 70 THEN 'C'
        WHEN Score >= 60 THEN 'D'
        ELSE                  'F'
    END AS Grade,
    CASE
        WHEN Score >= 60 THEN 'Pass'
        ELSE                  'Fail'
    END AS Result
FROM ExamResults
ORDER BY Score DESC;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to implement pagination (page 3, 10 rows per page) on a Products table sorted by ProductName?

<details><summary><b>Answer</b></summary>

```sql
DECLARE @PageNumber INT = 3;
DECLARE @PageSize   INT = 10;

SELECT
    ProductID,
    ProductName,
    Price
FROM Products
ORDER BY ProductName ASC
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;
-- Page 3: OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the department with the highest total salary bill, and list all employees in that department?

<details><summary><b>Answer</b></summary>

```sql
WITH DeptTotals AS (
    SELECT Department, SUM(Salary) AS TotalSalary
    FROM Employee
    GROUP BY Department
),
TopDept AS (
    SELECT TOP 1 Department
    FROM DeptTotals
    ORDER BY TotalSalary DESC
)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, e.Department
FROM Employee e
WHERE e.Department = (SELECT Department FROM TopDept)
ORDER BY e.Salary DESC;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to detect duplicate email addresses in a Customers table and list the duplicates with their counts?

```sql
-- Table: Customers (CustomerID INT, Name NVARCHAR(100), Email NVARCHAR(200))
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    Email,
    COUNT(*) AS DuplicateCount,
    STRING_AGG(CAST(CustomerID AS NVARCHAR), ', ')
        WITHIN GROUP (ORDER BY CustomerID) AS CustomerIDs
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the employee with the highest salary in each department using only a subquery (no window functions)?

<details><summary><b>Answer</b></summary>

```sql
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Department, e.Salary
FROM Employee e
WHERE e.Salary = (
    SELECT MAX(Salary)
    FROM Employee
    WHERE Department = e.Department
)
ORDER BY e.Department;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to calculate year-over-year revenue growth percentage by product category?

```sql
-- Table: CategoryRevenue (Category NVARCHAR(50), RevenueYear INT, Revenue DECIMAL(12,2))
```

<details><summary><b>Answer</b></summary>

```sql
SELECT
    Category,
    RevenueYear,
    Revenue,
    LAG(Revenue) OVER (PARTITION BY Category ORDER BY RevenueYear) AS PrevYearRevenue,
    ROUND(
        100.0 * (Revenue - LAG(Revenue) OVER (PARTITION BY Category ORDER BY RevenueYear))
              / NULLIF(LAG(Revenue) OVER (PARTITION BY Category ORDER BY RevenueYear), 0),
        2
    ) AS YoY_GrowthPct
FROM CategoryRevenue
ORDER BY Category, RevenueYear;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find all products that have never been sold?

```sql
-- Tables: Products (ProductID, ProductName)
--         OrderItems (OrderItemID, OrderID, ProductID, Quantity)
```

<details><summary><b>Answer</b></summary>

```sql
-- Method 1: NOT EXISTS (safest — handles NULLs correctly)
SELECT p.ProductID, p.ProductName
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM OrderItems oi WHERE oi.ProductID = p.ProductID
);

-- Method 2: LEFT JOIN with NULL check
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN OrderItems oi ON p.ProductID = oi.ProductID
WHERE oi.ProductID IS NULL;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a stored procedure that accepts a department name and returns the average, min, and max salary for that department?

<details><summary><b>Answer</b></summary>

```sql
CREATE PROCEDURE usp_GetDeptSalaryStats
    @Department NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Employee WHERE Department = @Department)
    BEGIN
        THROW 50001, 'Department not found.', 1;
    END;

    SELECT
        @Department                 AS Department,
        COUNT(*)                    AS EmployeeCount,
        AVG(Salary)                 AS AvgSalary,
        MIN(Salary)                 AS MinSalary,
        MAX(Salary)                 AS MaxSalary,
        STDEV(Salary)               AS StdDevSalary
    FROM Employee
    WHERE Department = @Department;
END;
GO

-- Execute
EXEC usp_GetDeptSalaryStats @Department = 'Engineering';
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to find the median salary from the Employee table?

<details><summary><b>Answer</b></summary>

```sql
-- SQL Server does not have a built-in MEDIAN function.
-- Use PERCENTILE_CONT (SQL Server 2012+) — exact interpolated median
SELECT DISTINCT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
        OVER () AS MedianSalary
FROM Employee;

-- Alternative: manual calculation using OFFSET-FETCH
DECLARE @Count INT = (SELECT COUNT(*) FROM Employee);

SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS MedianSalary
FROM (
    SELECT Salary
    FROM Employee
    ORDER BY Salary
    OFFSET (@Count - 1) / 2 ROWS
    FETCH NEXT 1 + (1 - @Count % 2) ROWS ONLY
) AS MedianRows;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to show the difference between each employee\'s salary and the average salary of their department, ranked within the department?

<details><summary><b>Answer</b></summary>

```sql
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    ROUND(AVG(Salary) OVER (PARTITION BY Department), 2)  AS DeptAvgSalary,
    ROUND(Salary - AVG(Salary) OVER (PARTITION BY Department), 2) AS DiffFromAvg,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRankInDept
FROM Employee
ORDER BY Department, SalaryRankInDept;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>



## Q. Write a SQL query to convert a comma-separated list of product IDs (stored in a column) into rows using STRING_SPLIT?

```sql
-- Table: Orders (OrderID INT, ProductList NVARCHAR(MAX))
-- ProductList sample: '101,205,302'
```

<details><summary><b>Answer</b></summary>

```sql
-- STRING_SPLIT (SQL Server 2016+)
SELECT
    o.OrderID,
    CAST(TRIM(s.value) AS INT) AS ProductID
FROM Orders o
CROSS APPLY STRING_SPLIT(o.ProductList, ',') s
WHERE ISNUMERIC(TRIM(s.value)) = 1
ORDER BY o.OrderID, ProductID;

-- Join back to Products for full details
SELECT
    o.OrderID,
    p.ProductID,
    p.ProductName,
    p.Price
FROM Orders o
CROSS APPLY STRING_SPLIT(o.ProductList, ',') s
JOIN Products p ON p.ProductID = CAST(TRIM(s.value) AS INT)
ORDER BY o.OrderID, p.ProductID;
```

</details>

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>
