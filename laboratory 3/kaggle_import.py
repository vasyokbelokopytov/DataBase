import csv
import cx_Oracle

username = 'SYSTEM'
password = '123'
dsn = 'localhost/xe'

connection = cx_Oracle.connect(username, password, dsn)

with open('C:/Users/admin/Desktop/metal.csv') as file:
    reader = csv.reader(file)

    next(reader)
    country_unique = []
    genre_unique = []
    bands_unique = []
    fans_unique = []
    bands_genres_unique = []
    error_counter = 0

    cursor = connection.cursor()
    try:
        for row in reader:

            country = row[4].split(',')[0].strip()
            band = row[1].strip()
            genres = row[6].split(',')
            record = '05.05.2020'

            try:
                formed = int(row[3])
            except:
                continue


            try:
                fans = int(row[2])
            except:
                fans = None


            try:
                split = int(row[5])
            except:
                split = None


            if (not country) or (not band) or (not formed):
                continue



            if country.lower() not in country_unique:
                cursor.execute("INSERT INTO Countries (country_name) VALUES (:country)", country=country)
                country_unique.append(country.lower())


            if (band.lower(), formed, country.lower()) not in bands_unique:
                cursor.execute("INSERT INTO Bands (band_name, formed_year, country_name, split_year) VALUES " +
                               "(:band, :formed, :country, :split)", (band, formed, country, split))
                bands_unique.append((band.lower(), formed, country.lower()))


            for genre in genres:
                if genre.lower().strip() not in genre_unique:
                    cursor.execute("INSERT INTO Genres (genre_name) VALUES (:genre)", genre=genre.strip())
                    genre_unique.append(genre.strip().lower())

                if (band.lower(), formed, country.lower(),genre.lower().strip()) not in bands_genres_unique:
                    cursor.execute("INSERT INTO Bands_Genres (band_name, formed_year, country_name, genre_name) VALUES " +
                                   "(:band, :formed, :country, :genre)", (band, formed, country, genre.strip()))
                    bands_genres_unique.append((band.lower(), formed, country.lower(), genre.lower().strip()))



            if (band.lower(), formed, country.lower(), record) not in fans_unique:
                cursor.execute("INSERT INTO Fans (band_name, formed_year, country_name, record_date, fans) VALUES " +
                    "(:band, :formed, :country, TO_DATE(:record, 'DD-MM-YYYY'), :fans)", (band, formed, country, record, fans))
                fans_unique.append((band.lower(), formed, country.lower(), record))

            error_counter +=1

    except:
        print(f"The error occurred on the {error_counter} line", error_counter)

    cursor.close()
    connection.commit()
    connection.close()
