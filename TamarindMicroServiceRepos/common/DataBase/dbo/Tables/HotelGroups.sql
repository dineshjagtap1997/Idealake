CREATE TABLE [dbo].[HotelGroups] (
    [HotelGroupID] INT              IDENTITY (1, 1) NOT NULL,
    [IATACode]     CHAR (3)         NOT NULL,
    [Name]         VARCHAR (200)    NOT NULL,
    [IsActive]     BIT              CONSTRAINT [DF__HotelGrou__IsAct__3DE82FB7] DEFAULT ((1)) NOT NULL,
    [Operation]    VARCHAR (10)     NOT NULL,
    [OperationOn]  DATETIME         CONSTRAINT [DF__HotelGrou__Opera__3EDC53F0] DEFAULT (getdate()) NOT NULL,
    [OldID]        VARCHAR (10)     NULL,
    [UpdatedOn]    DATETIME         NULL,
    [UpdatedBy]    INT              NULL,
    [OperationBy]  UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK__HotelGro__EFD6F5BF3BFFE745] PRIMARY KEY CLUSTERED ([IATACode] ASC, [Name] ASC, [IsActive] ASC)
);

