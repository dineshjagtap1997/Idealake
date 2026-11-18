CREATE TABLE [dbo].[TBL_Follow_Up_Section] (
    [FollowUPID]         BIGINT           IDENTITY (1, 1) NOT NULL,
    [FollowUpRemark]     VARCHAR (255)    NULL,
    [RescheduleFollowUp] VARCHAR (255)    NULL,
    [CreatedDateTime]    DATETIME         NOT NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [UpdatedBy]          INT              NULL,
=======
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [UpdatedDateTime]    DATETIME         NULL,
    [EnquiryID]          BIGINT           NULL,
    [FollowUpDate]       DATETIME         NULL,
    [FollowUpTime]       NVARCHAR (200)   NULL,
    [CreatedBy]          UNIQUEIDENTIFIER NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
    [UpdatedBy]          UNIQUEIDENTIFIER NULL,
>>>>>>> dev
=======
    [UpdatedBy]          UNIQUEIDENTIFIER NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    PRIMARY KEY CLUSTERED ([FollowUPID] ASC)
);

