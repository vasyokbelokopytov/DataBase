DECLARE
    count_of_rows   INTEGER := 0;
    country         bands.country_name%TYPE;
BEGIN
    SELECT
        COUNT(*)
    INTO count_of_rows
    FROM bands;

    FOR i IN 1..count_of_rows LOOP
    
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
