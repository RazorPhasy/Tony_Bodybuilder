USE `Tonybodybuilder`;

-- creating tables
-- ////////////////////////////////////////////////
CREATE TABLE TonyAmData (
	id INT,
	date Date,
	time_of_day TIME,
    hours_of_sleep_last_night FLOAT,
    calories_consumed_before_workout INT,
    muscle_group VARCHAR(255),
    muscle VARCHAR(255),
	`set` INT,
    excerise VARCHAR(255),
    weight_or_resistance INT,
    reps  INT,
    intensity_rating_1_to_10 Float,
    rest_or_sleep_time_after_workout_in_mins Float,
    bars INT,
    muscle_that_is_sore VARCHAR(255),
    soreness INT,
    second_muscle_that_is_sore VARCHAR(255),
    second_soreness INT,
    previous_days_before_workout INT,
    muscle_group_targeted_previous_workout VARCHAR(255),
    exercise_workout_summary VARCHAR(255),
    average_rep_time_workout_summary_in_secs FLOAT,
    average_rest_time_workout_summary_in_secs FLOAT,
    total_time_of_workout_in_mins FLOAT,
    entire_workout_summary_total_time_in_mins FLOAT,
    notes VARCHAR(255)
);



CREATE TABLE TonyPmData (
	id INT,
	date DATE,
	time_of_day TIME,
    hours_of_sleep_last_night FLOAT,
    calories_consumed_before_workout INT,
    muscle_group VARCHAR(255),
    muscle VARCHAR(255),
	`set` INT,
    excerise VARCHAR(255),
    weight_or_resistance INT,
    reps INT,
    intensity_rating_1_to_10 FLOAT,
    rest_or_sleep_time_after_workout_in_mins FLOAT,
    bars INT,
    muscle_that_is_sore VARCHAR(255),
    soreness INT,
    previous_days_before_workout INT,
    muscle_group_targeted_previous_workout VARCHAR(255),
    exercise_workout_summary VARCHAR(255),
    average_rep_time_workout_summary_in_secs FLOAT,
    average_rest_time_workout_summary_in_secs FLOAT,
    total_time_of_workout_in_mins FLOAT,
    entire_workout_summary_total_time_in_mins FLOAT,
    notes VARCHAR(255),
	second_muscle_that_is_sore VARCHAR(255),
    second_soreness INT
);




-- change because of reserved keyword
-- ////////////////////////////////////////////////
ALTER TABLE TonyAmData
CHANGE COLUMN `set` `sets` INT;


ALTER TABLE TonyPmData
CHANGE COLUMN `set` `sets` INT;

--    SELECT *
--    from TonyAmData;

-- SELECT *
-- FROM TonyPmData;



-- combining both tables
-- ////////////////////////////////////////////////

CREATE TABLE AllTonysWorkouts AS
SELECT *
FROM TonyData

UNION

SELECT *
FROM TonyPmData;

--    SELECT *
--    FROM AllTonysWorkouts;


-- 
START TRANSACTION;
ROLLBACK;
-- 

-- delete duplicates 
-- ////////////////////////////////////////////////
WITH DuplicateColumns AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY date, time_of_day, hours_of_sleep_last_night, 
            calories_consumed_before_workout, sets, muscle_group, muscle,
            excerise, weight_or_resistance, reps
        ) AS Row_num
    FROM AllTonysWorkouts
)


-- SELECT *
-- FROM DuplicateColumns
-- WHERE Row_num > 1;

DELETE FROM AllTonysWorkouts
WHERE id IN (
    SELECT id
    FROM DuplicateColumns
WHERE Row_num > 1
);

COMMIT;


-- 
START TRANSACTION;
ROLLBACK;
-- 


-- updating muscle_group column with naming convention
-- ////////////////////////////////////////////////
SELECT DISTINCT(muscle_group)
FROM AllTonysWorkouts;



SELECT *
FROM AllTonysWorkouts
WHERE muscle_group = 'Leg /Shoulder';


UPDATE AllTonysWorkouts
SET muscle_group = 
    CASE 
        WHEN muscle = 'Shoulder' THEN 'Pull'
        WHEN muscle = 'Leg' THEN 'Legs'
        ELSE muscle_group
    END
WHERE muscle_group = 'Leg /Shoulder';

UPDATE AllTonysWorkouts
SET muscle_group = 'Legs'
WHERE muscle_group = 'Leg';


-- update muscle column with naming convention
-- ////////////////////////////////////////////////
SELECT DISTINCT(muscle)
FROM AllTonysWorkouts;

UPDATE AllTonysWorkouts
SET muscle = 
    CASE 
        WHEN muscle = 'chest/ shoulder' THEN 'Chest / Shoulder'
        WHEN muscle = 'leg / shoulder' THEN 'Leg / Shoulder'
        WHEN muscle = 'Back/Bicep' THEN 'Back / Bicep'
        WHEN muscle = 'Chest/ Tricep' THEN 'Chest / Tricep'
        ELSE muscle
    END
WHERE muscle IN ('chest/ shoulder', 'leg / shoulder','Back/Bicep','Chest/ Tricep');




-- update column name spelling error
-- ////////////////////////////////////////////////
ALTER TABLE AllTonysWorkouts
RENAME COLUMN excerise TO exercise;


SELECT DISTINCT exercise
FROM AllTonysWorkouts
ORDER BY exercise asc;


COMMIT;

-- 
START transaction;
ROLLBACK;
-- 



-- update exercise and exercise_workout_summary column with naming convention
-- ////////////////////////////////////////////////
UPDATE AllTonysWorkouts
SET exercise = 
    CASE
        WHEN exercise = 'tricep extention' THEN 'Tricep extension'
        WHEN exercise = 'tricep dip machine / single arm tricep extention' THEN 'Tricep dip machine / Tricep extension single arm'
        WHEN exercise = 'tricep dip machine' THEN 'Tricep dip machine'
        WHEN exercise = 'tricep cable rope pulldown' THEN 'Tricep cable rope pulldown'
        WHEN exercise = 'single arm tricep extention' THEN 'Tricep extension single arm'
        WHEN exercise = 'Row machine single'  THEN 'Row machine single arm'
        WHEN exercise = 'incline chest press machine / single' THEN 'Incline chest press machine single arm'
        WHEN exercise = 'Extended bicep curl / Single'  THEN 'Extended bicep curl single arm'
        WHEN exercise = 'Bicep curl close grip single' THEN 'Bicep curl close grip single arm'
        WHEN exercise = 'chest press smith machine' THEN 'Chest press smith machine'
        WHEN exercise = 'calf raises' THEN 'Calf raises'
        WHEN exercise = 'Leg extention' THEN 'Leg extension'
        WHEN exercise = 'Tricep dip machine / tricep extension single arm' THEN 'Tricep dip machine / Tricep extension single arm'
        ELSE exercise
    END,
	exercise_workout_summary = CASE 
                                    WHEN exercise = 'tricep extention' THEN 'Tricep extension'
                                    WHEN exercise = 'tricep dip machine / single arm tricep extention' THEN 'Tricep dip machine / Tricep extension single arm'
                                    WHEN exercise = 'tricep dip machine' THEN 'Tricep dip machine'
                                    WHEN exercise = 'tricep cable rope pulldown' THEN 'Tricep cable rope pulldown'
                                    WHEN exercise = 'single arm tricep extention' THEN 'Tricep extension single arm'
                                    WHEN exercise = 'Row machine single'  THEN 'Row machine single arm'
                                    WHEN exercise = 'incline chest press machine / single' THEN 'Incline chest press machine single arm'
                                    WHEN exercise = 'Extended bicep curl / Single'  THEN 'Extended bicep curl single arm'
                                    WHEN exercise = 'Bicep curl close grip single' THEN 'Bicep curl close grip single arm'
                                    WHEN exercise = 'chest press smith machine' THEN 'Chest press smith machine'
									WHEN exercise = 'calf raises' THEN 'Calf raises'
                                    WHEN exercise = 'Leg extention' THEN 'Leg extension'
                                    WHEN exercise = 'Tricep dip machine / tricep extension single arm' THEN 'Tricep dip machine / Tricep extension single arm'
                                    ELSE exercise
                                END;

UPDATE TonyPmData
SET second_muscle_that_is_sore = TRIM(SUBSTRING_INDEX(muscle_that_is_sore, ',', -1));

-- Update muscle_that_is_sore column to remove the part after the comma
-- UPDATE TonyPmData
-- SET muscle_that_is_sore = TRIM(SUBSTRING_INDEX(muscle_that_is_sore, ',', 1));

-- UPDATE TonyPmData
-- SET 
-- 	muscle_that_is_sore = CONCAT(UPPER(SUBSTRING(muscle_that_is_sore, 1, 1)), 
-- 	LOWER(SUBSTRING(muscle_that_is_sore, 2)));



-- Cleaning second_muscle_that_is_sore column, it imported with wrong rows


UPDATE AllTonysWorkouts
SET second_muscle_that_is_sore = ' ';

-- SELECT second_muscle_that_is_sore
-- FROM AllTonysWorkouts;


-- SELECT DISTINCT(muscle_that_is_sore)
-- FROM AllTonysWorkouts;


-- parsed the 'muscle_that_is_sore' column to extract the second muscle
UPDATE AllTonysWorkouts
SET second_muscle_that_is_sore = SUBSTRING_INDEX(muscle_that_is_sore, ', ', -1)
WHERE muscle_that_is_sore LIKE '%, %';


SELECT DISTINCT(second_muscle_that_is_sore)
FROM AllTonysWorkouts;


-- title casing second_muscle_that_is_sore
UPDATE AllTonysWorkouts
SET second_muscle_that_is_sore = 
    CASE 
        WHEN second_muscle_that_is_sore LIKE '%legs%' THEN 'Legs'
        WHEN second_muscle_that_is_sore LIKE '%neck%' THEN 'Neck'
        ELSE NULL
    END;


-- Case-insensitive grouping for muscle_that_is_sore
UPDATE AllTonysWorkouts
SET muscle_that_is_sore = 
    CASE 
        WHEN muscle_that_is_sore IS NULL THEN NULL
        WHEN muscle_that_is_sore LIKE '%delts%' THEN 'Delts'
        WHEN muscle_that_is_sore LIKE '%legs%' THEN 'Legs'
        WHEN muscle_that_is_sore LIKE '%neck%' THEN 'Neck'
        WHEN muscle_that_is_sore LIKE '%back%' THEN 'Back'
        ELSE muscle_that_is_sore
    END;
    

COMMIT;


-- 
START TRANSACTION;
ROLLBACK;
-- 


-- Categorizing Muscles into Muscle Groups

UPDATE AllTonysWorkouts
SET muscle_group = ' ';


-- SELECT muscle_group
-- FROM AllTonysWorkouts;

-- SELECT distinct(muscle)
-- FROM AllTonysWorkouts;

UPDATE AllTonysWorkouts
SET muscle_group = 'Push'
WHERE muscle IN ('Chest', 'Tricep', 'Chest / Tricep', 'Shoulder', 'Tricep / Shoulder', 'Chest / Shoulder');

UPDATE AllTonysWorkouts
SET muscle_group = 'Pull'
WHERE muscle IN ('Bicep', 'Back', 'Back / Bicep');


UPDATE AllTonysWorkouts
SET muscle_group = 'Legs'
WHERE muscle IN ('Leg');

SELECT *
FROM AllTonysWorkouts;




-- adding column total_weight_lifted_per_excerise
ALTER TABLE AllTonysWorkouts
ADD total_weight_lifted_per_excerise  INT;



-- WITH WeightCTE AS (
--     SELECT date, 
--            exercise, 
--            SUM(weight_or_resistance) OVER (PARTITION BY date, exercise) AS total_weight_lifted
--     FROM AllTonysWorkouts
-- )
-- SELECT date, 
--        exercise, 
--        total_weight_lifted
-- FROM WeightCTE
-- ORDER BY exercise, date;



-- making CTE to see the calculated total wieght lifted
WITH WeightCTE AS (
    SELECT date, 
           exercise, 
           SUM(weight_or_resistance) OVER (PARTITION BY date, exercise) AS total_weight_lifted_per_excerise
    FROM AllTonysWorkouts
)
UPDATE AllTonysWorkouts AS a
JOIN WeightCTE AS b
ON a.date = b.date AND a.exercise = b.exercise
SET a.total_weight_lifted_per_excerise = b.total_weight_lifted_per_excerise;

SELECT DISTINCT(intensity_rating_1_to_10)
FROM AllTonysWorkouts;

-- add stimulate_hypertrophy column
ALTER TABLE AllTonysWorkouts
ADD stimulate_hypertrophy varchar(255);

UPDATE AllTonysWorkouts
SET stimulate_hypertrophy = 
    CASE
        WHEN intensity_rating_1_to_10 >= 8 THEN 'Yes'
        WHEN intensity_rating_1_to_10 IS NULL THEN ' '
        ELSE 'No'
    END;


-- SELECT DISTINCT(calories_consumed_before_workout)
-- FROM AllTonysWorkouts;


-- ALTER TABLE AllTonysWorkouts
-- ADD intensity_rating_1_to_10_pull INT;


-- UPDATE AllTonysWorkouts AS a
-- JOIN (
--     SELECT date, AVG(intensity_rating_1_to_10) AS avg_intensity
--     FROM AllTonysWorkouts
--     WHERE muscle_group = 'pull'
--     GROUP BY date
-- ) AS b ON a.date = b.date
-- SET a.intensity_rating_1_to_10_pull = b.avg_intensity
-- WHERE a.muscle_group = 'pull';

-- ALTER TABLE AllTonysWorkouts
-- DROP COLUMN intensity_rating_1_to_10_pull;



-- SELECT *
-- FROM AllTonysWorkouts
-- WHERE date = '2024-02-16';


-- Exporting data to Tableau making sore piechart
SELECT 
    date,
    muscle_that_is_sore AS muscle_group,
    MAX(soreness) AS total_soreness
FROM AllTonysWorkouts
WHERE muscle_that_is_sore IS NOT NULL
GROUP BY date, muscle_that_is_sore

UNION ALL

SELECT 
    date,
    second_muscle_that_is_sore AS muscle_group,
    MAX(second_soreness) AS total_soreness
FROM AllTonysWorkouts
WHERE second_muscle_that_is_sore IS NOT NULL
GROUP BY date, second_muscle_that_is_sore;
