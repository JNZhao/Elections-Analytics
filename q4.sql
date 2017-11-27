-- Left-right

SET search_path TO parlgov;
drop table if exists q4 cascade;

CREATE TABLE q4(
          countryName VARCHAR(50),
          r0_2 INT,
          r2_4 INT,
          r4_6 INT,
          r6_8 INT,
          r8_10 INT
);


DROP VIEW IF EXISTS party_r0_2 CASCADE;
--count how many parties have the left_right position between 0 and 2
CREATE VIEW party_r0_2 AS
SELECT p.country_id, count(pp.party_id) AS r0_2
FROM party p JOIN party_position pp on p.id = pp.party_id
WHERE left_right<2 and left_right>=0
GROUP BY p.country_id;


DROP VIEW IF EXISTS party_r2_4 CASCADE;
--count how many parties have the left_right position between 2 and 4
CREATE VIEW party_r2_4 AS
SELECT p.country_id, count(pp.party_id) AS r2_4 FROM party p JOIN party_position pp on p.id = pp.party_id
WHERE left_right<4 and left_right>=2
GROUP BY p.country_id;


DROP VIEW IF EXISTS party_r4_6 CASCADE;
--count how many parties have the left_right position between 4 and 6
CREATE VIEW party_r4_6 AS
SELECT p.country_id, count(pp.party_id) AS r4_6
FROM party p JOIN party_position pp on p.id = pp.party_id
WHERE left_right<6 and left_right>=4
GROUP BY p.country_id;


DROP VIEW IF EXISTS party_r6_8 CASCADE;
--count how many parties have the left_right position between 6 and 8
CREATE VIEW party_r6_8 AS
SELECT p.country_id, count(pp.party_id) AS r6_8
FROM party p JOIN party_position pp on p.id = pp.party_id
WHERE left_right < 8 and left_right >= 6
GROUP BY p.country_id;


DROP VIEW IF EXISTS party_r8_10 CASCADE;
--count how many parties have the left_right position between 8 and 10
CREATE VIEW party_r8_10 AS
SELECT p.country_id, count(pp.party_id) AS r8_10
FROM party p JOIN party_position pp on p.id = pp.party_id
WHERE left_right < 10 and left_right>=8
GROUP BY p.country_id;


DROP VIEW IF EXISTS LR CASCADE;
--combine all the categories of the count of left-right position by countriy_id
CREATE VIEW LR AS
SELECT country_id, r0_2, r2_4, r4_6, r6_8, r8_10
FROM party_r0_2 NATURAL FULL JOIN party_r2_4
NATURAL FULL JOIN party_r4_6
NATURAL FULL JOIN party_r6_8
NATURAL FULL JOIN party_r8_10;

--insert the final result
INSERT INTO q4(
   SELECT c.name AS countryName, r0_2, r2_4, r4_6, r6_8, r8_10
   FROM country c LEFT JOIN LR lr ON c.id = lr.country_id);