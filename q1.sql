--VoteRange

SET search_path TO parlgov;
drop table if exists q1 cascade;

CREATE TABLE q1(
   year INT,
   countryName VARCHAR(50),
   voteRange VARCHAR(20),
   partyName VARCHAR(100)
);

--select elections over the past 10 years
DROP VIEW IF EXISTS tenyear_election CASCADE;
CREATE VIEW tenyear_election AS
SELECT id, country_id, EXTRACT(YEAR from e_date) AS year, votes_valid
FROM election
WHERE EXTRACT(YEAR from e_date) <=2016 and EXTRACT(YEAR from e_date)>=1996;

--join the elections with the relavant vote info
DROP VIEW IF EXISTS votes_in_election CASCADE;
CREATE VIEW  votes_in_election AS
SELECT  ee.country_id, ee.year, er.party_id, cast(avg(er.votes) AS FLOAT)/avg(ee.votes_valid)* 100 AS voteRange
FROM tenyear_election ee, election_result er
WHERE er.election_id = ee.id
GROUP BY er.party_id, ee.year,ee.country_id;


--assign the vote range value to its corresponding textual range
DROP VIEW IF EXISTS vote_range_result CASCADE;
CREATE VIEW  vote_range_result AS
SELECT ev.year, c.name AS countryName, case when(ev.voteRange<=5) THEN '(0-5]'
                                            when(ev.voteRange>5 and ev.voteRange<=10) THEN '(5-10]'
                                            when(ev.voteRange>10 and ev.voteRange<=20) THEN '(10-20]'
                                            when(ev.voteRange>20 and ev.voteRange<=30) THEN '(20-30]'
                                            when(ev.voteRange>30 and ev.voteRange<=40) THEN '(30-40]'
                                            when(ev.voteRange>40 and ev.voteRange<=100) THEN '(40-100]'
                                            ELSE '-0' END,
                                       p.name_short AS partyName
FROM votes_in_election ev, party p,  country c
WHERE ev.country_id = c.id and p.id = ev.party_id and ev.voteRange is NOT NULL
GROUP BY ev.party_id,ev.year,c.name,p.name_short,ev.voteRange;

INSERT INTO q1 select * from vote_range_result;