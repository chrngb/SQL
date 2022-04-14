-- DESKTOP-DVN75H2\SQLEXPRESS


-- CREATE DATABASE covidproject;
USE covidproject;
SELECT TOP 5
    *
FROM coviddeath
ORDER BY total_cases DESC;


-- Death percentage

SELECT location, date, total_cases, total_deaths, population,
    total_deaths/total_cases*100
AS "death percentage"
FROM coviddeath
WHERE location = 'Nepal'
ORDER BY 1, 2;


-- case percentage as population

SELECT location, date, total_cases, total_deaths, population,
    total_cases/population*100
AS "case percentage per population"
FROM coviddeath
WHERE location = 'Nepal'
ORDER BY 1, 6 DESC;


-- Max cases per country

SELECT location, max(total_cases) AS maximumcase, population,
    max((total_cases/population))*100 AS "case percentage per population"
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY location, population
-- HAVING LOCATION='nepal'
ORDER BY 4 DESC;


-- death per country

SELECT location, max(total_deaths) AS maximumdeath, population,
    max((total_deaths/population))*100 AS "Death percentage per population"
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC;


-- death per continent

SELECT location, max(total_deaths) AS maximumdeath,
    max((total_deaths/population))*100 AS "Death percentage per population"
FROM coviddeath
WHERE continent IS NULL
GROUP BY location
ORDER BY 3 DESC;



-- cases per date

SELECT date, sum(cast(new_cases AS int)) AS 'Total cases', sum(cast(new_deaths AS int)) AS 'Total deaths'
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


-- total vaccines

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
    sum(cast(new_vaccinations AS bigint)) OVER(PARTITION BY cd.LOCATION ORDER BY cd.LOCATION, cd.date) AS totalvaccine
FROM coviddeath cd
    JOIN covidvaccine cv
    ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 1,2,3;

-- cte

WITH
    popvsvac
    AS

    (
        SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
            sum(cast(new_vaccinations AS bigint)) OVER(PARTITION BY cd.LOCATION ORDER BY cd.LOCATION, cd.date) AS totalvaccine
        FROM coviddeath cd
            JOIN covidvaccine cv
            ON cd.location = cv.location AND cd.date = cv.date
        WHERE cd.continent IS NOT NULL
        -- ORDER BY 1,2,3
    )

SELECT *, totalvaccine/population*100 AS vaccinedpopl
FROM popvsvac;

-- view

DROP VIEW if exists temp
CREATE VIEW temp
AS
    SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
        sum(cast(new_vaccinations AS bigint)) OVER(PARTITION BY cd.LOCATION ORDER BY cd.LOCATION, cd.date) AS totalvaccine
    FROM coviddeath cd
        JOIN covidvaccine cv
        ON cd.location = cv.location AND cd.date = cv.date
    WHERE cd.continent IS NOT NULL;


SELECT *
FROM temp;




