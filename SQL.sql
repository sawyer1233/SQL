use  hospital

SELECT 
    YEAR(registration_date) AS registration_year,
    COUNT(*) AS total_patients
FROM patients
GROUP BY YEAR(registration_date)
ORDER BY registration_year;