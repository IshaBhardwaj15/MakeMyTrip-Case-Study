# 🛫: MakeMyTrip-Case-Study

#### 1. WAQ to show segment wise user count and user count for users who booked flight tickets in April 2022.

```sql
select u.Segment,COUNT(distinct(u.User_id)) as Total_User_Count,
	COUNT(distinct(case
		when b.Line_of_business='Flight' and MONTH(b.Booking_date)=4 and YEAR(b.Booking_date)=2022 then b.User_id
	end)) as User_who_booked_flight_in_apr2022
from case_study.user_table as u
left join case_study.booking_table as b on
	b.User_id=u.User_id
group by u.Segment;
```

![image](https://github.com/IshaBhardwaj15/MakeMyTrip-Case-Study/blob/main/ss/Screenshot%20(63).png)

#### 2. WAQ to identify users whose first booking was a hotel booking

1st approach

```sql
with cte as
(
	select *, ROW_NUMBER() over(partition by User_id order by Booking_date asc) as rn
	from case_study.Booking_table
)
select User_id from cte
where Line_of_business='Hotel' and rn=1
```

2nd approach

```sql
select distinct(User_id) from
(
	select *,FIRST_VALUE(Line_of_business) over(partition by User_id order by Booking_date asc) as first_booking
	from case_study.booking_table
) A --alias required for sub query
where first_booking='Hotel'
```

![image](https://github.com/IshaBhardwaj15/MakeMyTrip-Case-Study/blob/main/ss/Screenshot%20(64).png)

#### 3. WAQ to calculate the days between first and last booking of each user

```sql
select User_id, DATEDIFF(day,min(Booking_date),max(Booking_date)) as #days_bw_first_and_last_booking
from case_study.booking_table
Group by User_id
```

![image](https://github.com/IshaBhardwaj15/MakeMyTrip-Case-Study/blob/main/ss/Screenshot%20(65).png)

#### 4. WAQ to count the number of flights and hotel bookings in each of the user segments for the user for the year 2022

```sql
select u.Segment,
sum(case when b.Line_of_business='flight' and YEAR(b.Booking_date)=2022 then 1 else 0 end) as Flights,
sum(case when b.Line_of_business='hotel' and YEAR(b.Booking_date)=2022 then 1 else 0 end) as Hotels
from case_study.booking_table as b
join case_study.user_table as u on
	u.User_id=b.User_id
group by u.Segment
```

![image](https://github.com/IshaBhardwaj15/MakeMyTrip-Case-Study/blob/main/ss/Screenshot%20(66).png)
