-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT * FROM hr;

SELECT gender, COUNT(*) as count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT * FROM hr;

SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company?
SELECT CASE
	WHEN age >= 18 AND age <= 30 THEN '18-30'
    WHEN age >= 31 AND age <= 40 THEN '31-40'
    WHEN age >= 41 AND age <= 50 THEN '41-50'
    WHEN age >= 51 AND age <= 60 THEN '51-60'
    ELSE '60+'
END age_group, COUNT(*) as count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;


-- 4. How many employees work at headquarters versus remote locations?

SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;



-- 5. What is the average length of employment for employees who have been terminated?
USE project1;

SELECT * FROM hr;


SELECT round(avg(datediff(termdate, hire_date))/365,0) AS retention_rate
FROM hr
WHERE termdate IS NOT NULL AND termdate <= curdate() AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT gender, department, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;


-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY count DESC;


-- 8. Which department has the highest turnover rate?
SELECT department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate
FROM (SELECT department, 
	COUNT(*) AS total_count,
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
	WHERE age >= 18
	GROUP BY department
	) AS sq
ORDER BY termination_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?
SELECT * FROM hr;

SELECT location_city, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_city
ORDER BY count DESC;

SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT year,
hires,
terminations,
hires-terminations AS net_change,
round((hires-terminations)/hires*100, 2) AS net_change_percent
FROM 
	(SELECT YEAR(hire_date) AS year,
	COUNT(*) AS hires,
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
	FROM hr
	WHERE age >= 18
	GROUP BY YEAR(hire_date)
	) AS sq
ORDER BY year ASC;


-- 11. What is the tenure distribution for each department?
SELECT department, 
round(avg(datediff(termdate, hire_date))/365,0) AS avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL AND age >= 18
GROUP BY department
ORDER BY avg_tenure DESC;
