DROP DATABASE IF EXISTS energy_dw;

CREATE DATABASE energy_dw;

USE energy_dw;

-- Drop tables if they exist
DROP TABLE IF EXISTS energy_consumption;
DROP TABLE IF EXISTS dim_time;
DROP TABLE IF EXISTS dim_location;

CREATE TABLE dim_time (
    time_id INT PRIMARY KEY,
    year_id INT NOT NULL,
    date_value CHAR(25) NOT NULL,
    season_name VARCHAR(25) NOT NULL,
    season_id INT NOT NULL,
    month_name VARCHAR(25) NOT NULL,
    month_id INT NOT NULL
);

CREATE TABLE dim_location (
    location_id INT PRIMARY KEY,
    district VARCHAR(100) NOT NULL,
    district_code INT NOT NULL,
    municipality VARCHAR(100) NOT NULL,
    municipality_code INT NOT NULL,
    parish VARCHAR(100) NOT NULL,
    parish_code VARCHAR(100) 
);

CREATE TABLE fact_energy_consumption (
    time_id INT NOT NULL,
    location_id INT NOT NULL,
    energy_consumption BIGINT NOT NULL,
    PRIMARY KEY (time_id, location_id),
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE fact_smart_measures (
    time_id INT NOT NULL,
    location_id INT NOT NULL,
    smart_measures FLOAT NOT NULL,
    PRIMARY KEY (time_id, location_id),
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);



DROP PROCEDURE IF EXISTS populate_time_dimension;
DELIMITER $$

CREATE PROCEDURE populate_time_dimension()
BEGIN
    DECLARE todays_date DATE;
    DECLARE end_date DATE;

    -- Initialize the start and end dates
    SET todays_date = '2020-01-01';
    SET end_date = '2030-12-31';

    -- Loop through each date
    WHILE todays_date <= end_date DO
        INSERT INTO dim_time (
            time_id,
            date_value,
            year_id,
            season_id,
	    season_name,
            month_name,
            month_id
        )
        VALUES (
            -- Date ID format: YYYYMM
            YEAR(todays_date) * 100 + MONTH(todays_date),
            -- Date as a string
            DATE_FORMAT(todays_date, '%Y-%m'),
            -- Year number
            YEAR(todays_date),
            -- Season number
            CASE 
                WHEN MONTH(todays_date) IN (12, 1, 2) THEN 1
                WHEN MONTH(todays_date) IN (3, 4, 5) THEN 2
                WHEN MONTH(todays_date) IN (6, 7, 8) THEN 3
                WHEN MONTH(todays_date) IN (9, 10, 11) THEN 4
            END,
	    -- Season name
	    CASE 
                WHEN MONTH(todays_date) IN (12, 1, 2) THEN 'Winter'
                WHEN MONTH(todays_date) IN (3, 4, 5) THEN 'Spring'
                WHEN MONTH(todays_date) IN (6, 7, 8) THEN 'Summer'
                WHEN MONTH(todays_date) IN (9, 10, 11) THEN 'Autumn'
            END,
            -- Month name
            MONTHNAME(todays_date),
            -- Month number
            MONTH(todays_date)
           );

        -- Increment the date by one day
        SET todays_date = DATE_ADD(todays_date, INTERVAL 1 MONTH);
    END WHILE;
END$$

DELIMITER ;


-- Execute the procedure to populate the table
CALL populate_time_dimension();



