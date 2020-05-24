CREATE OR REPLACE PROCEDURE add_fan_to_band (
    fan_id             IN   fan.id%TYPE,
    name_of_band       IN   band.band_name%TYPE,
    band_country       IN   band.country_name%TYPE,
    band_formed_year   IN   band.formed_year%TYPE
) IS

    BAND_MISSED_ERROR EXCEPTION;
    FAN_MISSED_ERROR EXCEPTION;
    counter   NUMBER;
    message   VARCHAR2(25);
    
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
        formed_year,
        country_name
    ) VALUES (
        fan_id,
        name_of_band,
        band_country,
        band_formed_year
    );

EXCEPTION
    WHEN FAN_MISSED_ERROR THEN 
        message := 'No such fan in db!';
        
    WHEN BAND_MISSED_ERROR THEN
        message := 'No such band in db!';
        
    WHEN OTHERS THEN
        message := 'Unexpected error!' ;
        
    DBMS_OUTPUT.PUT_LINE(message);
END;
