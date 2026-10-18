## PassionProject-LebronAnalytics

# Title: 14 Years of LeBron: A Fan's Data Story

In 5th grade I got cut from my school’s basketball team. I remember crying so hard that my mom felt so bad for me that she marched back into the gym with me to ask the coach if there was any other way. (There wasn’t lol)

So I got to work. Back then I couldn’t even run one lap around the gym without almost physically dying. And so I hooped before school, after school, and watched Lebron highlights. I was determined that whatever I had to do for me to never experience being rejected from my school’s basketball team again, that I will work harder than those already on the team. The next year I made the team as the 3rd pick: the smallest guy there, and the only Asian kid, so yes, I heard every Jeremy Lin joke. Meanwhile Lebron was having his own comeback year, going from “choker” in the 2011 finals to champion the following year.

I have watched every Lebron game since, from 11 years old to 25. Being a Lebron fan in Chicago meant years of trash talk from classmates, plenty of stressful playoff games, and basketball that brought me and my dad closer. Now i am using data to check the receipts on my 14 years of fandom.

## Questions
1. **The aging comparison:** How does LeBron's performance at each age compare to Jordan and Kobe?
2. **Responding to failure:**
   - How does he play after a loss, and what changed after the 2011 Finals?
   - How his play style changed (shot locations, 3-pointers, assists)
   - Comparing his eras: Cleveland, Miami, Cleveland again, the Lakers
3. **Memory vs. data:** Were the games I remember most really as big as they felt? Walk down memory lane and reliving those moments that I have now backed up with data.


## Datasource/Dataset that I am pulling from: 
- [Basketball-Reference.com](https://www.basketball-reference.com/players/j/jamesle01.html): season stats and game logs, 2003–present

## Tools
 Tool | What I used it for 
 
- Excel | First look at the raw data |
  
- Python (Jupyter, pandas) | Cleaning data and loading it into SQLite |
  
- SQL (SQLite, DBeaver) | Creating Lebron database, fragmenting and magnifying the data, peeling the onion, answering the questions |
  
- Tableau | Dashboards and visuals, painting the story |
  
- Claude | Utilized for planning and debugging |
  
- GitHub, Google Docs | Documentation |

## Project structure

data/raw/         original CSVs, never edited
data/processed/   cleaned CSVs and lebron.db (SQLite)
notebooks/        Jupyter notebooks (cleaning and exploration)
sql/              SQL queries
tableau/          Tableau workbooks


## ABOUT THE DATA
See the [data dictionary](Data%20Dictionary.md)

## Findings

### 1. The aging comparison: LeBron vs. Jordan vs. Kobe

**The short version:** Jordan and Kobe were the better scorers at their peaks. LeBron's edge is that he barely declined.

**Jordan and Kobe rose and fell. LeBron stayed flat.**

| Career stage | LeBron | Jordan | Kobe |
|---|---|---|---|
| Early (under 25) | 27.5 | 30.8 | 21.3 |
| Prime (25–29) | 27.5 | 32.1 | 29.4 |
| Veteran (30–34) | 26.4 | 28.9 | 26.9 |
| Late (35+) | 25.8 | 21.5 | 17.9 |

*Points per game, averaged across the seasons in each stage.*

Jordan dropped about 10 points from his prime to his late career, and Kobe about 11. LeBron dropped less than 2 points across his entire 23-season career.

**What stood out to me:**
- **Jordan and Kobe peaked in their 20s.** All of their top 5 scoring seasons came between ages 22 and 29.
- **LeBron's top 5 seasons span ages 21 to 38.** His 2nd best scoring season (30.3) came at 37, older than Kobe ever played.
- **He never fell off a cliff.** He stayed within about 6 points of his peak from age 22 to 39. Jordan and Kobe each finished more than 17 points below theirs.
- **His game changed as he aged.** His assists went up from 6.7 per game in his early 20s to about 8 in his 30s.
- **The age chart is mine at the start and end.** LeBron was the top scorer of the three at ages 19–21 and every age from 35 on. Jordan and Kobe owned the middle years (22–34).

**The catch: availability.**
LeBron's late-career numbers are strong *per game*, but he played less. He averaged about 77 games a season before 30 and about 61 from age 35 on, missing roughly a quarter of each season.

**How I kept the comparison fair:**
- I checked which ages all three players actually have seasons for. Jordan missed age 30 and 35–37 to retirement, and Kobe retired at 37. After 39, LeBron has no one left to compare to.
- I re-ran the comparison without injury-shortened seasons (under 50 games). The main finding didn't change.
- I counted a 50-game season as full when the whole league only played 50 games (the 1998-99 lockout).

**What this means to me as a fan:**
I became a fan in 2012-13, when LeBron was 28. The data says I started watching right before the part of his career that made him different: not his peak, but how long he held it.

## What I'd like to further explore
- How his playstyle changed (shot locations, 3-pointers, assists)
- Comparing his eras: Cleveland, Miami, Cleveland again, the Lakers




