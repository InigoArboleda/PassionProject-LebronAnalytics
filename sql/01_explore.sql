-- First queries against data/processed/lebron.db
-- Open lebron.db in DBeaver (New Connection > SQLite), then run these one at a time.

-- 1. Look at everything
SELECT * FROM per_game;

-- 2. Points, rebounds, assists by age
SELECT season, age, team, pts, trb, ast
FROM per_game
ORDER BY age;

-- 3. Averages by era
SELECT era,
       COUNT(*)           AS seasons,
       ROUND(AVG(pts), 1) AS avg_pts,
       ROUND(AVG(ast), 1) AS avg_ast
FROM per_game
GROUP BY era
ORDER BY MIN(age);

-- 4. Before vs. after I started watching every game (2012-13)
SELECT watched_every_game,
       ROUND(AVG(pts), 1) AS avg_pts,
       ROUND(AVG(trb), 1) AS avg_trb,
       ROUND(AVG(ast), 1) AS avg_ast
FROM per_game
GROUP BY watched_every_game;
