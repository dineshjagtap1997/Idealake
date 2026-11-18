CREATE TABLE [dbo].[State_Code_Master] (
    [ID]               INT              IDENTITY (1, 1) NOT NULL,
    [State_Code]       VARCHAR (MAX)    NULL,
    [IsActive]         BIT              NOT NULL,
    [Operation]        VARCHAR (50)     NOT NULL,
    [OperationBy]      UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]      DATETIME         NOT NULL,
    [IsUnionTerritory] BIT              NULL,
    [IsOtherTerritory] BIT              NULL,
    [2DigitCode]       NVARCHAR (2)     NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedOn]        DATETIME         NULL,
    CONSTRAINT [PK_State_Code_Master] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);

