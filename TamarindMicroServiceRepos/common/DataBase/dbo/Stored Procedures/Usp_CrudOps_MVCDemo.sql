
CREATE PROCEDURE [dbo].[Usp_CrudOps_MVCDemo]
    @Id int = NULL, 
    @Name NVARCHAR(100) = NULL,
    @Mobileno NVARCHAR(15) = NULL,
    @Address NVARCHAR(300) = 0,
    @Birthdate DATETIME = NULL,
    @EmailID NVARCHAR(15) = NULL,
	@IsActive bit,
	@CreatedBy Varchar(100)= NULL,
	@UpdatedBy Varchar(100) = NULL,
    @Query INT
AS
BEGIN
    IF (@Query = 1)
    BEGIN
        INSERT INTO MVCDemo (
            NAME,
            Address,
            Mobileno,
            Birthdate,
            EmailID,
			IsActive,
			CreatedBy,
			CreatedDateTime
        )
        VALUES (
            @Name,
            @Address,
            @Mobileno,
            @Birthdate,
            @EmailID,
			@IsActive,
			@CreatedBy,
			GETDATE()
        );
        IF (@@ROWCOUNT > 0)
        BEGIN
            SELECT 'Insert';
        END
    END

    IF (@Query = 2)
    BEGIN
        UPDATE MVCDemo
        SET NAME = @Name,
            Address = @Address,
            Mobileno = @Mobileno,
            Birthdate = @Birthdate,
            EmailID = @EmailID
        WHERE ID = @Id;
        SELECT 'Update';
    END

    IF (@Query = 3)
    BEGIN
        DELETE FROM MVCDemo
        WHERE ID = @Id;
        SELECT 'Deleted';
    END

    IF (@Query = 4)
    BEGIN
        SELECT * FROM MVCDemo;
    END

    IF (@Query = 5)
    BEGIN
        SELECT * FROM MVCDemo
        WHERE  ID= @Id;
    END


	END