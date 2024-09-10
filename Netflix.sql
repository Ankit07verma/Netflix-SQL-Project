--NetFlix Project

CREATE TABLE netflix
(
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

--Verifying Data import

Select * from netflix;

--Verifying Total rows

Select Count(*) as Total_content
From Netflix;

/* Business problem
  15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


-- Question 1

SELECT type, count(type) as Content_Type
FROM netflix
GROUP BY type;

-- Question 2

SELECT Type, Rating as Most_frequent_rating
	FROM
(SELECT type, rating, Count(rating) as CT,
Row_number() over(partition by type Order by Count(rating) desc) as RN
FROM netflix
Group By type, rating)x
WHERE x.RN = 1;

--Question 3

SELECT Title
FROM netflix
WHERE release_year = 2002 and type = 'Movie';

--Question 4

	SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

-- Question 5

SELECT *
FROM netflix
ORDER BY duration DESC
LIMIT 1;

-- Question 6

SELECT * 
FROM Netflix
WHERE release_year>2019;

--Question 7

SELECT title
FROM netflix 
WHERE Director = 'Rajiv Chilaka';

--Question 8

SELECT * 
FROM Netflix
Where Duration > '5 Seasons' AND type = 'TV Show';

--Question 9

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

--Question 10

	SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

-- Question 11

SELECT *
FROM netflix
WHERE Listed_in LIKE '%Documentaries';

--Question 12

SELECT * 
FROM netflix 
WHERE Director IS null;

--Question 13

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- QUESTION 14

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Question 15

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

	
Select * from netflix