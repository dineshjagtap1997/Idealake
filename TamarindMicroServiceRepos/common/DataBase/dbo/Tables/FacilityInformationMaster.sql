CREATE TABLE [dbo].[FacilityInformationMaster] (
    [FacilityInfoID]  INT              IDENTITY (1, 1) NOT NULL,
    [InformationName] VARCHAR (100)    NOT NULL,
    [ImageName]       VARCHAR (100)    NULL,
    [Image]           VARBINARY (MAX)  NULL,
    [MISSequenceNo]   INT              NULL,
    [IsActive]        BIT              NOT NULL,
    [Operation]       VARCHAR (10)     NOT NULL,
    [OperationBy]     UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]     DATETIME         CONSTRAINT [DF_FacilityInformationMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]           INT              NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedOn]       DATETIME         NULL,
    CONSTRAINT [PK_FacilityInformationMaster] PRIMARY KEY CLUSTERED ([FacilityInfoID] ASC)
);

