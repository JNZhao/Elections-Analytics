SET SEARCH_PATH TO parlgov;
drop table if exists q5 cascade;


CREATE TABLE q5(
        countryName VARCHAR(50),
        partyName VARCHAR(100),
        partyFamily VARCHAR(50),
        stateMarket REAL
);

--find all the cabinets in the past 20 years
DROP VIEW IF EXISTS timer CASCADE;
CREATE view timer AS
SELECT c.country_id,c.id AS cabinet_id
FROM cabinet c 
WHERE EXTRACT(year FROM c.start_date) <=2017
 AND EXTRACT(year FROM c.start_date)>=1997;

--count all the cabinets in terms of country in the past 20 years
DROP VIEW IF EXISTS country_counter CASCADE;
CREATE view country_counter AS
SELECT t.country_id,count(*) AS counter
FROM timer t
GROUP BY t.country_id;

--count the times of a party appearing in cabinet in the past 20 years
DROP VIEW IF EXISTS party_counter CASCADE;
CREATE view party_counter AS
SELECT cp.party_id, count(*) AS counter
FROM timer t,cabinet_party cp
WHERE   t.cabinet_id=cp.cabinet_id
GROUP BY cp.party_id;

--compare the number of the total cabinets with the number of appearance of 
--a party in that cabinets in the past 20 years in the country
DROP VIEW IF EXISTS compare CASCADE;
CREATE view compare AS
SELECT c1.party_id ,c2.country_id 
FROM party_counter c1 JOIN  country_counter c2
ON c1.counter=c2.counter;

--collect the party's and country's information
DROP VIEW IF EXISTS info CASCADE;
CREATE view info AS
SELECT i.party_id, p.name AS partyName, c.name AS countryName,i.country_id
FROM     compare i, party p, country c
WHERE i.party_id=p.id AND i.country_id=c.id;

--collect and organize the result 
DROP VIEW IF EXISTS result1 CASCADE;
CREATE view result1 AS
SELECT i.party_id,i.partyName, i.countryName, pf.family AS partyFamily 
FROM info i LEFT OUTER JOIN party_family pf
ON i.party_id=pf.party_id;

DROP VIEW IF EXISTS result2 CASCADE;
CREATE view result2 AS
SELECT r1.countryName, r1.partyName, r1.partyFamily, r2.state_market AS stateMarket
FROM result1 r1 LEFT OUTER JOIN party_position AS r2
ON r1.party_id=r2.party_id;

-- the answer to the query 
insert into q5 
SELECT * FROM result2;
