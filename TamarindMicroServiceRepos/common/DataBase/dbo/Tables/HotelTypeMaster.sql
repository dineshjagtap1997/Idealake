CREATE TABLE [dbo].[HotelTypeMaster] (
    [HotelTypeID]      INT              IDENTITY (1, 1) NOT NULL,
    [TypeValue]        VARCHAR (200)    NOT NULL,
    [IsActive]         BIT              NULL,
    [Operation]        VARCHAR (10)     NULL,
    [OperationBy]      UNIQUEIDENTIFIER NULL,
    [InsertedDatetime] DATETIME         NULL,
    CONSTRAINT [PK_HotelTypeMaster] PRIMARY KEY CLUSTERED ([HotelTypeID] ASC)
);

