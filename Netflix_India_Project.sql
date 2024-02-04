--create table 
create table netflix_a(
showid	bigint, name varchar(150),	type varchar(10),	
	rating varchar(100),	duration	varchar(220),
	description	varchar(650),hook_text	varchar(200),
	genre	varchar(150), release_year	int, release_date	date,
	mood_tag	varchar(50), actors	varchar(1500),
	creator	varchar(150), director	varchar(300), audio	varchar(150),
	subtitles	varchar(100), tags	varchar(200), similar_titles_id varchar (150),
	production_country varchar(150));
	
--copy data into the table A
copy netflix_a
from 'C:\Program Files\PostgreSQL\16\Data_copy\netflix_india_\netflixa.csv' delimiter ',' csv header

--create table 
create table netflix_b (showid	bigint, name	varchar(1500), season	varchar(1500),
					release_year int, episode_count	int, synopsis varchar(1500));

--copy data into the table B
copy netflix_b
from 'C:\Program Files\PostgreSQL\16\Data_copy\netflix_india_\netflixb.csv' delimiter ',' csv header

--create table 
create table netflix_c(showid	bigint, name varchar(1500),season	varchar(1500),
		episode_title varchar(1500),runtime	varchar(1500), synopsis varchar(1500));

--copy data into the table C
copy netflix_c
from 'C:\Program Files\PostgreSQL\16\Data_copy\netflix_india_\netflixc.csv' delimiter ',' csv header

--Display data in table A
select *
from netflix_a;

--Display data in table b
select *
from netflix_b;

--Display data in table c
select *
from netflix_c;

--List all data where the type is not TVseries
select *
from netflix_a
where type ='Movie';

--Sum of TV series and Movie in Netflix 
select type, count(type) as "Number of Type"
from netflix_a
where type is not null
group by type;


--which countries produces movie that is posted more on india netflix
select production_country, count (production_country)
from netflix_a
group by production_country
order by count(production_country) desc;

/* Display showId, names of movies, number of season of seasons, number of episotle, type and release year range*/
select distinct bc.*,a.type
from netflix_a as a
right join (select c.showid,c.name, count(distinct c.season) as "Number of Season",
			count(distinct c.episode_title) as "Number of Episode", 
			max(b.release_year)||'-'|| min(b.release_year) as Release_Range
		   from netflix_b as b
		   inner join netflix_c as c
		   on b.showid=c.showid
		 group by c.name,c.showid)as bc
on a.showid = bc.showid
where actors is not null
--group by bc.name, a.type
order by bc.name desc;

-- What movies did Dwayne Johnson take part as an actors
select name, actors--,count(actors)
from netflix_a
where actors like '%Dwayne Johnson%'
--group by name
order by name;

--views is created
create view Netflix as
select a.name,a.rating,a.genre,a.actors,a.audio,/*bc.name,*/bc.season
from netflix_a as a
inner join (select b.showid,b.name,c.season
		   from netflix_b as b
		   inner join netflix_c as c
		   on b.showid=c.showid) as bc
on a.showid= bc.showid
order by a.name;
