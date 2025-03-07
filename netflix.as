-- criação do database
CREATE DATABASE netflix;

-- seleção do database
USE netflix;

-- criação de tabela 
CREATE TABLE Engagement (
    Title VARCHAR(500),
    Available_Globally VARCHAR(3),
    Release_Date VARCHAR(50),
    Hours_Viewed DOUBLE
);

CREATE TABLE Titles (
    show_id VARCHAR(10),
    type VARCHAR(10),
    title VARCHAR(500),
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(500),
    date_added VARCHAR(50), 
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(20),
    listed_in TEXT,
    description TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/engagement.csv'
INTO TABLE Engagement
CHARACTER SET 'latin1' -- ou 'latin1' dependendo da codificação do arquivo
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@Title, @Available_Globally, @Release_Date, @Hours_Viewed)
SET
    Title = NULLIF(@Title, 'NA'),
    Available_Globally = NULLIF(@Available_Globally, 'NA'),
    Release_Date = STR_TO_DATE(NULLIF(@Release_Date, 'NA'), '%Y-%m-%d'),
    Hours_Viewed = IF(@Hours_Viewed REGEXP '^-?[0-9]+(\.[0-9]*)?$', NULLIF(@Hours_Viewed, 'NA'), NULL);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/titles.csv'
INTO TABLE Titles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(show_id, type, title, director, cast, country, @date_added, release_year, rating, duration, listed_in, description)
SET 
    -- show_id = NULLIF(@show_id, 'NA'),
    -- type = NULLIF(@type, 'NA'),
    -- title = NULLIF(@title, 'NA'),
    -- director = NULLIF(@director, 'NA'),
    -- cast = NULLIF(@cast, 'NA'),
    -- country = NULLIF(@country, 'NA'),
    date_added = NULLIF(@date_added, 'NA');
    -- release_year = NULLIF(@release_year, 'NA'),
    -- rating = NULLIF(@rating, 'NA'),
    -- duration = NULLIF(@duration, 'NA'),
    -- listed_in = NULLIF(@listed_in, 'NA'),
    -- description = NULLIF(@description, 'NA');

SELECT * FROM netflix limited 10;

SELECT t.show_id, t.title, t.type, t.director, t.cast, t.country, t.date_added, t.release_year, t.rating, t.duration, t.listed_in, t.description, e.Hours_Viewed
FROM netflix.titles t
INNER JOIN netflix.engagement e ON t.title = e.Title;

SELECT t.show_id, t.title, t.type, t.director, t.cast, t.country, t.date_added, t.release_year, t.rating, t.duration, t.listed_in, t.description, e.Hours_Viewed
FROM netflix.titles t
RIGHT JOIN netflix.engagement e ON t.title = e.Title;

SELECT t.show_id, t.title, t.type, t.director, t.cast, t.country, t.date_added, t.release_year, t.rating, t.duration, t.listed_in, t.description, e.Hours_Viewed
FROM netflix.titles t
LEFT JOIN netflix.engagement e ON t.title = e.Title
UNION
SELECT t.show_id, t.title, t.type, t.director, t.cast, t.country, t.date_added, t.release_year, t.rating, t.duration, t.listed_in, t.description, e.Hours_Viewed
FROM netflix.titles t
RIGHT JOIN netflix.engagement e ON t.title = e.Title;
