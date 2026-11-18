CREATE TABLE [dbo].[EmployeeMaster] (
    [EmpID]                      INT              IDENTITY (1, 1) NOT NULL,
    [EmpCode]                    NVARCHAR (MAX)   NULL,
    [UserID]                     UNIQUEIDENTIFIER NULL,
    [SalutationID]               INT              NOT NULL,
    [Gender]                     VARCHAR (10)     NOT NULL,
    [EmpName]                    VARCHAR (200)    NOT NULL,
    [Address]                    VARCHAR (MAX)    NULL,
    [CityIATACode]               CHAR (3)         NULL,
    [ResPhoneNo]                 VARCHAR (30)     NULL,
    [MobileNo]                   VARCHAR (30)     NULL,
    [PersonalEmail]              VARCHAR (200)    NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [CompanyID]                  INT              NULL,
=======
    [CompanyID]                  VARCHAR (200)    NULL,
>>>>>>> dev
=======
    [CompanyID]                  VARCHAR (200)    NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [DateOfBirth]                DATETIME         NULL,
    [DateOfJoining]              DATETIME         NULL,
    [DateOfRetirement]           DATETIME         NULL,
    [DesignationID]              INT              NULL,
    [DepartmentID]               NVARCHAR (500)   NULL,
    [ReportHeadID]               INT              NULL,
    [OffEmail]                   VARCHAR (200)    NULL,
    [OffPhone]                   VARCHAR (30)     NULL,
    [Pan]                        VARCHAR (50)     NULL,
    [IsActive]                   BIT              NOT NULL,
    [Operation]                  VARCHAR (10)     NOT NULL,
    [OperationBy]                UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]                DATETIME         CONSTRAINT [DF_EmployeeMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]                      INT              NULL,
    [LevelID]                    INT              DEFAULT ((0)) NOT NULL,
    [IsSales]                    BIT              NULL,
    [UserName]                   VARCHAR (500)    NULL,
    [Password]                   VARCHAR (MAX)    NULL,
    [IsLockedOut]                BIT              NULL,
    [CreateDate]                 DATETIME         NULL,
    [LastLoginDate]              DATETIME         NULL,
    [FailedPasswordAttemptCount] INT              NULL,
    [UpdatedOn]                  DATETIME         NULL,
    [RoleId]                     INT              NULL,
    [CreditNoteApp]              INT              CONSTRAINT [DF_CreditNoteApp] DEFAULT ('0') NULL,
    [AdvancesApp]                INT              CONSTRAINT [DF_AdvancesApp] DEFAULT ('0') NULL,
    [CreatedByNew]               INT              NULL,
    [UserIDN]                    INT              NULL,
    [OperationByN]               INT              NULL,
    [IsRemembered]               BIT              NULL,
    [UpdatedBy]                  UNIQUEIDENTIFIER NULL,
    [Level1UID]                  INT              NULL,
    [Level2UID]                  INT              NULL,
    [Level3UID]                  INT              NULL,
    [Level1]                     UNIQUEIDENTIFIER NULL,
    [Level2]                     UNIQUEIDENTIFIER NULL,
    [Level3]                     UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_EmployeeMaster] PRIMARY KEY CLUSTERED ([EmpID] ASC)
);

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

GO
CREATE NONCLUSTERED INDEX [IX_EmployeeMaster_UserID]
    ON [dbo].[EmployeeMaster]([UserID] ASC);

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
