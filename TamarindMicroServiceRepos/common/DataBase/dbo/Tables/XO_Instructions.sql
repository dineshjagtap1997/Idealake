CREATE TABLE [dbo].[XO_Instructions] (
    [XO_InstructionID] INT            NOT NULL,
    [File_ID]          NVARCHAR (50)  NULL,
    [Customer_Name]    VARCHAR (200)  NULL,
    [Supplier_Name]    VARCHAR (200)  NULL,
    [XO_ID]            NVARCHAR (50)  NOT NULL,
    [Qut_ID]           NUMERIC (33)   NOT NULL,
    [Forign_Exchange]  VARCHAR (3)    NULL,
    [Meals_Menu_Basis] VARCHAR (3)    NULL,
    [XO_Line_Desc]     VARCHAR (100)  NULL,
    [XO_Instruction]   VARCHAR (500)  NULL,
    [Confirmed_By]     NVARCHAR (100) NULL,
    [ArrivalDate]      DATETIME       NULL,
    [DepartureDate]    DATETIME       NULL,
    [FromCity]         VARCHAR (100)  NULL,
    [ToCity]           VARCHAR (100)  NULL,
    [ArrivalBy]        VARCHAR (100)  NULL,
    [DeptBy]           VARCHAR (100)  NULL,
    [FromTime]         VARCHAR (50)   NULL,
    [ToTime]           VARCHAR (50)   NULL,
    [YearCode]         INT            NULL,
    [XO_IssuedOn]      DATETIME       NULL,
    [NoOfPax]          INT            NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [DayWiseID]        BIGINT         NULL,
=======
    [DayWiseID]        NVARCHAR (500) NULL,
>>>>>>> dev
=======
    [DayWiseID]        NVARCHAR (500) NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [IsActive]         BIT            CONSTRAINT [DF_XO_Instructions_IsActive] DEFAULT ((1)) NULL
);

