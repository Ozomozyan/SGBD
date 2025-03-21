--===================================================
-- Procedure 1: SEED_DATA
-- Creates dummy players and seeds dummy turns for a given party.
--===================================================
CREATE PROCEDURE dbo.SEED_DATA
    @NB_PLAYERS INT,
    @PARTY_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @role VARCHAR(10);

    WHILE @i <= @NB_PLAYERS
    BEGIN
        -- Insert a new player.
        INSERT INTO dbo.players (id_player, pseudo)
        VALUES (@i, 'TestPlayer' + CAST(@i AS VARCHAR(10)));

        -- Determine role using the random_role function.
        -- Note: our random_role function is defined as an inline TVF so we can select from it.
        SELECT TOP 1 @role = Role FROM dbo.random_role(@PARTY_ID);

        -- Insert into players_in_parties.
        -- Here we assume:
        --    if @role = 'loup' then id_role = 2,
        --    else (if 'villageois') then id_role = 1.
        INSERT INTO dbo.players_in_parties (id_party, id_player, id_role, is_alive)
        VALUES (@PARTY_ID, @i, CASE WHEN @role = 'loup' THEN 2 ELSE 1 END, 'Y');

        SET @i = @i + 1;
    END;

    -- Seed dummy turns.
    -- We assume a constant number of turns (for example, 10) for the party.
    DECLARE @maxTurns INT = 10;
    DECLARE @turn INT = 1;

    WHILE @turn <= @maxTurns
    BEGIN
        INSERT INTO dbo.turns (id_turn, id_party, start_time, end_time)
        VALUES (@turn, @PARTY_ID, GETDATE(), NULL);
        SET @turn = @turn + 1;
    END;
END;
GO

--===================================================
-- Procedure 2: COMPLETE_TOUR
-- Applies movement requests and resolves conflicts for a given turn and party.
--===================================================
CREATE PROCEDURE dbo.COMPLETE_TOUR
    @TOUR_ID INT,
    @PARTY_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update all moves for this turn to mark them as "processed".
    -- (This is a stub – you need to add logic to validate moves and resolve conflicts.)
    UPDATE pp
    SET pp.action = 'done'
    FROM dbo.players_play pp
    JOIN dbo.turns t ON pp.id_turn = t.id_turn
    WHERE t.id_turn = @TOUR_ID
      AND t.id_party = @PARTY_ID;

    -- Additional conflict resolution logic goes here.
END;
GO

--===================================================
-- Procedure 3: USERNAME_TO_LOWER
-- Converts all player names (pseudo) to lowercase.
--===================================================
CREATE PROCEDURE dbo.USERNAME_TO_LOWER
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.players
    SET pseudo = LOWER(pseudo);
END;
GO
