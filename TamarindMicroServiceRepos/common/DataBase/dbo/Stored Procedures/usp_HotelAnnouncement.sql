CREATE PROCEDURE [dbo].[usp_HotelAnnouncement] (
	@AnnouncementID INT = 0
	,@HotelID INT = ''
	,@HeaderID INT = ''
	,@AnnouncementDetails VARCHAR(MAX) = ''
	,@ValidTo DATETIME = NULL
	,@Action CHAR(2) = ''
	,@CityID VARCHAR(10) = ''
	,@ChainIATACode VARCHAR(10) = ''
	,@OperationBy UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
	BEGIN TRY
		DECLARE @LogID INT;

		IF @Action = 'U'
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM HotelAnnouncement
					WHERE AnnouncementID = @AnnouncementID
					)
			BEGIN
				UPDATE HotelAnnouncement
				SET HeaderID = @HeaderID
					,AnnouncementDetails = @AnnouncementDetails
					,ValidTo = @ValidTo
				WHERE AnnouncementID = @AnnouncementID;

				SELECT '200' AS returnCode
					,'Record updated successfully.' AS returnMessage
					,@AnnouncementID AS ID;
			END
			ELSE
			BEGIN
				SELECT '404' AS returnCode
					,'Record not found.' AS returnMessage;
			END
		END
		ELSE IF @Action = 'I'
		BEGIN
			INSERT INTO HotelAnnouncement (
				HotelID
				,HeaderID
				,AnnouncementDetails
				,ValidTo
				)
			VALUES (
				@HotelID
				,@HeaderID
				,@AnnouncementDetails
				,@ValidTo
				);

			SET @LogID = SCOPE_IDENTITY()

			SELECT '200' AS returnCode
				,'New record added successfully.' AS returnMessage
				,@LogID AS ID;
		END
		ELSE IF @Action = 'D'
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM HotelAnnouncement
					WHERE AnnouncementID = @AnnouncementID
					)
			BEGIN
				DELETE
				FROM HotelAnnouncement
				WHERE AnnouncementID = @AnnouncementID;

				SELECT '200' AS returnCode
					,'Record Deleted Successfully.' AS returnMessage;
			END
			ELSE
			BEGIN
				SELECT '404' AS returnCode
					,'Announcement not found for deletion.' AS returnMessage;
			END
		END
		ELSE IF @Action = 'S'
		BEGIN
			SELECT C.Name AS City
				,HM.HotelName
				,HA.AnnouncementDetails
				,
				--    HG.Name AS HotelGroups,                    
				CONVERT(VARCHAR(12), HA.ValidTo, 106) AS ValidTill
				,AnnouncementID
				,ValidTo
			FROM HotelAnnouncement HA
			INNER JOIN HotelMaster HM ON HA.HotelID = HM.HotelID
			INNER JOIN City C ON C.IATACode = HM.CityIATACode
			-- INNER JOIN HotelGroups HG ON HG.IATACode = HM.ChainIATACode                   
			WHERE (
					@HotelID IS NULL
					OR @HotelID = 0
					OR HM.HotelID = @HotelID
					)
				AND (
					@CityID IS NULL
					OR @CityID = ''
					OR HM.CityIATACode = @CityID
					)
				AND (
					@ChainIATACode IS NULL
					OR @ChainIATACode = ''
					OR HM.ChainIATACode = @ChainIATACode
					)
				AND (
					@AnnouncementID IS NULL
					OR @AnnouncementID = ''
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					OR @AnnouncementID = 0
					OR HA.AnnouncementID = @AnnouncementID
					)
				AND RTRIM(LTRIM(HA.AnnouncementDetails)) <> ''
				 AND HA.ValidTo >= GETDATE()
			-- AND  (       @AnnouncementID IS NULL           OR AnnouncementID = @AnnouncementID       )                     
			ORDER BY CAST(ValidTo AS DATE) ASC;
				-- No need to return an additional success code here                        
		END
		ELSE IF @Action = 'SA'
		BEGIN
			SELECT C.Name AS City
				,HM.HotelName
				,HA.AnnouncementDetails
				,
				--    HG.Name AS HotelGroups,                    
				CONVERT(VARCHAR(12), HA.ValidTo, 106) AS ValidTill
				,AnnouncementID
				,ValidTo
			FROM HotelAnnouncement HA
			INNER JOIN HotelMaster HM ON HA.HotelID = HM.HotelID
			INNER JOIN City C ON C.IATACode = HM.CityIATACode
			-- INNER JOIN HotelGroups HG ON HG.IATACode = HM.ChainIATACode                   
			WHERE (
					@HotelID IS NULL
					OR @HotelID = 0
					OR HM.HotelID = @HotelID
					)
				AND (
					@CityID IS NULL
					OR @CityID = ''
					OR HM.CityIATACode = @CityID
					)
				AND (
					@ChainIATACode IS NULL
					OR @ChainIATACode = ''
					OR HM.ChainIATACode = @ChainIATACode
					)
				AND (
					@AnnouncementID IS NULL
					OR @AnnouncementID = ''
					OR @AnnouncementID = 0
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					OR HA.AnnouncementID = @AnnouncementID
					)
				AND RTRIM(LTRIM(HA.AnnouncementDetails)) <> ''
			-- AND  (       @AnnouncementID IS NULL           OR AnnouncementID = @AnnouncementID       )                     
			ORDER BY CAST(ValidTo AS DATE) ASC;
				-- No need to return an additional success code here                        
		END
		ELSE IF @Action = 'EX'
		BEGIN
			SELECT C.Name AS City
				,HM.HotelName
				,HA.AnnouncementDetails
				,
				--    HG.Name AS HotelGroups,                    
				CONVERT(VARCHAR(12), HA.ValidTo, 106) AS ValidTill
				
				,ValidTo
			FROM HotelAnnouncement HA
			INNER JOIN HotelMaster HM ON HA.HotelID = HM.HotelID
			INNER JOIN City C ON C.IATACode = HM.CityIATACode
			-- INNER JOIN HotelGroups HG ON HG.IATACode = HM.ChainIATACode                   
			WHERE (
					@HotelID IS NULL
					OR @HotelID = 0
					OR HM.HotelID = @HotelID
					)
				AND (
					@CityID IS NULL
					OR @CityID = ''
					OR HM.CityIATACode = @CityID
					)
				AND (
					@ChainIATACode IS NULL
					OR @ChainIATACode = ''
					OR HM.ChainIATACode = @ChainIATACode
					)
				AND (
					@AnnouncementID IS NULL
					OR @AnnouncementID = ''
					OR HA.AnnouncementID = @AnnouncementID
					)
				AND RTRIM(LTRIM(HA.AnnouncementDetails)) <> ''
			-- AND  (       @AnnouncementID IS NULL           OR AnnouncementID = @AnnouncementID       )                     
			ORDER BY CAST(ValidTo AS DATE) ASC;
				-- No need to return an additional success code here                        
		END
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE
		BEGIN
			SELECT '400' AS returnCode
				,'Invalid Action.' AS returnMessage;
		END
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorCode
			,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END