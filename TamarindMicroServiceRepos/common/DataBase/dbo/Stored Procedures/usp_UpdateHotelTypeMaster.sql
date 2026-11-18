


-- =============================================              
-- Author:  Sagar              
-- Create date: 05 Dec 2013             
-- Description: Update HotelTypeMaster              
-- =============================================              
              
 CREATE PROCEDURE [dbo].[usp_UpdateHotelTypeMaster]      
@HotelTypeID INT,              
@TypeValue VARCHAR(200),              
@IsActive BIT=1,              
@OperationBy UNIQUEIDENTIFIER,              
@ErrMsg VARCHAR(50) OUT              
AS              
BEGIN              
              
 IF NOT EXISTS(SELECT HotelTypeID FROM HotelTypeMaster WHERE UPPER(TypeValue) = UPPER(@TypeValue) AND HotelTypeID <> @HotelTypeID)              
 BEGIN              
  UPDATE HotelTypeMaster               
  SET TypeValue=@TypeValue, IsActive=@IsActive, Operation='Update', OperationBy=@OperationBy, InsertedDatetime =getdate()           
  WHERE HotelTypeID=@HotelTypeID              
 END              
 ELSE              
 BEGIN              
  SET @ErrMsg='Hotel Type already exists!'              
 END              
END 