CREATE procedure [dbo].[USP_InsertSAPCompCode]  
 @ParentId bigint,  
 @TypeId int,  
 @SAPCompCodename nvarchar(10),  
 @BPCode nvarchar(15),  
 @IsActive bit,  
 @CreatedBy UNIQUEIDENTIFIER  
as  
 begin  
  Declare @BPCodeN nvarchar(20)
  if(@TypeId = 1)
   Begin
		set @BPCodeN = (Select top 1 HotelCode from Hotelmaster where hotelid = @parentID)
   End
   else if(@TypeId = 2)
   Begin
		set @BPCodeN = (Select top 1 VendorCode from vendormaster where vendorid = @parentID)
   End
   else if(@TypeId = 3)
   Begin
		set @BPCodeN = (Select top 1 AgentCode from Agentmaster where Agentid = @parentID)
   End
      
  Insert into SAPCompCode  
  (ParentId,TypeId,SAPCompCodename,BPCode,IsActive,CreatedBy,InsertedDate)  
  values  
  (@ParentId,@TypeId,@SAPCompCodename,@BPCodeN,@IsActive,@CreatedBy,Getdate())  
  
end