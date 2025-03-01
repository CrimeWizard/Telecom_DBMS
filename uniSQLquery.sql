CREATE DATABASE Milestone2DB_24;
GO

use  Milestone2DB_24

go
-------------------------------------------------------------------------------------
------------------------create tables Procedure--------------------------------------------
CREATE PROCEDURE [createAllTables]

AS

create table customer_profile(
nationalID int primary key,
first_name varchar(50) not null, 
last_name varchar(50) not null,
email varchar(50),
address varchar(70) not null, 
date_of_birth date
)


create table customer_account(
mobileNo char(11) primary key,
pass varchar(50),
balance decimal(10,1),
account_type varchar(50) check(account_type = 'postpaid' or account_type = 'prepaid' or account_type = 'pay-as-you-go' ),
start_date date not null,
status varchar(50) check(status = 'active' or status = 'onhold'),
points int default 0,
nationalID int,
FOREIGN KEY (nationalID) REFERENCES customer_profile (nationalID)
)

create table Service_plan(
planID int identity primary key,
name varchar(50) not null,
price int not null,
SMS_offered int not null,
minutes_offered int not null,
data_offered int not null,
description varchar(50)
)

create table Subscription(
mobileNo Char(11),
planID int,
subscription_date date,
status varchar(50) check(status='active' or status='onhold'),
constraint pk_subscription primary key (mobileNo,planID),
FOREIGN KEY (mobileNo) REFERENCES customer_account (mobileNo),
FOREIGN KEY (planID) REFERENCES Service_plan (planID)
)

create table Plan_Usage(
usageID int identity primary key,
start_date date not null,
end_date date not null,
data_consumption int,
minutes_used int ,
SMS_sent int  , 
mobileNo Char(11) , 
planID int,
FOREIGN KEY (mobileNo) REFERENCES customer_account (mobileNo),
FOREIGN KEY (planID) REFERENCES Service_plan (planID)
)


create table Payment(
paymentID int identity primary key,
amount decimal(10,1) not null,
date_of_payment date not null,
payment_method varchar(50) check(payment_method ='cash' or payment_method ='credit'),
status varchar(50) check(status ='successful' or status='rejected' or status='pending'),
mobileNo Char(11),
FOREIGN KEY (mobileNo) REFERENCES customer_account (mobileNo)
)




create table process_payment(
paymentID int,
planID int,
FOREIGN KEY (paymentID) REFERENCES Payment (paymentID),
FOREIGN KEY (planID) REFERENCES Service_plan (planID),

remaining_amount as(dbo.function_remaining_amount(paymentID, planID)),
extra_amount as (dbo.function_extra_amount(paymentID, planID)),

constraint pk_process_payment primary key (paymentID) 
)

create table Wallet
(
walletID int identity primary key,
current_balance decimal(10,2) default 0,
currency varchar(50) default 'egp',
last_modified_date date ,
nationalID int,
mobileNo char(11),
FOREIGN KEY (nationalID) REFERENCES customer_profile (nationalID)
)

create table transfer_money(
walletID1 int, 
walletID2 int, 
transfer_id int identity,
amount decimal (10,2),
transfer_date date, 
constraint pk_transfer_money primary key (walletID1,walletID2,transfer_id),
FOREIGN KEY (walletID1) REFERENCES Wallet(walletID),
FOREIGN KEY (walletID2) REFERENCES Wallet (walletID)
)

create table Benefits (
benefitID int primary key identity, 
description varchar(50),
validity_date date, 
status varchar (50) check(status='active' or status ='expired'),
mobileNo char(11), 
FOREIGN KEY (mobileNo) REFERENCES customer_account(mobileNo)
)

create table Points_group(
pointId int identity,
benefitID int, 
pointsAmount int,
paymentId int,
FOREIGN KEY (paymentId) REFERENCES Payment(paymentID),
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
constraint pk_Points_group primary key (pointId,benefitId)
)

create table Exclusive_offer (
offerID int identity, 
benefitID int, 
internet_offered int ,
SMS_offered int,
minutes_offered int,
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
constraint pk_Exclusive_offer primary key (offerID,benefitId)

)

create table Cashback(
cashbackID int identity, 
benefitID int, 
walletID int, 
amount int,
credit_date date,FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (walletid) REFERENCES Wallet(walletid),
constraint pk_Cashback primary key (cashbackID,benefitId)
)

create table plan_provides_benefits(
benefitid int, 
planID int, 
FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
FOREIGN KEY (planID) REFERENCES service_plan(planID),
constraint pk_plan_provides_benefits primary key (planID,benefitId)
)

create table shop (
shopID int identity primary key,
name varchar(50),
Category varchar(50)
)
create table Physical_shop (
shopID int primary key, 
address varchar(50),
working_hours varchar(50),
FOREIGN KEY (shopID) REFERENCES shop(shopID),
)

create table E_shop (
shopID int primary key , 
URL varchar(50) not null,
rating int,
FOREIGN KEY (shopID) REFERENCES shop(shopID),
)

create table Voucher (
voucherID int identity primary key,
value int,
expiry_date date,
points int, 
mobileNo char(11),
redeem_date date,
shopid int, 
FOREIGN KEY (shopID) REFERENCES shop(shopID),
FOREIGN KEY (mobileNo) REFERENCES customer_account(mobileNo)
)



create table Technical_support_ticket (
ticketID int identity,
mobileNo char(11), 
issue_description varchar(50),
priority_level int,
status varchar(50) check (status in ('Open','In progress','Resolved'))
FOREIGN KEY (mobileNo) REFERENCES customer_account(mobileNo),
constraint pk_Technical_support_ticket primary key (ticketID,mobileNo)
)

GO

-------------------------------------------------------------------------------------
------------------------remaining function--------------------------------------------
go
CREATE FUNCTION [function_remaining_amount]
(@paymentId int, @planId int) --Define Function Inputs
RETURNS int -- Define Function Output
AS

Begin

declare @amount int

If (SELECT payment.amount FROM payment WHERE payment.paymentid=@paymentId)  < (SELECT Service_plan.price FROM Service_plan
WHERE Service_plan.planid=@planid)

Set @amount =  (SELECT Service_plan.price FROM Service_plan WHERE Service_plan.planid=@planid) - (SELECT payment.amount FROM payment
WHERE payment.paymentid=@paymentId)

Else
Set @amount = 0

Return @amount

END
go

-------------------------------------------------------------------------------------------
---------------------------------extra function--------------------------------------------
go
CREATE FUNCTION [function_extra_amount]
(@paymentId int, @planId int) --Define Function Inputs
RETURNS int -- Define Function Output
AS

Begin

declare @amount int

If (SELECT payment.amount FROM payment WHERE payment.paymentid=@paymentId)  > (SELECT Service_plan.price FROM Service_plan
WHERE Service_plan.planid=@planid)

Set @amount = (SELECT payment.amount FROM payment WHERE payment.paymentid=@paymentId) - (SELECT Service_plan.price FROM Service_plan WHERE Service_plan.planid=@planid)

Else
Set @amount = 0

Return @amount

END

go
-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Exec createAllTables

-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------Views------------------------------------------------------------------------------------------
-----------------------------------Basic Data Retrieval------------------------------------------------------------------------------------------


-----------------------------------allCustomerAccounts------------------------------------------------------------------------------------------
-------------------Fetch details for all customer profiles along with their active accounts---------------------
GO
CREATE VIEW [allCustomerAccounts] AS
SELECT p.*,a.mobileNo,a.account_type,a.status,a.start_date,a.balance,a.points from customer_profile p
inner join customer_account a 
on p.nationalID = a.nationalID
where a.status = 'active'

GO
-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------allServicePlans------------------------------------------------------------------------------------------
-------------------Fetch details for all offered Service Plans---------------------

GO
CREATE VIEW [allServicePlans] AS
select * from Service_plan
GO

-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------allBenefits------------------------------------------------------------------------------------------
-------------------Fetch details for all active Benefits---------------------
GO
CREATE VIEW [allBenefits] AS
select * from Benefits
where status = 'active'
GO


-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------AccountPayments------------------------------------------------------------------------------------------
-----------Fetch details for all payments along with their corresponding Accounts---------------------

GO
CREATE VIEW [AccountPayments] AS
select * from Payment p

GO

-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------allShops------------------------------------------------------------------------------------------
-----------Fetch details for all shops.---------------------
GO
CREATE VIEW [allShops] AS
select * from shop 
GO

-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------allResolvedTickets------------------------------------------------------------------------------------------
-----------Fetch details for all resolved tickets---------------------
GO
CREATE VIEW [allResolvedTickets] AS
select * from Technical_support_ticket
where status = 'Resolved'
GO

-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------CustomerWallet------------------------------------------------------------------------------------------
-----------Fetch details of all wallets along with their customer names---------------------
GO
CREATE VIEW [CustomerWallet] AS
select w.*,p.first_name,p.last_name from Wallet w
inner join customer_profile p
on w.nationalID = p.nationalID

GO

-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------E_shopVouchers------------------------------------------------------------------------------------------
-----------Fetch the list of all E-shops along with their redeemed vouchers’s ids and values---------------------
GO
CREATE VIEW [E_shopVouchers] AS
select e.*, v.voucherID,v.value from E_shop e
inner join Voucher v
on e.shopID = v.shopid

GO
-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------PhysicalStoreVouchers------------------------------------------------------------------------------------------
-----------Fetch the list of all physical stores along with their redeemed vouchers’s ids and values.---------------------
GO
CREATE VIEW [PhysicalStoreVouchers] AS
select p.*, v.voucherID,v.value from Physical_shop p
inner join Voucher v
on p.shopID = v.shopid

GO
-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------------------------------Num_of_cashback------------------------------------------------------------------------------------------
-----------Fetch number of cashback transactions per each wallet---------------------
GO
CREATE VIEW [Num_of_cashback] AS
select walletID,count(*)as 'count of transactions' from Cashback
group by walletID

GO


-----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------Account_Plan Procedure------------------------------------------------------------
-- List all accounts along with the service plans they are subscribed to ----------------------------------------------------
go
create Procedure [Account_Plan]
AS
Select customer_account.*, Service_plan.* from customer_account inner join Subscription
on customer_account.mobileNo = Subscription.mobileNo inner join Service_plan on Subscription.planID = Service_plan.planID
GO

-----------------------------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


------------------------------------Account_Plan_date Table Valued Function---------------------------------------------------------
-----Retrieve the list of accounts subscribed to the input plan on a certain date--------------------------------
go
CREATE FUNCTION [Account_Plan_date]
(@sub_date date, @plan_id int) --Define Function Inputs
RETURNS Table -- Define Function Output
AS
Return (Select customer_account.mobileNo, Service_plan.planID, Service_plan.name from customer_account inner join Subscription
on customer_account.mobileNo = Subscription.mobileNo inner join Service_plan on Subscription.planID = Service_plan.planID
WHERE Subscription.subscription_date = @sub_date AND Service_plan.planID = @plan_id)
go
--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------

-----------------------------Account_Usage_Plan table valued function-------------------------------------------------------
--Retrieve the total usage of the input account on each subscribed plan from a given input date.
go
create FUNCTION [Account_Usage_Plan]
(@mobile_num char(11), @start_date date) --Define Function Inputs
RETURNS Table -- Define Function Output
AS
Return (Select Plan_Usage.planID, sum(Plan_Usage.data_consumption) as 'total data' ,sum(Plan_Usage.minutes_used) as 'total mins',sum(Plan_Usage.SMS_sent) as 'total SMS'
from Plan_Usage
where  Plan_Usage.mobileNo = @mobile_num and Plan_Usage.start_date >= @start_date
group by Plan_Usage.planID)
go
--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------

---------------------------------Benefits_Account  -------------------------------------------------------------------------
---------Delete all benefits offered to the input account for a certain plan-------------------
go
CREATE PROCEDURE [Benefits_Account]
@mobile_num char(11), @plan_id int

AS
update Benefits
set mobileNo = null
from  Benefits B inner join plan_provides_benefits pb
on B.benefitID = pb.benefitid 
where B.mobileNo = @mobile_num and pb.planID = @plan_id
go
/*
delete B from Benefits B inner join plan_provides_benefits pb
on B.benefitID = pb.benefitid 
where B.mobileNo = 01234567890 and pb.planID = 1
*/

---must also delete any of the subclasses that have this benefit_id if using delete 
--delete from benefit or update mobile number to Null !!!!!!!



--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
---------------------------------Account_SMS_Offers  -------------------------------------------------------------------------
---------Retrieve the list of gained offers of type ‘SMS’ for the input account-------------------
go
CREATE FUNCTION [Account_SMS_Offers]
(@mobile_num char(11)) --Define Function Inputs
RETURNS Table -- Define Function Output
AS
Return(Select o.* from Exclusive_offer o inner join Benefits b 
on o.benefitID = b.benefitID 
where b.mobileNo = @mobile_num and o.SMS_offered >0 )
go 

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
---------------------------------Account_Payment  -------------------------------------------------------------------------
---------Get the number of accepted  payment transactions initiated by the input account during the last year--------------------
go
CREATE PROCEDURE [Account_Payment_Points]
@mobile_num char(11)

AS
select count(p.paymentID), sum(pb.pointsAmount) from Payment P
inner join Points_group pb 
on p.paymentID = pb.paymentId
where P.mobileNo = @mobile_num and (year(current_timestamp) - year(p.date_of_payment)=1 ) 
and P.status = 'successful'
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
---------------------------------Wallet_Cashback_Amount-------------------------------------------------------------------------
---------Retrieve the amount of cashback returned on the input wallet--------------------

go
CREATE FUNCTION [Wallet_Cashback_Amount]
(@walletID int, @planID int) --Define Function Inputs
RETURNS int -- Define Function Output
AS
Begin
declare @amount int

set @amount = (Select sum(c.amount) from Cashback c 
inner join plan_provides_benefits pb 
on c.benefitID = pb.benefitid
where c.walletID = @walletID and pb.planID = @planID)

return @amount
END
go


--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
---------------------------------Wallet_Transfer_Amount-------------------------------------------------------------------------
---------Retrieve the average of the sent transaction amounts from the input wallet within a certain duration.--------------------
go
CREATE FUNCTION [Wallet_Transfer_Amount]
(@walletID int, @start_date date, @end_date date) --Define Function Inputs
RETURNS int -- Define Function Output
AS
Begin
declare @avg int

set @avg = (Select avg(t.amount) from transfer_money t
where t.walletID1 = @walletID and t.transfer_date between @start_date and @end_date)

return @avg
END
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
---------------------------------Wallet_MobileNo-------------------------------------------------------------------------
-----------------------------Take mobileNo as an input, return true if this number is linked to a wallet, otherwise return false.
go
CREATE FUNCTION [Wallet_MobileNo]
(@mobile_num char(11)) --Define Function Inputs
RETURNS bit -- Define Function Output
AS
Begin
declare @output bit
IF exists((Select w.walletID from Wallet w
where w.mobileNo = @mobile_num ))
set @output = 1
else 
set @output = 0

return @output
END
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Total_Points_Account-----------------------
------------------------- Update the total number of points that the input account should have--------------------------

go
CREATE PROCEDURE [Total_Points_Account]
@mobile_num char(11)  

AS
declare @sum int
select @sum =  sum(pg.pointsAmount) from Points_group pg
inner join Payment p
on pg.paymentId = p.paymentID
where p.mobileNo = @mobile_num

update customer_account  
set points = @sum
where mobileNo = @mobile_num

delete from Points_group
where pointId in  (select pg.pointId from Points_group pg
inner join Payment p on pg.paymentId = p.paymentID
where p.mobileNo = @mobile_num)
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
-------------------------2.4.As a customer I should be able to------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------AccountLoginValidation-----------------------
-------------------------login using my mobileNo and password--------------------------
go
CREATE FUNCTION [AccountLoginValidation]
(@mobile_num char(11), @pass varchar(50)) --Define Function Inputs
RETURNS bit -- Define Function Output
AS
Begin
declare @output bit
IF exists((Select a.mobileNo from customer_account a
where a.mobileNo = @mobile_num and a.pass = @pass ))
set @output = 1
else 
set @output = 0

return @output
END
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Consumption-----------------------
-------------------------Retrieve the total SMS, Mins and Internet consumption for an input plan within a certain duration--------------------------

go
CREATE FUNCTION [Consumption]
(@Plan_name varchar(50), @start_date date, @end_date date) --Define Function Inputs
RETURNS Table -- Define Function Output
AS
Return(Select p.data_consumption,p.minutes_used,p.SMS_sent from Plan_Usage p 
inner join Service_plan s on s.planID = p.planID
where s.name = @Plan_name and p.start_date >= @start_date and p.end_date <= @end_date)
go 
--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Unsubscribed_Plans-----------------------
-------------------------Retrieve all offered plans that the input customer is not subscribed to--------------------------
go
CREATE PROCEDURE [Unsubscribed_Plans]
@mobile_num char(11)

AS
select  sp.* from  Service_plan sp 
where sp.planID not in (
select s.planID  from Subscription s
where s.mobileNo = @mobile_num)
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Usage_Plan_CurrentMonth-----------------------
-------------------------Retrieve the usage of all active plans for the input account in the current month--------------------------

go
CREATE FUNCTION [Usage_Plan_CurrentMonth]
(@mobile_num char(11)) --Define Function Inputs
RETURNS Table -- Define Function Output
AS
Return(select p.data_consumption, p.minutes_used, p.SMS_sent from Plan_Usage p
inner join Subscription s 
on p.planID = s.planID and p.mobileNo = s.mobileNo
where p.mobileNo = @mobile_num and s.status = 'active' 
and month(p.start_date)= month(current_timestamp) or month(p.end_date)= month(current_timestamp) and year(p.start_date)= year(current_timestamp) or year(p.end_date)= year(current_timestamp))
go 

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Cashback_Wallet_Customer-----------------------
------------------------- Retrieve all cashback transactions related to the wallet of the input customer--------------------------

go
CREATE FUNCTION [Cashback_Wallet_Customer]
(@NID int) --Define Function Inputs
RETURNS Table -- Define Function Output
AS
Return(select c.* from Cashback c 
inner join Wallet w 
on c.walletID = w.walletID 
where w.nationalID = @NID)
go 




--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Ticket_Account_Customer-----------------------
------------------------- Retrieve the number of technical support tickets that are NOT ‘Resolved’ for each account of the input customer--------------------------

go
CREATE PROCEDURE [Ticket_Account_Customer]
@NID int 

AS
select count(t.ticketID) from Technical_support_ticket t
inner join customer_account a 
on t.mobileNo = a.mobileNo
where t.status <> 'resolved' and a.nationalID = @NID
go


--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Account_Highest_Voucher-----------------------
------------------------- Return the voucher with the highest value for the input account.--------------------------

go
CREATE PROCEDURE [Account_Highest_Voucher]
@mobile_num char(11)  

AS
declare @max int
select @max =  max(v.value) from Voucher v 
where v.mobileNo = @mobile_num 

select v.voucherID from voucher v
where v.mobileNo = @mobile_num and v.value = @max

go


--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Remaining_plan_amount-----------------------
------------------------- Get the remaining amount for a certain plan based on the payment initiated by the input account--------------------------
go
CREATE FUNCTION [Remaining_plan_amount]
(@mobile_num char(11), @plan_name varchar(50)) --Define Function Inputs
RETURNS int -- Define Function Output
AS
Begin
declare @output int, @plan_id int, @payment_id int
Select @plan_id = s.planID, @payment_id= p.paymentID from Service_plan s inner join process_payment pp
on s.planID = pp.planID inner join payment p 
on pp.paymentID = p.paymentID
where s.name = @plan_name and p.mobileNo = @mobile_num and p.status='successful'

set @output = dbo.function_remaining_amount(@payment_id,@plan_id)
return @output
END
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Extra_plan_amount-----------------------
-------------------------Get the extra amount from a payment initiated by the input account for a certain plan--------------------------
go
CREATE FUNCTION [Extra_plan_amount]
(@mobile_num char(11), @plan_name varchar(50)) --Define Function Inputs
RETURNS int -- Define Function Output
AS
Begin
declare @output int, @plan_id int, @payment_id int
Select @plan_id = s.planID, @payment_id= p.paymentID from Service_plan s inner join process_payment pp
on s.planID = pp.planID inner join payment p 
on pp.paymentID = p.paymentID
where s.name = @plan_name and p.mobileNo = @mobile_num and p.status='successful'

set @output = dbo.function_extra_amount(@payment_id,@plan_id)
return @output
END
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Top_Successful_Payments-----------------------
-------------------------Retrieve the top 10 successful payments with highest value for the input account--------------------------
go
CREATE PROCEDURE [Top_Successful_Payments]
@mobile_num char(11)  

AS
select top 10 p.* from Payment p 
where p.mobileNo = @mobile_num
and p.status = 'successful'
order by p.amount desc
go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Subscribed_plans_5_Months-----------------------
-------------------------Retrieve all service plans the input account subscribed to in the past 5 months--------------------------

go
CREATE FUNCTION [Subscribed_plans_5_Months]
(@MobileNo char(11)) --Define Function Inputs
RETURNS Table -- Define Function Output
AS
Return(Select sp.* from Service_plan sp 
inner join Subscription s 
on sp.planID = s.planID
where s.mobileNo = @MobileNo and 
s.subscription_date >= DATEADD(month,-5,CURRENT_TIMESTAMP))
go 

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Initiate_plan_payment-----------------------
-------------------------Initiate an accepted payment for the input account for plan renewal and update the status of the subscription accordingly.--------------------------

go
CREATE PROCEDURE [Initiate_plan_payment]
@mobile_num char(11), @amount decimal(10,1), @payment_method varchar(50),
@plan_id int 

AS
declare @payment_id int
Insert into Payment (amount,date_of_payment,payment_method,status,mobileNo)
values(@amount,CURRENT_TIMESTAMP,@payment_method,'successful',@mobile_num)
SELECT @payment_id = p.paymentID from Payment p    
where p.mobileNo = @mobile_num and p.amount = @amount and p.date_of_payment = CAST(CURRENT_TIMESTAMP AS DATE)
and p.payment_method = @payment_method and p.status = 'successful'
Insert into process_payment(paymentID, planID) values(@payment_id, @plan_id)
if(select remaining_amount from process_payment where planID = @plan_id and paymentID = @payment_id) = 0 
update Subscription
set status = 'active'
where planID = @plan_id and mobileNo = @mobile_num
else
update Subscription
set status = 'onhold'
where planID = @plan_id and mobileNo = @mobile_num

go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Payment_wallet_cashback-----------------------
-------------------------Calculate the amount of cashback that will be returned on the wallet of the customer of the input account from a certain payment--------------------------

go
CREATE PROCEDURE [Payment_wallet_cashback]
@mobile_num char(11), @payment_id int, @benefit_id int 

AS
declare @amount int, @cash_amount int, @wallet_id int 
select @amount = p.amount  from Payment p
where p.paymentID = @payment_id and p.status = 'successful'
set @cash_amount = 0.1 * @amount
select @wallet_id = w.walletID from Wallet w
inner join customer_account a on
w.nationalID = a.nationalID 
where a.mobileNo = @mobile_num

Insert into Cashback(benefitID,walletID,amount,credit_date)
values(@benefit_id,@wallet_id,@cash_amount,current_timestamp)

update Wallet
set current_balance = current_balance + @cash_amount,
last_modified_date = current_timestamp
where walletID = @wallet_id

go


--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Initiate_balance_payment-----------------------
-------------------------Initiate an accepted payment for the input account for balance recharge--------------------------
go
CREATE PROCEDURE [Initiate_balance_payment]
@mobile_num char(11), @amount decimal(10,1), @payment_method varchar(50)

as
Insert into Payment (amount,date_of_payment,payment_method,status,mobileNo)
values(@amount,CURRENT_TIMESTAMP,@payment_method,'successful',@mobile_num)

update customer_account
set balance = balance + @amount
where mobileNo = @mobile_num

go

--//////////////////////////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------------------------------
----------------------------------------Redeem_voucher_points-----------------------
------------------------- Redeem a voucher for the input account and update the total points of the account accordingly--------------------------
go
CREATE PROCEDURE [Redeem_voucher_points]
@mobile_num char(11), @voucher_id int 

AS
If (Select v.points from Voucher v 
where v.voucherID = @voucher_id and v.expiry_date >CURRENT_TIMESTAMP ) <= (Select a.points from customer_account a 
where a.mobileNo = @mobile_num) 
begin 
declare @voucher_points int 
select @voucher_points = points from Voucher
where voucherID = @voucher_id
update Voucher
set mobileNo = @mobile_num , redeem_date = current_timestamp 
where voucherID = @voucher_id 

update customer_account
set points = points - @voucher_points
where mobileNo = @mobile_num
end 
else 
print 'no enough points to redeem voucher'

go 
--///////////////////////////////////////////////////////////////////////////////////////////////////
----------------------------------- Executions ------------------------------------------------------
----------------------------------- Views ------------------------------------------------------
----------------------------------- allCustomerAccounts ------------------------------------------------------

Select * from allCustomerAccounts
----------------------------------- allServicePlans ------------------------------------------------------

Select * from allServicePlans
----------------------------------- allBenefits ------------------------------------------------------

Select * from allBenefits
----------------------------------- AccountPayments ------------------------------------------------------

Select * from AccountPayments
-----------------------------------allShops------------------------------------------------------

Select * from allShops
-----------------------------------allResolvedTickets------------------------------------------------------

Select * from allResolvedTickets
-----------------------------------CustomerWallet------------------------------------------------------

Select * from CustomerWallet
-----------------------------------E_shopVouchers------------------------------------------------------

Select * from E_shopVouchers
-----------------------------------PhysicalStoreVouchers------------------------------------------------------

Select * from PhysicalStoreVouchers
-----------------------------------Num_of_cashback------------------------------------------------------

Select * from Num_of_cashback

--------------------Admin Executions--------------------------------------------
-----------------------Account_Plan Procedure----------------------------------
Exec Account_Plan

-----------------Account_Plan_date Table Valued Function--------------
select * from dbo.Account_Plan_date ('2023-01-01',1)

-----------------Account_Usage_Plan function execution-------------------------------------------
select * from Plan_Usage

select * from dbo.Account_Usage_Plan ('01234567895', '2023-05-01')

-------------------Benefits_Account procedure execution---------------------------------------------------------------------------------

Exec Benefits_Account @mobile_num ='01234567891', @plan_id = 1 
-------------------Account_SMS_Offers function execution---------------------------------------------------------------------------------

select * from dbo.Account_SMS_Offers ('01234567891')

-----------------------Account_Payment_Points Procedure execution----------------------------------
Exec Account_Payment_Points @mobile_num ='01234567891'

-------------------[Wallet_Cashback_Amount] function execution---------------------------------------------------------------------------------

declare @result int
set @result = dbo.Wallet_Cashback_Amount(3,3)
print @result

-------------------[Wallet_Transfer_Amount] function execution---------------------------------------------------------------------------------

declare @result int
set @result = dbo.Wallet_Transfer_Amount(1,'','')
print @result

-------------------[Wallet_MobileNo] function execution---------------------------------------------------------------------------------

declare @result bit
set @result = dbo.Wallet_MobileNo('01234567891')
print @result

-----------------------Total_Points_Account Procedure execution----------------------------------
Exec Total_Points_Account @mobile_num ='01234567890'



----------------------------Customer Executions------------------------------------
-------------------[AccountLoginValidation] function execution---------------------------------------------------------------------------------

declare @result bit
set @result = dbo.AccountLoginValidation('01234567414','password1')
print @result

-------------------Consumption function execution---------------------------------------------------------------------------------

select * from dbo.Consumption (1, '2023-01-01','2023-01-31')

-----------------------Unsubscribed_Plans Procedure execution----------------------------------

Exec Unsubscribed_Plans @mobile_num = '01234567890'

-------------------Usage_Plan_CurrentMonth function execution---------------------------------------------------------------------------------

select * from dbo.Usage_Plan_CurrentMonth ('01234567890')

-------------------Cashback_Wallet_Customer function execution---------------------------------------------------------------------------------

select * from dbo.Cashback_Wallet_Customer (3)

-----------------------Ticket_Account_Customer Procedure execution----------------------------------

Exec Ticket_Account_Customer @NID = 1

-----------------------Account_Highest_Voucher Procedure execution----------------------------------

Exec Account_Highest_Voucher @mobile_num = '01234567890'

-------------------Remaining_plan_amount function execution---------------------------------------------------------------------------------

declare @result bit
set @result = dbo.Remaining_plan_amount('Basic Plan','01234567890')
print @result

-------------------Extra_plan_amount function execution---------------------------------------------------------------------------------

declare @result bit
set @result = dbo.Extra_plan_amount('Basic Plan','01234567890')
print @result

-----------------------Top_Successful_Payments Procedure execution----------------------------------

Exec Top_Successful_Payments @mobile_num = '01234567890'

-------------------Subscribed_plans_5_Months function execution---------------------------------------------------------------------------------

select * from dbo.Subscribed_plans_5_Months ('01234567890')

-----------------------Initiate_plan_payment Procedure execution----------------------------------

Exec Initiate_plan_payment @mobile_num = '01234567890', @amount =100, @payment_method = 'cash',
@plan_id = 3
-----------------------Payment_wallet_cashback Procedure execution----------------------------------

Exec Payment_wallet_cashback @mobile_num = '01234567892',@payment_id = 8, @benefit_id = 3

-----------------------Initiate_balance_payment Procedure execution----------------------------------

Exec Initiate_balance_payment @mobile_num = '01234567890', @amount =100, @payment_method = 'cash'

-----------------------Redeem_voucher_points Procedure execution----------------------------------

Exec Redeem_voucher_points @mobile_num = '01234567890', @voucher_id = 3 



-- Inserting sample data into customer_profile table
INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', '123 Main St, Cairo', '1990-05-15'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '456 Elm St, Cairo', '1985-08-25');

-- Inserting sample data into customer_account table
INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES 
('01111234567', 'password123', 500.00, 'prepaid', '2022-01-01', 'active', 10, 1),
('01122345678', 'password456', 1500.00, 'postpaid', '2021-07-15', 'onhold', 0, 2);

-- Inserting sample data into Service_plan table
INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description)
VALUES 
('Basic Plan', 50, 100, 200, 500, 'Basic plan with minimal offerings'),
('Premium Plan', 200, 500, 1000, 5000, 'Premium plan with generous data and minutes');

-- Inserting sample data into Subscription table
INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES 
('01111234567', 1, '2022-01-01', 'active'),
('01122345678', 2, '2021-07-15', 'onhold');

-- Inserting sample data into Plan_Usage table
INSERT INTO Plan_Usage (start_date, end_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID)
VALUES 
('2022-02-01', '2022-02-28', 300, 150, 80, '01111234567', 1),
('2022-07-01', '2022-07-31', 1200, 800, 250, '01122345678', 2);

-- Inserting sample data into Payment table
INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES 
(50.00, '2022-01-10', 'cash', 'successful', '01111234567'),
(200.00, '2021-08-01', 'credit', 'successful', '01122345678');

-- Inserting sample data into process_payment table
INSERT INTO process_payment (paymentID, planID)
VALUES 
(1, 1),
(2, 2);

-- Inserting sample data into Wallet table
INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES 
(100.00, 'EGP', '2022-01-15', 1, '01111234567'),
(200.00, 'EGP', '2021-08-10', 2, '01122345678');

-- Inserting sample data into transfer_money table
INSERT INTO transfer_money (walletID1, walletID2, amount, transfer_date)
VALUES 
(1, 2, 50.00, '2022-03-01'),
(2, 1, 100.00, '2022-04-01');

-- Inserting sample data into Benefits table
INSERT INTO Benefits (description, validity_date, status, mobileNo)
VALUES 
('Discount on next recharge', '2022-12-31', 'active', '01111234567'),
('Bonus data offer', '2022-06-30', 'expired', '01122345678');

-- Inserting sample data into Points_group table
INSERT INTO Points_group (benefitID, pointsAmount, paymentId)
VALUES 
(1, 100, 1),
(2, 50, 2);

-- Inserting sample data into Exclusive_offer table
INSERT INTO Exclusive_offer (benefitID, internet_offered, SMS_offered, minutes_offered)
VALUES 
(1, 1000, 200, 500),
(2, 5000, 500, 1000);

-- Inserting sample data into Cashback table
INSERT INTO Cashback (benefitID, walletID, amount, credit_date)
VALUES 
(1, 1, 10, '2022-01-20'),
(2, 2, 20, '2021-08-15');

-- Inserting sample data into plan_provides_benefits table
INSERT INTO plan_provides_benefits (benefitID, planID)
VALUES 
(1, 1),
(2, 2);

-- Inserting sample data into shop table
INSERT INTO shop (name, Category)
VALUES 
('TechStore', 'Electronics'),
('FashionHub', 'Clothing');

-- Inserting sample data into Physical_shop table
INSERT INTO Physical_shop (shopID, address, working_hours)
VALUES 
(1, '789 Market St, Cairo', '9:00 AM - 9:00 PM'),
(2, '123 Fashion Ave, Cairo', '10:00 AM - 8:00 PM');

-- Inserting sample data into E_shop table
INSERT INTO E_shop (shopID, URL, rating)
VALUES 
(1, 'https://techstore.com', 4),
(2, 'https://fashionhub.com', 5);

-- Inserting sample data into Voucher table
INSERT INTO Voucher (value, expiry_date, points, mobileNo, redeem_date, shopid)
VALUES 
(100, '2022-06-01', 200, '01111234567', '2022-05-20', 1),
(200, '2022-12-31', 300, '01122345678', '2021-11-01', 2);

-- Inserting sample data into Technical_support_ticket table
INSERT INTO Technical_support_ticket (mobileNo, issue_description, priority_level, status)
VALUES 
('01111234567', 'Unable to recharge account', 2, 'Resolved'),
('01122345678', 'Network issues', 1, 'In progress');



----------------------------------------------------------------------------------------------------------------------------------------------



-- Insert customer profiles
INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES 
(1001, 'John', 'Doe', 'john.doe@example.com', '123 Main St', '1990-05-15'),
(1002, 'Jane', 'Smith', 'jane.smith@example.com', '456 Elm St', '1992-08-20'),
(1003, 'Alice', 'Brown', 'alice.brown@example.com', '789 Maple St', '1988-11-05');

-- Insert customer accounts
INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES 
('01012345678', 'password123', 150.0, 'prepaid', '2024-01-01', 'active', 10, 1001),
('01023456789', 'password456', 200.0, 'postpaid', '2024-02-01', 'active', 20, 1002),
('01034567890', 'password789', 300.0, 'pay-as-you-go', '2024-03-01', 'onhold', 30, 1003);

-- Insert service plans
INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description)
VALUES 
('Basic Plan', 100, 500, 100, 1, 'Affordable basic plan'),
('Standard Plan', 200, 1000, 200, 2, 'Most popular plan'),
('Premium Plan', 300, 2000, 500, 5, 'Best value for heavy users');

-- Insert subscriptions
INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES 
('01012345678', 1, '2024-05-01', 'active'),
('01023456789', 2, '2024-05-01', 'active'),
('01034567890', 3, '2024-06-01', 'onhold'),
('01012345678', 2, '2024-07-01', 'active');

-- Insert plan usages (optional, for additional context)
INSERT INTO Plan_Usage (start_date, end_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID)
VALUES 
('2024-05-01', '2024-05-31', 0.5, 50, 200, '01012345678', 1),
('2024-05-01', '2024-05-31', 1.0, 150, 500, '01023456789', 2);

SELECT * FROM customer_profile;





--------------------------------------
-- Insert different types of subscriptions
INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES 
(1004, 'Sam', 'Wilson', 'sam.wilson@example.com', '101 Oak St', '1995-03-22'),
(1005, 'Emma', 'Taylor', 'emma.taylor@example.com', '102 Pine St', '1998-04-19');

-- Insert customer accounts
INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES 
('01045678901', 'password321', 350.0, 'prepaid', '2024-04-01', 'active', 15, 1004),
('01056789012', 'password654', 450.0, 'postpaid', '2024-05-01', 'active', 25, 1005);

-- Insert service plans
INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description)
VALUES 
('Starter Plan', 120, 400, 100, 2, 'Entry-level plan'),
('Advanced Plan', 250, 1500, 400, 10, 'For heavy data and call users');

-- Insert subscriptions
INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES 
('01045678901', 1, '2024-04-15', 'active'),
('01056789012', 2, '2024-05-10', 'active'),
('01045678901', 2, '2024-06-01', 'onhold'),
('01056789012', 1, '2024-07-01', 'active');

-- Insert plan usages
INSERT INTO Plan_Usage (start_date, end_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID)
VALUES 
('2024-04-15', '2024-04-30', 1.5, 120, 300, '01045678901', 1),
('2024-05-01', '2024-05-31', 3.5, 300, 700, '01056789012', 2);

--//////////////////////////////////////////////////////////////////


-- Insert payments
INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES 
(120.00, '2024-04-10', 'credit', 'successful', '01045678901'),
(250.00, '2024-05-20', 'cash', 'successful', '01056789012');

-- Insert wallet transactions
INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES 
(200.00, 'EGP', '2024-04-20', 1004, '01045678901'),
(500.00, 'EGP', '2024-05-25', 1005, '01056789012');

-- Insert transfer_money records
INSERT INTO transfer_money (walletID1, walletID2, amount, transfer_date)
VALUES 
(1, 2, 50.00, '2024-05-01'),
(2, 1, 100.00, '2024-06-01');

--......................................./////////////
-- Insert benefits
INSERT INTO Benefits (description, validity_date, status, mobileNo)
VALUES 
('Discount for next purchase', '2024-06-30', 'active', '01045678901'),
('Free upgrade for service plan', '2024-07-31', 'active', '01056789012'),
('Bonus reward points', '2024-05-31', 'expired', '01045678901');

-- Insert Points_group entries
INSERT INTO Points_group (benefitID, pointsAmount, paymentId)
VALUES 
(1, 50, 1),
(2, 100, 2);

-- Insert Exclusive Offers
INSERT INTO Exclusive_offer (benefitID, internet_offered, SMS_offered, minutes_offered)
VALUES 
(1, 1000, 200, 500),
(2, 5000, 400, 1000);



--////////////////////////////////////////////

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth) 
VALUES (123456789, 'John', 'Doe', 'johndoe@example.com', '123 Main St, Cairo', '1995-04-15');
INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID) 
VALUES ('01012345678', 'password123', 100.50, 'postpaid', '2024-01-01', 'active', 0, 123456789);
INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description) 
VALUES ('Basic Plan', 200, 100, 200, 5, 'Basic plan with 100 SMS, 200 minutes, and 5GB data');

INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description) 
VALUES ('Premium Plan', 500, 300, 600, 20, 'Premium plan with 300 SMS, 600 minutes, and 20GB data');
INSERT INTO Subscription (mobileNo, planID, subscription_date, status) 
VALUES ('01012345678', 1, '2024-01-01', 'active');  -- Subscribed to Basic Plan (planID = 1)
INSERT INTO Plan_Usage (start_date, end_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID) 
VALUES ('2024-05-01', '2024-05-31', 3, 150, 80, '01012345678', 1);  -- Usage for Basic Plan
INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo) 
VALUES (200, '2024-05-01', 'cash', 'successful', '01012345678');
INSERT INTO Benefits (description, validity_date, status, mobileNo) 
VALUES ('Free Data Streaming', '2024-12-31', 'active', '01012345678');

INSERT INTO Benefits (description, validity_date, status, mobileNo) 
VALUES ('Free Calls on Weekends', '2024-12-31', 'active', '01012345678');
INSERT INTO Points_group (benefitID, pointsAmount, paymentId) 
VALUES (1, 50, 1);  -- 50 points earned for 'Free Data Streaming' benefit
INSERT INTO Exclusive_offer (benefitID, internet_offered, SMS_offered, minutes_offered) 
VALUES (1, 5, 100, 50);  -- Exclusive offer related to 'Free Data Streaming'
INSERT INTO Cashback (benefitID, walletID, amount, credit_date) 
VALUES (1, 1, 50, '2024-06-01');  -- Cashback for 'Free Data Streaming' benefit
INSERT INTO plan_provides_benefits (benefitID, planID) 
VALUES (1, 1);  -- Benefit 'Free Data Streaming' provided to Basic Plan (planID = 1)
INSERT INTO shop (name, Category) 
VALUES ('Tech Store', 'Electronics');

INSERT INTO shop (name, Category) 
VALUES ('Mobile Store', 'Mobile');
INSERT INTO Voucher (value, expiry_date, points, mobileNo, redeem_date, shopid) 
VALUES (100, '2024-12-31', 200, '01012345678', '2024-06-01', 1);  -- Voucher worth 100 EGP, redeemable for 200 points
INSERT INTO Technical_support_ticket (mobileNo, issue_description, priority_level, status) 
VALUES ('01012345678', 'Unable to access internet', 1, 'Open');  -- Technical issue reported


--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (1234567890, 'John', 'Doe', 'john.doe@example.com', '123 Main St, Cairo', '1995-01-01');
INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES ('01512345678', 'password123', 100.0, 'prepaid', '2024-01-01', 'active', 0, 1234567890);

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (9876543210, 'Jane', 'Doe', 'jane.doe@example.com', '456 Another St, Cairo', '1990-05-15');

-- --------------------------------------------------------------------------------------

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (6666661111, 'Sara', 'Mohamed', 'sara.mohamed@example.com', '456 Elm St, Cairo', '1996-07-15');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (7777772222, 'Ali', 'Hassan', 'ali.hassan@example.com', '789 Pine St, Cairo', '2000-05-25');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (8888883333, 'Mona', 'Fathy', 'mona.fathy@example.com', '123 Nile St, Cairo', '1992-11-10');


------------------------------------------------------------------

-- Insert sample data within the valid range for `int`
INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (123456789, 'Sara', 'Mohamed', 'sara.mohamed@example.com', '456 Elm St, Cairo', '1996-07-15');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (987654321, 'Ali', 'Hassan', 'ali.hassan@example.com', '789 Pine St, Cairo', '2000-05-25');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (135792468, 'Mona', 'Fathy', 'mona.fathy@example.com', '123 Nile St, Cairo', '1992-11-10');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (112233445, 'Ahmed', 'Tarek', 'ahmed.tarek@example.com', '1010 Market St, Cairo', '1988-02-20');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (223344556, 'Nadia', 'Hussein', 'nadia.hussein@example.com', '2020 Nile St, Cairo', '1994-03-17');








--//////////////////////////////////////////////////////////


INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (100000001, 'Sara', 'Mohamed', 'sara.mohamed@example.com', '456 Elm St, Cairo', '1996-07-15');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (100000002, 'Ali', 'Hassan', 'ali.hassan@example.com', '789 Pine St, Cairo', '2000-05-25');

INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES (100000003, 'Mona', 'Fathy', 'mona.fathy@example.com', '123 Nile St, Cairo', '1992-11-10');


INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES ('01512345678', 'password123', 100.0, 'prepaid', '2024-01-01', 'active', 0, 100000001);

INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES ('01523456789', 'password456', 150.0, 'postpaid', '2024-01-10', 'active', 10, 100000002);

INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES ('01534567890', 'password789', 200.0, 'pay-as-you-go', '2024-01-20', 'active', 20, 100000003);


INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description)
VALUES ('Basic Plan', 50, 100, 200, 500, 'Basic Plan with SMS, minutes, and data');

INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description)
VALUES ('Premium Plan', 100, 300, 500, 1000, 'Premium Plan with more offers');

INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description)
VALUES ('VIP Plan', 200, 500, 1000, 2000, 'VIP Plan with all benefits');


INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES ('01512345678', 1, '2024-01-01', 'active');

INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES ('01523456789', 2, '2024-01-10', 'active');

INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES ('01534567890', 3, '2024-01-20', 'active');


INSERT INTO Benefits (description, validity_date, status, mobileNo)
VALUES ('SMS Discount', '2024-12-31', 'active', '01512345678');

INSERT INTO Benefits (description, validity_date, status, mobileNo)
VALUES ('Data Bonus', '2024-06-30', 'active', '01523456789');

INSERT INTO Benefits (description, validity_date, status, mobileNo)
VALUES ('Minutes Offer', '2024-09-30', 'expired', '01534567890');


INSERT INTO Exclusive_offer (benefitID, internet_offered, SMS_offered, minutes_offered)
VALUES (1, 1000, 200, 300);

INSERT INTO Exclusive_offer (benefitID, internet_offered, SMS_offered, minutes_offered)
VALUES (2, 1500, 500, 700);

INSERT INTO Exclusive_offer (benefitID, internet_offered, SMS_offered, minutes_offered)
VALUES (3, 2000, 700, 1000);


INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES (500, 'EGP', '2024-01-01', 100000001, '01512345678');

INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES (1000, 'EGP', '2024-01-10', 100000002, '01523456789');

INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES (1500, 'EGP', '2024-01-20', 100000003, '01534567890');


INSERT INTO Points_group (benefitID, pointsAmount, paymentId)
VALUES (1, 10, 1);

INSERT INTO Points_group (benefitID, pointsAmount, paymentId)
VALUES (2, 20, 2);

INSERT INTO Points_group (benefitID, pointsAmount, paymentId)
VALUES (3, 30, 3);


INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES (100, '2024-01-01', 'cash', 'successful', '01512345678');

INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES (150, '2024-01-10', 'credit', 'successful', '01523456789');

INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES (200, '2024-01-20', 'cash', 'pending', '01534567890');


INSERT INTO customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', '123 Elm Street', '1990-01-01');

INSERT INTO customer_account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES ('01334567890', 'securePass123', 500.0, 'postpaid', '2024-12-01', 'active', 0, 1);

INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description)
VALUES ('Basic Plan', 100, 50, 100, 2, 'Affordable plan for light users');


INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES ('01334567890', 1, '2024-12-01', 'active'); -- Replace `1` with an existing `planID` in your database.

INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES (300.0, 'EGP', '2024-12-01', 1, '01334567890');

INSERT INTO Points_group (benefitID, pointsAmount, paymentId)
VALUES (1, 50, 1); -- Replace `1` with existing `benefitID` and `paymentId`.
