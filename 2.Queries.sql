SELECT * FROM encounter	
LIMIT 10

--- Calculating age and age group
SELECT 
	e.id,
	e.start,
	p.birthdate,
	EXTRACT(YEAR FROM AGE(e.start::DATE, p.birthdate)) AS age,
	CASE
		WHEN EXTRACT(YEAR FROM AGE(e.start::DATE, p.birthdate)) BETWEEN 0 AND 18 THEN 'Child'
		WHEN EXTRACT(YEAR FROM AGE(e.start::DATE, p.birthdate)) BETWEEN 19 AND 35 THEN 'Young Adult'
		WHEN EXTRACT(YEAR FROM AGE(e.start::DATE, p.birthdate)) BETWEEN 35 AND 60 THEN 'Adult'
		ELSE 'Senior'
	END AS age_group
FROM encounter e JOIN patients p ON e.patient = p.id

--- Calculating admission status
SELECT
	start,
	stop,
	patient,
	encounterclass,
	description,
	LAG(stop) OVER (PARTITION BY patient ORDER BY start) AS previous_date,
	CASE
		WHEN EXTRACT(EPOCH FROM(stop - start))/3600 > 24 THEN 'Admitted'
		WHEN LAG(stop) OVER (PARTITION BY patient ORDER BY start) IS NOT NULL 
		AND start <= LAG(stop) OVER (PARTITION BY patient ORDER BY start) + INTERVAL '30 days' THEN 'Readmitted'
		ELSE 'Non Admitted'
	END AS admission_status
FROM encounter

--- Calculating LOS
SELECT
	id,
	encounterclass,
	start,
	stop,
	ROUND(EXTRACT (EPOCH FROM (stop-start))/3600, 1) AS LOS,
	CASE
		WHEN ROUND(EXTRACT (EPOCH FROM (stop-start))/3600, 1)<24 THEN 'Short Stay'
		WHEN ROUND(EXTRACT (EPOCH FROM (stop-start))/3600, 1)<= 36 THEN 'Normal Stay'
		ELSE 'Long Stay'
	END AS LOS_Classification
FROM encounter


--- Calculating Mortality Rate
SELECT
	p.Id,
	p.deathdate,
	max(e.stop) AS max_date,
	(p.deathdate - max(e.stop)::DATE) AS day_diff
FROM patients p LEFT JOIN encounter e on p.Id = e.patient
GROUP BY p.Id
ORDER BY deathdate 


--- Calculating no of procedures per encounterclass
SELECT
    e.encounterclass,
    CAST(COUNT(p.description) AS FLOAT) / COUNT(DISTINCT e.id) AS avg_procedures_per_encounter
FROM encounter e
JOIN procedures p ON e.id = p.encounter
GROUP BY e.encounterclass
	