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
    TRIM(country_name),
    COUNT(band_name)
FROM
    Countries_Bands
GROUP BY
    TRIM(country_name)
ORDER BY
    count(band_name) DESC"""

cursor.execute(first_query)
country_bands = dict()

for raw in cursor:
    country_bands[raw[0]] = raw[1]


data = [go.Bar(
            x=list(country_bands.keys()),
            y=list(country_bands.values())
)]

layout = go.Layout(
    title='Number of bands in each country 2',
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

number_of_bands_in_each_country_url = py.plot(fig, filename='number_of_bands_in_each_country_2')






second_query = """SELECT
    TRIM(cb.country_name),
    COUNT(DISTINCT g.genre_name) genre
FROM
    Countries_Bands cb
    LEFT JOIN bands_genres bg ON cb.band_name = bg.band_name
                              AND cb.formed_year = bg.formed_year
                              AND cb.country_name = bg.country_name
    LEFT JOIN genres g        ON g.genre_name = bg.genre_name
GROUP BY
    TRIM(cb.country_name)
ORDER BY
    genre DESC"""


country_genres = dict()

cursor.execute(second_query)
for raw in cursor:
    country_genres[raw[0]] = raw[1]

pie = go.Pie(labels=list(country_genres.keys()), values=list(country_genres.values()))
percent_of_genres_url = py.plot([pie], filename='percent_of_genres_2')







third_query = """SELECT
    TRIM(cb.country_name),
    NVL(SUM(f.fans), 0) fans
FROM
    Countries_Bands cb
    LEFT JOIN Fans f    ON cb.band_name = f.band_name
                        AND cb.formed_year = f.formed_year
                        AND cb.country_name = f.country_name
WHERE
    (TO_CHAR(record_date, 'DD.MM.YYYY') = '05.05.2020') OR record_date IS NULL
GROUP BY TRIM(cb.country_name), record_date
ORDER BY fans DESC"""


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
country_fans_dynamic_url=py.plot(data, filename='country_fans_dynamic_2')







"""--------CREATE DASHBOARD------------------ """




my_dboard = dashboard.Dashboard()

number_of_bands_in_each_country_id = fileId_from_url(number_of_bands_in_each_country_url)
percent_of_genres_id = fileId_from_url(percent_of_genres_url)
country_fans_dynamic_id = fileId_from_url(country_fans_dynamic_url)

box_1 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': number_of_bands_in_each_country_id,
    'title': 'Number of bands in each country 2'
}

box_2 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': percent_of_genres_id,
    'title': 'Percent of using genres 2'
}

box_3 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': country_fans_dynamic_id,
    'title': 'Fans by country 2',
}



my_dboard.insert(box_1)
my_dboard.insert(box_2, 'below', 1)
my_dboard.insert(box_3, 'right', 2)

py.dashboard_ops.upload(my_dboard, '3 Laboratory Dashboard')


cursor.close()
connection.close()
