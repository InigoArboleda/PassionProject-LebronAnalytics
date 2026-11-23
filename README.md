# 14 Years of LeBron: A Fan's Data Story

In 5th grade I got cut from my school’s basketball team. I remember crying so hard that my mom felt so bad for me that she marched back into the gym with me to ask the coach if there was any other way. (There wasn’t lol)

So I got to work. Back then I couldn’t even run one lap around the gym without almost physically dying. And so I hooped before school, after school, and watched Lebron highlights. I was determined that whatever I had to do for me to never experience being rejected from my school’s basketball team again, that I will work harder than those already on the team. The next year I made the team as the 3rd pick: the smallest guy there, and the only Asian kid, so yes, I heard every Jeremy Lin joke. Meanwhile Lebron was having his own comeback year, going from “choker” in the 2011 finals to champion the following year.

I have watched every Lebron game since, from 11 years old to 25. Being a Lebron fan in Chicago meant years of trash talk from classmates, plenty of stressful playoff games, and basketball that brought me and my dad closer. Now I am using data to check the receipts on my 14 years of fandom.

## Questions
1. **The aging comparison:** How does LeBron's performance at each age compare to Jordan and Kobe?
2. **Responding to failure:**
   - How does he play after a loss?
   - What changed after the 2011 Finals?
3. **Memory vs. data:** Were the games I remember most really as big as they felt? Walking down memory lane and reliving the moments I remembered most while being a LeBron fan for so long. But now with data.


## Tableau Dashboard link: 
- https://public.tableau.com/app/profile/inigo.arboleda/viz/LebronAnalytics/LeBronDashboard
<a href="https://public.tableau.com/app/profile/inigo.arboleda/viz/LebronAnalytics/LeBronDashboard">
  <img src="d5.%20LeBron%20Dashboard.png" width="800" alt="14 Years of LeBron Tableau dashboard">
</a>


## Datasource/Dataset that I am pulling from: 
- [Basketball-Reference.com](https://www.basketball-reference.com/players/j/jamesle01.html): season stats and game logs, 2003–present

## What I built
- **Data:** 13 CSV files from Basketball-Reference (LeBron, Jordan and Kobe season stats, as well as LeBron regular and playoff game logs)
- **Python:** 4 data cleaning notebooks
- **SQL:** a SQLite database I designed (4 tables, 3 views), with 20+ analysis queries using and practicing joins, CTEs, CASE and window functions
- **Tableau:** 6 charts and a published, interactive dashboard

  
## Tools
 Tool | What I used it for 
 
- Excel | First look at the raw data |
  
- Python (Jupyter, pandas) | Cleaning data and loading it into SQLite |
  
- SQL (SQLite, DBeaver) | Creating Lebron database, fragmenting and magnifying the data, peeling the onion, answering the questions |
  
- Tableau | Dashboards and visuals, painting the story |
  
- Claude | Utilized for planning and debugging |
  
- GitHub, Google Docs | Documentation |


## About the data
See the [data dictionary](Data%20Dictionary.md)


## Findings

### 1. The aging comparison: LeBron vs. Jordan vs. Kobe
[View the interactive chart on Tableau Public]
https://public.tableau.com/app/profile/inigo.arboleda/viz/LebronAnalytics/LeBronDashboard

**Jordan and Kobe were the better scorers at their peaks. But, LeBron's edge is that he barely declined.**

| Career stage | LeBron | Jordan | Kobe |
|---|---|---|---|
| Early (under 25) | 27.5 | 30.8 | 21.3 |
| Prime (25–29) | 27.5 | 32.1 | 29.4 |
| Veteran (30–34) | 26.4 | 28.9 | 26.9 |
| Late (35+) | 25.8 | 21.5 | 17.9 |

- *Points per game, averaged across the seasons in each stage.*

- *Table references question 14 from SQL script. Lines 633-672*

- *Jordan dropped about 10 points from his prime to his late career, and Kobe about 11. LeBron dropped less than 2 points across his entire 23 season career.*
**What stood out to me:**
- Jordan and Kobe peaked in their 20s. All of their top 5 scoring seasons came between ages 22 and 29.
- LeBron's top 5 seasons came between ages 21 to 38. His 2nd best scoring season (30.3) was when he was 37, which is older than Kobe ever played.
- LeBron never drastically dropped his averages. He stayed within about 6 points of his peak from age 22 to 39. Jordan and Kobe each finished more than 17 points below theirs.
- His game changed as he aged. His assists went up from 6.7 assists per game in his early 20s to about 8 apg in his 30s.
- LeBron was the top scorer of the three at ages 19–21 and every age from 35 on. Jordan and Kobe owned the middle years (22–34).

**Availability**
LeBron's late career numbers are strong per game, but he played less. He averaged about 77 games a season before 30 and about 61 from age 35 on, missing roughly a quarter of each season.

**How I 'unbias' the comparisons between the players:**
- I checked which ages all three players actually have seasons for. Jordan missed age 30 and 35 to 37 to retirement, and Kobe retired at 37. After 39, LeBron has no one left to compare to.
- I re ran the comparison without injury shortened seasons (under 50 games). The main finding didn't change.
- I counted a 50 game season as full and under 50 games as short seasons. For example, the whole league only played 50 games (the 1998-99 lockout).

**What this means to me as a LeBron fan:**
I became a fan in 2012-13, when LeBron was 28. Based off of the data and my findings, the data shows that I started watching right before the part of his career that made him different: not his peak, but how long he held it.

### 2. Responding to failure: after losses, and after the 2011 Finals

**The short version:** After the 2011 Finals, LeBron didn't score more. He scored smarter, and that's when the Heat won two titles.

**What changed after the 2011 Finals**

| | Before (2010-11) | After (2011-12 and 2012-13) |
|---|---|---|
| Points per game | 26.7 | 26.9 |
| Field goal % | 51.0% | 54.9% |
| Shots per game | 18.8 | 18.3 |
| Turnovers | 3.6 | 3.2 |
| Game Score | 21.7 | 23.7 |

- His scoring stayed the same, but he got there on fewer shots, with better shooting and fewer turnovers.
- He moved his shots closer to the basket: shots at the rim went from 28% to 37% of his attempts, and long 2-pointers dropped from 26% to 20%.

**How he played after a loss**
- In 2010-11, he scored 2.6 more points after a loss (28.5 vs. 25.9) and had a higher Game Score.
- In the two title seasons, there was almost no difference. He played the same whether his team had just won or lost.
- My read: in his first Miami season, losses fired him up. By the title years, his level stayed the same no matter what.

**How the team bounced back**
- The Heat won 64% of games after a loss in 2010-11, 67% in 2011-12, and 80% in 2012-13. They got better at responding to losses every season.
- In 2012-13 (the year of their 27-game winning streak), a loss didn't affect them at all: 80% after a loss and 80% after a win.

**How I kept it fair**
- I kept the games LeBron missed, so "the previous game" is always the team's last game, even if he sat out.
- I caught that importing the data had turned missing games into zeros (empty text, not NULL), which made his averages look about a point lower. I fixed it before analyzing.

**What this means to me as a fan:**
- Getting into Lebron's career during his infamous 2011 NBA finals performance, showed me as a kid that when I was cut from my school's basketball tryouts in 5th grade that you don't bounce back by doing more of the same, you get better at the right things. The data says LeBron did the same thing after the 2011 Finals!



## 3. Memory vs. data: Were the games I remember most really as big as they felt? Walk down memory lane and reliving those moments that I have now backed up with data.

**The short version:** 
- When coming up with my most memorable/favorite LeBron moments I remembered his impact he had in the games as well as the impact he had to the fans like me watching across their living rooms.
- From the 5 memories that I listed, I guessed the points i think he had and compare it to the data that actually told me how much he scored in that specific memory.
- Out of the 14 total games, I was correct 11 times of 14. But out of the 'wrong guessed' memories, the irony happens when the #1 ranked memory I listed was the one I got wrong. This being the 2016 Finals Game 7 vs GSW. I guessed that he had 35 points but actually only scored 27 points. The reason why I was wrong with my #1 memory was because I remembered the atmosphere, the pressure, the anxiety, the impact he had this game. This game was the game LeBron had one of the greatest sports moments with his game saving 'block'.


**How I tested it**
My memories (I ranked my fav lebron moments before looking at any data or stats to avoid any outside influence):
   - I guessed my memories and guessed his points before doing research on his actual stats
1. 2016 Finals comeback (Games 5-7). The entire series. Once LeBron and the Cavs started the comeback, the whole story and series was so captivating. In my opinion this reminded me of a david and goliath story. I think/guessing that his stats were around 35 ppg and like 7 reb and 7 assists
2. 2012 ECF Game 6 at Boston. I think his stats were like 30 ppg. and in this game I remember the feeling that he barely missed and had like 40 points I am guessing based off of my memory
3. 2018 playoffs: Indiana game winner, Toronto series, ECF Games 6-7 vs Boston. The last two boston games and also that indiana series game winners and the toronto calling 'lebronto' after he delivered a straight clinic against them. I think he averaged like low to mid 30 ppg and truly remember that he took control of the entire scoring for his team. 
4. 2013 Finals Games 6-7 vs San Antonio. People love to say Ray Allen won that game, but people forget the consecutive points and efficiency scoring performance LeBron had that fourth quarter that opened up the Heat to even compete in a close game for Ray Allen to hit his clutch 3 pointer. Also people forget that the 3 point shot Ray Allen hit, did not win the game but allowed them to go OT. And in OT lebron was the finisher and closer. He then kept it rolling and exploded the next game to win his first ever ring.
I am guessing that LeBron had 30 pts in Game 6
5. Passing Kareem (Feb 2023 vs OKC) LeBron being known for being a pass first player, ends up the number one scorer in the entire nba histroy is insane. Shows how good and complete he is as a player. The dedication to be great on all aspects of the game. If I remember correctly, I think he must have scored about 35 pts this game.

**What I found**
Based off of my findings:

- My biggest under guess was his 2018 ECF Game 6 vs Boston performance. I guessed his scored 32 points but ended up having a much higher scoring game with 46 points.
- My second biggest under guess was another 2018 playoff performance vs Indiana in Round 1 Game 5. I guessed he scored 32 points but ended up scoring 44 points.
- My third biggest under guess was yet again in his 2018 playoff run vs Toronto in Round 2 Game 2, guessing he scored 32 points. But ended up scoring another 40 point game with 43 points.
- My closest guess was with his 2013 Finals Game 6 vs San Antonio performance. I guessed 30 points and he dropped 32 points.
- And lastly, my #1 memory of his. His 2016 Finals Game 7 vs Golden State, I guessed 35 points but he ended up scoring lower with 27 points. But the moment felt so big because of 'the block'.

**How I kept it fair**
- I wrote my guessed and favorite memories before looking at any stats
- Out Lebron's 20 + year career, I was able to pull my 5 most memorable and favorite performances of his, totaling to 14 games. Telling me more about my emotions reliving these memories, not about his whole career.
- Points do not capture everything. Which is the whole impact and point of 'the block'! From 'the block' I remembered how big the game was and how big the game felt. My feelings turned my guess into a high scoring guess. The game was huge, BUT not just because of his scoring.
     - This is important because stats measure what is countable like points. But they can miss context. Just like with this LeBron moment. The biggest play of my #1 memory of LeBron's was a block that added 0 points to his stat line.


**What this means to me as a fan:**

I've watched LeBron for 14 years, and I thought I remembered his biggest games pretty well! The data showed I actually undersold him. He beat my guess in 11 of 14 games.

But the game I remembered most was one where he scored less than I guessed. I remembered a huge scoring night in Game 7 of the 2016 Finals, and he had 27. What I never forgot was the block!

I was at home watching with my dad, who left the room because he was convinced he would jinx the Cavs and they'd lose lol. When LeBron got that block, my heart stopped. I wasn't even celebrating yet, I was locked in on what they'd do with the next possession. 

Those in the same boat as me as a LeBron fan, knows the feeling where literally every possession had to be perfect this entire game to pull off this comeback against a 73-win Warriors team, one of the greatest teams in NBA history.

When it was over, my dad was speechless. He's a Kobe fan the way I'm a LeBron fan, and I could tell that night solidified LeBron as the GOAT for him. Then I did what every fan I knew was doing and posted it on my IG story to celebrate LeBron and the Cavs iconic comeback lol. 'CLEVELAND THIS IS FOR YOUUUU!'

This project taught me that data can tell me what happened, but it can't tell me how it felt.




