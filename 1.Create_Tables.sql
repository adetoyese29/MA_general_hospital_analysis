DROP TABLE IF EXISTS patients;
CREATE TABLE patients
	(
		Id TEXT PRIMARY KEY,
		BIRTHDATE DATE,
		DEATHDATE DATE,
		PREFIX VARCHAR(5),
		FIRST VARCHAR(20),
		LAST VARCHAR(20),
		SUFFIX VARCHAR(5),
		MAIDEN VARCHAR(20),
		MARITAL VARCHAR(3),
		RACE VARCHAR(12),
		ETHNICITY VARCHAR(15),
		GENDER VARCHAR(5),
		BIRTHPLACE TEXT,
		ADDRESS TEXT,
		CITY TEXT,
		STATE VARCHAR(15),
		COUNTY TEXT,
		ZIP INT,
		LAT FLOAT,
		LON FLOAT
		);

DROP TABLE IF EXISTS payers;
CREATE TABLE payers
	(
		Id TEXT PRIMARY KEY,
		NAME VARCHAR(30),
		ADDRESS TEXT,
		CITY VARCHAR(18),
		STATE_HEADQUARTERED VARCHAR(5),
		ZIP INT,
		PHONE TEXT
		);

DROP TABLE IF EXISTS encounter;
CREATE TABLE encounter
	(
		Id TEXT PRIMARY KEY,
		START TIMESTAMP,
		STOP TIMESTAMP,
		PATIENT TEXT,
		ORGANIZATION TEXT,
		PAYER TEXT,
		ENCOUNTERCLASS VARCHAR(12),
		CODE TEXT,
		DESCRIPTION TEXT,
		BASE_ENCOUNTER_COST FLOAT,
		TOTAL_CLAIM_COST FLOAT,
		PAYER_COVERAGE FLOAT,
		REASONCODE TEXT,
		REASONDESCRIPTION TEXT,
		Start_time TIME,
		Stop_time TIME,
		Start_hour INT,
		Stop_hour INT,
		FOREIGN KEY (PATIENT) REFERENCES patients(Id),
		FOREIGN KEY (PAYER) REFERENCES payers(Id)
		);

DROP TABLE IF EXISTS procedures;
CREATE TABLE procedures
	(
		START TIMESTAMP,
		STOP TIMESTAMP,
		PATIENT TEXT,
		ENCOUNTER TEXT,
		CODE TEXT,
		DESCRIPTION TEXT,
		BASE_COST INT,
		REASONCODE TEXT,
		REASONDESCRIPTION TEXT,
		FOREIGN KEY (PATIENT) REFERENCES patients(Id),
		FOREIGN KEY (ENCOUNTER) REFERENCES encounter(Id)
		);


ALTER TABLE public.encounter OWNER to postgres;
ALTER TABLE public.patients OWNER to postgres;
ALTER TABLE public.procedures OWNER to postgres;
ALTER TABLE public.payers OWNER to postgres;