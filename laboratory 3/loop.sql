DECLARE
    country         bands.country_name%TYPE;
    
BEGIN
    FOR i IN 1..20 LOOP
    
        IF ( remainder(i, 3) = 0 ) THEN
            country := 'Poland';
        ELSE
            country := 'Finland';
        END IF;


        INSERT INTO bands (
            band_name,
            formed_year,
            split_year,
            country_name
        ) VALUES (
            'BAND' || i,
            1930 - 3 * i,
            1930 + 4 * i,
            country
        );

    END LOOP;

END;
