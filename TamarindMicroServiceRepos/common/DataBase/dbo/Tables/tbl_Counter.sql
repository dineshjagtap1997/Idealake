CREATE TABLE [dbo].[tbl_Counter] (
    [UpdationDate] DATETIME     NOT NULL,
    [CustID]       BIGINT       NULL,
    [LeadID]       BIGINT       NULL,
    [ENQID]        BIGINT       NULL,
    [CustomerCode] BIGINT       NULL,
    [AGENTCODE]    BIGINT       NULL,
    [AGENTLEAD]    BIGINT       NULL,
    [EmpCode]      VARCHAR (20) NOT NULL,
    [ENQSYSID]     BIGINT       NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [BookingID]    BIGINT       NULL
=======
    [BookingID]    BIGINT       NULL,
    [EnqDraft]     INT          NULL
>>>>>>> dev
=======
    [BookingID]    BIGINT       NULL,
    [EnqDraft]     INT          NULL
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
);

