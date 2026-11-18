CREATE TABLE [dbo].[EmployeeMarketMap] (
    [EmpMarketID] INT IDENTITY (1, 1) NOT NULL,
    [EmpID]       INT NOT NULL,
    [MarketID]    INT NOT NULL,
    CONSTRAINT [PK_EmployeeMarketMap] PRIMARY KEY CLUSTERED ([EmpMarketID] ASC)
);

