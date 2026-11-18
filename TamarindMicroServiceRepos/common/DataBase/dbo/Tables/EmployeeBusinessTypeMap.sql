CREATE TABLE [dbo].[EmployeeBusinessTypeMap] (
    [EmployeeBusinessTypeID] INT IDENTITY (1, 1) NOT NULL,
    [EmpID]                  INT NOT NULL,
    [BusinessTypeID]         INT NOT NULL,
    CONSTRAINT [PK_EmployeeBusinessTypeMap] PRIMARY KEY CLUSTERED ([EmployeeBusinessTypeID] ASC)
);

