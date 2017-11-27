--Participate

SET search_path TO parlgov;
drop table if exists q3 cascade;

CREATE table q3(
        countryName VARCHAR(50),
        year INT,
        participationRatio real
);



DROP VIEW IF EXISTS fifteenyear_election CASCADE;
--select elections from the past 15 years and the corresponding participation ratio
CREATE VIEW fifteenyear_election AS
SELECT country_id, EXTRACT(YEAR from e_date) AS year, cast(votes_cast AS FLOAT)/electorate AS participationRatio
FROM election
WHERE  EXTRACT(YEAR from e_date)>=2001 and EXTRACT(YEAR from e_date) <= 2016;


DROP VIEW IF EXISTS participation CASCADE;
--take average of the partipation ratio by year and exclude the null values
CREATE VIEW participation AS
SELECT country_id,year,avg(participationRatio) AS participationRatio
FROM fifteenyear_election
WHERE  participationRatio>=0 and participationRatio<=1
GROUP BY  country_id, year;


DROP VIEW IF EXISTS enthu_country CASCADE;
--exclude all countries that do not have a non-descending participation ratio (i.e. participation ratio decreases temporarily)
CREATE VIEW enthu_country AS
(SELECT  country_id  FROM participation)
EXCEPT
(SELECT country_id
 FROM participation p
 WHERE p.participationRatio<SOME(
     SELECT participationRatio
     FROM participation
     WHERE p.year>year)
);


DROP VIEW IF EXISTS enthu_participation CASCADE;
--the final result
CREATE VIEW enthu_participation AS
SELECT c.name,p.year,cast(cast(p.participationRatio AS decimal(18,6))AS FLOAT)
FROM participation p, enthu_country ci, country c
WHERE  p.country_id = ci.country_id and ci.country_id = c.id;


INSERT INTO q3 select * from enthu_participation;