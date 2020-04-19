import cx_Oracle

def exec(cursor, query):
    columns = []
    cursor.execute(query)
    for column in cursor.description:
        columns.append(column[0])
    print(" | ".join(columns))
    for row in cursor:
        print(row)
    print("\n")

username = 'SYSTEM'
password = '123'
dsn = 'localhost/xe'

connection = cx_Oracle.connect(username, password, dsn)
cursor = connection.cursor()

first_query = """SELECT
    TRIM(c.country_name) country,
    COUNT(b.band_name) bands
FROM
    Countries   c
    LEFT JOIN Bands b ON c.country_name = b.country_name
GROUP BY
    TRIM(c.country_name)
ORDER BY
    bands DESC"""

second_query = """SELECT
    TRIM(g.genre_name) genres,
    COUNT(b.band_name) bands
FROM
    genres g
    LEFT JOIN Bands_Genres bg ON g.genre_name = bg.genre_name
    LEFT JOIN Bands b         ON b.band_name = bg.band_name
                             AND b.formed_year = bg.formed_year
                             AND b.country_name = bg.country_name
GROUP BY
    TRIM(g.genre_name)
ORDER BY
    bands DESC"""

third_query = """SELECT 
    TRIM(c.country_name) country, 
    NVL(SUM(b.fans), 0) fans
FROM 
    Countries c
    LEFT JOIN Bands b ON c.country_name = b.country_name
GROUP BY 
    TRIM(c.country_name)
ORDER BY 
    fans DESC"""

exec(cursor, first_query)
exec(cursor, second_query)
exec(cursor, third_query)

cursor.close()
connection.close()