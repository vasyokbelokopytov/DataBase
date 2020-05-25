CREATE OR REPLACE TYPE fan_record AS OBJECT (
    fan_id     NUMBER,
    fan_name   VARCHAR2(50)
);

CREATE OR REPLACE TYPE fans_table IS
    TABLE OF fan_record;


CREATE OR REPLACE FUNCTION fan_by_genre_and_band_country (
    genre     genre.genre_name%TYPE,
    country   country.country_name%TYPE
) RETURN fans_table
    PIPELINED
IS

    CURSOR fans_cursor IS
    SELECT
        f.id  fan_id,
        f.fan_name  fan_name
    FROM
        country      c
        JOIN band         b ON c.country_name = b.country_name
        JOIN band_genre   bg ON b.band_name = bg.band_name
                              AND b.country_name = bg.country_name
                              AND b.formed_year = bg.formed_year
        JOIN genre        g ON bg.genre_name = g.genre_name
        JOIN band_fan     bf ON b.band_name = bf.band_name
                            AND b.country_name = bf.country_name
                            AND b.formed_year = bf.formed_year
        JOIN fan          f ON bf.id = f.id
    WHERE
        country = c.country_name
        AND genre = g.genre_name;

BEGIN
    FOR fan_row IN fans_cursor LOOP
        PIPE ROW ( fan_record(fan_row.fan_id, fan_row.fan_name) );
    END LOOP;
END;
