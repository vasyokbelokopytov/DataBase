CREATE TABLE Countries (
    country_name VARCHAR(20) NOT NULL PRIMARY KEY
);

CREATE TABLE Genres (
    genre_name VARCHAR(30) NOT NULL PRIMARY KEY
);

CREATE TABLE Bands (
     band_name VARCHAR(30) NOT NULL
    ,formed_year NUMBER(4,0) NOT NULL
    ,split_year NUMBER(4,0) 
    ,country_name VARCHAR(20) NOT NULL REFERENCES Countries(country_name)
    ,fans NUMBER(4,0) NOT NULL CHECK(fans >= 0)
    ,CONSTRAINT CHK_Years CHECK (formed_year > 0 AND split_year > 0)
    ,CONSTRAINT PK_Bands PRIMARY KEY (band_name, formed_year, country_name)
);

CREATE TABLE Bands_Genres (
     band_name VARCHAR(30) NOT NULL
    ,formed_year NUMBER(4,0) NOT NULL
    ,genre_name VARCHAR(30) NOT NULL
    ,country_name VARCHAR(20) NOT NULL
    ,CONSTRAINT PK_Bands_Genres PRIMARY KEY (band_name, formed_year, country_name, genre_name)
    ,CONSTRAINT FK1_Bands_Genres FOREIGN KEY (genre_name) REFERENCES Genres(genre_name)
    ,CONSTRAINT FK2_Bands_Genres FOREIGN KEY (band_name, formed_year, country_name) REFERENCES Bands(band_name, formed_year, country_name)
);
