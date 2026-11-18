<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE usp_DestinationMaster                  
    @SelectedValues NVARCHAR(MAX)=NULL, -- Comma-separated values like "1:C,5:S,10:T"                  
 @Action char(3) null,          
 @Name Varchar(max) = null          
AS                  
BEGIN               
              
    IF @Action = 'I'                  
    BEGIN                  
        -- Temporary table to store parsed values                  
        CREATE TABLE #TempValues (EntityID INT, EntityType CHAR(1));                  
              
        -- Remove trailing comma and spaces, then split              
        INSERT INTO #TempValues (EntityID, EntityType)                  
        SELECT                   
            CAST(LEFT(value, LEN(value) - 1) AS INT),  -- Extract ID (all but last char)              
            RIGHT(value, 1)                           -- Extract Type (last char: C, S, or T)              
        FROM STRING_SPLIT(TRIM(',' FROM @SelectedValues), ',');  -- Remove trailing commas              
              
        -- Insert into DestinationMaster                  
        INSERT INTO DestinationMaster (CountryID, StateID, CityID)                  
        SELECT                   
            MAX(CASE WHEN EntityType = 'C' THEN EntityID END) AS CountryID,                  
            MAX(CASE WHEN EntityType = 'S' THEN EntityID END) AS StateID,                  
            MAX(CASE WHEN EntityType = 'T' THEN EntityID END) AS CityID                  
        FROM #TempValues;                  
              
        -- Return Success Message                  
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage;                  
              
        -- Cleanup                  
        DROP TABLE #TempValues;                  
    END                  
else if @Action = 's'                  
begin                  
--SELECT C.IATACode, C.Name AS COUNTRYNAME , S.State_ID, S.Name AS STATENAME, CT.ident AS CITY_ID, CT.Name AS CITYNAME FROM CITY CT                  
--  INNER JOIN STATE S ON S.State_ID = CT.State_IATACode                  
--  INNER JOIN Country C ON C.IATACode = S.Country_IATACode                  
                  
SELECT                   
        CONCAT(C.ID, 'C') AS ID, C.NAME AS Name                  
    FROM Country C                  
                      
    UNION ALL                  
                      
    SELECT                   
        CONCAT(S.State_ID, 'S') AS ID, S.NAME AS Name                  
    FROM STATE S                  
                      
    UNION ALL                  
                      
    SELECT                   
        CONCAT(CT.ID, 'T') AS ID, CT.NAME AS Name                  
    FROM CITY CT            
          
end       
ELSE IF @Action='EX'
BEGIN
SELECT                   
         C.NAME AS Name                  
    FROM Country C                  
                      
    UNION ALL                  
                      
    SELECT                   
       S.NAME AS Name                  
    FROM STATE S                  
                      
    UNION ALL                  
                      
    SELECT                   
         CT.NAME AS Name                  
    FROM CITY CT            

END
else if @Action = 'ES'           
begin          
          
          
-- Create the temp table first          
CREATE TABLE #temptable (          
    id INT,          
    Names NVARCHAR(MAX)          
);          
          
-- Insert the aggregated results into the temp table          
INSERT INTO #temptable (id, NameS)          
SELECT id, STRING_AGG(Name, ', ') AS Names          
FROM (          
    SELECT dm.id, c.Name           
    FROM DestinationMaster dm          
    INNER JOIN Country c ON c.id = dm.CountryID          
          
    UNION ALL          
          
    SELECT dm.id, s.Name           
    FROM DestinationMaster dm          
    INNER JOIN State s ON s.State_ID = dm.StateID          
          
    UNION ALL          
          
    SELECT dm.id, ct.Name           
    FROM DestinationMaster dm          
    INNER JOIN City ct ON ct.ID = dm.CityID          
) AS CombinedData          
GROUP BY id;          
          
-- Select from temp table to verify data          
SELECT ID, NAMES AS NAME FROM #temptable          
--where #temptable.Names like '%' +@name+ '%'         
        
          
          
end          
          
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE usp_DestinationMaster                    
    @SelectedValues NVARCHAR(MAX)=NULL, -- Comma-separated values like "1:C,5:S,10:T"                    
 @Action char(3) null,            
 @Name Varchar(max) = null            
AS                    
BEGIN                 
                
    IF @Action = 'I'                    
    BEGIN                    
        -- Temporary table to store parsed values                    
        CREATE TABLE #TempValues (EntityID INT, EntityType CHAR(1));                    
                
        -- Remove trailing comma and spaces, then split                
        INSERT INTO #TempValues (EntityID, EntityType)                    
        SELECT                     
            CAST(LEFT(value, LEN(value) - 1) AS INT),  -- Extract ID (all but last char)                
            RIGHT(value, 1)                           -- Extract Type (last char: C, S, or T)                
        FROM STRING_SPLIT(TRIM(',' FROM @SelectedValues), ',');  -- Remove trailing commas                
                
        -- Insert into DestinationMaster                    
        INSERT INTO DestinationMaster (CountryID, StateID, CityID)                    
        SELECT                     
            MAX(CASE WHEN EntityType = 'C' THEN EntityID END) AS CountryID,                    
            MAX(CASE WHEN EntityType = 'S' THEN EntityID END) AS StateID,                    
            MAX(CASE WHEN EntityType = 'T' THEN EntityID END) AS CityID                    
        FROM #TempValues;                    
                
        -- Return Success Message                    
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage;                    
                
        -- Cleanup                    
        DROP TABLE #TempValues;                    
    END                    
else if @Action = 's'                    
begin                    
--SELECT C.IATACode, C.Name AS COUNTRYNAME , S.State_ID, S.Name AS STATENAME, CT.ident AS CITY_ID, CT.Name AS CITYNAME FROM CITY CT                    
--  INNER JOIN STATE S ON S.State_ID = CT.State_IATACode                    
--  INNER JOIN Country C ON C.IATACode = S.Country_IATACode                    
                    
SELECT                     
        CONCAT(C.ID, 'C') AS ID, C.NAME AS Name                    
    FROM Country C                    
                        
    UNION ALL                    
                        
    SELECT                     
        CONCAT(S.State_ID, 'S') AS ID, S.NAME AS Name                    
    FROM STATE S                    
                        
    UNION ALL                    
                        
    SELECT                     
        CONCAT(CT.ID, 'T') AS ID, CT.NAME AS Name                    
    FROM CITY CT              
            
end         
ELSE IF @Action='EX'  
BEGIN  
SELECT                     
         C.NAME AS Name                    
    FROM Country C                    
                        
    UNION ALL                    
                        
    SELECT                     
       S.NAME AS Name                    
    FROM STATE S                    
                        
    UNION ALL                    
                        
    SELECT                     
         CT.NAME AS Name                    
    FROM CITY CT              
  
END  
else if @Action = 'ES'             
begin            
            
            
-- Create the temp table first            
CREATE TABLE #temptable (            
    id INT,            
    Names NVARCHAR(MAX)            
);            
            
-- Insert the aggregated results into the temp table            
INSERT INTO #temptable (id, NameS)            
SELECT id, STRING_AGG(Name, ', ') AS Names            
FROM (            
    SELECT dm.id, c.Name             
    FROM DestinationMaster dm            
    INNER JOIN Country c ON c.id = dm.CountryID            
            
    UNION ALL            
            
    SELECT dm.id, s.Name        
    FROM DestinationMaster dm            
    INNER JOIN State s ON s.State_ID = dm.StateID            
            
    UNION ALL            
            
    SELECT dm.id, ct.Name             
    FROM DestinationMaster dm            
    INNER JOIN City ct ON ct.ID = dm.CityID            
) AS CombinedData            
GROUP BY id;            
            
-- Select from temp table to verify data            
SELECT ID, NAMES AS NAME FROM #temptable            
--where #temptable.Names like '%' +@name+ '%'           
          
            
            
end            
            
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END; 