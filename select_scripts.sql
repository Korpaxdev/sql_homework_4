-- 1. the count of singers in genres
SELECT genre_name,
	count(s.singer_name)
FROM genres g
	JOIN genressingers g2 ON g.genre_id = g2.genre_id
	JOIN singers s ON g2.singer_id = s.singer_id
GROUP BY genre_name;

-- 2. the count of tracks between 2019 and 2020
SELECT count(*)
from tracks t
	JOIN albums a ON a.album_id = t.album_id
WHERE date_part('year', album_release_year) BETWEEN 2019 AND 2020;

-- 3. the avg duration of tracks in albums
SELECT album_name,
	AVG(t.track_duration)
FROM albums a
	JOIN tracks t ON t.album_id = a.album_id
GROUP BY album_name;

-- 4. the singers who haven't released albums in 2020
SELECT *
FROM singers s
WHERE singer_name NOT IN (
		SELECT singer_name
		FROM singers s2
			JOIN singersalbums s3 ON s3.singer_id = s2.singer_id
			JOIN albums a ON a.album_id = s3.album_id
		WHERE date_part('year', a.album_release_year) = 2020
	);

-- 5. the collections where singer is Disturbed 
SELECT c.collection_id,
	c.collection_name,
	c.collection_release_year
FROM collections c
	JOIN trackscolletions t ON t.collection_id = c.collection_id
	JOIN tracks t2 ON t2.track_id = t.track_id
	JOIN singersalbums s ON s.album_id = t2.album_id
	JOIN singers s2 ON s2.singer_id = s.singer_id
WHERE s2.singer_name = 'Disturbed'
GROUP BY c.collection_id;

--6. the names of albums where singer sings in more than 1 genre
SELECT ag.album_name
FROM (
		SELECT a.album_name,
			count(g2)
		FROM singers s
			JOIN genressingers g ON s.singer_id = g.singer_id
			JOIN genres g2 ON g2.genre_id = g.genre_id
			JOIN singersalbums s2 ON s2.singer_id = s.singer_id
			JOIN albums a ON a.album_id = s2.album_id
		GROUP BY a.album_name
	) AS ag
WHERE ag.count > 1;

-- 7. the albums that are not included in collections
SELECT t.track_name
FROM tracks t
	LEFT JOIN trackscolletions t2 ON t2.track_id = t.track_id
WHERE t2.track_id IS NULL;

-- 8. the singers with the shortest track
SELECT s.singer_name
FROM singers s
	JOIN singersalbums s2 ON s.singer_id = s2.singer_id
	JOIN tracks t ON s2.album_id = t.album_id
WHERE (
		SELECT min(t2.track_duration)
		FROM tracks t2
	) = t.track_duration;

-- 9.the albums containing the least number of tracks
-- variant throught temporary table
CREATE TEMPORARY TABLE tmp1 ON COMMIT DROP AS (
	SELECT a.album_id,
		a.album_name,
		count(*)
	FROM albums a
		JOIN tracks t ON t.album_id = a.album_id
	GROUP BY a.album_id,
		a.album_name
);
SELECT tmp1.album_name
FROM tmp1
WHERE (
		SELECT MIN(tmp1.count)
		FROM tmp1
	) = tmp1.count;
	
-- variant throught 'with'
WITH tmp1 AS (
	SELECT a.album_id,
		a.album_name,
		count(*)
	FROM albums a
		JOIN tracks t ON t.album_id = a.album_id
	GROUP BY a.album_id,
		a.album_name
)
SELECT tmp1.album_name
FROM tmp1
WHERE (
		SELECT MIN(tmp1.count)
		FROM tmp1
	) = tmp1.count;