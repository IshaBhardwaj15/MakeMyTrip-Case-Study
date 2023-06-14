--creating databse case_study
create database case_study
go

--creating schema case_study
create schema case_study
go

--using databse case_study to create tables and making further operations
Use case_study
go


--creating table called booking_table
CREATE TABLE case_study.booking_table
(
   Booking_id VARCHAR(3) NOT NULL, 
   Booking_date date NOT NULL,
   User_id VARCHAR(2) NOT NULL,
   Line_of_business VARCHAR(6) NOT NULL
)

--inserting data into booking_table
INSERT INTO case_study.booking_table
	(Booking_id,Booking_date,User_id,Line_of_business) 
VALUES 
('b1','2022-03-23','u1','Flight'),
('b2','2022-03-27','u2','Flight'),
('b3','2022-03-28','u1','Hotel'),
('b4','2022-03-31','u4','Flight'),
('b5','2022-04-02','u1','Hotel'),
('b6','2022-04-02','u2','Flight'),
('b7','2022-04-06','u5','Flight'),
('b8','2022-04-06','u6','Hotel'),
('b9','2022-04-06','u2','Flight'),
('b10','2022-04-10','u1','Flight'),
('b11','2022-04-12','u4','Flight'),
('b12','2022-04-16','u1','Flight'),
('b13','2022-04-19','u2','Flight'),
('b14','2022-04-20','u5','Hotel'),
('b15','2022-04-22','u6','Flight'),
('b16','2022-04-26','u4','Hotel'),
('b17','2022-04-28','u2','Hotel'),
('b18','2022-04-30','u1','Hotel'),
('b19','2022-05-04','u4','Hotel'),
('b20','2022-05-06','u1','Flight')


--creating table user_table
CREATE TABLE case_study.user_table
(
   User_id VARCHAR(3) NOT NULL,
   Segment VARCHAR(2) NOT NULL
)

--inserting data into user_table
INSERT INTO case_study.user_table
	(User_id,Segment) 
VALUES 
 ('u1','s1'),
 ('u2','s1'),
 ('u3','s1'),
 ('u4','s2'),
 ('u5','s2'),
 ('u6','s3'),
 ('u7','s3'),
 ('u8','s3'),
 ('u9','s3'),
 ('u10','s3')

--checking how our tables look like
select * from case_study.booking_table
select * from case_study.user_table

--Query 1. WAQ to show segment wise user count and user count for users who booked flight tickets in April 2022.

select u.Segment,COUNT(distinct(u.User_id)) as Total_User_Count,
	COUNT(distinct(case
		when b.Line_of_business='Flight' and MONTH(b.Booking_date)=4 and YEAR(b.Booking_date)=2022 then b.User_id
	end)) as User_who_booked_flight_in_apr2022
from case_study.user_table as u
left join case_study.booking_table as b on
	b.User_id=u.User_id
group by u.Segment;

--Query 2. WAQ to identify users whose first booking was a hotel booking

--1st approach

with cte as
(
	select *, ROW_NUMBER() over(partition by User_id order by Booking_date asc) as rn
	from case_study.Booking_table
)
select User_id from cte
where Line_of_business='Hotel' and rn=1

--2nd approach

select distinct(User_id) from
(
	select *,FIRST_VALUE(Line_of_business) over(partition by User_id order by Booking_date asc) as first_booking
	from case_study.booking_table
) A --alias required for sub query
where first_booking='Hotel'

--Query 3 WAQ to calculate the days between first and last booking of each user

select User_id, DATEDIFF(day,min(Booking_date),max(Booking_date)) as #days_bw_first_and_last_booking
from case_study.booking_table
Group by User_id

--Query 4 WAQ to count the number of flights and hotel bookings in each of the user segments for the user for the year 2022

select u.Segment,
sum(case when b.Line_of_business='flight' and YEAR(b.Booking_date)=2022 then 1 else 0 end) as Flights,
sum(case when b.Line_of_business='hotel' and YEAR(b.Booking_date)=2022 then 1 else 0 end) as Hotels
from case_study.booking_table as b
join case_study.user_table as u on
	u.User_id=b.User_id
group by u.Segment