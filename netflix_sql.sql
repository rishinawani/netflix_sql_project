select * from netflix;

select distinct type
from netflix;

-- counting number of movies vs tv shows
SELECT type, count(*)
FROM netflix
GROUP BY type;

-- find the most common rating given to movies and tv show
SELECT  type, rating
from 
(
SELECT 
  type,rating,count(*),
  Rank() OVER(PARTITION BY type ORDER BY count(*) DESC ) as ranking 
  from netflix
  GROUP BY type, rating
) as t1
WHERE ranking = 1;

-- List all the movies released in there years

SELECT title,release_year
FROM
netflix
WHERE type =  'Movie'
Group BY release_year, title
ORDER BY release_year 
;
-- List all the movies released in a specefic years
SELECT title,release_year
FROM
netflix
WHERE type =  'Movie'
AND
release_year = 2020
;
-- Find the top 5 countries  with the most content on netflix
SELECT UNNEST(STRING_TO_ARRAY(country,',')) as new_country
, count(show_id) as total_cont
FROM netflix
Group by 1
ORDER BY 2 DESC;
-- Identify the longest duration

SELECT * FROM Netflix
WHERE 
 type = 'Movie'
 AND 
 duration = (SELECT MAX(duration) FROM netflix);
 
 -- Find the content added in last 5 years
 
 SELECT *
 FROM netflix
 WHERE
  TO_Date(date_added, 'Month DD, YYYY ') >= CURRENT_DATE - Interval '5 Years ';

-- Find all the movies/Tv shows by director 'Rajiv Chilaka'

SELECT * 
FROM netflix
WHere director LIKE '%Rajiv Chilaka%';

-- List all Tv shows with more than 5 seasons

SELECT * FROM netflix
WHERE
  type = 'TV Show'
  AND
  Split_Part(duration, ' ', 1):: numeric > 5;

-- count the number of  content item in each genre 
SELECT  UNNEST(STRING_TO_Array(listed_in,','))as genre,count(*)
from netflix
Group BY  UNNEST(STRING_TO_Array(listed_in,','));

--Find each year and the average number of content release by India on netflix,
--return top 5 years with highest avg content release

 
SELECT 
 release_year,
 Count(*), count(*):: numeric/(SELECT count(*) FROM netflix where country = 'India'):: numeric * 100 as avg 
From netflix
WHERE country = 'India'
Group BY 1;

--List all the movies that are documantaries
SELECT * FROM netflix
WHERE
 listed_in Ilike '%documentaries%';

-- find all the content without director
SELECT * FROM netflix
WHERE
 director ISNULL;

-- Find how many movies actor ' Salman Khan' appeared in last 10 years
SELECT * FROM netflix
WHERE 
 casts ILIKE '%salman khan%'
 AND release_year > extract(Year FROM current_date) - 10;
-- FIND  the top 10  actors who have appeared in the highest number 
--of movies produced in India
SELECT  UNNEST(STRING_TO_Array(casts,',')), count(*)
FROM netflix
Group BY  UNNEST(STRING_TO_Array(casts,',')) 
ORDER BY count(*) DESC
LIMIT 10;

-- Categorize the content based on the presence of keywords 'romantic' and 'comedy'
--changing the the phrase to 'romcom' and all other contetn as 'genral'. Give the count too
WITH categry_tab AS
(SELECT *, 
 CASE
 WHEN
 description ILIKE '% romantic%'
 AND
 description ILIKE '% comedy%' THEN 'romcom' 
 ELSE 'Others'
 END as Category
FROM netflix )
SELECT category, count(*)
FROM categry_tab
Group by category
;