SET search_path to parlgov;

SELECT * FROM q6
GROUP BY countryName, cabinetId, startDate, endDate,pmParty 
Order by countryName DESC, startDate ASC;

