USE MultiRestaurantOrderingDB;
GO

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'RestaurantCommissionHistory')
BEGIN
    CREATE TABLE dbo.RestaurantCommissionHistory (
        HistoryID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        RestaurantID INT NOT NULL,
        OldRate DECIMAL(5,2) NULL,
        NewRate DECIMAL(5,2) NOT NULL,
        ChangedBy INT NOT NULL,
        Reason NVARCHAR(255) NULL,
        ChangedAt DATETIME2(0) NOT NULL CONSTRAINT DF_RestaurantCommissionHistory_ChangedAt DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT FK_RestaurantCommissionHistory_Restaurants FOREIGN KEY (RestaurantID)
            REFERENCES dbo.Restaurants(RestaurantID),
        CONSTRAINT FK_RestaurantCommissionHistory_Users FOREIGN KEY (ChangedBy)
            REFERENCES dbo.Users(UserID)
    );

    CREATE NONCLUSTERED INDEX IX_RestaurantCommissionHistory_Restaurant_ChangedAt
        ON dbo.RestaurantCommissionHistory (RestaurantID, ChangedAt DESC);
END
GO
