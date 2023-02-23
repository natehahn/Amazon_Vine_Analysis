-- vine table
CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);

SELECT * FROM vine_table;

-- 1) Filter the data and create a new DataFrame or table to retrieve all the rows where the total_votes count is 
-- equal to or greater than 20 to pick reviews that are more likely to be helpful and to avoid having division by 
-- zero errors later on.
SELECT *
FROM vine_table
WHERE total_votes > 20;

CREATE TABLE total_votes
AS SELECT *
FROM vine_table
WHERE total_votes > 20;

SELECT * FROM total_votes;

SELECT COUNT(review_id)
FROM total_votes;
-- 61153

-- 2)Filter the new DataFrame or table created in Step 1 and create a new DataFrame or table to retrieve all the
-- rows where the number of helpful_votes divided by total_votes is equal to or greater than 50%.
SELECT *
FROM total_votes
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

CREATE TABLE helpful_votes
AS SELECT *
FROM total_votes
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

SELECT COUNT(review_id)
FROM helpful_votes;
-- 37921

-- 3) Filter the DataFrame or table created in Step 2, and create a new DataFrame or table that retrieves all
-- the rows where a review was written as part of the Vine program (paid)
SELECT *
FROM helpful_votes
WHERE vine = 'Y';

CREATE TABLE reviews_paid
AS SELECT *
FROM helpful_votes
WHERE vine = 'Y';

SELECT COUNT(review_id)
FROM reviews_paid;
-- 90

-- 4) Repeat Step 3, but this time retrieve all the rows where the review was not part of the Vine program (unpaid)
SELECT *
FROM helpful_votes
WHERE vine = 'N';

CREATE TABLE reviews_unpaid
AS SELECT *
FROM helpful_votes
WHERE vine = 'N';

SELECT COUNT(review_id)
FROM reviews_unpaid;
-- 37831

-- 5) Determine the total number of reviews, the number of 5-star reviews, and the percentage of 5-star reviews for
-- the two types of review (paid vs unpaid).

SELECT COUNT(review_id)
FROM vine_table;
-- 1785997

SELECT COUNT(review_id)
	as  "Vine Reviews"
FROM vine_table
WHERE vine = 'Y';
-- 4291

SELECT COUNT(review_id)
	as  "Non-Vine Reviews"
FROM vine_table
WHERE vine = 'N';
-- 1781706

SELECT COUNT(star_rating)
FROM vine_table
WHERE star_rating = 5;
-- 1026924

SELECT COUNT(star_rating)
	as  "Vine 5-Star Reviews"
FROM vine_table
WHERE star_rating = 5 AND vine = 'Y';
-- 1607
--/1785997X100 = .08%

SELECT COUNT(star_rating)
	as "Non-Vine 5-Star Reviews"
FROM vine_table
WHERE star_rating = 5 AND vine = 'N';
-- 1025317/1785997X100 = 57%

SELECT DISTINCT CAST((select count(star_rating) FROM vine_table where star_rating = 5 AND vine = 'Y')as float) / 
		CAST((select count(review_id) FROM vine_table) as float) * 100
	   as "Percentage of Vine 5-Star Reviews"
from vine_table;

SELECT DISTINCT CAST((select count(star_rating) FROM vine_table where star_rating = 5 AND vine = 'N')as float) / 
		CAST((select count(review_id) FROM vine_table) as float) * 100
	   as "Percentage of Non-Vine 5-Star Reviews"
from vine_table;



SELECT star_rating,
       count(star_rating) as stars,
	   ROUND(
	    count(star_rating) / (select count(vine) FROM vine_table WHERE vine = 'Y')
	   ) as percentage
from vine_table
group by star_rating;

SELECT (CAST(numer as float) / CAST(denom as float)) *  100 as percentage
FROM
(SELECT COUNT(review_id) as denom,
	SUM(CASE WHEN star_rating = 5 AND vine = 'Y' then 1 else 0 end) as numer
FROM vine_table
)a;

SELECT COUNT(star_rating)
FROM vine_table
WHERE star_rating = 2;


