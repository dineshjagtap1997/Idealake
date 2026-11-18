CREATE TABLE [dbo].[File2FileMapping_Log] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [FileMapID]   INT          NOT NULL,
    [CompanyID]   INT          NOT NULL,
    [YearID1]     INT          NOT NULL,
    [YearCode1]   VARCHAR (20) NOT NULL,
    [FileCode1]   VARCHAR (30) NOT NULL,
    [YearID2]     INT          NOT NULL,
    [YearCode2]   VARCHAR (20) NOT NULL,
    [FileCode2]   VARCHAR (30) NOT NULL,
    [IsActive]    BIT          NULL,
    [Operation]   VARCHAR (10) NOT NULL,
    [OperationBy] INT          NOT NULL,
    [OperationOn] DATETIME     NOT NULL,
    [UpdatedBy]   INT          NULL,
    [UpdatedOn]   DATETIME     NULL
);

