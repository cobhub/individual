SELECT *
FROM data_analyst_jobs;
-- 1 How many rows are in the data_analyst_jobs table? 1,793
SELECT COUNT (*)
FROM data_analyst_jobs;
-- 2 Write a query to look at just the first 10 rows.
-- What company is associated with the job posting on the 10th row? ExxonMobil
SELECT *
FROM data_analyst_jobs
LIMIT 10;
-- 3 How many postings are in Tennessee? 21
-- How many are there in either Tennessee or Kentucky? 6
SELECT COUNT(location)
FROM data_analyst_jobs
WHERE location ILIKE 'TN' OR location ILIKE 'KY'
GROUP BY location;
-- 4 How many postings in Tennessee have a star rating above 4? 3
SELECT COUNT(location)
FROM data_analyst_jobs
WHERE star_rating > 4
AND location ILIKE 'TN';
-- 5 How many postings in the dataset have
-- a review count between 500 and 1000? 151
SELECT COUNT (review_count)
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;
-- 6 Show the average star rating for companies in each state.
-- The output should show the state as state and the average
-- rating for the state as avg_rating. Which state shows the
-- highest average rating? Nebraska
SELECT state, AVG(avg_rating) AS avg_of_avg
FROM (
    SELECT location AS state, AVG(star_rating) AS avg_rating
    FROM data_analyst_jobs
	WHERE star_rating IS NOT NULL
    GROUP BY location)
AS subquery
GROUP BY state
ORDER BY avg_of_avg DESC;
-- 7 Select unique job titles from the data_analyst_jobs table.
-- How many are there? 881
SELECT COUNT (DISTINCT(title))
FROM data_analyst_jobs;
-- 8 How many unique job titles are there for California companies? 230
SELECT location, COUNT(DISTINCT title) AS distinct_title_count
FROM data_analyst_jobs
GROUP BY location
ORDER BY distinct_title_count DESC;
-- 9 Find the name of each company and its average star rating
-- for all companies that have more than 5000 reviews across
-- all locations. How many companies are there with more that
-- 5000 reviews across all locations? 126
SELECT DISTINCT(title) AS unique_co, 
AVG(star_rating) AS avg_rating,
location,
review_count
FROM data_analyst_jobs
WHERE review_count > 5000
GROUP BY title, location, review_count;
-- 10 Add the code to order the query in #9 from highest to lowest average
-- star rating. Which company with more than 5000 reviews across all locations
-- in the dataset has the highest star rating? What is that rating?
-- NIKE, 4.2
SELECT company, 
AVG(star_rating) AS avg_rating,
location,
review_count
FROM data_analyst_jobs
WHERE review_count > 5000
GROUP BY company, location, review_count
ORDER BY avg_rating DESC;
-- 11 Find all the job titles that contain the word ‘Analyst’.
-- How many different job titles are there? 1,669
SELECT COUNT(title) as analyst_jobs
FROM data_analyst_jobs
WHERE title ILIKE '%analyst%';
-- 12 How many different job titles do not contain either the word Analyst’
-- or the word ‘Analytics’? What word do these positions have in common? 4
--Tableau!
SELECT title
FROM data_analyst_jobs
WHERE title NOT ILIKE '%analyst%'
AND title NOT ILIKE '%analytics%';
-- BONUS: You want to understand which jobs requiring SQL are hard to fill.
-- Find the number of jobs by industry (domain) that require SQL and have
-- been posted longer than 3 weeks.
-- >>Disregard any postings where the domain is NULL.
-- >>Order your results so that the domain with the greatest number
-- of hard to fill jobs is at the top.
-- >>Which three industries are in the top 4 on this list?
--Banks and Financial Services, Consulting and Business Services,
-- Internet and Software, Education and Schools
-- How many jobs have been listed for more than 3 weeks for each of the top 4?
--B&FS: 2, C&BS:2, IE&S:1, E&S:1
SELECT
domain AS industry,
COUNT(domain) AS domain_count,
days_since_posting,
skill,
title
FROM data_analyst_jobs
WHERE skill ILIKE '%sql%'
AND days_since_posting > 21
AND domain IS NOT NULL
GROUP BY domain, title, skill, days_since_posting
ORDER BY domain_count DESC;