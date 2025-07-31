CREATE DATABASE ENERGYDB2;
USE ENERGYDB2;

-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

SELECT * FROM COUNTRY; 

-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM EMISSION_3;  

-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);
SELECT * FROM POPULATION;

-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);
desc production;

SELECT * FROM PRODUCTION;

-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);

SELECT * FROM GDP_3;

-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM CONSUMPTION;


-- Data Analysis Questions
 -- General & Comparative Analysis
-- 1. What is the total emission per country for the most recent year available?
SELECT country, SUM(emission) AS total_emission
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY total_emission DESC;

-- 2.What are the top 5 countries by GDP in the most recent year?
SELECT country, value AS gdp
FROM gdp_3
WHERE year = (SELECT MAX(year) FROM gdp_3)
ORDER BY gdp DESC
LIMIT 5;

-- 3.Compare energy production and consumption by country and year. 
SELECT p.country, p.year, p.energy, p.production, c.consumption
FROM production p
JOIN consumption c ON p.country = c.country AND p.year = c.year AND p.energy = c.energy
order by production desc;

-- 4. Which energy types contribute most to emissions across all countries?
SELECT energy_type, SUM(emission) AS total_emission
FROM emission_3
GROUP BY energy_type
ORDER BY total_emission DESC;

-- 5. What is the average energy production for each energy type across all years?
SELECT energy, 
       ROUND(AVG(production), 2) AS avg_production
FROM production
GROUP BY energy
ORDER BY avg_production DESC;

-- 6. Top 5 countries with the highest energy production in the latest year
SELECT country, 
       SUM(production) AS total_production
FROM production
WHERE year = (SELECT MAX(year) FROM production)
GROUP BY country
ORDER BY total_production DESC
LIMIT 5;

-- 7.How have global emissions changed year over year?
SELECT 
    year,
    SUM(emission) AS total_global_emission
FROM 
    emission_3
GROUP BY 
    year
ORDER BY 
    year;
    

-- 8.  Which 5 countries have the lowest total energy production in the latest year?
SELECT country, SUM(production) AS total_production
FROM production
WHERE year = (SELECT MAX(year) FROM production)
GROUP BY country
ORDER BY total_production ASC
LIMIT 5;

-- 9.Which energy types are used by the most number of countries in the latest year?
SELECT energy, COUNT(DISTINCT country) AS country_count
FROM consumption
WHERE year = (SELECT MAX(year) FROM consumption)
GROUP BY energy
ORDER BY country_count DESC;


  
-- 10.How many countries reported GDP data in the latest year?
SELECT COUNT(DISTINCT Country) AS countries_reporting_gdp
FROM gdp_3
WHERE year = (SELECT MAX(year) FROM gdp_3);


-- 11.How have global emissions changed year over year?
SELECT 
    year,
    SUM(emission) AS total_global_emission
FROM 
    emission_3
GROUP BY 
    year
ORDER BY 
    year;
    
-- 12. Has energy consumption increased or decreased over the years for major economies?
   SELECT 
    country,
    year,
    SUM(consumption) AS total_consumption
FROM 
    consumption
WHERE 
    country IN ('United States', 'China', 'India', 'Germany', 'Japan')
GROUP BY 
    country, year
ORDER BY 
    country, year;

    -- 13. What is the global GDP trend over the years?
SELECT year, 
       ROUND(SUM(Value), 2) AS global_gdp
FROM gdp_3
GROUP BY year
ORDER BY year;

-- 14. How has global population changed over time?
SELECT year, 
       ROUND(SUM(Value), 0) AS global_population
FROM population
GROUP BY year
ORDER BY year;
   
    
    
