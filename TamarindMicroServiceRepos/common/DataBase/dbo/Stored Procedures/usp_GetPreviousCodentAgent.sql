<<<<<<< HEAD
<<<<<<< HEAD
﻿      
CREATE PROCEDURE [dbo].[usp_GetPreviousCodentAgent]       
(      
@IsActive bit = 1      
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [dbo].[usp_GetPreviousCodentAgent]       
(      
@IsActive bit = 1     ,
@IsVendorAgentHotel int = 0
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
)      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
<<<<<<< HEAD
<<<<<<< HEAD
      
    select AgentID , AgentCode + '-' + AgentName AS 'AgentCode',IsActive from AgentMaster WHERE IsActive =  1
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    if(@IsVendorAgentHotel=1)  --Vendor
	Begin
		select VendorID  as 'AgentID', VendorCode + '-' + VendorName AS 'AgentCode',IsActive from VendorMaster where IsActive=0
	END
	else if(@IsVendorAgentHotel=2)  --Hotel
	Begin
		select HotelID as 'AgentID', HotelCode + '-' + HotelName AS 'AgentCode',IsActive from HotelMaster where IsActive=0
	End
	Else
	Begin
	    select AgentID , AgentCode + '-' + AgentName AS 'AgentCode',IsActive from AgentMaster WHERE IsActive =  0
	End
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END 