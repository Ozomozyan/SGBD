CREATE VIEW dbo.ALL_PLAYERS AS
SELECT TOP 100 PERCENT
    p.pseudo AS [Name of the player],
    COUNT(DISTINCT pp.id_party) AS [Number of parties],
    COUNT(pl.id_turn) AS [Number of turns],
    MIN(pl.start_time) AS [Date of first participation],
    MAX(pl.start_time) AS [Date of last action]
FROM dbo.players p
LEFT JOIN dbo.players_in_parties pp 
    ON p.id_player = pp.id_player
LEFT JOIN dbo.players_play pl 
    ON p.id_player = pl.id_player
GROUP BY p.pseudo
HAVING COUNT(pp.id_party) > 0
ORDER BY
    COUNT(DISTINCT pp.id_party),
    MIN(pl.start_time),
    MAX(pl.start_time),
    p.pseudo;
GO
