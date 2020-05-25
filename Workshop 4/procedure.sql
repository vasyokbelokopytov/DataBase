Create Or Replace PROCEDURE add_fan_to_band (
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
