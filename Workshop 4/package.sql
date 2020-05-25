CREATE OR REPLACE PACKAGE MetalPackage IS
TYPE fan_record IS RECORD (
    fan_id     fan.id%TYPE,
    fan_name   fan.fan_name%TYPE
);

TYPE fans_table IS TABLE OF fan_record;


FUNCTION fan_by_genre_and_band_country (
    genre     genre.genre_name%TYPE,
    country   country.country_name%TYPE
) RETURN fans_table
    PIPELINED;
    
    
PROCEDURE add_fan_to_band (
    fan_id             IN   fan.id%TYPE,
    name_of_band       IN   band.band_name%TYPE,
    band_country       IN   band.country_name%TYPE,
    band_formed_year   IN   band.formed_year%TYPE
);

END MetalPackage;



/


CREATE OR REPLACE PACKAGE BODY MetalPackage IS

FUNCTION fan_by_genre_and_band_country (
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
        PIPE ROW ( fan_row );
    END LOOP;
END;







PROCEDURE add_fan_to_band (
    fan_id             IN   fan.id%TYPE,
    name_of_band       IN   band.band_name%TYPE,
    band_country       IN   band.country_name%TYPE,
    band_formed_year   IN   band.formed_year%TYPE
) IS

    BAND_MISSED_ERROR EXCEPTION;
    FAN_MISSED_ERROR EXCEPTION;
    counter   NUMBER;

BEGIN
    SELECT COUNT(*) INTO counter FROM fan
    WHERE 
        fan.id = fan_id;

    IF counter = 0 THEN
        RAISE FAN_MISSED_ERROR;
    END IF;

    SELECT COUNT(*) INTO counter FROM band
    WHERE
        band.band_name = name_of_band
        AND band.formed_year = band_formed_year
        AND band.country_name = band_country;

    IF counter = 0 THEN
        RAISE BAND_MISSED_ERROR;
    END IF;

    INSERT INTO band_fan (
        id,
        band_name,
        country_name,
        formed_year

    ) VALUES (
        fan_id,
        name_of_band,
        band_country,
        band_formed_year
    );
    
    DBMS_OUTPUT.PUT_LINE('Fan successfully added to band!');


EXCEPTION
    WHEN FAN_MISSED_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('No such fan in db!');

    WHEN BAND_MISSED_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No such band in db!');
        
    WHEN dup_val_on_index THEN
        DBMS_OUTPUT.PUT_LINE('Already a fan of this band!');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error!');
END;

END MetalPackage;
