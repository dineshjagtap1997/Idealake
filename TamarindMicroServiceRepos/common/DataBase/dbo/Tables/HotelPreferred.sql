CREATE TABLE [dbo].[HotelPreferred] (
    [PreferredHotelID] INT              IDENTITY (1, 1) NOT NULL,
    [HotelID]          INT              NOT NULL,
    [ValidFrom]        DATETIME         NOT NULL,
    [ValidTo]          DATETIME         NOT NULL,
    [IsPreferred]      BIT              NOT NULL,
    [Operation]        VARCHAR (10)     NOT NULL,
    [OperationBy]      UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]      DATETIME         CONSTRAINT [DF_HotelPreferred_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]            INT              NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedOn]        DATETIME         NULL,
    CONSTRAINT [PK_HotelPreferred] PRIMARY KEY CLUSTERED ([PreferredHotelID] ASC)
);

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

GO
CREATE NONCLUSTERED INDEX [IX_HotelPreferred_ValidDates]
    ON [dbo].[HotelPreferred]([HotelID] ASC, [IsPreferred] ASC, [ValidFrom] ASC, [ValidTo] ASC);

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
