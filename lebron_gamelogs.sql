/*
DATA ANALYST: INIGO ARBOLEDA
PROJECT: LEBRON ANALYTICS
DATE: SEPT-OCT 2026


QUESTION 2 - Responding to failure:
1. How does he play after a loss?
2. What changed after the 2011 Finals?
3. Comparing his eras: Cleveland, Miami, Cleveland again, the Lakers

Data: lebron_gamelogs.csv (2010-11, 2011-12, 2012-13 regular season game logs)


NEXT STEPS: Creating tables
1. game_logs - 37 columns, 230 rows 


LOAD THE DATA: right click the table and choose import data to load the csv
- I like to copy and paste transpose the columns using excel. And then I fill out the data types with commas and other values to be an easy and consistent importing of data.
- I also like to look at my python notebook using either games.info() or games.dtypes() to help me fill out the datatypes of the columns
	- .info() in python to get datatypes:
			- int64 is INTEGER
			- float64 is DECIMAL(p,s)
			- REAL is approximate: measurements, stats, averages
				- DECIMAL (p,s) is exact with fixed number of digits. ex. money must add up exactly. p is number of digits and s is how many come after the decimal point. ex (4,1) holds 27.2 and 131.4
			- str is VARCHAR (n)
				- TEXT is the text of any length
				- VARCHAR (n) is text up to n 
				
Dont forget to right click under diagram, create new diagram, and connect it to desired database
-- if disconnected, click control + 9 to connect to lebron.db
*/

--------------------------------------------

-- ACTION: Creating table and loading import data: game_logs

CREATE TABLE IF NOT EXISTS game_logs(
	rk			integer ,
	gcar			integer ,
	gtm			integer ,
	date 		date	 not null ,
	team			varchar (100) ,
	home_away	varchar (100) ,
	opp			varchar (100) ,
	mp			decimal (4,2) ,
	fg			integer	,
	fga			integer	,
	fg_pct		decimal (4,3) ,
	three_p		integer	,
	three_pa		integer	,
	three_p_pct	decimal (4,3) ,
	two_p		integer	,
	two_pa		integer	,
	two_p_pct	decimal (4,3) ,
	efg_pct		decimal (4,3) ,
	ft			integer	,
	fta			integer	,
	ft_pct		decimal (4,3) ,
	orb			integer	,
	drb			integer	,
	trb			integer	,
	ast			integer	,
	stl			integer	,
	blk			integer	,
	tov			integer	,
	pf			integer	,
	pts			integer	,
	gmsc	 		decimal (4,1) ,
	plus_minus	integer	,
	status		varchar (100) ,
	started		varchar (100) ,
	win_loss		varchar (100) ,
	score		varchar (100) ,
	season		varchar (100) ,
	primary key (date)
)
;

-- IMPORTING DATA: Since I already have my csv file dataset, I will just import the data into my newly created table: game_logs
/* A fix i need to make is that after looking at the dataset imported, the 13 games that lebron did not play, the stat columns should be NULL so that it wont affect the averages. BUT, it looks like dbeaver stored the imported csv as empty text ('') instead. 
 * this is problematic because avg() skips null and avg() counts '' as 0. Which will impact the true numbers.
 * so for example, the 13 missing games basically says that lebron scored 0 points.
 * WHAT I DID: re-imported the csv data, but i checked off the option 'set empty strings to null' which allowed me to replace any missing data as null. */

-- data checking:
select *
from game_logs;


-- how many games did Lebron play in each of the three seasons
select 
	season,
	count(*) as games
from game_logs 
group by season;

/*
2010-11	82 games
2011-12	66 games
2012-13	82 games
  */

-- how many games did Lebron play and not pay
select
	status,
	count(*) as games
from game_logs
group by status;

/*
Did Not Dress	7
Did Not Play	 	4
Inactive	 		2
Played			217
*/

-- How many games did lebron play in each of the three seasons and what did he average points?

SELECT season,
       COUNT(pts) AS games_played,
       ROUND(AVG(pts), 1) AS avg_pts
FROM game_logs
GROUP BY season;

/* FINDINGS:
2010-11	79 games 26.7 ppg
2011-12	62 games	 27.1 ppg
2012-13	76 games 26.8 ppg
*/

--------------------------------------------------------------
/* QUESTION 2 - Responding to failure:
1. How does he play after a loss?
2. What changed after the 2011 Finals?
3. Comparing his eras: Cleveland, Miami, Cleveland again, the Lakers

Action 1 : How does he play after a loss?
1. I want to label each game with the previous game’s result. Using window function, LAG(win_loss), to add a prev_result column. Partition by season, so the first game of each season isn’t compared with the last game of the season before.
2. I want to compare his averages after a loss vs. after a win. Points, rebounds, assists, Game Score and FG%, using only games he played.
3. Check this by season. Does the pattern hold in each of the three seasons?
4. Does his team bounce back? How often did the Heat win the game after a loss, compared with the game after a win?

Action 2: What changed after the 2011 Finals?
5. Compare season averages for 2010-11 (before) vs. 2011-12 and 2012-13 (after): points, FG%, 3-point attempts, assists, rebounds, minutes and Game Score.
6. Make sure to create a new column labeling “Before” and “After” with CASE, and compare the two groups directly.

Action 3: Final table for Tableau
7. Create a view with each game, its prev_result and the Before/After label, then export it as a CSV. 
*/
-----------------------------------------------------------------

-- 1. I want to label each game with the previous game’s result. Using window function, LAG(win_loss), to add a prev_result column. Partition by season, so the first game of each season isn’t compared with the last game of the season before.

select
	date,
	season,
	opp as opponent,
	win_loss,
	status,
	pts,
	LAG(win_loss) OVER (PARTITION BY season) AS prev_result
from game_logs
order by date
;


/* Breakdown of query:
- the LAG window function lets you see the previous row value.
- so here the PARTITION BY tells sql to run the LAG window function for each season. 
- And then the ORDER BY clause at the end that sorts the data from earliest to latest.
*/

-- 2. I want to compare his averages after a loss vs. after a win. Points, rebounds, assists, Game Score and FG%, using only games he played.

with games as (
select
	date,
	season,
	opp as opponent,
	win_loss,
	status,
	pts as points,
	trb as rebounds,
	ast as assists,
	gmsc as game_score,
	fg_pct as fg_pct,
	LAG(win_loss) OVER (PARTITION BY season) AS prev_result
from game_logs
order by date
)
SELECT
	prev_result,
	count(*) as games,
	round(avg(points),1) as avg_pts,
	round(avg(rebounds),1) as avg_rbs,
	round(avg(assists),1) as avg_ast,
	round(avg(game_score),1) as avg_gamescore,
	round(avg(fg_pct),3) as avg_fg
from games
where status = 'Played' and prev_result IS NOT NULL
group by prev_result;

/* Findings:
L	55 games 	
	27.4 avg_pts	 
	7.3 avg_rbs	 
	6.9	 avg_ast 
	22.9 avg_gamescore	
	0.533 avg_fg

W	159 games	
	26.6	 avg_pts 
	8.0 avg_rbs	 
	6.9 avg_ast 	
	23.0	 avg_gamescore 
	0.539 avg_fg

Breakdown of query:
- the count (*) counts all the 214 rows. This shows me that Lebron played 214 games from the three seasons 2010-2013. Using the count(*) aggregation allows me to compare and contrast his peformance for L's and W's
- Turned the previous query into a CTE so that i could create that temporary dataset to pull his averages from.
- in the WHERE clause I have 'and prev_result IS NOT NULL'. If i dont have this it will give me row full of NULL stats. Which i do not want. I only want games the he's played. Whether he loss or won the game. Two rows.
- 'Game score' significance: It is a single number that rates how good one game was overall. It punishes mistakes and rewards efficiency. For ex. if Lebron scores 30 but has a terrible field goal pct and a lot of turnovers, that doesnt really mean he had a good game. 
	- Having the game score shows me how well LeBron played overall after a loss compared with after a win
	
Further research: 
- Game score adds the good things: points, made shots, rebounds, assists, steals, blocks and subtracts the bad things: missed shots, missed free throws, turnovers, fouls

Game Score
About 10	 	An average game for a typical NBA player
20+			A very good game
30+			An excellent game
40+			An outstanding, rare game

- Lebron averaging about 23 game score across these three seasons shows his consistency and efficiency. His typical/regular game was always a very good game statistically.
*/

-- 3. Check this by season. Comparing lebron's averages after a loss and after a win, for each season. Does the pattern hold in each of the three seasons?

with games as (
select
	date,
	season,
	opp as opponent,
	win_loss,
	status,
	pts as points,
	trb as rebounds,
	ast as assists,
	gmsc as game_score,
	fg_pct as fg_pct,
	LAG(win_loss) OVER (PARTITION BY season) AS prev_result
from game_logs
)
SELECT
	season,
	prev_result,
	count(*) as games,
	round(avg(points),1) as avg_pts,
	round(avg(rebounds),1) as avg_rbs,
	round(avg(assists),1) as avg_ast,
	round(avg(game_score),1) as avg_gamescore,
	round(avg(fg_pct),3) as avg_fg
from games
where status = 'Played' and prev_result IS NOT NULL
group by
	season,
	prev_result
order by 
	season,
	prev_result;

/* Findings:
season	win/loss		games	avg_pts	avg_rbs	avg_ast	avg_gsc	avg_fg
2010-11		L		22  		28.5		7.0		6.8		23.2		0.53
2010-11		W		56  		25.9		7.7		7.2		21.3		0.499
2011-12		L		18		26.7		7.5		6.2		21.4		0.522
2011-12		W		43		27.1		8.1		6.3		23.3		0.537
2012-13		L		15		26.6		7.3		8.1		24.3		0.55
2012-13		W		60		26.9		8.2		7.1		24.4		0.577

Breakdown of query:
- I used the same query from last question, but i added the season column, and edited both group by and order by
- the query prints out a L and W row per each season with visibility on Lebron's stats for each L and W for each season.


Answering the question:
Does the pattern hold? Not really. It only shows up in 2010-11.
- 2010-11: after a loss he scored 2.6 more points and had a higher Game Score (23.2 vs 21.3).
- 2011-12 and 2012-13: almost no difference after a loss vs after a win.
- Possible observation is that in his first Miami season (heavy criticism), losses fired him up but the difference is not too significant to even back up this statement 
- Small samples: only 15-22 games after a loss per season.
- prev_result col is not a win_loss col. Meaning that the L row are games that came right after a loss. And the W row are games that came right after a win.
- so, in 2010-11 in the 22 games following a loss, Bron avg 28.5 ppg and in the 56 games following a win he avg 25.9 ppg
*/

-- UPDATED 3. CASE WHEN to relabel the window function column
with games as (
select
	date,
	season,
	opp as opponent,
	win_loss,
	status,
	pts as points,
	trb as rebounds,
	ast as assists,
	gmsc as game_score,
	fg_pct as fg_pct,
	CASE 
	WHEN LAG(win_loss) OVER (PARTITION BY season order by date) = 'L' then 'After a loss'
	WHEN LAG(win_loss) OVER (PARTITION BY season order by date) = 'W' then 'After a win'
	END AS prev_result
from game_logs
)
SELECT
	season,
	prev_result,
	count(*) as games,
	round(avg(points),1) as avg_pts,
	round(avg(rebounds),1) as avg_rbs,
	round(avg(assists),1) as avg_ast,
	round(avg(game_score),1) as avg_gamescore,
	round(avg(fg_pct),3) as avg_fg
from games
where status = 'Played' and prev_result IS NOT NULL
group by
	season,
	prev_result
order by 
	season,
	prev_result;

/* Findings: Updated query result sample set
 2010-11		After a loss		22
2010-11		After a win		56
2011-12		After a loss		18
2011-12		After a win		43
2012-13		After a loss		15
2012-13		After a win		60
*/

-- 4. Does his team bounce back? How often did the Heat win the game after a loss, compared with the game after a win?
with games as (
select
	season,
	win_loss,
	status,
	CASE 
	WHEN LAG(win_loss) OVER (PARTITION BY season order by date) = 'L' then 'After a loss'
	WHEN LAG(win_loss) OVER (PARTITION BY season order by date) = 'W' then 'After a win'
	END AS prev_result
from game_logs
)
select
	season,
	prev_result,
	count(*) as games,
	sum(Case when win_loss = 'W' then 1 else 0 end) as wins,
	ROUND(100.0 * SUM(CASE WHEN win_loss = 'W' THEN 1 ELSE 0 END) / COUNT(*), 1) AS win_pct
from games
where status = 'Played' 
and prev_result is not NULL 
group by season,prev_result
order by season,prev_result;



/* Findings:
2010-11	After a loss		22	14	63.6
2010-11	After a win		56	43	76.8
2011-12	After a loss	 	18	12	66.7
2011-12	After a win		43	32	74.4
2012-13	After a loss		15	12	80.0
2012-13	After a win		60	48	80.0


- 2010-11: Bron played better after losses (question 3) but the team only won 63.6% of thos games. His response did not really translate into team wins
- 2011-12: 
- 2012-13: 80% win rate after a loss and after a win. A loss did not affect them at all.
	- I remember that this was the season they had 27 game winning streak
- The heat's win rate after a loss increased every season. From 63.6 to 66.7 to 80. The team got better at responding to losses as they grew into a championship team.


Breakdown of query:
- I want to find the rows where the Heat won.
- Using the sum + case when to add up the rows that fit the condition of my case when
- reads it as give each win a 1 and each loss a 0. then sum it up
- for 2010-11 loss row. In the 22 games that season that followed a loss, the heat won 14 and lost 8. hence, 14/22 = 63.6%
 */
-------------------------------------------

-- Action 2: What changed after the 2011 Finals?
-- 5. Compare season averages for 2010-11 (before) vs. 2011-12 and 2012-13 (after): points, FG%, 3-point attempts, assists, rebounds, minutes and Game Score.


-- 6. Make sure to create a new column labeling “Before” and “After” with CASE, and compare the two groups directly.





