USE updated_titanic_data;

SELECT * FROM titanic;

ALTER TABLE titanic
MODIFY COLUMN pclass INTEGER;

SELECT *
FROM titanic
WHERE pclass = '';

-- needed to delete one of the row to convert text to interger. the pclass was blank as well as that row, empty row.
DELETE FROM titanic
WHERE pclass = '';

-- deleting columns that is not necessary for analyzing
ALTER TABLE titanic
DROP COLUMN ticket;

ALTER TABLE titanic
DROP COLUMN fare;

-- change the text to integer
ALTER TABLE titanic
MODIFY COLUMN pclass INTEGER;

-- change the text to integer
ALTER TABLE titanic
MODIFY COLUMN survived INTEGER;

-- check the nulls of the 'age'
SELECT *
FROM titanic
WHERE age IS NULL;

UPDATE titanic
SET age = NULL
WHERE age = '';

ALTER TABLE titanic
MODIFY COLUMN age INTEGER;

-- data is cleaned for analysis now 
SELECT * FROM titanic;

-- extract data to see how many survived per gender and their survival rate 
SELECT
	sex,
    SUM(survived) AS survived,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS death,
    SUM(survived) / (SUM(survived) + SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END)) AS survival_rate
FROM titanic
GROUP BY 1;

-- extract data by survival rate by class
SELECT
	pclass,
    SUM(survived) AS survived,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS death,
    SUM(survived) + SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS total_people,
    SUM(survived) / (SUM(survived) + SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END)) AS survival_rate
FROM titanic
GROUP BY 1;

-- using CTE to rename the numerical class to actual classes
WITH class_cte AS (
SELECT
	pclass,
    SUM(survived) AS survived,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS death,
    SUM(survived) + SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS total_people,
    SUM(survived) / (SUM(survived) + SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END)) AS survival_rate
FROM titanic
GROUP BY 1)
SELECT 
	CASE 
    WHEN pclass = 1 THEN 'first_class'
    WHEN pclass = 2 THEN 'second_class'
    WHEN pclass = 3 THEN 'third_class'
END AS class,
	survived,
    death,
    total_people,
    survival_rate
FROM class_cte;

SELECT * FROM titanic;

-- look at age group for survival rate 
SELECT
    CASE 
        WHEN age < 18 THEN 'Child (0-17)'
        WHEN age BETWEEN 18 AND 35 THEN 'Young Adult (18-35)'
        WHEN age BETWEEN 36 AND 55 THEN 'Adult (36-55)'
        WHEN age > 55 THEN 'Senior (56+)'
        ELSE 'Unknown'
    END AS age_group,
    SUM(survived) AS survived,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS deaths,
    COUNT(*) AS total_passengers,
    SUM(survived) / COUNT(*) AS survival_rate
FROM titanic
GROUP BY age_group
ORDER BY age_group;

SELECT * FROM titanic;

-- survival rate based on gender and class
SELECT
    pclass,
    sex,
    COUNT(*) AS total_passengers,
    SUM(survived) AS survived_passengers,
    (SUM(survived) / COUNT(*)) AS survival_rate
FROM titanic
GROUP BY pclass, sex
ORDER BY pclass, sex;

-- for consistency i would use CTE to rename the numerical classes 
WITH class_sex_CTE AS (
SELECT
    pclass,
    sex,
    COUNT(*) AS total_passengers,
    SUM(survived) AS survived_passengers,
    (SUM(survived) / COUNT(*)) AS survival_rate
FROM titanic
GROUP BY pclass, sex
ORDER BY pclass, sex)
SELECT 
	CASE 
    WHEN pclass = 1 THEN 'first_class'
    WHEN pclass = 2 THEN 'second_class'
    WHEN pclass = 3 THEN 'third_class'
END AS class,
	sex,
    total_passengers,
    survived_passengers,
	survival_rate
FROM class_sex_CTE
ORDER BY survival_rate;

SELECT * FROM titanic;

-- finding the total population, toal deaths, total survived, and death_rate
SELECT 
	sex,
	COUNT(sex) AS total,
    SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS death,
    SUM(CASE WHEN survived = 1 THEN 1 ELSE 0 END) AS survived,
    SUM(survived) / (SUM(survived) + SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END)) AS death_rate
FROM titanic
GROUP BY sex; 

SELECT 
	SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END) AS death,
    SUM(CASE WHEN survived = 1 THEN 1 ELSE 0 END) AS survived,
    SUM(survived) / (SUM(survived) + SUM(CASE WHEN survived = 0 THEN 1 ELSE 0 END)) AS survival_rate
FROM titanic;

SELECT
	AVG(age) AS avg_age
FROM titanic;