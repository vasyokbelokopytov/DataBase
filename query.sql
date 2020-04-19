--First query

SELECT
    TRIM(c.country_name) country,
    COUNT(b.band_name) bands
FROM
    Countries   c
    LEFT JOIN Bands b ON c.country_name = b.country_name
GROUP BY
    TRIM(c.country_name)
ORDER BY
    bands DESC;


--Second query

SELECT
    TRIM(g.genre_name) genres,
    COUNT(b.band_name) bands
FROM
    genres g
    LEFT JOIN Bands_Genres bg ON g.genre_name = bg.genre_name
    LEFT JOIN Bands b         ON b.band_name = bg.band_name
                             AND b.formed_year = bg.formed_year
                             AND b.country_name = bg.country_name
GROUP BY
    TRIM(g.genre_name)
ORDER BY
    bands DESC;


--Third query

SELECT 
    TRIM(c.country_name) country, 
    NVL(SUM(b.fans), 0) fans
FROM 
    Countries c
    LEFT JOIN Bands b ON c.country_name = b.country_name
GROUP BY 
    TRIM(c.country_name)
ORDER BY 
    fans DESC;
    
    
--Alternative third query

SELECT
    formed_year,
    SUM(fans)
FROM
    bands
GROUP BY
    formed_year
ORDER BY
    formed_year;
