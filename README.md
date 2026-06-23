# 🏦 Banking Management System
### Database Management System (DBMS) | SQL Server (T-SQL)

A fully designed and implemented relational database for a multi-branch banking system, built as a DBMS semester project at **Bahria University, Islamabad**. The project covers the complete database development lifecycle — from logical schema design and physical DDL construction to data population and analytical SQL queries.



## 📌 System Overview

The database models a real-world banking environment with 10 interconnected tables covering customers, employees, branches, accounts (savings & current), loans, transactions, and ATMs — all spread across Pakistani cities including Islamabad, Lahore, Karachi, Rawalpindi, and Peshawar.


## 🗂️ Database Schema

| Table | Description |
|---|---|
| `Customer` | Stores customer personal details with CNIC validation |
| `Branch` | Bank branches across Pakistan with manager linkage |
| `Employee` | Staff records including Branch Managers, Loan Officers, and Tellers |
| `Account` | Supertype table for all accounts (Savings / Current) |
| `SavingsAccount` | Subtype — stores interest rate per savings account |
| `CurrentAccount` | Subtype — stores overdraft limit per current account |
| `Loan` | Personal, Home, Car, and Business loans with approval tracking |
| `Transaction` | Deposits, Withdrawals, and Transfers with status tracking |
| `ATM` | ATM locations linked to branches with cash availability |

### Supertype / Subtype Mapping
Account serves as the supertype with `AccountType` differentiating Savings vs Current. `SavingsAccount` and `CurrentAccount` each share `AccountID` as both a Primary Key and Foreign Key back to `Account`, implementing the Table-Per-Type (TPT) inheritance pattern.



## 🛠️ Technical Highlights

- **Database**: Microsoft SQL Server (T-SQL / MSSQL)
- **DDL Constraints**: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`
- **CNIC Validation**: Pattern enforced via `CHECK (CNIC LIKE '[0-9][0-9][0-9][0-9][0-9]-...-[0-9]')`
- **Computed Column**: `OutstandingBalance` in `Loan` defined as a computed column (`AS ApprovedAmount`)
- **Circular FK Resolution**: `Branch.ManagerID → Employee` added via `ALTER TABLE` after Employee creation to resolve the circular dependency
- **Referential Integrity**: All cross-table relationships enforced via foreign keys
- **Aggregate Queries**: `GROUP BY`, `HAVING`, `SUM`, `COUNT` across multi-table JOINs
- **Relational Algebra**: All queries expressed formally with σ, π, γ, and ⨝ operators


## 📁 Project Structure

```
├── Banking System.sql          # Full SQL script (DDL + DML + Queries)
└── Banking Management System.pdf  # Project report with schema, screenshots & relational algebra
```



## ⚙️ How to Run

### Prerequisites
- Microsoft SQL Server (2017 or later) or SQL Server Express
- SQL Server Management Studio (SSMS)

### Steps

1. Clone this repository
2. Open **SQL Server Management Studio (SSMS)**.
3. Connect to your SQL Server instance.
4. Open `Banking System.sql`.
5. Create a new database and select it:
   ```sql
   CREATE DATABASE BankingDB;
   USE BankingDB;
   ```
6. Execute the full script — tables will be created, populated, and queries will run.


## 🔍 Sample Analytical Queries

### Query 1 — Transaction Summary per Customer
```sql
SELECT C.FirstName, C.LastName, T.Type, SUM(T.Amount) AS TotalAmount
FROM Customer C
INNER JOIN Account A ON C.CustomerID = A.CustomerID
INNER JOIN [Transaction] T ON A.AccountID = T.AccountID
GROUP BY C.FirstName, C.LastName, T.Type;
```

### Query 2 — Total Account Balance by City
```sql
SELECT C.City, SUM(A.Balance) AS TotalBalance
FROM Customer C
INNER JOIN Account A ON C.CustomerID = A.CustomerID
GROUP BY C.City;
```

### Query 3 — High-Value Loan Branches (>PKR 1,000,000 approved)
```sql
SELECT B.BranchName, B.City, COUNT(L.LoanID) AS LoanCount, SUM(L.ApprovedAmount) AS TotalApproved
FROM Loan L
INNER JOIN Employee E ON L.ApprovedByEmpID = E.EmployeeID
INNER JOIN Branch B ON E.BranchID = B.BranchID
WHERE L.LoanStatus = 'Approved'
GROUP BY B.BranchName, B.City
HAVING SUM(L.ApprovedAmount) > 1000000;
```

---

## 📊 Sample Data Highlights

- **10 Branches** across Islamabad, Lahore, Karachi, Rawalpindi, Peshawar
- **12 Employees** — Branch Managers, Loan Officers, Tellers
- **12 Customers** with valid CNICs and addresses
- **12 Accounts** — 7 Savings (interest rates 6%–7.5%), 5 Current (overdraft limits up to PKR 200,000)
- **12 Loans** — Personal, Home, Car, Business (PKR 200,000 – PKR 5,000,000)
- **15 Transactions** — Deposits, Withdrawals, Transfers (Jan 2024)
- **12 ATMs** — Active, Under Maintenance, and Offline statuses


## 👩‍💻 Author

**Aroona Noor** 
