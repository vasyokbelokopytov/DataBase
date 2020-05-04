import chart_studio
import cx_Oracle
import plotly.graph_objects as go
import chart_studio.plotly as py
import chart_studio.dashboard_objs as dashboard
import re

def fileId_from_url(url):
    """Return fileId from a url."""
    raw_fileId = re.findall("~[A-z.]+/[0-9]+", url)[0][1: ]
    return raw_fileId.replace('/', ':')


chart_studio.tools.set_credentials_file(username='vasyok_belokopytov', api_key='bw1SWDiMwcOsiqTUJbq8')

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

cursor.execute(first_query)
country_bands = dict()

for raw in cursor:
    country_bands[raw[0]] = raw[1]
    

data = [go.Bar(
            x=list(country_bands.keys()),
            y=list(country_bands.values())
)]

layout = go.Layout(
    title='Number of bands in each country',
    xaxis=dict(
        title='Countries',
        titlefont=dict(
            family='Comic Sans, monospace',
            size=18,
            color='#7f7f7f'
        )
    ),
    yaxis=dict(
        title='Bands',
        rangemode='nonnegative',
        autorange=True,
        titlefont=dict(
            family='Comic Sans, monospace',
            size=18,
            color='#7f7f7f'
        )
    )
)

fig = go.Figure(data=data, layout=layout)

number_of_bands_in_each_country_url = py.plot(fig, filename='number_of_bands_in_each_country')






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


genres_bands = dict()

cursor.execute(second_query)
for raw in cursor:
    genres_bands[raw[0]] = raw[1]
    

pie = go.Pie(labels=list(genres_bands.keys()), values=list(genres_bands.values()))
percent_of_genres_url = py.plot([pie], filename='percent_of_genres')







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


country_fans = dict()
cursor.execute(third_query)

for raw in cursor:
    country_fans[raw[0]] = raw[1]
    


country_fans_dynamic = go.Scatter(
    x=list(country_fans.keys()),
    y=list(country_fans.values()),
    mode='lines+markers'
)
data = [country_fans_dynamic]
country_fans_dynamic_url=py.plot(data, filename='country_fans_dynamic')






alternative_third_query = """SELECT
    formed_year,
    SUM(fans)
FROM
    bands
GROUP BY
    formed_year
ORDER BY
    formed_year"""

formed_years_fans = dict()
cursor.execute(alternative_third_query)

for raw in cursor:
    formed_years_fans[raw[0]] = raw[1]
    
formed_years_fans_dynamic = go.Scatter(
    x=list(formed_years_fans.keys()),
    y=list(formed_years_fans.values()),
    mode='lines+markers'
)
data = [formed_years_fans_dynamic]
formed_years_fans_dynamic_url=py.plot(data, filename='formed_years_fans_dynamic')





"""--------CREATE DASHBOARD------------------ """




my_dboard = dashboard.Dashboard()

number_of_bands_in_each_country_id = fileId_from_url(number_of_bands_in_each_country_url)
percent_of_genres_id = fileId_from_url(percent_of_genres_url)
country_fans_dynamic_id = fileId_from_url(country_fans_dynamic_url)
formed_years_fans_dynamic_id = fileId_from_url(formed_years_fans_dynamic_url)

box_1 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': number_of_bands_in_each_country_id,
    'title': 'Number of bands in each country'
}

box_2 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': percent_of_genres_id,
    'title': 'Percent of using genres'
}

box_3 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': country_fans_dynamic_id,
    'title': 'Fans by country',
}

box_4 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': formed_years_fans_dynamic_id,
    'title': 'Fans by formed year',

}

my_dboard.insert(box_1)
my_dboard.insert(box_2, 'below', 1)
my_dboard.insert(box_3, 'below', 2)
my_dboard.insert(box_4, 'right', 3)

py.dashboard_ops.upload(my_dboard, '2 Laboratory Dashboard')


cursor.close()
connection.close()
