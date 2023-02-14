CREATE LOGIN eTestAdmin
    WITH PASSWORD = 's3cre3tP4ss!';
GO

USE eTest;
GO

CREATE USER eTestAdmin FOR LOGIN eTestAdmin;
GO

USE eTest;
GO

EXEC sp_addrolemember 'db_datareader', 'eTestAdmin'
EXEC sp_addrolemember 'db_datawriter', 'eTestAdmin'
GO