
CREATE PROCEDURE [Ahorro].[InsertTransmissionRecord]
    @FileName VARCHAR(100),  
    @HashSHA256 VARCHAR(100),
    @ServerType VARCHAR(100),
    @ServerAddress VARCHAR(100),
    @DestinationDirectory VARCHAR(100)
AS
BEGIN
    
    SET NOCOUNT ON;

    -- Inicia la transacción
    BEGIN TRANSACTION;

    BEGIN TRY        
        INSERT INTO [Ahorro].[TransmissionRecords]
        (
            FileName,
            HashSHA256,
            ServerType,
            ServerAddress,
            DestinationDirectory,
            DateRecordTransmission
        )
        VALUES
        (
            @FileName,
            @HashSHA256,
            @ServerType,
            @ServerAddress,
            @DestinationDirectory,
            GETDATE()
        );
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN            
            ROLLBACK TRANSACTION;
        END;
		        
        THROW; 
    END CATCH
END

GO

