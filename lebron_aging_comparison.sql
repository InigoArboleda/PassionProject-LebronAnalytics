/*
DATA ANALYST: INIGO ARBOLEDA
PROJECT: LEBRON ANALYTICS
DATE: SEPT-OCT 2026


CREATING Lebron.db database
	Next: create the database in DBeaver
	Open DBeaver and choose Database → New Database Connection.
	Pick SQLite and click Next.
	Click Create, go to your project's data/processed/ folder, and name the file lebron.db.
	Click Finish.
	
NEXT STEPS: Creating tables
1. players - 4 columns with player_id, player_name, first_season, last_season
		   - Lebron is id 1, Jordan is 2, Kobe is 3
2. per_game - 32 columns
			- .info() in python to get datatypes:
			- int64 is INTEGER
			- float64 is DECIMAL(p,s)
				- REAL is approximate: measurements, stats, averages
				- DECIMAL (p,s) is exact with fixed number of digits. ex. money must add up exactly. p is number of digits and s is how many come after the decimal point. ex (4,1) holds 27.2 and 131.4
			- str is VARCHAR (n)
				- TEXT is the text of any lenght
				- VARCHAR (n) is text up to n characters
LOAD THE DATA: right click the table and choose import data to load the csv
Dont forget to right click under diagram, create new diagram, and connect it to desired database
*/

------------------------------------------------------------

-- ACTION: CREATING TABLE and Inserting values: players
CREATE TABLE IF NOT EXISTS players (
	player_id integer primary key not null,
	player_name varchar(100) not null,
	first_season varchar(100),
	last_season varchar (100)
)
;

INSERT INTO players (player_id, player_name, first_season, last_season)
VALUES
	(1, 'LeBron James', '2003-04', '2025-26'),
	(2, 'Michael Jordan', '1984-85', '2002-03'),
	(3, 'Kobe Bryant', '1996-97', '2015-16')
;
--remember single quotes for varchar/text, and for numbers and integers no quotes
--in here seasons need quotes because they are varchar datatype

-- DATA CHECKING newly players table
select *
from players;

-- ACTION: CREATING TABLE AND INSERTING VALUES: per_game
CREATE TABLE IF NOT EXISTS per_game (
	season	varchar (100) not null,
	age	integer,
	team	 varchar (100),
	lg	varchar (100),
	pos	varchar (100),
	g	integer,
	gs	integer,
	mp	decimal (4,1),
	fg	decimal (4,1),
	fga	decimal (4,1),
	fg_pct	decimal (4,3),
	three_p	decimal (4,1),
	three_pa 	decimal (4,1),
	three_p_pct	decimal (4,3),
	two_p	decimal (4,1),
	two_pa	decimal (4,1),
	two_p_pct	decimal (4,3),
	efg_pct	decimal (4,3),
	ft	decimal (4,1),
	fta	decimal (4,1),
	ft_pct	decimal (4,3),
	orb	decimal (4,1),
	drb	decimal (4,1),
	trb	decimal (4,1),
	ast	decimal (4,1),
	stl	decimal (4,1),
	blk	decimal (4,1),
	tov	decimal (4,1),
	pf	decimal (4,1),
	pts	decimal (4,1),
	awards	varchar (100),
	player_id integer not null,
	primary key(player_id, season),
	foreign key (player_id) references players (player_id)
)
;
-- what i did: opened the csv in excel, copy and pasted and transpose the 32 col headers
-- in a separate sheet, and then i filled in the data types using jupyter notebook and commas, 
-- and then pasted it in dbeaever

--DATA CHECK newly per_game table
select *
from per_game;

-- INSERTING VALUES INTO TABLE per_game
/*
 - Compared to the players table, where it is easier to insert values manually, the per__Game
csv is just too big of a dataset that it will be faster to just import the data. Rather than typing manually.
- Right click on the per_game table and press import data, pick csv and select all_players_per_game.csv from data/processed/ folder you created. Make sure each column matches before proceeding
- once done, do a data check that everything populated correctly.
*/

-- Lets see the data!
select *
from per_game;

-- how many rows?
select count(*)
from per_game;
-- 58 rows
-- count(*) counts rows, hence here it is counting how many rows in the dataset

-- from the dataset, i want to know how many seasons each player played
SELECT 
player_id,
count(*) as seasons
from per_game
group by player_id;

/*
 - count(*) counts rows. so in this query, sql is counting how many times player_id pops up,
 and since i am grouping each of the 3 players from the data, i labeled alias as seasons
 id 1 LeBron: 23 seasons
 id 2 Michael: 15 seasons
 id 3 Kobe: 20 seasons
 */

-------------------------------------------------------------

/* 
OKAY! so now that i have succesfully created my tables for the players 
Lebron, Michael Jordan, and Kobe,  
I have their regular season per_game stats from their entire career.
Now I can start querying to further fragment and magnify this data!
 
BIG PICTURE (from my README): How does Lebron's performance at each age compare to Jordan and Kobe?
 	By the end of this sql round, I want to gain three things:
		- Clear findings such as,"At age 35 and older, LeBron averaged X points while Jordan averaged Y."
		- One clean result table to hand to Tableau for age comparisons charting.
		- Practice SQL skills for my range: joins, grouping, CASE, CTEs and window functions.
		
QUESTIONS (utilized claude to help me come up with these questions/actions):

ACTION 1: Get to know the three careers (JOIN, GROUP BY)
	1. Show each player's name, number of seasons, and career averages for points, rebounds and assists.
	2. What was each player's best scoring season, and how old were they?
	3. What's the oldest age each player played at, and what did they average that season?
	4.  many seasons did each player average over 27 points?

ACTION 2: Compare them at the same age (the core of your question)
	5. Show all three players' points per game at age 30, side by side.
	6. Which ages do all three players have a season for? (Think: Jordan has gaps, and Kobe stopped at 37.)
	7. For each age, who had the highest points per game of the three?
	
ACTION 3: Group the ages into career stages (CASE)
	8. Use CASE to label each season as Early (under 25), Prime (25–29), Veteran (30–34) or Late (35+).
	9. Show each player's average points, rebounds and assists in each stage.
	10. Build your era column for LeBron's seasons with CASE (Cleveland, Miami, Cleveland again, Lakers) and show his averages for each era.

ACTION 4: Measure the decline (CTEs and window functions)
	11.For each player, find their peak scoring season, then show how far below that peak they were at each later age.
	12. Rank each player's seasons from best to worst by points with RANK(). At what ages did their top 5 seasons happen?
	
ACTION 5: Check that the comparison is fair
	13. Show seasons where a player played fewer than 50 games. Should those count the same as full seasons? (Kobe's 6-game season and Jordan's 17- and 18-game seasons will show up here.)
	14. Re-run your "average by career stage" query excluding those short seasons. Does the story change?
	15. Compare games played by age for all three. LeBron's averages stayed high late in his career, but was he on the court as much?

ACTION 6: Build the table for Tableau
	16. Write one final query that returns: player name, age, season, career stage, games, points, rebounds, assists and a flag for short seasons. Save it as a view (CREATE VIEW aging_curve AS ...).
 */

----------------------------------------------------------
/* ACTION 1: Get to know the three careers (JOIN, GROUP BY)
	1. Show each player's name, number of seasons, and career averages for points, rebounds and assists.
	2. What was each player's best scoring season, and how old were they?
	3. What's the oldest age each player played at, and what did they average that season?
	4. How many seasons did each player average over 27 points?*/

-- 1. Show each player's name, number of seasons, and career averages for points, rebounds and assists.
select 
	p.player_name as player_name,
	count(pg.season) as seasons,
	avg(pg.pts) as avg_pts,
	avg(pg.trb) as avg_rb,
	avg(pg.ast) as avg_ast
from players p
left join per_game pg on pg.player_id = p.player_id
group by p.player_name;

-- ROUND function/make the avgs 1 decimal place
select 
	p.player_name as player_name,
	count(pg.season) as seasons,
	ROUND(avg(pg.pts),1) as avg_pts,
	ROUND(avg(pg.trb),1) as avg_rb,
	ROUND(avg(pg.ast),1) as avg_ast
from players p
left join per_game pg on pg.player_id = p.player_id
group by p.player_name;

/*FINDINGS:
Kobe Bryant	20 seasons	24.2	 avgpts 5.2 avgrb 4.8 avgast
LeBron James	 23 seasons	26.7	 avgpts 7.5	avgrb  7.4 avgast
Michael Jordan 15 seasons 29.5 avgpts 6.1 avgrb	5.1 avgast

MJ had the highest avg points, LBJ 2nd and Kobe 3rd
LBJ had the highest avg assits, MJ 2nd and Kobe 3rd
LBJ had the highest avg rebounds, MJ 2nd and Kobe 3rd
LBJ played the most seasons, Kobe 2nd and MJ 3rd
*/

-- 2. What was each player's best scoring season, and how old were they?
	-- i know we have season col but we do not have a col that will give us best scoring season
	-- hence, i will use a CTE so that i can use MAX(pts) for each player
	-- and then use rank window function rank() so that i can rank the pts for each player
	-- i know i am going to need scoring col, age col, playername col, and season col
	-- dont need to use AVG because the data for 'pts' is already the average the player scroed that particular season

--WINDOW RANK FUNCTION version
WITH ppg_ranked AS(
SELECT
	pg.season as season,
	pg.age as age,
	p.player_name as playername,
	pg.pts as pts,
	RANK()OVER(PARTITION BY pg.player_id ORDER BY pg.pts DESC) as pts_rank
FROM per_game pg
LEFT JOIN players p on p.player_id = pg.player_id
)
SELECT
	playername,
	season,
	age,
	pts,
	pts_rank
FROM ppg_ranked
WHERE pts_rank = 1
ORDER BY pts DESC
;
/* 
FINDINGS
Michael Jordan	1986-87	23 yrs old 37.1 ppg
Kobe Bryant	2005-06	27 yrs old 35.4 ppg
LeBron James	 2005-06	 21 yrs old 31.4 ppg

I can see that both Lebron and Kobe's best scoring year were during the 2005-06 season.

- WHERE pts_rank = 1 Makes sure that we query the number one season of each player best scoring season, Without this it will show multiple rows of their scoring season since it is using a ranked window function.
 */

-- 3. What's the oldest age each player played at, and what did they average that season?
WITH ranked AS (
    SELECT
        p.player_name,
        pg.player_id,
        pg.season,
        pg.age,
        pg.g,
        pg.pts,
        pg.trb,
        pg.ast,
        RANK() OVER (PARTITION BY pg.player_id ORDER BY pg.age DESC) AS age_rank
    FROM per_game pg
    JOIN players p ON p.player_id = pg.player_id
)
SELECT
	player_name, 
	season, 
	age, 
	g, 
	pts, 
	trb, 
	ast
FROM ranked
WHERE age_rank = 1
ORDER BY age DESC;

/* 
FINDINGS:
LeBron James	 
	2025-26	 41yrs	60gms	20.9	ppg 6.1rbs	7.2ast
Michael Jordan	
	2002-03	39yrs	82gms	20ppg 	6.1rbs	3.8ast
Kobe Bryant	
	2015-16	37yrs	66gms	17.6ppg 	3.7rbs	2.8ast
	
- Lebron still playing at 41, two yrs diff from MJ and 4 yrs diff from Kobe
- LBJ scored more points than both players in their final seasons
-LBJ has nearly twice the assists than Jordan
- MJ did however play all 82 games at 39 yrs old
- Lebron's row is not his final season, compared to the others. He will play the next upcoming season 2026-27
 
*/

-- 4. How many seasons did each player average over 27 points? 
select
	player_id,
	COUNT(season) as seasons_over_27
from per_game 
where pts > 27
group by player_id
order by seasons_over_27 DESC;

/*
 FINDINGS:
 Lebron 12 seasons out of 23 avg over 27
 Michael Jordan 11 out of 15 seasons avg over 27
 Kobe Bryant 8 out of 20 seasons avg over 27
 */

-----------------------------------------------------------

/* ACTION 2: Compare them at the same age (the core of your question)
	5. Show all three players' points per game at age 30, side by side.
	6. Which ages do all three players have a season for? (Think: Jordan has gaps, and Kobe stopped at 37.)
	7. For each age, who had the highest points per game of the three?
*/

-- 5. Show all three players' points per game at age 30, side by side.
select
	p.player_name,
	pg.season,
	pg.pts,
	pg.age
from per_game pg
left join players p on p.player_id = pg.player_id
where age = 30
order by pts DESC;

/*
FINDINGS:
Kobe Bryant		26.8	ppg 		30yrs
LeBron James	 	25.3	ppg  	30yrs 

- originally i set the where age clause = to 30, but only LBJ and Kobe populated. After researching, MJ was playing baseball from 30 to 32 years old. MJ was retired that year (1993-94)
 */

-- 6. Which ages do all three players have a season for? (Think: Jordan has gaps, and Kobe stopped at 37.)
SELECT 
	age,
	count(*) as players
from per_game
group by age
order by age;

/* 
FINDINGS:
18		1	Kobe only
19–20	2	LeBron and Kobe
21–29	3	All three
30		2	LeBron and Kobe (Jordan retired)
31–34	3	All three
35–37	2	LeBron and Kobe (Jordan retired)
38–39	2	LeBron and Jordan (Kobe had retired)
40–41	1	LeBron only

- this query lets me see what ages do all three players play at. meaning at age 18 (kobe) was the only one from the three that played that young. 19 there are two which is Lebron and Kobe etc.
- and now at 40-41 age, only lebron is left. No one to compare to
so from the query, i now know that i can compare all three at the ages 21-29 and 31-34.
- after 34 yrs old its not all three anymore. Its Lebron vs kobe from 35 to 37 yrs old. From 38 and 39 its Lebron vs MJ
 */

-- 7. For each age, who had the highest points per game of the three?
select
	p.player_name as player,
	pg.age as age,
	max(pg.pts) as top_pts
from per_game pg
left join players p on p.player_id = pg.player_id 
group by pg.pts 
order by pg.age
;

/*
FINDINGS:
- LeBron led at 10 ages, Jordan at 8 and Kobe at 6.
- LeBron was the top scorer early (ages 19-21) and late (ages 35-41).
- Jordan and Kobe led through the middle years (ages 22-34).
  LeBron was not the top scorer of the three at any age in that range.
- Jordan had the highest single mark: 37.1 points per game at age 23.
- From age 35 on, LeBron led every year.
- At 40 and 41, LeBron was the only one of the three still playing.
- At 35-37 he is compared only with Kobe (Jordan was retired).
- At 38-39 he is compared only with Jordan (Kobe had retired).
- Kobe led at 18 only because he was the only one playing at that age. 7.6 ppg, which is not a lot
- Kobe's leads at 22 and 31 came against short Jordan seasons
TAKEAWAY:
In their primes, Jordan and Kobe scored more than LeBron.
What sets LeBron apart is how early he started and how long he lasted.
*/

------------------------------------------------------------

/* ACTION 3: Group the ages into career stages (CASE)
	8. Use CASE to label each season as Early (under 25), Prime (25–29), Veteran (30–34) or Late (35+).
	9. Show each player's average points, rebounds and assists in each stage.
	10. Build your era column for LeBron's seasons with CASE (Cleveland, Miami, Cleveland again, Lakers) and show his averages for each era.
*/

-- 8. Use CASE to label each season as Early (under 25), Prime (25–29), Veteran (30–34) or Late (35+).
select
	pg.player_id,
	p.player_name,
	pg.season,
	pg.age,
	CASE 
		WHEN pg.age < 25 then 'EARLY'
		WHEN pg.age <= 29 then 'PRIME'
		WHEN pg.age <= 34 then 'VETERAN'
		ELSE 'LATE'
		END AS age_grouping
from per_game pg
left join players p on p.player_id = pg.player_id;
/* 
FINDINGS:
24	EARLY
25	PRIME
29	PRIME
30	VETERAN
34	VETERAN
35	LATE
 */

-- 9. Show each player's average points, rebounds and assists in each stage.
WITH avg_per_stage AS(
select
	pg.player_id,
	p.player_name,
	pg.season,
	pg.age,
	pg.pts,
	pg.trb,
	pg.ast,
	CASE 
		WHEN pg.age < 25 then 'EARLY'
		WHEN pg.age <= 29 then 'PRIME'
		WHEN pg.age <= 34 then 'VETERAN'
		ELSE 'LATE'
		END AS age_grouping
from per_game pg
left join players p on p.player_id = pg.player_id
)
select 
	player_name,
	age_grouping,
	COUNT(*) as seasons,
	ROUND(AVG(pts),1) as avg_pts,
	ROUND(AVG(trb),1) as avg_trb,
	ROUND(AVG(ast),1) as avg_ast
from avg_per_stage
group BY 
	player_name,
	age_grouping
order by player_name, age ;


/* FINDINGS:
Kobe Bryant		EARLY	7	21.3	 5.0	 4.1
Kobe Bryant		PRIME	5	29.4	 5.7	 5.3
Kobe Bryant		VETERAN	5	26.9	 5.3	 5.0
Kobe Bryant		LATE		3	17.9	 4.6	 4.9
LeBron James		EARLY	6	27.5	 7.0 6.7
LeBron James		PRIME	5	27.5	 7.5	 7.1
LeBron James		VETERAN	5	26.4	 7.8	 8.1
LeBron James		LATE		7	25.8	 7.6	 7.8
Michael Jordan	EARLY	4	30.8	 5.2	 4.8
Michael Jordan	PRIME	5	32.1	 6.8 6.3
Michael Jordan	VETERAN	4	28.9	 6.3	 4.3
Michael Jordan	LATE		2	21.4	 5.9	 4.5
 
 - prime is usually 25-29 yrs old in the sport
 - Putting the query from previous question inside a CTE, becasue the info i pulled from that is somehting i wanna pull further more.
 - After i have my cte/inner query set up, the outer query is where i ask myself what do i wanna show. what columns, what data, what information will be relevant. the inner query is there so that i can have my temporary dataset. 
 - count(*) as seasons allows me to count how many seasons the player had in that specific age_grouping. For ex. kobe has 7 seasons that fit the EARLY criteria, while LBJ has 6 seasons.
 */

-- 10. Build your era column for LeBron's seasons with CASE (Cleveland, Miami, Cleveland again, Lakers) and show his averages for each era.

with lebron_avg AS (
select
	p.player_name,
	pg.season,
	pg.pts,
	pg.trb,
	pg.ast,
	CASE 
		WHEN pg.season <= '2009-10' then 'Cleveland (1st stint)'
		WHEN pg.season >= '2010-11' and pg.season <= '2013-14' then 'Miami'
		WHEN pg.season >= '2014-15' and pg.season <= '2017-18' then 'Cleveland (2nd stint)'
		ELSE 'Lakers'
		END AS lebron_era	
from per_game pg
left join players p on p.player_id = pg.player_id
where pg.player_id = 1
)
select
	player_name,
	lebron_era,
	COUNT(*) as seasons,
	ROUND(AVG(pts),1) AS avg_pts,
	ROUND(AVG(trb),1) AS avg_trb,
	ROUND(AVG(ast),1) AS avg_ast	
from lebron_avg
group by player_name,lebron_era
order by season
;

/*
FINDINGS:
LeBron James	 Cleveland (1st stint)	7	27.8		7.1	7.0
LeBron James	 Miami					4	26.9		7.6	6.7
LeBron James	 Cleveland (2nd stint)	4	26.1		7.7	8.0
LeBron James	 Lakers					8	26.0		7.7	7.9

what i know:
Cleveland (1st stint)	2003-04 to 2009-10	
Miami					2010-11 to 2013-14		
Cleveland (2nd stint)	2014-15 to 2017-18		
Lakers					2018-19 to 2025-26

- WHERE pg.player_id = 1, is so that I can only get lebron's data. If not, it will show the other player id's/other players.
 */

---------------------------------------------------------------

/* ACTION 4: Measure the decline (CTEs and window functions)
	11. For each player, find their peak scoring season, then show how far below that peak they were at each later age.
	12. Rank each player's seasons from best to worst by points with RANK(). At what ages did their top 5 seasons happen?*/

-- 11. For each player, find their peak scoring season, then show how far below that peak they were at each later age.

with peak as (
SELECT 
	pg.player_id,
	pg.season as peak_season,
	pg.age as peak_age,
	MAX(pg.pts) as peak_scoring
from per_game pg
group by pg.player_id
)
select
	p.player_name,
	pg.season,
	pg.age,
	pg.pts,
	pk.peak_scoring,
	ROUND(pg.pts - pk.peak_scoring,1) as below_peak
from per_game pg
left join peak pk on pk.player_id = pg.player_id 
left join players p on p.player_id = pg.player_id
where pg.age > pk.peak_age
order by p.player_name, pg.age
;

/* FINDINGS:
- LeBron peaked at 31.4 (age 21) but stayed within about 6 points of it. from age 22 to 39. At 37 he scored 30.3, just 1.1 below his peak.
  
- Jordan peaked at 37.1 (age 23) and was 17.1 below it in his last season (39).

- Kobe peaked at 35.4 (age 27) and was 17.8 below it in his last season (37).
*/

-- 12. Rank each player's seasons from best to worst by points with RANK(). At what ages did their top 5 seasons happen?

WITH ranked AS (
    SELECT
        p.player_name,
        pg.season,
        pg.age,
        pg.pts,
        RANK() OVER (PARTITION BY pg.player_id ORDER BY pg.pts DESC) AS pts_rank
    FROM per_game pg
    JOIN players p ON p.player_id = pg.player_id
)
SELECT player_name, pts_rank, season, age, pts
FROM ranked
WHERE pts_rank <= 5
ORDER BY player_name, pts_rank;

/* FINDINGS:
- Jordan's and Kobe's top 5 scoring seasons all came in their 20s (ages 22-29).
- LeBron's top 5 range from age 21 to 38. His 2nd best scoring season (30.3) came at 37. and his 5th best (28.9) at 38.
- Two of LeBron's best scoring seasons came at ages neither Jordan nor Kobe ever reached as top scorers.
- shows me lebron's longevity and consistency over the years.
*/

-------------------------------------------------------------

/* ACTION 5: Check that the comparison is fair
	13. Show seasons where a player played fewer than 50 games. Should those count the same as full seasons? (Kobe's 6-game season and Jordan's 17- and 18-game seasons will show up here.)
	14. Re-run your "average by career stage" query excluding those short seasons. Does the story change?
	15. Compare games played by age for all three. LeBron's averages stayed high late in his career, but was he on the court as much? */

-- 13. Show seasons where a player played fewer than 50 games. Should those count the same as full seasons? (Kobe's 6-game season and Jordan's 17- and 18-game seasons will show up here.)

select 
	p.player_name as player,
	pg.season as season,
	pg.g as games,
	pg.age as age,
	pg.pts as pts
from per_game pg
left join players p on p.player_id = pg.player_id
where pg.g < 50
order by pg.g;

/* FINDINGS:
Kobe Bryant		2013-14	6g	35yrs	13.8ppg
Michael Jordan	1994-95	17g	31yrs	26.9ppg
Michael Jordan	1985-86	18g	22yrs	22.7ppg
Kobe Bryant		2014-15	35g	36yrs	22.3ppg
LeBron James		2020-21	45g	36yrs	25ppg
Kobe Bryant		1998-99	50g	20yrs	19.9ppg

Research:
- Kobe 2013-14 (6 games): injury
- Jordan 1994-95 (17 games): came back from retirement late in the season
- Jordan 1985-86 (18 games): broken foot
- Kobe 2014-15 (35 games): injury
- LeBron 2020-21 (45 games): injury, in a season shortened to 72 games
- Kobe 1998-99 (50 games): not a short season. The whole league only played 50 games that year because of a lockout, and he played all of them.

I think to answer the question, I do not think these seaons should count the same.
*/

-- 14. From question 9, Re-run the "average by career stage" query excluding those short seasons. Does the story change?
WITH avg_per_stage AS(
select
	pg.player_id,
	p.player_name,
	pg.season,
	pg.age,
	pg.pts,
	pg.trb,
	pg.ast,
	CASE 
		WHEN pg.age < 25 then 'EARLY'
		WHEN pg.age <= 29 then 'PRIME'
		WHEN pg.age <= 34 then 'VETERAN'
		ELSE 'LATE'
		END AS age_grouping
from per_game pg
left join players p on p.player_id = pg.player_id
where pg.g >= 50
)
select 
	player_name,
	age_grouping,
	COUNT(*) as seasons,
	ROUND(AVG(pts),1) as avg_pts,
	ROUND(AVG(trb),1) as avg_trb,
	ROUND(AVG(ast),1) as avg_ast
from avg_per_stage
group BY 
	player_name,
	age_grouping
order by player_name, min(age) ;


/* FINDINGS:
- The significance of this question is to see what would happen to our observations if we were to focus on seasons that were not impacted with injuries and/or shortened seasons. 
- The main finding didn’t change: LeBron’s scoring stayed flat while Jordan’s and Kobe’s dropped
- Lebron's avg barely moved. Only in his LATE stage did his ppg go from 25.8 to 25.9
- Under 50 games is considered as short seasons. Hence, 50 games and above is opposite.
- I queried this by including a where clause in the inner cte query that pulls games 50 or more. 
 */

--	15. Compare games played by age for all three. LeBron's averages stayed high late in his career, but was he on the court as much? 

select
	p.player_name as player,
	pg.age as age,
	pg.g as games,
	pg.pts as points
from per_game pg
left join players p on p.player_id = pg.player_id
where pg.age >= 30
order by pg.age, p.player_name;

/* FINDINGS:
- LeBron's games dropped from 77 games per season before 30 to 6 1games from age 35 on.
- His per-game scoring stayed high late, but he missed about a quarter of each season.
- Kobe played far less after 35 (36 games per season)
- Jordan played more games at 38-39 (60 and 82) but scored less (22.9 and 20.0).
- Takeaway: LeBron's late-career story is strong per game, with less availability.
*/


-- 15b. Average games per season, by career stage
SELECT
    p.player_name AS player,
    CASE
        WHEN pg.age < 30 THEN 'Under 30'
        WHEN pg.age <= 34 THEN '30-34'
        ELSE '35+' END AS age_group,
    COUNT(*) AS seasons,
    ROUND(AVG(pg.g), 1) AS avg_games
FROM per_game pg
JOIN players p ON p.player_id = pg.player_id
GROUP BY player, age_group
ORDER BY player, MIN(pg.age);

/* FINDINGS:
Kobe Bryant		Under 30		12 seasons	72.2 avg games
Kobe Bryant		30-34		5			74.6
Kobe Bryant		35+			3			35.7
LeBron James		Under 30		11			76.5
LeBron James		30-34		5			71.2
LeBron James		35+			7			60.6
Michael Jordan	Under 30		9			74.1
Michael Jordan	30-34		4			65.8
Michael Jordan	35+		    2			71.0

- Lebron was not on the court as much.
- He averaged about 61 games a season from age 35 on, compared with about 77 before 30.
- From 34 to 38 he never played more than 67 games in a season.
- So his late-career scoring was strong when he played, but he missed about a quarter of each season.


- Kobe played far less after 35 (about 36 games a season), so LeBron was much more available than him.
- Jordan played 60 and 82 games at 38 and 39, more per season than LeBron at those ages. But that’s only two seasons, and he scored less (22.9 and 20.0).

Research
- Two of LeBron’s seasons were short during 2011-12 (66 games, NBA lockout) and 2020-21 (72 games, COVID). 
 */

----------------------------------------------------------------------

/* ACTION 6: Build the table for Tableau
	16. Write one final query that returns: player name, age, season, career stage, games, points, rebounds, assists and a flag for short seasons. Save it as a view (CREATE VIEW aging_curve AS ...).
 */
CREATE VIEW  IF NOT EXISTS aging_curve AS
select
	p.player_id as id,
	p.player_name as player_name,
	pg.age as age,
	pg.season as season,
	pg.g as games,
	pg.pts as points,
	pg.trb as rebounds,
	pg.ast as assists,
	CASE 
		WHEN pg.age < 25 then 'EARLY'
		WHEN pg.age <= 29 then 'PRIME'
		WHEN pg.age <= 34 then 'VETERAN'
		ELSE 'LATE'
	END as age_grouping,
	CASE
		WHEN pg.g < 50 then 'YES' 
		ELSE 'NO' END as short_season
from per_game pg
left join players p on p.player_id = pg.player_id
;

/*
 I created the final query to get a final data set for my next visual steps!
 - The CREATE VIEW is similar to creating a new table within my database. Moreso a 'saved query' that i can use and query from like a table. Populates under the 'views' folder in the database folder.
 - From this query i added a 'short season' column to let me know if that player in that specific year/season played more or less than 50 games.
 -- I also created another column 'age_grouping' that allows me to give visibility whether in that particalur season or year if specified player was in their: EARLY, PRIME, VETERAN, or LATE stages of their career.
 */

--DATA CHECK:
select *
from aging_curve;

-- export the data, right click the dataset and export data into my processed data folder aging_curve.csv





