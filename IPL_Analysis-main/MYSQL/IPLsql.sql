-- IPL 2024–2025 MySQL Project Script
-- Author: [Chirag Suri]
-- Description: This script sets up the IPL database, imports ball-by-ball data, creates filtered views,
-- and prepares clean datasets for analysis of Orange Cap, Purple Cap, and other performance metrics.
-- ----------------------------------------------------------------------------------

-- 1. Create and select the working database
CREATE DATABASE IF NOT EXISTS ipl2025;
USE ipl2025;

-- 2. Allow loading of local files (needed for LOAD DATA LOCAL INFILE)
SHOW VARIABLES LIKE 'local_infile';
-- If it says OFF, enable it:
SET GLOBAL local_infile = 1;

-- 3. Create the main ball-by-ball data table
-- This table includes cleaned and relevant columns for match analysis
CREATE TABLE ipl_ball_by_ball (
    match_id INT,
    innings INT,
    batting_team VARCHAR(100),
    bowling_team VARCHAR(100),
    over_no INT,
    ball INT,
    ball_no FLOAT,
    batter VARCHAR(100),
    bat_pos INT,
    runs_batter INT,
    batter_runs INT,
    batter_balls INT,
    bowler VARCHAR(100),
    bowler_wicket INT,
    runs_extra INT,
    runs_total INT,
    extra_type VARCHAR(50),
    wicket_kind VARCHAR(50),
    player_out VARCHAR(100),
    fielders TEXT,
    runs_target INT,
    team_reviewed VARCHAR(100),
    review_decision VARCHAR(50),
    player_of_match VARCHAR(100),
    match_won_by VARCHAR(100),
    win_outcome VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(20),
    venue VARCHAR(100),
    city VARCHAR(100),
    season VARCHAR(10),
    result_type VARCHAR(50),
    event_match_no VARCHAR(20),
    stage VARCHAR(50),
    date DATE
);
-- Columns include match_id, batter, bowler, runs_batter, bowler_wicket, fielders, etc.

-- 4. Load IPL.csv file into the ball-by-ball table
-- Note: Adjust the file path in LOAD DATA LOCAL INFILE as per your system
-- STR_TO_DATE is used for proper date formatting
LOAD DATA LOCAL INFILE 'G:/WEBD CODES/DA Projects/IPL/Dataset/IPL.csv'
INTO TABLE ipl_ball_by_ball
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(
    @dummy, match_id, @date, @match_type, @event_name, innings, 
    batting_team, bowling_team, over_no, ball, ball_no, batter, 
    bat_pos, @runs_batter, @balls_faced, bowler, @valid_ball, 
    @runs_extra, runs_total, @runs_bowler, @runs_not_boundary, 
    extra_type, @non_striker, @non_striker_pos, wicket_kind, 
    player_out, fielders, @runs_target, @review_batter, 
    team_reviewed, review_decision, @umpire, @umpires_call, 
    player_of_match, match_won_by, win_outcome, toss_winner, 
    toss_decision, venue, city, @day, @month, @year, season, 
    @gender, @team_type, @superover_winner, result_type, 
    @method, @balls_per_over, @overs, event_match_no, 
    stage, @match_number, @team_runs, @team_balls, 
    @team_wicket, @new_batter, batter_runs, batter_balls, 
    bowler_wicket, @batting_partners, @next_batter, @striker_out
)
SET 
    date = STR_TO_DATE(@date, '%Y-%m-%d'),
    runs_target = NULLIF(@runs_target, ''),
    runs_extra = NULLIF(@runs_extra, ''),
    runs_batter = NULLIF(@runs_batter, '');
;

-- 5. Create a filtered table for 2024 and 2025 IPL seasons
CREATE TABLE ipl_filtered_2024_2025 AS
SELECT *
FROM ipl_ball_by_ball
WHERE season IN ('2024', '2025');

-- 6. Verify season selection
SELECT DISTINCT season FROM ipl_filtered_2024_2025 ORDER BY season;

-- 7. Most runs in a match during IPL 2025
SELECT batter, match_id, SUM(runs_batter) AS runs_in_match
FROM (
    SELECT match_id, innings, over_no, ball, batter, MAX(runs_batter) AS runs_batter
    FROM ipl_filtered_2024_2025
    WHERE season = 2025
    GROUP BY match_id, innings, over_no, ball, batter
) AS clean_balls
GROUP BY batter, match_id
ORDER BY runs_in_match DESC
LIMIT 50;

-- 8. Create a cleaned view for de-duplicated ball data (one row per delivery)
CREATE OR REPLACE VIEW ipl_2024_2025_cleaned AS
SELECT 
    match_id,
    innings,
    over_no,
    ball,
    MAX(batter) AS batter,
    MAX(bowler) AS bowler,
    MAX(runs_batter) AS runs_batter,
    MAX(bowler_wicket) AS bowler_wicket,
    MAX(wicket_kind) AS wicket_kind,
    MAX(player_out) AS player_out,
    MAX(fielders) AS fielders,
    MAX(season) AS season  
FROM ipl_filtered_2024_2025
GROUP BY match_id, innings, over_no, ball;

-- 9. Orange Cap: Top run scorers in 2025;
SELECT batter, SUM(runs_batter) AS total_runs
FROM ipl_2024_2025_cleaned
WHERE season = 2025
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 50;

-- 10. Purple Cap: Top wicket-takers in 2025;
SELECT bowler, SUM(bowler_wicket) AS wickets
FROM ipl_2024_2025_cleaned
WHERE season = 2025
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 50;

-- 11. Top fielders (most catches) in 2025;
SELECT fielders, COUNT(*) AS catches
FROM ipl_2024_2025_cleaned
WHERE wicket_kind = 'caught' AND season = 2025
GROUP BY fielders
ORDER BY catches DESC
LIMIT 50;

-- 12. Strike Rate of Top 10 batters (batters with >7 innings and more than 100 balls faced) in 2025;
WITH batter_stats AS (
    SELECT
        batter,
        season,
        match_id,
        innings,
        COUNT(*) AS balls_faced,
        SUM(runs_batter) AS runs_scored
    FROM ipl_2024_2025_cleaned
    WHERE batter IS NOT NULL
    GROUP BY batter, season, match_id, innings
)
SELECT
    batter,
    season,
    COUNT(*) AS innings_played,
    SUM(balls_faced) AS total_balls,
    SUM(runs_scored) AS total_runs,
    ROUND(SUM(runs_scored) * 100.0 / SUM(balls_faced), 2) AS strike_rate
FROM batter_stats
WHERE season = '2025'
GROUP BY batter, season
HAVING COUNT(*) > 7 AND SUM(balls_faced) > 100
ORDER BY strike_rate DESC
LIMIT 50;

-- 13. Economy Rate of top 10 bowlers (bowlers with >7 matches) in 2025 with wicket count;
WITH bowler_stats AS (
    SELECT
        bowler,
        season,
        match_id,
        COUNT(*) AS balls_bowled,
        SUM(runs_batter) AS runs_conceded,
        SUM(CASE 
              WHEN bowler_wicket = 1 AND wicket_kind IN ('bowled', 'caught', 'lbw', 'stumped', 'hit wicket') 
              THEN 1 
              ELSE 0 
            END) AS wickets
    FROM ipl_2024_2025_cleaned
    WHERE bowler IS NOT NULL
    GROUP BY bowler, season, match_id
)
SELECT
    bowler,
    season,
    COUNT(*) AS matches_played,
    SUM(balls_bowled) AS total_balls,
    SUM(runs_conceded) AS conceded_runs,
    SUM(wickets) AS total_wickets,
    ROUND(SUM(runs_conceded) * 6.0 / SUM(balls_bowled), 2) AS economy_rate
FROM bowler_stats
WHERE season = '2025'
GROUP BY bowler, season
HAVING COUNT(*) > 7
ORDER BY economy_rate ASC
LIMIT 50;

-- 14. Create a match-level summary view (one row per match)
CREATE OR REPLACE VIEW ipl_match_summary_2024_2025 AS
SELECT
    match_id,
    MAX(toss_winner) AS toss_winner,
    MAX(CASE
        WHEN toss_winner = batting_team THEN bowling_team
        ELSE batting_team
    END) AS toss_loser,
    MAX(match_won_by) AS match_won_by,
    MAX(player_of_match) AS player_of_match,
    MAX(season) AS season
FROM ipl_filtered_2024_2025
WHERE season IN ('2024', '2025')
GROUP BY match_id;

-- 15. Toss-win impact: whether toss winner also won the match;
SELECT 
    CASE 
        WHEN toss_winner = match_won_by THEN 'Toss Winner Wins'
        ELSE 'Toss Loser Wins'
    END AS toss_outcome,
    COUNT(*) AS matches
FROM ipl_match_summary_2024_2025
GROUP BY toss_outcome;

-- 16. Player of the Match award tally;
SELECT player_of_match, COUNT(*) AS awards
FROM ipl_match_summary_2024_2025
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;
