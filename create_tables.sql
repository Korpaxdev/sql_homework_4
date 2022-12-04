CREATE TABLE Genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Singers (
    singer_id SERIAL PRIMARY KEY,
    singer_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Albums (
    album_id SERIAL PRIMARY KEY,
    album_name VARCHAR(100) NOT NULL,
    album_release_year DATE NOT NULL CHECK(album_release_year <= now())
);
CREATE TABLE Tracks (
    track_id SERIAl PRIMARY KEY,
    track_name VARCHAR(100) NOT NULL,
    track_duration INT NOT NULL CHECK(track_duration > 0),
    album_id INT REFERENCES Albums(album_id)
);
CREATE TABLE Collections (
    collection_id SERIAL PRIMARY KEY,
    collection_name VARCHAR(100) NOT NULL,
    collection_release_year DATE NOT NULL CHECK(collection_release_year <= now())
);

-- Create many - many relations 
CREATE TABLE GenresSingers (
    genre_id INT REFERENCES Genres(genre_id),
    singer_id INT REFERENCES Singers(singer_id),
    PRIMARY KEY (genre_id, singer_id)
);
CREATE TABLE SingersAlbums (
    singer_id INT REFERENCES Singers(singer_id),
    album_id INT REFERENCES Albums(album_id),
    PRIMARY KEY (singer_id, album_id)
);
CREATE TABLE TracksColletions (
    track_id INT REFERENCES Tracks(track_id),
    collection_id INT REFERENCES Collections(collection_id),
    PRIMARY KEY (track_id, collection_id)
);