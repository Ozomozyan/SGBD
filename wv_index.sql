-- 1) Add primary keys to parties and roles

-- For parties table
ALTER TABLE dbo.parties
ALTER COLUMN id_party INT NOT NULL;
GO

ALTER TABLE dbo.parties
ADD CONSTRAINT PK_parties_id_party
PRIMARY KEY (id_party);
GO

-- For roles table
ALTER TABLE dbo.roles
ALTER COLUMN id_role INT NOT NULL;
GO

ALTER TABLE dbo.roles
ADD CONSTRAINT PK_roles_id_role
PRIMARY KEY (id_role);
GO

-- 2) Ensure players table: change pseudo column type to allow indexing
ALTER TABLE dbo.players
ALTER COLUMN pseudo VARCHAR(255);
GO

-- 3) Add primary key to players (if not already done)
ALTER TABLE dbo.players
ALTER COLUMN id_player INT NOT NULL;
GO

ALTER TABLE dbo.players
ADD CONSTRAINT PK_players_id_player
PRIMARY KEY (id_player);
GO

-- 4) Add foreign keys for players_in_parties
ALTER TABLE dbo.players_in_parties
ADD CONSTRAINT FK_players_in_parties_parties
FOREIGN KEY (id_party)
REFERENCES dbo.parties(id_party);
GO

ALTER TABLE dbo.players_in_parties
ADD CONSTRAINT FK_players_in_parties_players
FOREIGN KEY (id_player)
REFERENCES dbo.players(id_player);
GO

ALTER TABLE dbo.players_in_parties
ADD CONSTRAINT FK_players_in_parties_roles
FOREIGN KEY (id_role)
REFERENCES dbo.roles(id_role);
GO

-- 5) Create an index on 'pseudo' in players
CREATE INDEX IDX_players_pseudo
    ON dbo.players (pseudo);
GO

-- 6) Add columns for lines/columns in parties (if needed)
ALTER TABLE dbo.parties
ADD number_of_lines INT,
    number_of_columns INT;
GO

ALTER TABLE dbo.parties
ADD CONSTRAINT CK_parties_lines_cols_positive
CHECK (number_of_lines > 0 AND number_of_columns > 0);
GO
