/*
DATA ANALYST: INIGO ARBOLEDA
PROJECT: LEBRON ANALYTICS
DATE: SEPT-OCT 2026


QUESTION 3 - Memory vs. data: 
- Were the games I remember most really as big as they felt? 
- Walking down memory lane and reliving the moments I remembered most while being a LeBron fan for so long. But now with data.


Data: 
1. lebron_memory_gamelogs.csv


My memories (I ranked my fav lebron moments before looking at any data or stats to avoid any outside influence):

1. 2016 Finals comeback (Games 5-7). The entire series. Once LeBron and the Cavs started the comeback, the whole story and series was so captivating. In my opinion this reminded me of a david and goliath story. I think/guessing that his stats were around 35 ppg and like 7 reb and 7 assists
2. 2012 ECF Game 6 at Boston. I think his stats were like 30 ppg. and in this game I remember the feeling that he barely missed and had like 40 points I am guessing based off of my memory
3. 2018 playoffs: Indiana game winner, Toronto series, ECF Games 6-7 vs Boston. The last two boston games and also that indiana series game winners and the toronto calling 'lebronto' after he delivered a straight clinic against them. I think he averaged like low to mid 30 ppg and truly remember that he took control of the entire scoring for his team. 
4. 2013 Finals Games 6-7 vs San Antonio. People love to say Ray Allen won that game, but people forget the consecutive points and efficiency scoring performance LeBron had that fourth quarter that opened up the Heat to even compete in a close game for Ray Allen to hit his clutch 3 pointer. Also people forget that the 3 point shot Ray Allen hit, did not win the game but allowed them to go OT. And in OT lebron was the finisher and closer. He then kept it rolling and exploded the next game to win his first ever ring.
I am guessing that LeBron had 30 pts in Game 6
5. Passing Kareem (Feb 2023 vs OKC) LeBron being known for being a pass first player, ends up the number one scorer in the entire nba histroy is insane. Shows how good and complete he is as a player. The dedication to be great on all aspects of the game. If I remember correctly, I think he must have scored about 35 pts this game.


Action 1: setup
	- I am going to add game_type to game_logs, because from the memory csv there will be regular games and playoff games. Having an indication i think will be important because without it, it could seem like the same kind of game. label existing games, import the new games

Action 2: creating 'memories' table
	- create memories table

Action 3: analyze the data
	- joining the newly created table memories to game_logs and comparing my guesses with the real stats
				
Dont forget to right click under diagram, create new diagram, and connect it to desired database
-- if disconnected, click control + 9 to connect to lebron.db
*/

------------------------------------------------------

/* 
 Action 1: setup
	- I am going to add game_type to game_logs, because from the memory csv there will be regular games and playoff games. Having an indication i think will be important because without it, it could seem like the same kind of game. label existing games, import the new games
*/

alter table game_logs
add column game_type varchar(10);

-- the alter table function allows me to change the structure of my table without deleting any data. 

-- checking if new column was succesfully added to the game_logs table
select game_type
from game_logs;

-- yay it worked! there are 230 null rows into the game_type
-- the reason why it is null is because there is no information
-- but what i want to do now is update this table to set the game_type to 'regular'. they are 'regular' games because the data imported into this game_logs table were all from lebron's regular season games. 

update game_logs 
set game_type = 'Regular';

-- the update function changes the data inside the columns that already exist. 
-- the alter table function changes the structure of the table. adding a new column basically.

select game_type
from game_logs;

-- yay, now instead of the 230 rows under game_type being NULL. It is now filled in with text 'Regular'
-- now the table is ready for me to import the lebron_memory_gamelogs.csv 
-- before importing, refresh the game logs table so that dbeaver can update the changes you made. like the alter and update functions that you did.

--data check the import, the alter, the updates
select 
*
from game_logs;
-- nice there are 401 rows/games

select 
	game_type,
	season,
	count(*) as games
from game_logs 
group by game_type,season
order by season;

/*
Regular		2010-11	82
Playoffs		2011-12	23
Regular		2011-12	66
Playoffs		2012-13	23
Regular		2012-13	82
Playoffs		2015-16	21
Playoffs		2017-18	22
Regular		2022-23	82
*/


/*
Action 2: creating 'memories' table
	- create memories table
*/

-- Action 2: CREATING TABLE and Inserting values: memories
CREATE TABLE IF NOT EXISTS memories (
	memory varchar(50) primary key not null,
	memory_rank integer not null,
	start_date date not null,
	end_date date not null,
	my_guess_pts integer
)
;
-- 5 columns

INSERT INTO memories (memory, memory_rank, start_date, end_date, my_guess_pts)
VALUES
	('2016 Finals Comeback', 1, '2016-06-13', '2016-06-19', 35),
	('2012 ECF G6 at BOS', 2, '2012-06-07', '2012-06-07', 40),
	('2018 R1 G5 vs IND', 3, '2018-04-25', '2018-04-25', 32),
	('2018 R2 vs TOR', 3, '2018-05-01', '2018-05-07', 32),
	('2018 ECF G6-7 vs BOS', 3, '2018-05-25', '2018-05-27', 32),
	('2013 Finals G6-7 vs SAS', 4, '2013-06-18', '2013-06-20', 30),
	('Passing Kareem', 5, '2023-02-07', '2023-02-07', 35)
;

--remember single quotes for varchar/text, and for numbers and integers no quotes
--also dates in sql date format is yyyy-mm-dd

select *
from memories;

/*
2016 Finals Comeback		1	2016-06-13	2016-06-19	35
2012 ECF G6 at BOS		2	2012-06-07	2012-06-07	40
2018 R1 G5 vs IND		3	2018-04-25	2018-04-25	32
2018 R2 vs TOR			3	2018-05-01	2018-05-07	32
2018 ECF G6-7 vs BOS		3	2018-05-25	2018-05-27	32
2013 Finals G6-7 vs SAS	4	2013-06-18	2013-06-20	30
Passing Kareem			5	2023-02-07	2023-02-07	35
 */
-- yay the inserting into the newly created table worked!

/* Action 3: analyze the data
	- joining the newly created table memories to game_logs and comparing my guesses with the real stats
*/

-- Action 3: 
select
	m.memory_rank,
	m.memory,
	gl.date as date,
	gl.opp as opponent,
	m.my_guess_pts as guess_pts,
	gl.pts as points
from memories m 
left join game_logs gl on gl.date between m.start_date and m.end_date
order by 
	m.memory_rank,
	gl.date;

/* 
1	2016 Finals Comeback		2016-06-13	GSW	35	41
1	2016 Finals Comeback		2016-06-16	GSW	35	41
1	2016 Finals Comeback		2016-06-19	GSW	35	27
2	2012 ECF G6 at BOS		2012-06-07	BOS	40	45
3	2018 R1 G5 vs IND		2018-04-25	IND	32	44
3	2018 R2 vs TOR			2018-05-01	TOR	32	26
3	2018 R2 vs TOR			2018-05-03	TOR	32	43
3	2018 R2 vs TOR			2018-05-05	TOR	32	38
3	2018 R2 vs TOR			2018-05-07	TOR	32	29
3	2018 ECF G6-7 vs BOS		2018-05-25	BOS	32	46
3	2018 ECF G6-7 vs BOS		2018-05-27	BOS	32	35
4	2013 Finals G6-7 vs SAS	2013-06-18	SAS	30	32
4	2013 Finals G6-7 vs SAS	2013-06-20	SAS	30	37
5	Passing Kareem			2023-02-07	OKC	35	38

findings:
- my 7 memories are in the table and the between operator within the join allowed me to pick up every game within the range.
- from the table, the memories that i was closest on was:
 	- memory 5 'surpassing kareem' vs OKC. I guessed 35 points but he actually scored 38
 	- memory 4 2013 Finals game 6 against the spurs, I guessed 30 points and he actually scored 32 points
 	- memory 3 2018 ECF game 7 vs BOS. I guessed that he scored 32 points but he actually scored 35 points.
 	
 - from the table, the memories that i was most off on was:
 	- memory 3 2018 round 2 game 2 vs TOR. I guessed that he scored 32, but he scored 43 points instead lol. Dominant performance.
 	- memory 3 2018 game 6 vs BOS. I guessed that he scored 32, but he ended up scoring 46 points. He went off those last two games vs BOS this year.
 	- memory 3 2018 round 1 game 5 vs IND. I guessed he scored 32, but ended up scoring 44 points. 
 	- memory 1. Game 7 2016 FINALS vs GSW. I guessed that he had a high scoring game of 35 points, but he actually only scored 27 points. Thinking back to this game, i think the reason why I had guessed such a high scoring game was the feelings i felt. But then i REMEMBER 'the block' that he had. That moment was so breathtaking, and anxiety inducing, stressful, all emotions in one lol. 
 	
 - Based off of these findings, most of my 'offs' were during LeBron's 2018 playoff run. I guessed he scored 30 points, which is REALLY good. But i underestimated this historic 2018 run, and he actually ended up scoring more than i originally guessed.
 - My #1 ranked memory was LeBron’s lowest-scoring game of the three. I realized that I didn’t remember the points. I remembered the block.
 */

-- comparing my guessed points to the actual points. finding the difference.

select
	m.memory_rank,
	m.memory,
	gl.date as date,
	gl.opp as opponent,
	m.my_guess_pts as guess_pts,
	gl.pts as points,
	gl.pts - m.my_guess_pts as pts_diff
from memories m 
left join game_logs gl on gl.date between m.start_date and m.end_date
group by
	m.memory_rank,
	m.memory,
	gl.date,
	gl.opp,
	m.my_guess_pts,
	gl.pts
order by 
	m.memory_rank,
	gl.date
	;

-- last action: get data ready and exported for tableau

create view memory_vs_data as 
select
	m.memory_rank,
	m.memory,
	gl.date as date,
	gl.opp as opponent,
	m.my_guess_pts as guess_pts,
	gl.pts as points,
	gl.pts - m.my_guess_pts as pts_diff
from memories m 
left join game_logs gl on gl.date between m.start_date and m.end_date
order by 
	m.memory_rank,
	gl.date
	;

-- data check if the view was succesfully created
select *
from memory_vs_data;

-- 14 rows, 7 columns










