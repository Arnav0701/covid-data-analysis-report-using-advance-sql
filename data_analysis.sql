																	# DATA ANALYSIS
use covid;

/* 1. The Survival Metric
	What is the Case Fatality Rate (CFR) for each country, expressed as the percentage of deaths relative to confirmed cases? Rank countries from highest to lowest.
 */

with totals as (select 
					country_region,
                    sum(confirmed) as total_confirmed,
                    sum(deaths) as total_deaths
				from
					covid_data
				group by
					country_region)
select
	t.country_region,
    concat(round((t.total_deaths/t.total_confirmed)*100,2),"%") as percent_f_death_to_confirm
from
    totals t
where 
	total_deaths > 0
order by
	total_deaths/total_confirmed desc;
    
    
/* 2. Population Penetration
	Which 10 countries experienced the highest infection rates relative to their population size?
 */

# 	considering population of 2020
with total_deaths as(select country_region, sum(confirmed) as confirmed
					from covid_data
                    group by country_region)
select
	distinct cd.country_region,
    td.confirmed/pd.YR2020 as infection_rate
from
	covid_data cd
    join
    population_data pd on cd.country_region = pd.country_name
    join
    total_deaths td on cd.country_region = td.country_region
order by
	infection_rate desc
limit 10
;


/* 3. Regional Contribution
	For countries with multiple administrative regions (such as provinces or states), which region contributed the largest share of the country’s total deaths?
 */

with deaths_per_country as (select country_region, sum(deaths) as deaths
					from covid_data
                    group by country_region),
deaths_per_province as(select country_region, province, sum(deaths) as deaths
					from covid_data
                    where country_region in (select country_region
											from covid_data
                                            group by country_region
											having count(distinct province)>1)
					group by country_region, province)
select
	dpc.country_region,
    dpp.province,
    dpc.deaths as countries_total_deaths,
    dpp.deaths as province_total_deaths,
    round(dpp.deaths/dpc.deaths * 100,2) as percentage_contribution
from
	deaths_per_country dpc
    join
    deaths_per_province dpp on dpc.country_region = dpp.country_region
where
	(dpp.country_region, dpp.deaths) in (select country_region, max(deaths)
										from deaths_per_province
                                        group by country_region)
group by
	dpc.country_region, dpp.province
order by
	percentage_contribution desc;


/* 4. The “First 100” Benchmark
	How long did it take each country to progress from its first reported case to reaching 100 total deaths?
 */

with first_conf as (select country_region, min(date_raw) as conf_date
				from covid_data
				where confirmed>=1
				group by country_region),
first100 as (select country_region, min(date_raw) as f100_date
				from covid_data
				where confirmed>=100
				group by country_region)
select
	s.country_region,
    datediff(f.f100_date,s.conf_date) as days
from
	first_conf s
    join
    first100 f on s.country_region = f.country_region
order by
	days, s.country_region;
    
    
/* 5. Global Hotspot Center
	Where is the geographic center of the most severe outbreak zones, considering the top 5% of global hotspots weighted by case counts?
 */

WITH TopHotspots AS (
    SELECT 
        country_region, 
        AVG(latitude) AS lat, 
        AVG(longitude) AS lon, 
        SUM(confirmed) AS total_cases
    FROM covid_data
    GROUP BY country_region
    ORDER BY total_cases DESC
    LIMIT 10
)
SELECT 
    SUM(lat * total_cases) / SUM(total_cases) AS weighted_center_lat,
    SUM(lon * total_cases) / SUM(total_cases) AS weighted_center_long,
    SUM(total_cases) AS total_cases_in_top_5_percent
FROM TopHotspots;


/* 6. Recovery Lag
	At a global level, what is the average time delay between surges in confirmed cases and subsequent increases in recoveries?
 */
	
with rec_p_day as (select date_raw, sum(confirmed) as t_confirmed, sum(recovered) as t_recovered
	from covid_data
	group by date_raw),
max_rec as (select max(t_confirmed) as max_conf, max(t_recovered) as max_rec
	from rec_p_day 
    )
select
	t1.date_raw as date_of_max_confirmed,
    t2.date_raw as date_of_max_recovery,
    datediff(t2.date_raw,t1.date_raw) as days_from_peak_cases_to_most_recovery
from
	(select
		date_raw
	from
		rec_p_day rpd
    join
		max_rec mr
	where
		rpd.t_confirmed = mr.max_conf
	limit 1) t1
join
	(select 
		date_raw
	from
		rec_p_day rpd
	join
		max_rec mr
	where
		rpd.t_recovered = mr.max_rec
	limit 1) t2
;
/*Connecting the Dots: The "2-Day Lag" Mystery Solved:
Now that you have this list, you have the final piece of the puzzle for your portfolio.
In your previous query, you found a Global Recovery Lag of 2 days. You can now prove why that number was so low:
The Evidence: Your discrepancy column shows hundreds of thousands of "extra" recoveries.
The Analysis: Since these recoveries were likely added in bulk (back-filled) without matching confirmed cases, they created an artificial peak in the recovery data.
The Conclusion: This artificial peak happened closer to the infection peak than the real biological recovery would have, shrinking your DATEDIFF from 14 days down
to 2 days.*/


/* 7. Data Integrity Audit
	Which countries exhibit inconsistencies in reported data, where the sum of recoveries and deaths exceeds total confirmed cases? What is the total magnitude of
    these discrepancies?
 */

with error_count as (select
	country_region, sum(confirmed) as total_confirmed, sum(deaths) as total_deaths, sum(recovered) as total_recovered
from
	covid_data
group by
	country_region
having
	(sum(recovered) + sum(deaths))>sum(confirmed))
select
	e.country_region, e.total_confirmed, e.total_deaths, e.total_recovered, ((e.total_deaths+e.total_recovered)-e.total_confirmed) as discrepancy
from
	error_count e
order by
	discrepancy desc;


/* 8. Trend Smoothing
	What is the 7-day moving average of new cases for key countries such as the United States and India, to account for reporting fluctuations?
 */

select
	t.country_region,
    t.date_raw,
    round(avg(t.daily_cases) over(partition by country_region
						  order by date_raw
                          rows between 6 preceding and current row),0) as seven_day_moving_avg
from
	(select country_region, date_raw, sum(confirmed) as daily_cases
	from covid_data
	where country_region in ('USA','India')
	group by country_region, date_raw) t
;


/* 9. Peak Momentum Identification
	On which date did each country experience its highest number of new daily cases? Was there a period when multiple countries peaked simultaneously, indicating a global surge?
 */

select 
	t2.country_region,
    t2.date_raw,
	t2.cases_per_day
from (select
		t.country_region,
        t.date_raw,
        t.cases_per_day,
        rank() over(partition by t.country_region
					order by t.cases_per_day desc
					) as row_num
	from
		(select country_region,
			date_raw,
            sum(confirmed) as cases_per_day
		from covid_data
		group by country_region, date_raw) t
        ) t2
where
	t2.row_num = 1
order by
	t2.cases_per_day desc;


/* 10. Growth Acceleration (Doubling Rate)
	During the early phase of the pandemic, how quickly did total cases double in size across different continents?
 */

WITH DailyAggregated AS (
    -- Step 1: Squash raw data into daily totals per country
    SELECT 
        country_region, 
        date_raw, 
        SUM(confirmed) AS daily_new_cases
    FROM covid_data
    GROUP BY country_region, date_raw
),	
country_p_day_data AS (SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY country_region ORDER BY date_raw) AS row_num
    FROM (
    -- Step 2: Create the 'Snowball' (Running Total)
    SELECT 
        country_region, 
        date_raw, 
        -- (Running Total)
        SUM(daily_new_cases) OVER(PARTITION BY country_region ORDER BY date_raw) AS cumulative_cases
    FROM DailyAggregated
    ) t
    WHERE cumulative_cases >= 100
),	-- considering threshold 100
cte_base_dates as (select
	t.country_region,
    t.date_raw as base_date,
    t.cumulative_cases
from country_p_day_data t
where
	t.row_num=1),
cte_doubled_dates as (select
	t1.country_region,
    min(t1.date_raw) as final_date
from
	country_p_day_data t1
    join
    cte_base_dates t2 on t1.country_region = t2.country_region
where
	t1.cumulative_cases >= 2*t2.cumulative_cases
group by
	country_region
)
select
	t1.country_region,
	t1.base_date,
    t2.final_date,
    datediff(t2.final_date,t1.base_date) as number_of_days
from
	cte_base_dates t1
    join
    cte_doubled_dates t2 on t1.country_region = t2.country_region
order by
	number_of_days
;


/* 11. Month-over-Month Growth
	How did infection levels change month over month during 2020? Which month experienced the highest rate of growth?
 */

select
	t.months,
    t.confirmed as current_cases,
    nullif(lag(t.confirmed) over w, 0) as previous_cases,
    concat(round((t.confirmed-lag(t.confirmed) over w)/nullif(lag(t.confirmed) over w,0) * 100 , 2), '%') as percent_change
from(select
		month(date_raw) as monthnum,
		monthname(date_raw) as months,
		sum(confirmed) as confirmed
	from
		covid_data
	where
		date_raw <= '2020-12-31'
	group by
		month(date_raw),monthname(date_raw))t
window w as (order by t.monthnum)
order by
	((t.confirmed-lag(t.confirmed) over w)/nullif(lag(t.confirmed) over w,0)) desc;


/* 12. Sustained Decline Analysis
	Which countries managed to achieve a continuous period of at least 14 days of declining new cases, indicating effective control over the spread?
 */

with cte_data_w_prev_conf as (-- creating prev_confirmed column with previous date cases
	select t.country_region,
		t.date_raw,
        t.confirmed,
		lag(t.confirmed) over(partition by country_region order by date_raw) as prev_confirmed
	from (-- creating single values for each date in a country (sum of confirmed from diff provinces)
		select country_region, date_raw, round(sum(confirmed),0) as confirmed from covid_data group by country_region, date_raw) t),
cte_filtered as (-- filtering only rows with declining cases
	select country_region,
		date_raw,
        confirmed
	from cte_data_w_prev_conf
    where prev_confirmed > confirmed
	),
cte_with_group_id as(
-- 3. THE FIX: Assign a "Group ID" to consecutive dates
-- ROW_NUMBER() increments by 1. date_raw increments by 1.
-- If both move together, (date_raw - row_number) stays constant!
	select country_region,
		date_raw,
        date_sub(date_raw , interval row_number() over(partition by country_region order by date_raw) day) as streak_group_id
	from cte_filtered)
select -- finding range lowest to highest in each group 
		country_region,
		min(date_raw)as streak_start_date,
        max(date_raw)as streak_end_date,
        datediff(max(date_raw), min(date_raw))+1 as streak_length
	from
		cte_with_group_id
	group by
		country_region, streak_group_id
	having
		datediff(max(date_raw), min(date_raw))+1 >= 14 -- if range >= 14
	order by
		streak_start_date
;
