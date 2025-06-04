-- SQL script to set up the educators table and produce reports

-- Table creation
CREATE TABLE educators (
    first_name VARCHAR(50),
    last_name VARCHAR(50) CHECK (char_length(last_name) > 1),
    dob DATE,
    gender VARCHAR(10),
    college_attended VARCHAR(100),
    degree_title VARCHAR(100),
    media VARCHAR(50),
    date_contacted DATE,
    school_placed VARCHAR(100),
    date_found_job DATE
);

-- Sample data insertion
INSERT INTO educators VALUES
    ('Mary', 'Lynn', '2000-09-13', 'Female', 'Excelsior College', 'BA in Mathematics Education', 'Magazine', '2022-05-02', 'Brooklyn High School', '2022-05-09'),
    ('Josh', 'Frank', '1998-04-23', 'Male', 'Georgia State University', 'MA in Social Studies Education', 'Social Media', '2022-02-12', 'Manhattan Elementary School', '2022-05-09'),
    ('Charles', 'Smith', '1994-07-09', 'Male', 'Excelsior College', 'PhD in Education', 'Social Media', '2021-08-07', 'New York City Day School', '2021-08-12'),
    ('Samantha', 'Brown', '1999-09-24', 'Female', 'Columbia University', 'BA in English Education', 'Newspaper', '2021-05-23', 'Brooklyn High School', '2021-07-30'),
    ('Howard', 'Lang', '1998-08-04', 'Male', 'Georgia State University', 'MA in History Education', 'Word of Mouth', '2022-01-31', NULL, NULL),
    ('Sarah', 'Blanks', '1995-10-20', 'Female', 'Columbia University', 'MA in Science Education', 'Social Media', '2020-05-23', 'New York City Day School', '2020-08-17'),
    ('Ella', 'Lewis', '2000-08-22', 'Female', 'Excelsior College', 'BA in English Education', 'Word of Mouth', '2022-04-01', NULL, NULL),
    ('Julie', 'Goldman', '1997-03-30', 'Female', 'University of Denver', 'MA in Social Studies Education', 'Social Media', '2020-07-14', 'Manhattan Elementary School', '2020-08-17');

-- 1. Placement Speed by College (placements made within two weeks of contact)
SELECT college_attended,
       COUNT(*) AS placed_within_two_weeks
FROM educators
WHERE date_found_job IS NOT NULL
  AND date_found_job <= date_contacted + INTERVAL '14 days'
GROUP BY college_attended;

-- 2. Placement Success by Gender
SELECT gender,
       COUNT(*) FILTER (WHERE date_found_job IS NOT NULL) AS placed_count,
       COUNT(*) FILTER (WHERE date_found_job IS NULL) AS not_placed_count
FROM educators
GROUP BY gender;

-- 3. Daily Contact and Media Source Analysis
-- 3a. Average number of people who contact us per day
SELECT AVG(cnt) AS avg_contacts_per_day
FROM (
    SELECT date_contacted, COUNT(*) AS cnt
    FROM educators
    GROUP BY date_contacted
) sub;

-- 3b. Count of how many people heard about us via each media source
SELECT media, COUNT(*) AS total
FROM educators
GROUP BY media;

-- 4. Daily Placement Rate (average placements per day)
SELECT AVG(cnt) AS avg_placements_per_day
FROM (
    SELECT date_found_job, COUNT(*) AS cnt
    FROM educators
    WHERE date_found_job IS NOT NULL
    GROUP BY date_found_job
) sub;

-- 5. Placement by Degree Type per day
SELECT degree_title,
       date_found_job,
       COUNT(*) AS placements
FROM educators
WHERE date_found_job IS NOT NULL
GROUP BY degree_title, date_found_job
ORDER BY date_found_job, degree_title;

-- 6. Educator Contact List in "First Name, Last Name, Age – Degree" format
SELECT first_name || ', ' || last_name || ', ' ||
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, dob)) ||
       ' – ' || degree_title AS contact
FROM educators;
