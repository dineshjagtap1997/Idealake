CREATE TABLE [dbo].[tbl_OTP] (
    [OTPID]     INT           IDENTITY (1, 1) NOT NULL,
    [OTP]       INT           NULL,
    [CreatedOn] DATETIME      NOT NULL,
    [UserID]    VARCHAR (500) NULL
);

