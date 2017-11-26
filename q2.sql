SET SEARCH_PATH TO parlgov;
drop table if exists q2 cascade;

create table q2(
countryName VARCHaR(100),
partyName VARCHaR(100),
partyFamily VARCHaR(100),
wonElections INT,
mostRecentlyWonElectionId INT,
mostRecentlyWonElectionYear INT
);

-- find total number of party of each country
DROP VIEW IF EXISTS party_num CASCADE;
CREATE VIEW party_num AS                
SELECT country_id, count(id) AS totalparties
FROM party
GROUP BY country_id;

-- find total number of elections of each country
DROP VIEW IF EXISTS e_num CASCADE;                  
CREATE VIEW e_num AS
SELECT country_id, count(id) AS totalelections
FROM election
GROUP BY country_id;

-- 3 times the average number of winning elections of parties of the each country.
DROP VIEW IF EXISTS avg_three CASCADE;   
CREATE VIEW avg_three AS
SELECT country_id AS cid, 
(3*(cast(e_num.totalelections AS decimal)/ party_num.totalparties)) AS threeavg
from e_num natural join party_num;

-- find the winners of each election.
DROP VIEW IF EXISTS winners CASCADE;
CREATE view winners AS
SELECT e1.election_id AS eid, e1.party_id AS pid
FROM election_result  e1
WHERE e1.votes>=ALL(
        SELECT votes 
        FROM election_result e2
        WHERE e1.election_id=e2.election_id);

-- count times of a party has won.
DROP VIEW IF EXISTS numwon CASCADE;
CREATE VIEW numwon AS     
-- ***********************numwon  -> timesofwown
SELECT pid, count(eid) as wonelections
FROM winners
GROUP BY pid;

-- combine the party with the corresponding country's info
DROP VIEW IF EXISTS add_country CASCADE;
CREATE VIEW add_country AS
SELECT country_id AS cid, pid, wonelections
FROM party, numwon
WHERE pid = party.id;

-- find the party that won more than 3 times the average number of winning elections of parties for the same country
DROP VIEW IF EXISTS more_avg CASCADE;
CREATE VIEW more_avg AS    
SELECT add_country.cid, pid, wonelections
FROM avg_three, add_country
WHERE avg_three.cid = add_country.cid AND
      add_country.wonelections > threeavg;

-- find the most recent date of the won election
DROP VIEW IF EXISTS mostrecent CASCADE;
CREATE VIEW mostrecent AS
SELECT more_avg.pid, max(election.e_date) AS Mostrecentdate
FROM winners, more_avg, election
WHERE more_avg.pid  = winners.pid AND
      winners.eid = election.id
GROUP BY more_avg.pid;

-- collect and add infomation
DROP VIEW IF EXISTS add_date CASCADE;
CREATE VIEW add_date AS
SELECT cid, mostrecent.pid, wonelections, Mostrecentdate
FROM mostrecent, more_avg
WHERE mostrecent.pid = more_avg.pid;

-- collect and organize result
DROP VIEW IF EXISTS result1 CASCADE;
CREATE VIEW result1 AS
SELECT cid, pid, election.id AS eid, wonelections,extract(year from Mostrecentdate) AS mostrecentyear
FROM add_date, election
WHERE add_date.Mostrecentdate = election.e_date AND
      add_date.cid = election.country_id;

DROP VIEW IF EXISTS result2 CASCADE;
CREATE VIEW result2 AS
SELECT country.name AS countryName, party.name AS partyName, party_family.family AS partyFamily, 
wonelections, eid, mostrecentyear
FROM (result1 left join party_family on pid = party_family.party_id), country, party
WHERE cid = country.id AND
      pid = party.id;

-- the answer to the query
Insert into q2
SELECT * FROM result2;