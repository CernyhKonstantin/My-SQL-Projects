-- Datenbank erstellen
CREATE DATABASE GamingDB;
USE GamingDB;

GO
-- Tabellen erstellen
-- Games (Spiele)
CREATE TABLE Games (
    GameID INT IDENTITY(1,1) PRIMARY KEY,
    GameTitle VARCHAR(100),
    Genre VARCHAR(50),
    ReleaseYear INT,
    Rating DECIMAL(3,1)   -- Bewertung von 0 bis 10
);

GO

-- Players (Spieler)
CREATE TABLE Players (
    PlayerID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50),
    Country VARCHAR(50),
    JoinDate DATE
);

GO

-- GameSessions (Spielsessions)
CREATE TABLE GameSessions (
    SessionID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT,
    GameID INT,
    PlayDate DATE,
    DurationMinutes INT,
    CONSTRAINT FK_GameSessions_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    CONSTRAINT FK_GameSessions_Games FOREIGN KEY (GameID) REFERENCES Games(GameID)
);

GO

-- Highscores
CREATE TABLE Highscores (
    HighscoreID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT,
    GameID INT,
    Score INT,
    AchievedDate DATE,
    CONSTRAINT FK_Highscores_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    CONSTRAINT FK_Highscores_Games FOREIGN KEY (GameID) REFERENCES Games(GameID)
);

GO

-- Testdaten einfügen
-- Spiele
INSERT INTO Games (GameTitle, Genre, ReleaseYear, Rating) VALUES
('GTA San Andreas', 'Action', 2004, 9.5),
('Minecraft', 'Sandbox', 2011, 9.0),
('Fortnite', 'Battle Royale', 2017, 8.5),
('Call of Duty', 'Shooter', 2020, 8.8);

GO
-- Spieler
INSERT INTO Players (Username, Country, JoinDate) VALUES
('Mezzaluna', 'Germany', '2024-01-10'),
('ProGamer99', 'USA', '2023-11-05'),
('ShadowX', 'UK', '2024-02-15'),
('NoobMaster', 'Germany', '2024-03-01');

GO
-- Spielsessions
INSERT INTO GameSessions (PlayerID, GameID, PlayDate, DurationMinutes) VALUES
(1, 1, '2025-03-10', 120),
(1, 2, '2025-03-11', 60),
(2, 3, '2025-03-10', 90),
(3, 1, '2025-03-12', 45),
(4, 2, '2025-03-12', 30),
(1, 1, '2025-04-01', 150);

GO
-- Highscores
INSERT INTO Highscores (PlayerID, GameID, Score, AchievedDate) VALUES
(1, 1, 9500, '2025-03-10'),
(2, 3, 8700, '2025-03-10'),
(3, 1, 6000, '2025-03-12'),
(1, 2, 12000, '2025-03-11'),
(4, 2, 4000, '2025-03-12');

GO
-- Abfragen
-- Top-Spieler nach Gesamtpunktzahl
SELECT 
    p.Username,
    SUM(h.Score) AS TotalScore
FROM Players p
JOIN Highscores h ON p.PlayerID = h.PlayerID
GROUP BY p.Username
ORDER BY TotalScore DESC;

GO
-- Durchschnittliche Spielzeit pro Spieler
SELECT 
    p.Username,
    AVG(gs.DurationMinutes) AS AvgPlayTime
FROM Players p
JOIN GameSessions gs ON p.PlayerID = gs.PlayerID
GROUP BY p.Username
ORDER BY AvgPlayTime DESC;

GO
-- Durchschnittliche Spielzeit pro Spiel
SELECT 
    g.GameTitle,
    AVG(gs.DurationMinutes) AS AvgSessionTime
FROM Games g
JOIN GameSessions gs ON g.GameID = gs.GameID
GROUP BY g.GameTitle
ORDER BY AvgSessionTime DESC;

GO
-- Bestes Spiel nach Bewertung
SELECT TOP 1
    GameTitle,
    Rating
FROM Games
ORDER BY Rating DESC;

GO
-- Meistgespieltes Spiel
SELECT 
    g.GameTitle,
    COUNT(gs.SessionID) AS TotalSessions
FROM Games g
JOIN GameSessions gs ON g.GameID = gs.GameID
GROUP BY g.GameTitle
ORDER BY TotalSessions DESC;

GO
-- Top Highscore pro Spiel
SELECT 
    g.GameTitle,
    p.Username,
    MAX(h.Score) AS BestScore
FROM Highscores h
JOIN Players p ON h.PlayerID = p.PlayerID
JOIN Games g ON h.GameID = g.GameID
GROUP BY g.GameTitle, p.Username
ORDER BY BestScore DESC;

GO

