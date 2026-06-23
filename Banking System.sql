-- Customer
CREATE TABLE Customer(
CustomerID INT PRIMARY KEY IDENTITY(1,1),
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
CNIC CHAR(15) NOT NULL UNIQUE
CHECK (CNIC LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'),
ContactNo VARCHAR(20) NOT NULL,
HouseNo VARCHAR(20) NULL,
Street VARCHAR(80) NULL,
City VARCHAR(80) NOT NULL,
PostalCode VARCHAR(10) NULL,
DateOfBirth DATE NOT NULL,
RegistrationDate DATE NOT NULL DEFAULT GETDATE()
);


--Branch
CREATE TABLE Branch(
BranchID INT PRIMARY KEY IDENTITY(1,1),
BranchName VARCHAR(100) NOT NULL,
City VARCHAR(80) NOT NULL,
PostalCode VARCHAR(10) NOT NULL,
ContactNo VARCHAR(20) NOT NULL UNIQUE,
ManagerID INT NULL  
);

--Employee
CREATE TABLE Employee(
EmployeeID INT PRIMARY KEY IDENTITY(1,1),
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Designation VARCHAR(60) NOT NULL,
Salary DECIMAL(12,2) NOT NULL CHECK (Salary > 0),
Phone VARCHAR(20) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
JoiningDate DATE NOT NULL,
BranchID INT NOT NULL,
FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Adding Constraint
ALTER TABLE Branch
ADD CONSTRAINT FK_Branch_Manager
FOREIGN KEY (ManagerID) REFERENCES Employee(EmployeeID);

-- Account (supertype)
CREATE TABLE Account(
AccountID INT PRIMARY KEY IDENTITY(1,1),
AccountType VARCHAR(10) NOT NULL CHECK (AccountType IN ('Savings','Current')),
Balance DECIMAL(15,2) NOT NULL DEFAULT 0.00
CHECK (Balance >= 0),
Status VARCHAR(10) NOT NULL DEFAULT 'Active'
CHECK (Status IN ('Active','Frozen','Closed')),
OpeningDate DATE NOT NULL DEFAULT GETDATE(),
CustomerID  INT NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

--  Savings Account (subtype)
CREATE TABLE SavingsAccount(
AccountID INT PRIMARY KEY,
InterestRate DECIMAL(5,2) NOT NULL CHECK (InterestRate >= 0),
FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

-- Current Account (subtype)
CREATE TABLE CurrentAccount(
AccountID INT PRIMARY KEY,
OverdraftLimit DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (OverdraftLimit >= 0),
FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);
select *from Loan;
--  Loan
CREATE TABLE Loan(
LoanID INT PRIMARY KEY IDENTITY(1,1),
LoanType VARCHAR(20) NOT NULL
CHECK (LoanType IN ('Personal','Home','Car','Business')),
ApprovedAmount DECIMAL(15,2) NOT NULL CHECK (ApprovedAmount > 0),
InterestRate DECIMAL(5,2) NOT NULL CHECK (InterestRate >= 0),
RepaymentSchedule VARCHAR(20) NOT NULL DEFAULT 'Monthly',
OutstandingBalance AS (ApprovedAmount),        
LoanStatus VARCHAR(10) NOT NULL DEFAULT 'Pending'
CHECK (LoanStatus IN ('Pending','Approved','Closed')),
CustomerID INT NOT NULL,
ApprovedByEmpID INT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (ApprovedByEmpID) REFERENCES Employee(EmployeeID)
);


--Transaction
CREATE TABLE [Transaction](
TransactionID INT PRIMARY KEY IDENTITY(1,1),
Type VARCHAR(15) NOT NULL
CHECK (Type IN ('Deposit','Withdrawal','Transfer')),
Amount DECIMAL(15,2) NOT NULL CHECK (Amount > 0),
Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
Status VARCHAR(10) NOT NULL DEFAULT 'Pending'
CHECK (Status IN ('Completed','Failed','Pending')),
AccountID INT NOT NULL,
ProcessedByEmpID INT NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
FOREIGN KEY (ProcessedByEmpID) REFERENCES Employee(EmployeeID)
);

-- ATM
CREATE TABLE ATM(
ATMID INT PRIMARY KEY IDENTITY(1,1),
Location VARCHAR(150) NOT NULL,
CashAvailability DECIMAL(15,2) NOT NULL CHECK (CashAvailability >= 0),
OperationalStatus VARCHAR(20) NOT NULL DEFAULT 'Active'
CHECK (OperationalStatus IN ('Active','Under Maintenance','Offline')),
BranchID INT NOT NULL,
FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);







-- Branch(without manager)
INSERT INTO Branch (BranchName, City, PostalCode, ContactNo)
VALUES('Blue Area Branch','Islamabad','44000','051-1112222'),
('Saddar Branch','Rawalpindi','46000','051-3334444'),
('Gulberg Branch','Lahore','54000','042-5556666'),
('Clifton Branch','Karachi','75600','021-7778888'),
('Cantt Branch','Peshawar','25000','091-9990000'),
('DHA Phase 1 Branch','Lahore','54792','042-1112233'),
('Johar Town Branch','Lahore','54782','042-4445566'),
('Gulshan Branch','Karachi','75300','021-2223344'),
('Hayatabad Branch','Peshawar','25100','091-5556677'),
('F-7 Markaz Branch','Islamabad','44220','051-7778899');

-- Employee
INSERT INTO Employee (FirstName, LastName, Designation, Salary, Phone, Email, JoiningDate, BranchID)
VALUES
('Amir','Khan','Branch Manager',120000,'0300-1112222','amir.khan@bank.pk','2018-03-15',1),
('Sara','Ahmed','Loan Officer',85000,'0301-2223333','sara.ahmed@bank.pk','2019-07-01',1),
('Bilal','Raza','Branch Manager',115000,'0302-3334444','bilal.raza@bank.pk','2017-11-20',2),
('Nadia','Malik','Teller',55000,'0303-4445555','nadia.malik@bank.pk','2021-01-10',2),
('Usman','Ali','Branch Manager',125000,'0304-5556666','usman.ali@bank.pk','2016-06-05',3),
('Hira','Shah','Loan Officer',88000,'0305-6667777', 'hira.shah@bank.pk','2020-09-15',3),
('Kamran','Siddiqui','Branch Manager',110000,'0306-7778888','kamran.s@bank.pk','2015-04-22',4),
('Zainab','Hassan','Teller',52000,'0307-8889999','zainab.h@bank.pk','2022-03-01',4),
('Tariq','Mahmood','Branch Manager',118000,'0308-9990000','tariq.m@bank.pk','2017-08-18',5),
('Ayesha','Farooq','Loan Officer',82000,'0309-0001111','ayesha.f@bank.pk','2021-11-05',5),
('Imran','Yusuf','Teller',54000,'0310-1112222','imran.y@bank.pk','2020-05-20',6),
('Fatima','Qureshi','Teller',53000,'0311-2223333','fatima.q@bank.pk','2019-12-10',7);

-- Update ManagerID in branch
UPDATE Branch SET ManagerID=1 WHERE BranchID=1;
UPDATE Branch SET ManagerID=3 WHERE BranchID=2;
UPDATE Branch SET ManagerID=5 WHERE BranchID=3;
UPDATE Branch SET ManagerID=7 WHERE BranchID=4;
UPDATE Branch SET ManagerID=9 WHERE BranchID=5;
UPDATE Branch SET ManagerID=1 WHERE BranchID=6;
UPDATE Branch SET ManagerID=3 WHERE BranchID=7;
UPDATE Branch SET ManagerID=5 WHERE BranchID=8;
UPDATE Branch SET ManagerID=7 WHERE BranchID=9;
UPDATE Branch SET ManagerID=9 WHERE BranchID=10;

-- Customer
INSERT INTO Customer (FirstName,LastName,CNIC,ContactNo,HouseNo,Street,City,PostalCode,DateOfBirth)
VALUES
('Ali','Raza','35202-1234567-1','0300-1111111','12','Khayaban-e-Iqbal','Islamabad','44000','1990-05-10'),
('Sana','Malik','35202-2345678-2','0301-2222222','45','Jinnah Avenue','Islamabad','44000','1985-08-22'),
('Hassan','Ahmed','37405-3456789-3','0302-3333333','7', 'Mall Road','Rawalpindi','46000','1992-03-15'),
('Maryam','Khan','35201-4567890-4','0303-4444444','23','Allama Iqbal Rd','Lahore','54000','1988-11-30'),
('Fahad','Siddiqui','21303-5678901-5','0304-5555555','89','Clifton Block 5','Karachi','75600','1995-07-07'),
('Amna','Hussain','17301-6789012-6','0305-6666666','3', 'University Rd','Peshawar','25000','1993-01-25'),
('Umar','Farooq','35202-7890123-7','0306-7777777','56','F-8 Markaz','Islamabad','44220','1987-09-14'),
('Saira','Iqbal','35401-8901234-8','0307-8888888','14','DHA Phase 2','Lahore','54792','1991-04-03'),
('Junaid','Baig','21301-9012345-9','0308-9999999','67','Gulshan Block 9','Karachi','75300','1986-12-20'),
('Rabia','Shah','17302-0123456-0','0309-0000000','9', 'Hayatabad Ph 3','Peshawar','25100','1994-06-18'),
('Zubair','Mirza','35202-1357924-1','0310-1010101','31','G-10/2','Islamabad','44000','1989-02-28'),
('Hina','Javed','35201-2468013-2','0311-2020202','18','Johar Town C-Blk','Lahore','54782','1996-10-05');

-- Account (supertype)
INSERT INTO Account (AccountType, Balance, Status, OpeningDate, CustomerID)
VALUES
('Savings',150000.00,'Active','2020-01-15',1),
('Current',500000.00,'Active','2019-06-01',2),
('Savings',75000.00,'Active','2021-03-20',3),
('Current',250000.00,'Frozen','2018-11-10',4),
('Savings',320000.00,'Active','2022-07-05',5),
('Savings',45000.00,'Active','2020-09-12',6),
('Current',180000.00,'Active','2017-04-28',7),
('Savings',620000.00,'Active','2019-01-30',8),
('Current',95000.00,'Closed','2016-08-15',9),
('Savings',410000.00,'Active','2023-02-14',10),
('Savings',30000.00,'Active','2021-11-07',11),
('Current',780000.00,'Active','2020-05-23',12);

-- SavingsAccount (subtype)
INSERT INTO SavingsAccount (AccountID, InterestRate)
VALUES
(1,7.50),(3,6.00),(5,7.00),(6,6.50),(8,7.25),(10,6.75),(11,6.00);

-- CurrentAccount (subtype)
INSERT INTO CurrentAccount (AccountID, OverdraftLimit)
VALUES
(2,100000.00),(4,50000.00),(7,75000.00),(9,30000.00),(12,200000.00);

-- Loan
INSERT INTO Loan (LoanType,ApprovedAmount,InterestRate,RepaymentSchedule,
LoanStatus,CustomerID,ApprovedByEmpID)
VALUES
('Personal',500000,12.50,'Monthly','Approved',1,2),
('Home',5000000,10.00,'Monthly','Approved',2,6),
('Car',800000,11.00,'Monthly','Pending',3,NULL),
('Business',2000000,9.50,'Monthly','Approved',4,2),
('Personal',300000,13.00,'Monthly','Approved',5,10),
('Home',3500000,10.50,'Monthly','Pending', 6,NULL),
('Car',600000,11.50,'Monthly','Approved',7,6),
('Business',1500000,9.00,'Monthly','Closed',8,10),
('Personal',200000,14.00,'Monthly','Approved',9,2),
('Home',4000000,10.25,'Monthly','Approved',10,6),
('Car',750000,11.75,'Monthly','Pending',11,NULL),
('Business',2500000,8.75,'Monthly','Approved',12,10);

-- Transaction
INSERT INTO [Transaction] (Type,Amount,Timestamp,Status,AccountID,ProcessedByEmpID)
VALUES
('Deposit',50000,'2024-01-05 09:15:00','Completed',1,4),
('Withdrawal',20000,'2024-01-06 10:30:00','Completed',1,4),
('Transfer',30000,'2024-01-07 11:00:00','Completed',2,8),
('Deposit',100000,'2024-01-08 09:00:00','Completed',2,8),
('Withdrawal',15000,'2024-01-09 14:20:00','Failed',3,4),
('Deposit',75000,'2024-01-10 10:45:00','Completed',5,8),
('Transfer',25000,'2024-01-11 13:00:00','Completed',6,11),
('Deposit',200000,'2024-01-12 09:30:00','Completed',7,11),
('Withdrawal',50000,'2024-01-13 15:10:00','Completed',8,12),
('Deposit',80000,'2024-01-14 11:20:00','Completed',10,12),
('Transfer',40000,'2024-01-15 08:55:00','Pending',11,4),
('Deposit',300000,'2024-01-16 12:00:00','Completed',12,8),
('Withdrawal',10000,'2024-01-17 16:30:00','Completed',1,4),
('Deposit',60000,'2024-01-18 09:45:00','Completed',3,11),
('Transfer',90000,'2024-01-19 14:00:00','Completed',5,12);

-- ATM
INSERT INTO ATM (Location, CashAvailability, OperationalStatus, BranchID)
VALUES
('Blue Area, Jinnah Ave, Islamabad',2000000,'Active',1),
('Centaurus Mall, Islamabad',1500000,'Active',1),
('Saddar Bazaar, Rawalpindi',1800000,'Active',2),
('Gulberg Main Market, Lahore',2500000,'Active',3),
('Clifton Bridge, Karachi',500000,'Under Maintenance',4),
('Peshawar Cantt Main Gate',1200000,'Active',5),
('DHA Phase 1 Commercial, Lahore',1700000,'Active',6),
('Johar Town Al-Fatah, Lahore',300000,'Active',7),
('Gulshan-e-Iqbal, Karachi',2200000,'Active',8),
('Hayatabad Phase 3, Peshawar',900000,'Offline',9),
('F-7 Markaz, Islamabad',1600000,'Active',10),
('University Road, Peshawar',1100000,'Active',5);


SELECT C.FirstName, C.LastName, T.Type, SUM(T.Amount) AS TotalAmount
FROM Customer C
INNER JOIN Account A ON C.CustomerID = A.CustomerID
INNER JOIN [Transaction] T ON A.AccountID = T.AccountID
GROUP BY C.FirstName, C.LastName, T.Type;


SELECT C.City,SUM(A.Balance) AS TotalBalance
FROM Customer C
INNER JOIN Account A ON C.CustomerID = A.CustomerID
GROUP BY C.City;


SELECT B.BranchName,B.City,COUNT(L.LoanID)AS LoanCount, SUM(L.ApprovedAmount) AS TotalApproved
FROM Loan L
INNER JOIN Employee E ON L.ApprovedByEmpID = E.EmployeeID
INNER JOIN Branch B ON E.BranchID = B.BranchID
WHERE L.LoanStatus = 'Approved'
GROUP BY B.BranchName, B.City
HAVING SUM(L.ApprovedAmount) > 1000000;

INSERT INTO Customer (FirstName, LastName, CNIC, ContactNo, HouseNo, Street, City, PostalCode, DateOfBirth)
VALUES ('Ali', 'Ahmad', 'sgdvsd', '0300-0000000', NULL, NULL, 'Karachi', '75000', '1990-01-01');


