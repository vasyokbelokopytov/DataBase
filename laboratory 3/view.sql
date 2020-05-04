CREATE VIEW Countries_Bands AS
    SELECT
        b.band_name,
        b.formed_year,
        c.country_name
    FROM
        countries c
        LEFT JOIN bands b ON c.country_name = b.country_name;
