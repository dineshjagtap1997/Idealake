CREATE TABLE [dbo].[HotelRating] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Ratings]     INT              NULL,
    [Code]        VARCHAR (10)     NOT NULL,
    [Description] VARCHAR (50)     NOT NULL,
    [MISSequence] INT              NOT NULL,
    [IsActive]    BIT              CONSTRAINT [DF__HotelRati__IsAct__6BAEFA67] DEFAULT ((1)) NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         CONSTRAINT [DF__HotelRati__Opera__6CA31EA0] DEFAULT (getdate()) NOT NULL,
    [OldID]       INT              NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK__HotelRat__3214EC2769C6B1F5] PRIMARY KEY CLUSTERED ([ID] ASC)
);

