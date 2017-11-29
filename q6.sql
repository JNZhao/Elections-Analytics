-- Sequences
SET search_path TO parlgov;
drop table if exists q6 cascade;

CREATE TABLE q6(
        countryName VARCHAR(50),
        cabinetId INT,
        startDate DATE,
        endDate DATE,
        pmParty VARCHAR(100)
);



DROP VIEW IF EXISTS cabinet_end_date CASCADE;
--find the end date of each cabinet
CREATE VIEW cabinet_end_date AS
SELECT c1.id, c2.start_date AS endDate
FROM cabinet c1, cabinet c2
WHERE c1.id = c2.previous_cabinet_id;


DROP VIEW IF EXISTS pmParty CASCADE;
--find which party the prime minister comes from
CREATE VIEW pmParty AS
SELECT cp.cabinet_id, cp.party_id AS pmPartyId
FROM cabinet_party cp
WHERE cp.pm = True;


DROP VIEW IF EXISTS cabinet_dates CASCADE;
--Combine the satrt date and end date of each cabinet. Fill the end date with 'NULL' when it has not ended
CREATE VIEW cabinet_dates AS
SELECT c.id,c.country_id,c.start_date AS startDate, c2.endDate
FROM cabinet c LEFT JOIN cabinet_end_date c2 on c.id = c2.id;


DROP VIEW IF EXISTS cabinet_dates_party CASCADE;
--join the dates with the party of the prime minister
CREATE VIEW cabinet_dates_party AS
SELECT c.id,c.country_id,c.startDate, c.endDate, pp.pmPartyId
FROM cabinet_dates c LEFT JOIN pmParty pp on c.id  = pp.cabinet_id;

--insert the final result
INSERT INTO q6
SELECT c.name AS countryName, pa.id AS cabinetId, startDate, endDate, p.name AS pmParty
FROM cabinet_dates_party pa, country c, party p
WHERE pa.country_id = c.id and pa.pmPartyId = p.id;