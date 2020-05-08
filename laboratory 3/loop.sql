BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO countries (country_name) VALUES ('country' || i);
    
        INSERT INTO bands (
            band_name,
            formed_year,
            split_year,
            country_name
        ) VALUES (
            'BAND' || i,
            1930 - 3 * i,
            1930 + 4 * i,
            'country' || i
        );

    END LOOP;

END;
