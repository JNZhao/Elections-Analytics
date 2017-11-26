SET SEARCH_PATH TO parlgov;
drop table if exists q7 cascade;

DROP TABLE IF EXISTS q7 CASCADE;
CREATE TABLE q7(
        countryId INT, 
        alliedPartyId1 INT, 
        alliedPartyId2 INT
);

--count %30 times elections in terms of country
DROP VIEW IF EXISTS count_elections CASCADE;
CREATE VIEW count_elections AS
SELECT e.country_id, 0.3*count(e.id) AS count_e
FROM election e
GROUP BY e.country_id;

--find alliance pairs
DROP VIEW IF EXISTS pairs CASCADE;
CREATE VIEW pairs AS
SELECT distinct e1.party_id AS a1, e2.party_id AS a2, e1.election_id AS e_id
FROM election_result e1, election_result e2
WHERE e1.election_id = e2.election_id and e1.id != e2.id and 
    (e2.id = e1.alliance_id OR
    e1.id = e2.alliance_id  OR
    e1.alliance_id = e2.alliance_id);

--count times of the alliance pairs participated in different elections in the country 
DROP VIEW IF EXISTS count_pairs CASCADE;
CREATE VIEW count_pairs AS
SELECT a1, a2, country_id, count(*) AS count_p
FROM pairs a, election e
WHERE a.e_id = e.id 
AND    a1 < a2
GROUP BY a1, a2, country_id;

--collect and organize the result
DROP VIEW IF EXISTS result CASCADE;
CREATE VIEW result AS
SELECT cp.country_id AS countryId, a1 AS alliedParty1, a2 AS alliedParty2
FROM count_elections ce, count_pairs cp
WHERE ce.country_id = cp.country_id
AND cp.count_p >= ce.count_e;

-- the answer to the query 
insert into q7 
SELECT * FROM result;


