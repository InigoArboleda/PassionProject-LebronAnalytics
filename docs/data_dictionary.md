# Data Dictionary

Everything I learned about my data before analyzing it: where it came from, what each column means, and the problems I found.

- [Metadata](#metadata)
- [Issues log](#issues-log)
- [Data dictionary](#data-dictionary)

## Metadata

One row per file in data/raw. Source: Basketball-Reference.com. Downloaded between Sept 30 and Oct 4, 2026. Saved as CSV on Oct 4, 2026.

| File | Player | Table | Source URL | Seasons covered | Rows in file | Seasons / games played | Columns | One row is | Known issues |
|---|---|---|---|---|---|---|---|---|---|
| `lebron_per_game.csv` | LeBron James | Per Game, regular season | https://www.basketball-reference.com/players/j/jamesle01.html | 2003-04 to 2025-26 | 29 | 23 | 31 | One regular season | Summary rows at the bottom (career and team totals, repeated header, blank row) are not seasons. |
| `lebron_advanced.csv` | LeBron James | Advanced, regular season | https://www.basketball-reference.com/players/j/jamesle01.html | 2003-04 to 2025-26 | 30 | 23 | 29 | One regular season | Summary rows at the bottom (career and team totals, repeated header, blank row) are not seasons. MP here is total minutes for the season, not per game. |
| `lebron_shooting.csv` | LeBron James | Shooting, regular season | https://www.basketball-reference.com/players/j/jamesle01.html | 2003-04 to 2025-26 | 31 | 23 | 31 | One regular season | Summary rows at the bottom (career and team totals, repeated header, blank row) are not seasons. Two header rows (group labels above column names). Column names repeat across groups. |
| `lebron_gamelog_2010_11.csv` | LeBron James | Game log, regular season | https://www.basketball-reference.com/players/j/jamesle01/gamelog/2011 | 2010-11 | 83 | 79 | 34 | One team game | 82 team games, 79 played. Missed games show text (Did Not Play, Did Not Dress, Inactive) in the stat columns. Last row is season totals. Home/away column has no header.|
| `lebron_gamelog_2011_12.csv` | LeBron James | Game log, regular season | https://www.basketball-reference.com/players/j/jamesle01/gamelog/2012 | 2011-12 | 67 | 62 | 34 | One team game | 66 team games, 62 played. Missed games show text (Did Not Play, Did Not Dress, Inactive) in the stat columns. Last row is season totals. Home/away column has no header.|
| `lebron_gamelog_2012_13.csv` | LeBron James | Game log, regular season | https://www.basketball-reference.com/players/j/jamesle01/gamelog/2013 | 2012-13 | 83 | 76 | 34 | One team game | 82 team games, 76 played. Missed games show text (Did Not Play, Did Not Dress, Inactive) in the stat columns. Last row is season totals. Home/away column has no header.|
| `jordan_per_game.csv` | Michael Jordan | Per Game, regular season | https://www.basketball-reference.com/players/j/jordami01.html | 1984-85 to 2002-03 | 23 | 15 | 31 | One regular season | Summary rows at the bottom (career and team totals, repeated header, blank row) are not seasons. 4 seasons say 'Did not play - retired' in place of numbers.|
| `kobe_per_game.csv` | Kobe Bryant | Per Game, regular season | https://www.basketball-reference.com/players/b/bryanko01.html | 1996-97 to 2015-16 | 22 | 20 | 31 | One regular season | Summary rows at the bottom (career and team totals, repeated header, blank row) are not seasons. 2013-14 has only 6 games (injury), so its averages are a small sample.|

## Issues log

Problems I found while exploring the data in Excel, and what I did about each one.

| Table | Column / rows | Issue | What I did / plan | Status |
|---|---|---|---|---|
| Shooting | 3-10, 10-16 (4 header cells) | Excel turned the shot distance headers into dates (March 10, October 16). | Retyped them as text with an apostrophe. | Fixed |
| Game logs | MP | Excel read mm:ss as hours and minutes (39:18 became 39 hours 18 minutes). | Redid text-to-columns with MP set to Text. Will convert to decimal minutes in Python. | Fixed |
| 2012-13 game log | Whole table | I exported the table while it was sorted by Result, so it was out of date order and missing the games he did not play. | Refreshed the page and exported again. Checked that Gtm counts 1, 2, 3... | Fixed |
| All season tables | Bottom rows | Repeated header, career totals, blank row and team totals are mixed in with the seasons. | Remove in Phase 2. | To do |
| Jordan per game | 1993-94, 1998-99 to 2000-01 | Retired seasons have text in place of numbers, so there are gaps in his ages. | Decide how to handle the gaps in the aging comparison. | To do |
| Kobe per game | 2013-14 | Only 6 games played, so the averages are not reliable. | Decide on a minimum games rule for the comparison. | To do |
| Game logs | Missed games | Rows for games he missed have text in the stat columns. | Decide whether they count as the 'previous game' for the after-a-loss question. | To do |
| Game logs | Date | CSV saved dates as month/day/2-digit year. | Tell pandas the date format when loading. | To do |
| Shooting | Headers | Two header rows, and column names repeat between groups. | Load with the second row as the header, then rename. | To do |
| All season tables | Awards | Several awards are run together in one cell. | Leave as is unless I need it. | Note |
| All files | Decimals | Saving through Excel dropped trailing zeros (.290 became 0.29). The values are the same. | No action needed. | Note |

## Data dictionary

One row per column. Examples come from LeBron's first row in each table (2003-04 season, or the first game of 2010-11).

### All season tables

| Column | Full name | Definition | Data type | Example | Notes |
|---|---|---|---|---|---|
| `Season` | Season | The NBA season, written as start year and end year. | Text | 2003-04 | Keep as text. Excel can turn values like 2003-04 into dates. |
| `Age` | Age | Player's age on February 1 of that season. | Whole number | 19 | Jordan's retired seasons have text here. |
| `Team` | Team | Team abbreviation (CLE, MIA, LAL, CHI, WAS). | Text | CLE |  |
| `Lg` | League | League played in. Always NBA in this data. | Text | NBA | Same value in every row, so not useful for analysis. |
| `Pos` | Position | Main position that season (PG, SG, SF, PF, C). | Text | SG |  |
| `G` | Games | Games played that season. | Whole number | 79 | Check this before trusting an average. Kobe played 6 games in 2013-14. |
| `GS` | Games started | Games where he was in the starting lineup. | Whole number | 79 |  |
| `Awards` | Awards | Awards and award voting finishes that season. | Text | MVP-9ROY-1 | Several awards run together with no separator, like MVP-9ROY-1. MVP-9 means 9th in MVP voting. |

### Per game (lebron, jordan, kobe)

| Column | Full name | Definition | Data type | Example | Notes |
|---|---|---|---|---|---|
| `MP` | Minutes per game | Average minutes played per game. | Decimal | 39.5 |  |
| `FG` | Field goals per game | Shots made per game (2s and 3s together). | Decimal | 7.9 |  |
| `FGA` | Field goal attempts per game | Shots taken per game. | Decimal | 18.9 |  |
| `FG%` | Field goal percentage | Share of shots made. FG divided by FGA. | Decimal | 0.417 | Stored as a decimal: 0.417 means 41.7%. |
| `3P` | 3-pointers per game | 3-point shots made per game. | Decimal | 0.8 |  |
| `3PA` | 3-point attempts per game | 3-point shots taken per game. | Decimal | 2.7 |  |
| `3P%` | 3-point percentage | Share of 3-point shots made. | Decimal | 0.29 | Decimal. Blank if he took no 3s. |
| `2P` | 2-pointers per game | 2-point shots made per game. | Decimal | 7.1 |  |
| `2PA` | 2-point attempts per game | 2-point shots taken per game. | Decimal | 16.1 |  |
| `2P%` | 2-point percentage | Share of 2-point shots made. | Decimal | 0.438 | Decimal. |
| `eFG%` | Effective field goal percentage | Shooting percentage that gives extra credit for 3s, since they are worth more. (FG + 0.5 x 3P) / FGA. | Decimal | 0.438 | Decimal. |
| `FT` | Free throws per game | Free throws made per game. | Decimal | 4.4 |  |
| `FTA` | Free throw attempts per game | Free throws taken per game. | Decimal | 5.8 |  |
| `FT%` | Free throw percentage | Share of free throws made. | Decimal | 0.754 | Decimal. |
| `ORB` | Offensive rebounds per game | Rebounds grabbed after his own team's miss. | Decimal | 1.3 |  |
| `DRB` | Defensive rebounds per game | Rebounds grabbed after the other team's miss. | Decimal | 4.2 |  |
| `TRB` | Total rebounds per game | ORB plus DRB. | Decimal | 5.5 |  |
| `AST` | Assists per game | Passes that led directly to a teammate's basket. | Decimal | 5.9 |  |
| `STL` | Steals per game | Times he took the ball from the other team. | Decimal | 1.6 |  |
| `BLK` | Blocks per game | Opponent shots he blocked. | Decimal | 0.7 |  |
| `TOV` | Turnovers per game | Times he lost the ball to the other team. | Decimal | 3.5 | Lower is better. |
| `PF` | Personal fouls per game | Fouls committed per game. | Decimal | 1.9 |  |
| `PTS` | Points per game | Average points scored per game. | Decimal | 20.9 | Main stat for the aging curve. |

### Advanced (lebron_advanced)

| Column | Full name | Definition | Data type | Example | Notes |
|---|---|---|---|---|---|
| `MP` | Minutes played (total) | Total minutes for the whole season. | Whole number | 3122 | Different from Per Game, where MP is an average. |
| `PER` | Player Efficiency Rating | One number for per-minute production. 15 is league average. | Decimal | 18.3 | Rate stat. 25+ is MVP level. |
| `TS%` | True shooting percentage | Shooting efficiency counting 2s, 3s and free throws. PTS / (2 x (FGA + 0.44 x FTA)). | Decimal | 0.488 | Decimal. League average has risen over time. |
| `3PAr` | 3-point attempt rate | Share of his shots that were 3-pointers. | Decimal | 0.145 | Decimal. Useful for the playstyle question. |
| `FTr` | Free throw rate | Free throw attempts per field goal attempt. | Decimal | 0.308 | Decimal. |
| `ORB%` | Offensive rebound percentage | Share of available offensive rebounds he grabbed while on the floor. | Decimal | 3.5 | Already a percent: 3.5 means 3.5%. |
| `DRB%` | Defensive rebound percentage | Share of available defensive rebounds he grabbed while on the floor. | Decimal | 11.8 | Already a percent. |
| `TRB%` | Total rebound percentage | Share of all available rebounds he grabbed while on the floor. | Decimal | 7.6 | Already a percent. |
| `AST%` | Assist percentage | Share of teammates' baskets he assisted while on the floor. | Decimal | 27.8 | Already a percent. |
| `STL%` | Steal percentage | Share of opponent possessions that ended with his steal. | Decimal | 2.2 | Already a percent. |
| `BLK%` | Block percentage | Share of opponent 2-point shots he blocked. | Decimal | 1.3 | Already a percent. |
| `TOV%` | Turnover percentage | Turnovers per 100 plays he used. | Decimal | 13.9 | Lower is better. |
| `USG%` | Usage percentage | Share of team plays he used (shots, free throws, turnovers) while on the floor. | Decimal | 28.2 | Already a percent. |
| `OWS` | Offensive win shares | Estimated wins added through offense. | Decimal | 2.4 | Counting stat. Depends on games played. |
| `DWS` | Defensive win shares | Estimated wins added through defense. | Decimal | 2.6 | Counting stat. |
| `WS` | Win shares | Estimated team wins he was responsible for. OWS plus DWS. | Decimal | 5.1 | Counting stat. 15+ is MVP level. |
| `WS/48` | Win shares per 48 minutes | Win shares per full game of playing time. | Decimal | 0.078 | Rate stat. About 0.100 is average. |
| `OBPM` | Offensive box plus/minus | Points per 100 possessions he added on offense vs. an average player. | Decimal | 2.3 | Can be negative. |
| `DBPM` | Defensive box plus/minus | Points per 100 possessions he added on defense vs. an average player. | Decimal | -0.6 | Can be negative. |
| `BPM` | Box plus/minus | Points per 100 possessions he added vs. an average player. OBPM plus DBPM. | Decimal | 1.7 | Rate stat. 0 is average, +8 is MVP level. |
| `VORP` | Value over replacement player | BPM turned into a season total, compared with a bench-level player. | Decimal | 2.9 | Counting stat. |

### Shooting (lebron_shooting)

| Column | Full name | Definition | Data type | Example | Notes |
|---|---|---|---|---|---|
| `FG%` | Field goal percentage | Share of all shots made. | Decimal | 0.417 | Decimal. |
| `Dist.` | Average shot distance | Average distance of his shots, in feet. | Decimal | 11.2 |  |
| `2P (% of FGA)` | Share of shots that were 2-pointers | Out of all his shots, the share that were 2s. | Decimal | 0.855 | Group: % of FGA by Distance. Decimal. |
| `0-3 (% of FGA)` | Share of shots from 0-3 feet | Share of his shots taken at the rim. | Decimal | 0.315 | Group: % of FGA by Distance. |
| `3-10 (% of FGA)` | Share of shots from 3-10 feet | Share of his shots taken from 3 to 10 feet. | Decimal | 0.168 | Excel turned this header into a date. Fixed by typing it as text. |
| `10-16 (% of FGA)` | Share of shots from 10-16 feet | Share of his shots taken from 10 to 16 feet. | Decimal | 0.161 | Excel turned this header into a date. Fixed by typing it as text. |
| `16-3P (% of FGA)` | Share of shots from 16 feet to the 3-point line | Share of his shots that were long 2s. | Decimal | 0.211 |  |
| `3P (% of FGA)` | Share of shots that were 3-pointers | Out of all his shots, the share that were 3s. | Decimal | 0.145 |  |
| `2P (FG%)` | 2-point percentage | Share of 2-point shots made. | Decimal | 0.438 | Group: FG% by Distance. Same header name as column 11. |
| `0-3 (FG%)` | Percentage made from 0-3 feet | Share of shots made at the rim. | Decimal | 0.604 | Header repeats. Rename in Phase 2. |
| `3-10 (FG%)` | Percentage made from 3-10 feet | Share of shots made from 3 to 10 feet. | Decimal | 0.356 | Header repeats. Was also turned into a date by Excel. |
| `10-16 (FG%)` | Percentage made from 10-16 feet | Share of shots made from 10 to 16 feet. | Decimal | 0.313 | Header repeats. Was also turned into a date by Excel. |
| `16-3P (FG%)` | Percentage made from 16 feet to the 3-point line | Share of long 2s made. | Decimal | 0.352 | Header repeats. |
| `3P (FG%)` | 3-point percentage | Share of 3-point shots made. | Decimal | 0.29 | Header repeats. |
| `2P (% Ast'd)` | Share of made 2s that were assisted | Share of his made 2-pointers that came off a teammate's pass. | Decimal | 0.442 | Group: % of FG Ast'd. |
| `3P (% Ast'd)` | Share of made 3s that were assisted | Share of his made 3-pointers that came off a teammate's pass. | Decimal | 0.746 | Group: % of FG Ast'd. |
| `%FGA (Dunks)` | Share of shots that were dunks | Share of his shot attempts that were dunks. | Decimal | 0.064 | Group: Dunks. |
| `# (Dunks)` | Dunks made | Number of dunks made that season. | Whole number | 91 |  |
| `%3PA (Corner 3s)` | Share of 3s taken from the corner | Share of his 3-point attempts from the corners. | Decimal | 0.286 | Group: Corner 3s. |
| `3P% (Corner 3s)` | Corner 3-point percentage | Share of corner 3s made. | Decimal | 0.323 | Group: Corner 3s. |
| `Att. (1/2 Court)` | Heave attempts | Shots taken from beyond half court. | Whole number | 3 |  |
| `Md. (1/2 Court)` | Heaves made | Shots made from beyond half court. | Whole number | 0 |  |

### Game logs (lebron_gamelog_...)

| Column | Full name | Definition | Data type | Example | Notes |
|---|---|---|---|---|---|
| `Rk` | Row number | Counts the games he played, in order. | Whole number | 1 | Does not go up on games he missed. |
| `Gcar` | Career game number | Which game of his career this was. | Whole number | 549 | Blank when he did not play. |
| `Gtm` | Team game number | Which game of the team's season this was (1 to 82). | Whole number | 1 | Use this to check the games are in order. |
| `Date` | Game date | Date the game was played. | Date | 10/26/10 | Saved in the CSV as month/day/2-digit year (10/26/10). |
| `Team` | Team | His team's abbreviation. | Text | MIA |  |
| `(no header)` | Home or away | @ means an away game. Blank means a home game. | Text | @ | Column has no name. Rename it in Phase 2. |
| `Opp` | Opponent | Opposing team's abbreviation. | Text | BOS |  |
| `Result` | Game result | W or L followed by the final score (his team's score first). | Text | L 80-88 | Needs splitting into win/loss and score for the 'after a loss' question. |
| `GS` | Game started | * means he started the game. | Text | * | Shows Did Not Play, Did Not Dress or Inactive when he missed the game. |
| `MP` | Minutes played | Minutes and seconds he played, as mm:ss. | Text | 42:39 | Excel read 39:18 as 39 hours 18 minutes. Fixed by importing as Text. Convert to decimal minutes in Python. |
| `FG to PTS` | Box score stats | Same stats as the Per Game table (FG, FGA, FG%, 3P, 3PA, 3P%, 2P, 2PA, 2P%, eFG%, FT, FTA, FT%, ORB, DRB, TRB, AST, STL, BLK, TOV, PF, PTS), but as totals for that one game. | Whole number (percentages are decimals) | PTS = 31 | A percentage is blank when he had zero attempts. |
| `GmSc` | Game Score | One number rating how good a single game was. About 10 is average, 40 is outstanding. | Decimal | 16 | Good stat for the memory vs. data question. |
| `+/-` | Plus/minus | How many points his team outscored the opponent by while he was on the floor. | Whole number | 1 | Can be negative. |
