USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- for finding the total number of rows in each table of the schema we can use select clause
select count(*) as total_number_of_rows_director_mapping from director_mapping;
-- Number of rows in director_mapping table is 3867
select count(*) as total_number_of_rows_genre from genre;
-- Number of rows in genre table is 14662
select count(*) as total_number_of_rows_movie from movie;
-- Number of rows in movie table is 7997
select count(*) as total_number_of_rows_names from names;
-- Number of rows in names table is 25735
select count(*) as total_number_of_rows_ratings from ratings;
-- Number of rows n ratings table is 7997
select count(*) as total_number_of_rows_role_mapping from role_mapping;
-- Number of rows in role_mapping is 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- To find the null vlaues we can use case stament 

SELECT 
     SUM( CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_id,
     SUM( CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_title,
     SUM( CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_year,
     SUM( CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_date_published,
     SUM( CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_duration,
     SUM( CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_country,
     SUM( CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_worlwide_gross_income,
     SUM( CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_languages,
     SUM( CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS NULL_COUNT_production_company
FROM MOVIE
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- COUNTRY = 20
-- WORLDWIDE_GROSS_COMPANY = 3724
-- LANGUAGES = 194
-- PRODUCTION COMPANY = 528

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+
Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
Select year, count(id) as number_of_movies 
from movie
group by year
order by year;
/* number of movies released each year is
2017 = 3052
2018 = 2944
2019 = 2001 */

-- TOTAL NUMBER OF MOVIES MONTH WISE

select month(date_published) as month_num, count(id) as number_of_movies 
from movie
group by month_num
order by month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

Select count(id) as total_number_of_movie_produced 
from movie 
where (country like "%USA%" or country like "%India%")
and year = 2019 
-- Total number of movies produced n usa or India is 1059

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select Distinct Genre  
from genre 

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

Select genre, count(movie_id) as number_of_movies
from genre 
group by genre
order by number_of_movies desc
limit 1;
-- Highest number of movie produced by 'drama' genre
/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with movies_belong_to_only_one_genre as 
(
Select movie_id, count(genre) as number_of_genre
from genre
group by movie_id
having number_of_genre = 1)
select count(*) 
from movies_belong_to_only_one_genre;

-- Total number of movies beleong to only one genre is 3289.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre, round(avg(m.duration),2) as avg_duration 
from movie as m inner join genre as g on m.id = g.movie_id 
group by g.genre
order by avg_duration desc; 

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with all_genre_of_movies as(
select genre, count(movie_id) as movie_count,
rank() over(order by count(movie_id) desc) as genre_rank
from genre
group by genre
)
select * 
from all_genre_of_movies
where genre = "Thriller"


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT
     MIN(avg_rating) AS min_avg_rating, MAX(avg_rating) AS max_avg_rating,
     MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes,
     MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM 
    RATINGS;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
-- using rank function
Select m.title, r.avg_rating,
     rank() over(order by avg_rating desc) as movie_rank
from movie as m inner join 
ratings as r on m.id = r.movie_id
limit 10;

-- using dense_rank
SELECT title, avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
LIMIT 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

With rank_of_movies_on_average_rating As 
(SELECT title, avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
LIMIT 10
)
select * 
from rank_of_movies_on_average_rating
where title = "Fan";


-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

Select median_rating, count(movie_id) as movie_count
from ratings
group by median_rating
order by movie_count desc;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
-- using DENSE_RANK() function
select m.production_company, count(m.id) as movie_count, 
DENSE_RANK() over (order by count(m.id) desc) as prod_company_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
where r.avg_rating > 8 
and production_company is not null
group by m.production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre, count(g.movie_id) as movie_count
from genre as g 
inner join movie as m ON g.movie_id = m.id
inner join ratings as r ON r.movie_id = m.id
where m.country like "%USA%" and r.total_votes > 1000
and month(m.date_published) = 3 and m.year = 2017
group by g.genre
order by movie_count desc;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
Select m.title, r.avg_rating, g.genre 
from genre as g 
inner join movie as m ON g.movie_id = m.id
inner join ratings as r ON r.movie_id = m.id
where m.title like "The%"
And avg_rating > 8 
order by avg_rating desc;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
Select m.title, g.genre, r.median_rating
from genre as g 
inner join movie as m ON g.movie_id = m.id
inner join ratings as r ON r.movie_id = m.id
where m.title like "The%"
And median_rating = 10
order by median_rating;
-- inspect which movie and genre got the highest median rating as we saw above highest median rating is 10


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
Select r.median_rating, count(r.movie_id) as movie_count
from ratings as r
inner join movie as m ON r.movie_id = m.id
where m.date_published between '2018-04-01' AND '2019-04-01'
And median_rating = 8 
order by movie_count desc;
-- number of movie count is 361
-- Once again, try to solve the problem given below.


-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select m.country , sum(r.total_votes) as votes_count 
from ratings as r
inner join movie as m ON r.movie_id = m.id
where m.country = "Germany" or m.country = "Italy"
group by m.country

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/
-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM 
    Names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
 
 with top_three_genres As (
select g.genre, count(g.movie_id) as movie_count
from genre as g 
inner join movie as m ON g.movie_id = m.id
inner join ratings as r ON r.movie_id = m.id 
where r.avg_rating >8
group by g.genre
order by movie_count desc
limit 3
)
select n.name, count(g.movie_id) as movie_count
from genre as g 
inner join movie as m ON g.movie_id = m.id
inner join ratings as r ON r.movie_id = m.id 
inner join director_mapping as d ON d.movie_id = m.id
inner join names as n ON d.name_id = n.id
where r.avg_rating > 8 and     
g.genre IN (SELECT genre FROM top_three_genres)
group by n.name
order by movie_count desc
limit 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

Select n.name, count(m.id) as movie_count
from movie as m
inner join ratings as r ON r.movie_id = m.id 
inner join role_mapping as rm ON rm.movie_id = m.id
inner join names as n ON rm.name_id = n.id
where r.median_rating >= 8    
group by n.name
order by movie_count desc
limit 2;

/*  top two actors are
Mammootty
Mohanlal  */


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, sum(r.total_votes) as vote_count,
  Rank() Over(order by sum(r.total_votes) desc) as prod_comp_rank
from movie as m
inner join ratings as r ON r.movie_id = m.id
group by m.production_company
limit 3;  

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    actor_name,
    total_votes,
    movie_count,
    actor_avg_rating,
    actor_rank
FROM (
    SELECT 
        n.name AS actor_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
        RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC, SUM(r.total_votes) DESC) AS actor_rank
    FROM 
        names AS n
        INNER JOIN role_mapping AS rm ON rm.name_id = n.id
        INNER JOIN movie AS m ON rm.movie_id = m.id
        INNER JOIN ratings AS r ON r.movie_id = m.id
    WHERE 
        rm.category = 'actor' 
        AND m.country LIKE '%India%'
    GROUP BY 
        actor_name
    HAVING 
        movie_count >= 5
) AS ranked_actress
WHERE 
    actor_rank <= 5;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM (
    SELECT n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
        RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC, SUM(r.total_votes) DESC) AS actress_rank
    FROM names AS n
    INNER JOIN role_mapping AS rm ON rm.name_id = n.id
    INNER JOIN movie AS m ON rm.movie_id = m.id
    INNER JOIN ratings AS r ON r.movie_id = m.id
    WHERE 
        rm.category = 'actress' 
        AND m.country LIKE '%India%'
        AND m.languages LIKE '%hindi%'
    GROUP BY 
        actress_name
    HAVING 
        movie_count >= 3
) AS ranked_actress
WHERE 
    actress_rank <= 5;
    
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
select m.title,g.genre, r.avg_rating,
     (case 
           when r.avg_rating > 8 then 'Superhit movies'
           when r.avg_rating between 7 and 8 then 'Hit movies'
           when r.avg_rating between 5 and 7 then 'One-time-watch movies'
           when r.avg_rating < 5 then 'Flop movies'
		end) as movie_category
from movie as m
inner join ratings as r ON r.movie_id = m.id
inner join genre as g ON g.movie_id = m.id
where genre = "thriller";

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre, 
round(avg(duration),2) as avg_duration, 
SUM(ROUND(AVG(duration), 2)) over(order by genre) AS running_total_duration,
ROUND(AVG(ROUND(AVG(duration), 2)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
from movie as m
inner join genre as g ON g.movie_id = m.id
group by genre
order by genre;

-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
with top_3_genres as (
select g.genre, count(m.id) as movie_count
from movie as m
inner join genre as g ON g.movie_id = m.id
group by genre
order by movie_count desc),
 
top_grossing as (
select g.genre, m.year, (m.title) as movie_name, m.worlwide_gross_income,
row_number() OVER (PARTITION BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
from movie as m
inner join genre as g ON g.movie_id = m.id
where g.genre IN ( select g.genre from top_3_genres)
)
select * from top_grossing
where movie_rank <= 5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
m.production_company AS production_company, 
COUNT(*) AS movie_count,
RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE r.median_rating >= 8
AND m.languages LIKE '%,%' -- Checks for movies with multiple languages
And m.production_company is not null
GROUP BY m.production_company
ORDER BY prod_comp_rank
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(m.id) AS movie_count,
        avg(r.avg_rating),
        rank() OVER (ORDER BY COUNT(m.id) desc) AS actress_rank

    FROM names AS n
    INNER JOIN role_mapping AS rm ON rm.name_id = n.id
    INNER JOIN movie AS m ON rm.movie_id = m.id
    INNER JOIN genre AS g ON g.movie_id = m.id
    INNER JOIN ratings AS r ON r.movie_id = m.id
    WHERE 
        rm.category = 'actress' 
        AND r.avg_rating > 8
        AND g.genre = "Drama"
    GROUP BY actress_name
    order by movie_count desc
    limit 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH movie_date_info AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 final_result AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM final_result
 LIMIT 9;

