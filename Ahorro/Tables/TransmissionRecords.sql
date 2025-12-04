CREATE TABLE [Ahorro].[TransmissionRecords] (
    [FileName]               VARCHAR (100) NOT NULL,
    [HashSHA256]             VARCHAR (64)  NOT NULL,
    [ServerType]             VARCHAR (100) NOT NULL,
    [ServerAddress]          VARCHAR (100) NOT NULL,
    [DestinationDirectory]   VARCHAR (100) NOT NULL,
    [DateRecordTransmission] DATETIME      NOT NULL,
    CONSTRAINT [PK_TransmissionRecords] PRIMARY KEY CLUSTERED ([FileName] ASC, [HashSHA256] ASC)
);


GO

