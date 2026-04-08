use covid;
SELECT * FROM population_data limit 3;

# 1
select * from population_data where country_name like 'Baha%';

update population_data
set country_name = 'Bahamas'
where country_name = 'Bahamas, The';

# 2
select * from covid_data limit 2;
SELECT * FROM population_data 
WHERE country_code IN ('MMR', 'BUR', 'MM');

update covid_data
set country_region = 'Myanmar',
	province = 'Myanmar'
where country_region = 'Burma' or province = 'Burma';

select * from covid_data where country_region = 'myanmar';


# 3
select * from population_data where Country_name like 'Brunei Darussalam';

update covid_data
set country_region = 'Brunei Darussalam'
where country_region = 'Brunei';


# 4
select * from population_data where country_name like 'congo%';

update population_data
set country_name = 'Congo (Kinshasa)'
where country_code = 'COD';

update population_data
set country_name = 'Congo (Brazzaville)'
where country_code = 'COG';


# 5
select * from population_data where country_name like 'egy%';
update population_data
set country_name = 'Egypt'
where country_code = 'EGY';

# 6
select * from population_data where country_name like 'U%';
update population_data
set country_name = 'USA'
where country_code = 'USA';

update covid_data
set country_region = 'USA'
where country_region = 'US';

# 7
select * from population_data where country_name like 'Ir%';
update population_data
set country_name = 'Iran'
where country_code = 'IRN';


# 8
select * from population_data where country_name like 'Gambi%';
update population_data
set country_name = 'Gambia'
where country_code = 'GMB';


# 9
select * from population_data where country_name like 'Tu%';
update population_data
set country_name = 'Turkey'
where country_code = 'TUR';


# 10
select * from covid_data where country_name like 'holy%';
update covid_data
set country_region = 'Vatican City'
where country_region = 'Holy See';


# 11
select * from population_data where country_name like 'korea%';
update population_data
set country_name = 'North Korea'
where country_code = 'PRK';

update population_data
set country_name = 'South Korea'
where country_code = 'KOR';

update covid_data
set country_region = 'South Korea'
where country_region = 'Korea, South';


# 12
select * from population_data where country_name like 'kyr%';
update population_data
set country_name = 'Kyrgyzstan'
where country_code = 'KGZ';


# 13
select * from population_data where country_name like 'rus%';
update population_data
set country_name = 'Russia'
where country_code = 'RUS';


# 14
select * from population_data where country_name like 'lao%';
update population_data
set country_name = 'Laos'
where country_code = 'LAO';

# 15
select * from population_data where country_name like 'ms zaa%';
select * from covid_data where country_region = 'ms zaandam';
# it is not even a country
delete from covid_data where country_region = 'ms zaandam';


# 16
select * from population_data where country_name like 'mic%';
update population_data
set country_name = 'Micronesia'
where country_code = 'FSM';


# 17
select * from population_data where country_name like 'st%';
update covid_data
set country_region = 'St. Kitts and Nevis'
where country_region = 'Saint Kitts and Nevis';


# 18
select * from population_data where country_name like '%vincent and %';
update covid_data
set country_region = 'St. Vincent and the Grenadines'
where country_region = 'Saint Vincent and the Grenadines';


# 19
select * from population_data where country_name like '%lucia';
update covid_data
set country_region = 'St. Lucia'
where country_region = 'Saint Lucia';


# 20
select * from population_data where country_name like '%slovak%';
update population_data
set country_name = 'Slovakia'
where country_name = 'Slovak';


# 21
select * from population_data where country_name like '%somal%';
update population_data
set country_name = 'Somalia'
where country_code = 'SOM';


# 22
select * from population_data where country_name like '%syri%';
update population_data
set country_name = 'Syria'
where country_code = 'SYR';


# 23
select * from population_data where country_name like '%VENE%';
update population_data
set country_name = 'Venezuela'
where country_code = 'VEN';


# 24
select * from population_data where country_name like '%yeme%';
update population_data
set country_name = 'Yemen'
where country_code = 'YEM';

commit;

# covid_data and population_data had 27 mis-match columns
/* TAIWAN(not recoganized as nation), Vatican City(very low population), 
is not in the population dataset
 */