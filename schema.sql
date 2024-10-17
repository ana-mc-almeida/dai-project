-- Drop tables if they exist
DROP TABLE IF EXISTS energy_consumption;
DROP TABLE IF EXISTS dim_time;
DROP TABLE IF EXISTS dim_location;

CREATE TABLE dim_time (
    time_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    season VARCHAR(15) NOT NULL,
    month INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE dim_location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    district VARCHAR(50) NOT NULL,
    municipality VARCHAR(50) NOT NULL,
    parish VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE energy_consumption (
    fact_id INT AUTO_INCREMENT PRIMARY KEY,
    time_id INT NOT NULL,
    location_id INT NOT NULL,
    energy_consumption BIGINT NOT NULL,
    smart_measures INT NOT NULL,
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);
