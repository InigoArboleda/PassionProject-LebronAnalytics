## PassionProject-LebronAnalytics

# Title: 14 Years of LeBron: A Fan's Data Story

In 5th grade I got cut from my school’s basketball team. I remember crying so hard that my mom felt so bad for me that she marched back into the gym with me to ask the coach if there was any other way. (There wasn’t lol)

So I got to work. Back then I couldn’t even run one lap around the gym without almost physically dying. And so I hooped before school, after school, and watched Lebron highlights. I was determined that whatever I had to do for me to never experience being rejected from my school’s basketball team again, that I will work harder than those already on the team. The next year I made the team as the 3rd pick: the smallest guy there, and the only Asian kid, so yes, I heard every Jeremy Lin joke. Meanwhile Lebron was having his own comeback year, going from “choker” in the 2011 finals to champion the following year.

I have watched every Lebron game since, from 11 years old to 25. Being a Lebron fan in Chicago meant years of trash talk from classmates, plenty of stressful playoff games, and basketball that brought me and my dad closer. Now i am using data to check the receipts on my 14 years of fandom.

## Questions
1. **The aging comparison:** How does LeBron's performance at each age compare to Jordan, Kobe, Kareem and Karl Malone?
2. **Responding to failure:** How does he play after a loss, and what changed after the 2011 Finals?
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


## Findings
*(coming soon)*

## What I'd like to further explore
- How his playstyle changed (shot locations, 3-pointers, assists)
- Comparing his eras: Cleveland, Miami, Cleveland again, the Lakers




