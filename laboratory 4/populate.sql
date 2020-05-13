BEGIN
    for i in 1..3 loop
    
        INSERT INTO Countries (country_name) VALUES ('COUNTRY' || i);
        INSERT INTO Genres (genre_name) VALUES ('GENRE' || i);
        INSERT INTO Fans (fan_name, birth_date) VALUES ('FAN' || i, ADD_MONTHS(SYSDATE(), -i*123));
        INSERT INTO Bands (band_name, formed_year, country_name, split_year) VALUES ('BAND' || i, 1980 + i, 'COUNTRY' || i, 1980 + 6*i);
        INSERT INTO Bands_Genres (band_name, formed_year, country_name, genre_name) VALUES ('BAND' || i, 1980 + i, 'COUNTRY' || i, 'GENRE' || i);
        INSERT INTO Bands_Fans (band_name, formed_year, country_name, fan_name, birth_date) VALUES ('BAND' || i, 1980 + i, 'COUNTRY' || i, 'FAN' || i, ADD_MONTHS(SYSDATE(), -i*123));
        
    end loop;
END;
