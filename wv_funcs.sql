/* 
   IMPORTANT: Before executing these functions, create the OccupiedPositions table 
   if you plan to use it. For example:
   CREATE TABLE dbo.OccupiedPositions (
       id_party INT,
       [line] INT,
       [col] INT
   );
   GO
*/

/*-------------------------------------------------
 Function 1: random_position
 Returns the first (line, col) pair that is not already used for the given party.
 (Since we cannot use NEWID(), this version is deterministic.)
--------------------------------------------------*/
CREATE FUNCTION dbo.random_position(
    @partyID INT,
    @lines INT,
    @cols INT
)
RETURNS TABLE
AS
RETURN
(
    WITH all_positions AS (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY l.number, c.number) AS row_idx,
            l.number AS [line], 
            c.number AS [col]
        FROM master..spt_values l
        CROSS JOIN master..spt_values c
        WHERE l.type = 'P' AND c.type = 'P'
          AND l.number BETWEEN 1 AND @lines
          AND c.number BETWEEN 1 AND @cols
    )
    SELECT TOP 1 [line], [col]
    FROM all_positions
    WHERE NOT EXISTS (
         SELECT 1 
         FROM dbo.OccupiedPositions op
         WHERE op.id_party = @partyID
           AND op.[line] = all_positions.[line]
           AND op.[col] = all_positions.[col]
    )
);
GO

/*-------------------------------------------------
 Function 2: random_role
 Returns either 'loup' or 'villageois' in a deterministic way.
 Here we use a simple modulus on @partyID.
--------------------------------------------------*/
CREATE FUNCTION dbo.random_role(@partyID INT)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @role VARCHAR(10);
    IF (@partyID % 2 = 0)
        SET @role = 'loup';
    ELSE
        SET @role = 'villageois';
    RETURN @role;
END;
GO

/*-------------------------------------------------
 Function 3: get_the_winner
 Returns details of the winner for a given party as a table.
 We cast text columns to VARCHAR(255) and also include the casts in GROUP BY.
--------------------------------------------------*/
CREATE FUNCTION dbo.get_the_winner(@partyID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1
         CAST(p.pseudo AS VARCHAR(255)) AS PlayerName,
         CAST(r.description_role AS VARCHAR(255)) AS Role,
         CAST(pa.title_party AS VARCHAR(255)) AS PartyName,
         (
             SELECT COUNT(*) 
             FROM dbo.players_play pp2
             JOIN dbo.turns t2 ON pp2.id_turn = t2.id_turn
             WHERE pp2.id_player = p.id_player 
               AND t2.id_party = @partyID
         ) AS TurnsPlayed,
         (
             SELECT COUNT(*) 
             FROM dbo.turns t3
             WHERE t3.id_party = @partyID
         ) AS TotalTurns,
         AVG(DATEDIFF(SECOND, pp.start_time, pp.end_time)) AS AverageDecisionTime
    FROM dbo.players p
    JOIN dbo.players_in_parties pip ON p.id_player = pip.id_player
    JOIN dbo.roles r ON pip.id_role = r.id_role
    JOIN dbo.parties pa ON pip.id_party = pa.id_party
    JOIN dbo.players_play pp ON p.id_player = pp.id_player
    WHERE pip.id_party = @partyID
    GROUP BY p.id_player, 
             CAST(p.pseudo AS VARCHAR(255)), 
             CAST(r.description_role AS VARCHAR(255)), 
             CAST(pa.title_party AS VARCHAR(255))
    ORDER BY COUNT(*) DESC
);
GO
