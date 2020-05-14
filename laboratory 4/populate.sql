BEGIN
    for i in 1..3 loop
    
        INSERT INTO Country (country_name) VALUES ('COUNTRY' || i);
        INSERT INTO Genre (genre_name) VALUES ('GENRE' || i);
        INSERT INTO Fan (id, fan_name) VALUES (i, 'FAN' || i);
        INSERT INTO Band (band_name, formed_year, country_name, split_year) VALUES ('BAND' || i, 1980 + i, 'COUNTRY' || i, 1980 + 6*i);
        INSERT INTO Band_Genre (band_name, formed_year, country_name, genre_name) VALUES ('BAND' || i, 1980 + i, 'COUNTRY' || i, 'GENRE' || i);
        INSERT INTO Band_Fan (band_name, formed_year, country_name, id) VALUES ('BAND' || i, 1980 + i, 'COUNTRY' || i, i);
        
    end loop;
END;
