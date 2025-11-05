-- Netflix Projects

-- Creating table

CREATE TABLE netflix(
	
	show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)

);

SELECT * FROM netflix;


-- TASK

-- 1. Count the Number of Movies vs TV Shows

SELECT
	type,
	COUNT(*) AS total_content
FROM netflix
GROUP BY type;

-- 2. Find the Most Common Rating for Movies and TV Shows

SELECT
	type,
	rating
FROM 

(
	SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
	FROM netflix
	GROUP BY 1,2 ) AS t1 
WHERE 
	ranking = 1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * 
FROM netflix
WHERE 
	release_year = '2020' 
	AND 
	type = 'Movie';


-- 4. Find the Top 5 Countries with the Most Content on Netflix


SELECT	
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	countr
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1


SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country
FROM netflix;


-- 5. Identify the Longest Movie


SELECT * 
FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix);


-- 6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE 
	director ILIKE '%Rajiv Chilaka%';


-- 8. List All TV Shows with More Than 5 Seasons

SELECT * 
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5;

-- 9. Count the Number of Content Items in Each Genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS Genre,
	COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


-- 10.Find each year and the average numbers of content release in India on netflix.

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added , 'Month DD, YYYY')) AS year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric *100
	, 2)AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;


-- 11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries%';


-- 12. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
	AND release_year > EXTRACT(year FROM CURRENT_DATE) - 10;


-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


/*  15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. 
Count the number of items in each category.*/


SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' 
			OR 
			description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;