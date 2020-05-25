SET SERVEROUTPUT ON;

--Случай, когда нету фаната:
EXEC add_fan_to_band(99, 'Metallica', 'USA', 1981)

--Случай, когда нету группы:
EXEC add_fan_to_band(3, 'Pseudotallica', 'USA', 1981)

--Случай, когда человек уже фанат этой группы:
EXEC add_fan_to_band(5, 'Metallica', 'USA', 1981)

--Успешный случай:
EXEC add_fan_to_band(9, 'Metallica', 'USA', 1981)



--Разные случаи:
SELECT * FROM TABLE(fan_by_genre_and_band_country('Heavy', 'USA'));

SELECT * FROM TABLE(fan_by_genre_and_band_country('Heavy', 'Finland'));

SELECT * FROM TABLE(fan_by_genre_and_band_country('Progressive', 'Sweden'));
