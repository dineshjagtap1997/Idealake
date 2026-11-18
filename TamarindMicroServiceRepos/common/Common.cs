using CommonClass;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using MongoDB.Repositories;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System.ComponentModel;
using System.Data;
using System.Dynamic;
using System.Reflection;
using System.Text;
using System.Linq;
namespace TamarindAstra.Common


{
    public class CommonFunctions
    {
        public static string _base64Key = SharedConfiguration.GetCryptoSecretKey();
        private static string isEncrypted = "Y";
        private readonly IConfiguration _configuration;
        private readonly static string _uploadFolderPath = Path.Combine(Directory.GetCurrentDirectory(), "Uploads");
        private static RabbitMQService _rabbitMQService;
        private static MongoHelper _mongoHelper;
        private static CancellationToken cancellationToken;
        public CommonFunctions(IConfiguration config, IOptions<Cryptography> options)
        {
            if (!Directory.Exists(_uploadFolderPath))
            {
                Directory.CreateDirectory(_uploadFolderPath);
            }
            _configuration = config;
        }
        public static T DecryptAndDeserializeArrayRequest<T>(string requestText) where T : class
        {
            requestText = requestText.Replace(" ", "+");
            JArray jArray = Cryptography.DecryptArrayData(requestText, _base64Key, isEncrypted);
            return jArray != null && jArray.Count > 0 ? JsonConvert.DeserializeObject<T>(jArray.ToString()) : default;
        }

        public static List<TRequest> DecryptAndDeserializeRequestList<TRequest>(string requestText) where TRequest : class
        {
            requestText = requestText.Replace(" ", "+");
            JArray objArray = Cryptography.DecryptArrayData(requestText, _base64Key, isEncrypted) as JArray;

            return objArray != null && objArray.Count > 0 ? JsonConvert.DeserializeObject<List<TRequest>>(objArray.ToString()) : new List<TRequest>();
        }


        public static TRequest SmartDecryptAndDeserialize<TRequest>(string responseText) where TRequest : class
        {
            if (string.IsNullOrEmpty(responseText))
                return null;

            try
            {
                responseText = responseText.Trim();

                // Check if it's already JSON format
                if (responseText.StartsWith("{") || responseText.StartsWith("["))
                {
                    // Direct JSON deserialization
                    var settings = new JsonSerializerSettings
                    {
                        Converters = new List<JsonConverter> { new NullableDateTimeConverter() }
                    };
                    return JsonConvert.DeserializeObject<TRequest>(responseText, settings);
                }
                else
                {
                    // Try decryption first
                    return DecryptAndDeserializeNullRequest<TRequest>(responseText);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }



        #region  Decrypt null date Data starts here
        public static TRequest DecryptAndDeserializeNullRequest<TRequest>(string requestText) where TRequest : class
        {
            requestText = requestText.Replace(" ", "+");
            JObject obj = Cryptography.DecryptionData(requestText, _base64Key, isEncrypted);

            if (obj != null && obj.Count > 0)
            {
                var settings = new JsonSerializerSettings
                {
                    Converters = new List<JsonConverter> { new NullableDateTimeConverter() }
                };

                return JsonConvert.DeserializeObject<TRequest>(obj.ToString(), settings);
            }

            return null;
        }

        public class NullableDateTimeConverter : JsonConverter<DateTime?>
        {
            public override DateTime? ReadJson(JsonReader reader, Type objectType, DateTime? existingValue, bool hasExistingValue, JsonSerializer serializer)
            {
                if (reader.TokenType == JsonToken.Null)
                    return null;

                if (reader.TokenType == JsonToken.String)
                {
                    string value = reader.Value.ToString();
                    if (string.IsNullOrEmpty(value) || value.ToLower() == "null")
                        return null;

                    return DateTime.Parse(value);
                }

                return existingValue;
            }

            public override void WriteJson(JsonWriter writer, DateTime? value, JsonSerializer serializer)
            {
                if (value.HasValue)
                    writer.WriteValue(value.Value);
                else
                    writer.WriteNull();
            }
        }
        #endregion Decrypt null date Data ends here

        public static ResponseModel BlankResponse(string code, string message, object? DataObj = null)
        {
            Exception? ex = null;
            return CreateErrorResponse(ex, code, message, DataObj);
        }

        public static ResponseModel CreateErrorResponse(Exception? ex, string code, string message, object? DataObj = null)
        {
            var responseModel = new ResponseModel();

            if (ex != null)
                LoggerClass.LogError(ex, message, "ApiExceptionLogs");
            else
                LoggerClass.LogError(null, message, "ApiExceptionLogs");

            var errorResponse = new
            {
                returnCode = code,
                returnMessage = ex != null ? ex.Message : message,
                token = (string)null,
                Data = DataObj ?? new List<string>() // default empty list if null
            };

            string jsonString = JsonConvert.SerializeObject(errorResponse);

            responseModel.responseText = isEncrypted == "Y"
                ? Cryptography.EncryptStringAES(jsonString, _base64Key)
                : jsonString;

            return responseModel;
        }
        public static ResponseModel ProcessResult<T>(ResponseViewModel<T> data)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = JsonConvert.SerializeObject(data);
            responseModel.responseText = jsonString;
            // Encrypt the response if needed
            if (isEncrypted == "Y")
            {
                responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
            }
            return responseModel;
        }
        public static string ProcessResult1<T>(ResponseViewModel<T> data)
        {
            string jsonString = JsonConvert.SerializeObject(data);
            string responseData = jsonString;
            // Encrypt the response if needed
            if (isEncrypted == "Y")
            {
                responseData = Cryptography.EncryptStringAES(jsonString, _base64Key);
            }
            return responseData;
        }
        //public static ResponseModel ProcessFileResult<T>(FileResponseViewModel<T> data, byte[] param)
        //{

        //    //  if (param != Encoding.UTF8.GetBytes("200"))
        //    if ((param != null && param.SequenceEqual(Encoding.UTF8.GetBytes("200"))) || (param != null && !param.SequenceEqual(Encoding.UTF8.GetBytes("201"))))
        //    {
        //        data.data = param;
        //        data.returnCode = "200";
        //        data.returnMessage = "Data Found";
        //        data.ID = data.ID;
        //    }
        //    else
        //    {
        //        data.returnCode = "201";
        //        data.returnMessage = "Data Not Found";
        //    }
        //    ResponseModel responseModel = new ResponseModel();
        //    string jsonString = JsonConvert.SerializeObject(data);
        //    JObject obj = JObject.Parse(jsonString);

        //    string companyName = (string)obj["data"];

        //    responseModel.responseText = jsonString;
        //    // Encrypt the response if needed
        //    if (isEncrypted == "Y")
        //    {
        //        responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
        //    }
        //    return responseModel;
        //}

        public static ResponseModel ProcessFileResult<T>(FileResponseViewModel<T> fileData, byte[] fileBytes)
        {
            try
            {
                Console.WriteLine($"📁 ProcessFileResult called with file size: {fileBytes?.Length ?? 0} bytes");

                ResponseModel responseModel = new ResponseModel();

                if (fileBytes == null || fileBytes.Length == 0)
                {
                    Console.WriteLine("❌ No file data to process");

                    fileData.returnCode = "201";
                    fileData.returnMessage = "No file data to process";
                    fileData.data = null;

                    responseModel.returnCode = "201";
                    responseModel.returnMessage = "No file data to process";
                    responseModel.responseText = "201";

                    return responseModel;
                }

                // File data exists - SUCCESS case
                Console.WriteLine("✅ Processing file data successfully");

                fileData.returnCode = "200";
                fileData.returnMessage = "File generated successfully";
                fileData.data = fileBytes; // Direct assignment since data is byte[]

                responseModel.returnCode = "200";
                responseModel.returnMessage = "File generated successfully";
                responseModel.FileContent = fileBytes; // Store for direct access

                // Serialize the FileResponseViewModel
                string jsonString = JsonConvert.SerializeObject(fileData);
                responseModel.responseText = jsonString;

                // Encrypt if needed
                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    Console.WriteLine("🔒 Response encrypted");
                }

                Console.WriteLine("✅ ProcessFileResult completed successfully");
                return responseModel;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ ProcessFileResult error: {ex.Message}");
                return CreateErrorResponse(ex, "500", "Failed to process file result");
            }
        }
        // 3. Alternative method specifically for file processing (recommended)
        public static ResponseModel ProcessFileResultForExport(byte[] fileBytes, string fileName = null)
        {
            try
            {
                ResponseModel responseModel = new ResponseModel();

                if (fileBytes == null || fileBytes.Length == 0)
                {
                    responseModel.returnCode = "201";
                    responseModel.returnMessage = "No file data generated";
                    responseModel.responseText = "201"; // Simple status for empty result
                    return responseModel;
                }

                // Success case
                responseModel.returnCode = "200";
                responseModel.returnMessage = "File generated successfully";
                responseModel.FileContent = fileBytes;

                // Store as base64 in responseText for extraction
                responseModel.responseText = Convert.ToBase64String(fileBytes);

                return responseModel;
            }
            catch (Exception ex)
            {
                var errorResponse = new ResponseModel
                {
                    returnCode = "500",
                    returnMessage = $"File processing failed: {ex.Message}",
                    responseText = "500"
                };
                return errorResponse;
            }
        }

        public static ResponseModel ProcessDBData_WitoutAction<T>(ResponseViewModel<T> data, string SPName, dynamic parameters)// sarthak
        {
            var mongoRequest = data.data;
            data.dataList = SqlHelper.LoadData<T, dynamic>(SPName, parameters);

            // Determine initial return status
            if (data.dataList?.Count > 0)
            {
                data.returnCode = "200";
                data.returnMessage = "Data Found";
            }
            else
            {
                var statusResponse = SqlHelper.LoadData<StatusModel, dynamic>(SPName, parameters);
                var status = statusResponse;
                data.returnCode = status?.returnCode?.ToString() ?? "201";
                data.returnMessage = status?.returnMessage ?? "Data Not Found";
            }

            // If data found, push to RabbitMQ
            if (data.returnCode == "200")
            {
                var spNameClean = RemoveSchemaFromSpName(SPName);
                RabbitMQService.StoreDataInQueue(mongoRequest, data.ID, spNameClean);
            }

            return ProcessResult(data);
        }

        //public static ResponseModel ProcessDBData_WitoutAction<T>(ResponseViewModel<T> data, string SPName, dynamic parameters)//avadhut
        //{
        //    var mongoRequest = data.data;
        //    data.dataList = SqlHelper.LoadData<T, dynamic>(SPName, parameters);

        //    // Determine initial return status
        //    var statusResponse = SqlHelper.LoadData<StatusModel, dynamic>(SPName, parameters);
        //    if (statusResponse != null && statusResponse.Count > 0)
        //    {
        //        var status = statusResponse.First();
        //        data.returnCode = status?.returnCode?.ToString() ?? "201";
        //        data.returnMessage = status?.returnMessage ?? "Data Not Found";
        //    }
        //    else
        //    {
        //        data.returnCode = "201";
        //        data.returnMessage = "Data Not Found";
        //    }

        //    // If data found, push to RabbitMQ
        //    if (data.returnCode == "200")
        //    {
        //        var spNameClean = RemoveSchemaFromSpName(SPName);
        //        RabbitMQService.StoreDataInQueue(mongoRequest, data.ID, spNameClean);
        //    }

        //    return ProcessResult(data);
        //}
        public static ResponseModel ProcessDBData<T>(ResponseViewModel<T> data, string action, string SPName, dynamic parameters)
        {
            var mongorequest = data.data;
            if (action.ToLower() == "rd" || action.ToLower() == "s" || action.ToLower() == "es" || action.ToLower() == "ex" || action.ToLower() == "sa" || action.ToLower() == "f" || action.ToLower() == "usap" || action.ToLower() == "c" || action.ToLower() == "sb")
            //|| action.ToLower() == "u" Contact Avadhut before un commenting Action U
            {

                data.dataList = SqlHelper.LoadData<T, dynamic>(SPName, parameters);

                if (data.dataList.Count > 0)
                {
                    data.returnCode = "200";
                    data.returnMessage = "Data Found";
                    if (action.ToLower() == "rd")
                    {
                        var userIdProp = mongorequest?.GetType().GetProperty("UserId");
                        var userIdValue = userIdProp?.GetValue(mongorequest);

                        long? userId = null;
                        if (userIdValue != null)
                        {
                            userId = Convert.ToInt64(userIdValue); // safely convert int? → long?
                        }

                        RabbitMQService.StoreDataInQueue(mongorequest, userId, SPName);
                    }

                }
                else
                {
                    data.returnCode = "201";
                    data.returnMessage = "Data Not Found";
                
                }

            }
            else
            {

                var statusresponse = SqlHelper.LoadData<StatusModel, dynamic>(SPName, parameters);
                if (statusresponse != null && statusresponse.Count > 0)
                {
                    data.returnCode = statusresponse[0].returnCode?.ToString();
                    data.returnMessage = statusresponse[0].returnMessage;
                    data.LastSavedOn = statusresponse[0].LastSavedOn;
                    data.XONumber = statusresponse[0].XONumber;
                    data.ID = statusresponse[0].ID;
                    var empCodeProp = mongorequest?.GetType().GetProperty("EmpCode");
                    var HotelCodeProp = mongorequest?.GetType().GetProperty("HotelCode");
                    var HotelIDProp = mongorequest?.GetType().GetProperty("HotelID");
                    var HotelSAPCodeProp = mongorequest?.GetType().GetProperty("SAPCode");
                    var AgentCode = mongorequest?.GetType().GetProperty("AgentCode");
                    var CustomerCode = mongorequest?.GetType().GetProperty("CustomerCode");
                    if (empCodeProp != null && empCodeProp.CanWrite)
                    {
                        empCodeProp.SetValue(mongorequest, statusresponse[0].EmpCode);
                    }
                    if (HotelCodeProp != null && HotelCodeProp.CanWrite)
                    {
                        HotelCodeProp.SetValue(mongorequest, statusresponse[0].EmpCode);
                    }
                    if (AgentCode != null && AgentCode.CanWrite)
                    {
                        AgentCode.SetValue(mongorequest, statusresponse[0].AgentCode);
                    }
                    if (CustomerCode != null && CustomerCode.CanWrite)
                    {
                        CustomerCode.SetValue(mongorequest, statusresponse[0].CustomerCode);
                    }
                    if (data.returnCode == "200")
                    { 
                        SPName = RemoveSchemaFromSpName(SPName);
                        RabbitMQService.StoreDataInQueue(mongorequest, data.ID, SPName);
                    }
                }
            }
            return ProcessResult(data);
        }



        public static ResponseModel ProcessMongoDBData<T>(ResponseViewModel<T> data, string action, string SPName, dynamic parameters)
        {
            SPName = RemoveSchemaFromSpName(SPName);
            RabbitMQService.StoreDataInQueue(data.data, data.ID, SPName);
            return ProcessResult(data);
        }

        public static string RemoveSchemaFromSpName(string spName)
        {
            if (string.IsNullOrEmpty(spName))
                return spName;

            // Remove surrounding brackets entirely (optional, if you want clean name)
            spName = spName.Trim();

            // Find first dot that separates schema and procedure
            int dotIndex = spName.IndexOf('.');

            if (dotIndex >= 0 && dotIndex < spName.Length - 1)
            {
                // The rest after the dot is procedure name, possibly bracketed
                string procPart = spName.Substring(dotIndex + 1).Trim();

                // Remove surrounding brackets if any
                procPart = procPart.Trim('[', ']');

                return procPart;
            }

            // No dot found, just remove brackets if any
            return spName.Trim('[', ']');
        }

        public static ResponseModel ProcessDBDataComma<T>(ResponseViewModel<T> data, string action, string SPName, dynamic parameters)
        {

            if (action.ToLower() == "s")
            {
                data.dataList = SqlHelper.LoadData<T, dynamic>(SPName, parameters);

                if (data.dataList.Count > 0)
                {
                    data.returnCode = "200";
                    data.returnMessage = "Data Found";
                }
                else
                {
                    data.returnCode = "201";
                    data.returnMessage = "Data Not Found";
                }
            }

            return ProcessResult(data);
        }

        public static ResponseModel ProcessDBDataPagination<T>(ResponseViewModel<T> data, string action, string SPName, dynamic parameters)
        {
            var mongorequest = data.data;

            if (action.ToLower() == "s" || action.ToLower() == "f" || action.ToLower() == "sa")
            {
                var result = SqlHelper.LoadDataMultiple<T, dynamic>(SPName, parameters);

                if (result.dataList.Count > 0)
                {
                    data.dataList = result.dataList;
                    data.count = result.count;
                    data.returnCode = "200";
                    data.returnMessage = "Data Found";
                }
                else
                {
                    data.returnCode = "201";
                    data.returnMessage = "Data Not Found";
                    data.count = 0;
                }
            }
            else
            {

                var statusresponse = SqlHelper.LoadData<StatusModel, dynamic>(SPName, parameters);
                if (statusresponse != null)
                {
                    data.returnCode = statusresponse[0].returnCode?.ToString();
                    data.returnMessage = statusresponse[0].returnMessage;
                    data.ID = statusresponse[0].ID;
                    if (data.returnCode == "200")
                    {
                        SPName = RemoveSchemaFromSpName(SPName);
                        RabbitMQService.StoreDataInQueue(mongorequest, data.ID, SPName);
                    }
                }
            }

            return ProcessResult(data);
        }

        public static DataTable ConvertExcelToDataTable(IFormFile file)
        {
            var dataTable = new DataTable();

            using (var stream = file.OpenReadStream())
            {
                IWorkbook workbook = new XSSFWorkbook(stream);
                ISheet sheet = workbook.GetSheetAt(0); // Read the first sheet

                // Use the first row as column names
                dataTable = ConvertSheetToDataTable(sheet);
            }

            return dataTable;
        }

        private static DataTable ConvertSheetToDataTable(ISheet sheet)
        {
            var table = new DataTable();

            // Add columns
            var headerRow = sheet.GetRow(0);
            foreach (var cell in headerRow.Cells)
                table.Columns.Add(cell.ToString());

            // Add rows
            for (int row = 1; row <= sheet.LastRowNum; row++)
            {
                var sheetRow = sheet.GetRow(row);
                if (sheetRow == null) continue;

                var dataRow = table.NewRow();
                for (int col = 0; col < headerRow.LastCellNum; col++)
                    dataRow[col] = sheetRow.GetCell(col)?.ToString() ?? string.Empty;

                table.Rows.Add(dataRow);
            }

            return table;
        }
        public static void AddMetadataColumns(DataTable dataTable, int createdBy)
        {
            // Add common metadata columns
            dataTable.Columns.Add("CreatedBy", typeof(int));

            foreach (DataRow row in dataTable.Rows)
            {
                row["CreatedBy"] = createdBy;
            }
        }
        public static async Task<StatusModel> BulkInsertUsingDataTableAsync<T>(ResponseViewModel<T> data, string SPName, dynamic parameters)
        {
            ResponseModel responseModel = new ResponseModel();


            string uniqueFileName = string.Empty;

            // Call the database procedure
            var statusResponse = await SqlHelper.SaveDataAsync<StatusModel>(SPName, parameters);

            if (statusResponse != null)
            {
                data.returnCode = statusResponse.returnCode?.ToString();
                data.returnMessage = statusResponse.returnMessage;


            }
            return statusResponse;
        }

        public static string CreateSubFolder(string subFolderPath)
        {
            string fullPath = Path.Combine(_uploadFolderPath, subFolderPath);

            // Ensure the nested folder structure exists
            if (!Directory.Exists(fullPath))
            {
                Directory.CreateDirectory(fullPath);
            }
            return fullPath;
        }

        public static DateTime? ParseDate(string dateString)
        {
            if (!string.IsNullOrEmpty(dateString) && dateString != "null")
            {
                if (DateTime.TryParse(dateString, out DateTime parsedDate))
                {
                    return parsedDate;
                }
            }
            return null;
        }

        public static string? FormatDateToYMD(DateTime? date)
        {
            return date?.ToString("yyyy-MM-dd");
        }


        public static ResponseModel ProcessResult1(object data, string v1, string v2)
        {
            throw new NotImplementedException();
        }
        public static string GetMasterTypeName(int parentTypeID)
        {
            return parentTypeID switch
            {
                25 => "Customer",
                11 => "Agent",
                10 => "Hotel",
                9 => "Vendor",
                8 => "EmailConfig",
                1 => "HotelRateCard",
                2 => "GuideRateCard",
                4 => "MonumentRateCard",
                5 => "SpecialServiceRateCard",
                3 => "TransportRateCard",
                6 => "MOTRateCard",
                7 => "HotelOfferRateCard",
                _ => "Other"
            };
        }
        public static string GetMasterTypeImageName(int parentTypeID)
        {
            return parentTypeID switch
            {
                7 => "Agent",
                2 => "CityHotel",
                3 => "Customer",
                _ => "Other"
            };
        }

        public static DataTable ToDataTable(List<Dictionary<string, object>> list)
        {
            var dataTable = new DataTable();

            if (list == null || list.Count == 0)
                return dataTable;

            // Add columns
            foreach (var key in list[0].Keys)
                dataTable.Columns.Add(key);

            // Add rows
            foreach (var dict in list)
            {
                var row = dataTable.NewRow();
                foreach (var kvp in dict)
                    row[kvp.Key] = kvp.Value ?? DBNull.Value;
                dataTable.Rows.Add(row);
            }

            return dataTable;
        }
        private byte[] ExportToCsv(DataTable dataTable)
        {
            StringBuilder sb = new StringBuilder();

            // Adding headers to CSV
            var columnNames = dataTable.Columns.Cast<DataColumn>().Select(col => col.ColumnName);
            sb.AppendLine(string.Join(",", columnNames));

            // Adding rows to CSV
            foreach (DataRow row in dataTable.Rows)
            {
                var fields = row.ItemArray.Select(field => field.ToString().Replace(",", " ")); // Escape commas
                sb.AppendLine(string.Join(",", fields));
            }

            // Return CSV as byte array
            return Encoding.UTF8.GetBytes(sb.ToString());
        }

        public static string MergeJson(dynamic parameters, int? data, string SPName)
        {
            string collectionName = GetEnumDescription((DatabaseObjects)Enum.Parse(typeof(DatabaseObjects), SPName));
            dynamic expandoAlpha = new ExpandoObject();
            var jsonData = (IDictionary<string, object>)expandoAlpha;
            if (parameters != null)
            {
                foreach (var prop in parameters.GetType().GetProperties())
                {
                    jsonData[prop.Name] = prop.GetValue(parameters);
                }
            }
            DateTimeOffset utcDateTimeOffset = DateTimeOffset.Now;
            DateTime localDateTime = utcDateTimeOffset.LocalDateTime;

            jsonData["LogId"] = data;
            jsonData["OperationOn"] = localDateTime.ToString("yyyy-MM-dd HH:mm:ss.fff");
            var jsonObject = new { collectionName, jsonData };
            string jsonString = JsonConvert.SerializeObject(jsonObject);
            return jsonString;
        }
        static string GetEnumDescription(DatabaseObjects value)
        {
            var field = value.GetType().GetField(value.ToString());
            var attribute = (DescriptionAttribute)Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute));
            return attribute != null ? attribute.Description : value.ToString();
        }

        public static DataTable ConvertListToDataTableWithEmpName<T>(List<T> list)
        {
            var dt = new DataTable();
            if (list == null || list.Count == 0) return dt;

            var firstItem = list[0];

            // Dynamic object handling (ExpandoObject)
            if (firstItem is IDictionary<string, object> dict)
            {
                // Add existing columns from first item
                foreach (var key in dict.Keys)
                {
                    Type colType = dict[key]?.GetType() ?? typeof(object);
                    dt.Columns.Add(key.ToString(), colType);
                }

                // Add CreatedbyName column if not present
                if (!dt.Columns.Contains("CreatedbyName"))
                {
                    dt.Columns.Add("CreatedbyName", typeof(object));
                }

                foreach (IDictionary<string, object> item in list)
                {
                    DataRow row = dt.NewRow();

                    // Existing properties
                    foreach (var key in dict.Keys)
                    {
                        //row[key] = item.TryGetValue(key.ToString(), out object val) ? val : null;
                        row[key] = item.TryGetValue(key.ToString(), out object val) ? (val ?? DBNull.Value) : DBNull.Value;
                    }

                    // New CreatedbyName property
                    row["CreatedbyName"] = item.TryGetValue("CreatedbyName", out object createdByName)
                        ? createdByName
                        : null;

                    dt.Rows.Add(row);
                }
            }
            // Static type handling
            else
            {
                PropertyInfo[] props = typeof(T).GetProperties();
                bool hasCreatedByName = props.Any(p => p.Name == "CreatedbyName");

                // Add existing properties as columns
                foreach (var prop in props)
                {
                    dt.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
                }

                // Add CreatedbyName column if not present
                if (!dt.Columns.Contains("CreatedbyName"))
                {
                    dt.Columns.Add("CreatedbyName", typeof(object));
                }

                foreach (var item in list)
                {
                    DataRow row = dt.NewRow();

                    // Existing properties
                    foreach (var prop in props)
                    {
                        row[prop.Name] = prop.GetValue(item) ?? null;
                    }

                    // New CreatedbyName property
                    row["CreatedbyName"] = hasCreatedByName
                        ? props.First(p => p.Name == "CreatedbyName").GetValue(item) ?? null
                        : null;

                    dt.Rows.Add(row);
                }
            }

            return dt;
        }

        public static DataTable ConvertListToDataTable<T>(List<T> list)
        {
            var dt = new DataTable();
            if (list == null || list.Count == 0) return dt;

            var firstItem = list[0];

            // Dynamic object handling (ExpandoObject)
            if (firstItem is IDictionary<string, object> dict)
            {
                foreach (var key in dict.Keys)
                {
                    Type colType = dict[key]?.GetType() ?? typeof(object);
                    dt.Columns.Add(key.ToString(), colType);
                }

                foreach (IDictionary<string, object> item in list)
                {
                    DataRow row = dt.NewRow();
                    foreach (var key in dict.Keys)
                    {
                        if (key == "RoleId" || key == "UserID" || key == "Level1UID" || key == "Level2UID" || key == "Level3UID" || key == "AdvancesApp")
                        {
                            if (item.TryGetValue(key.ToString(), out object roleIdValue))
                            {
                                // Now you have the value of RoleID in `roleIdValue`
                                if (roleIdValue == null)
                                {
                                    row[key] = 0; // If RoleID is null, set it to 0
                                }
                                else
                                {
                                    row[key] = roleIdValue; // Otherwise, set the actual value
                                }
                            }
                        }
                        else
                        {
                            row[key] = item.TryGetValue(key.ToString(), out object val) ? val : DBNull.Value;
                        }
                    }
                    dt.Rows.Add(row);
                }
            }
            // Static type handling
            else
            {
                PropertyInfo[] props = typeof(T).GetProperties();
                foreach (var prop in props)
                {
                    dt.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
                }

                foreach (var item in list)
                {
                    DataRow row = dt.NewRow();
                    foreach (var prop in props)
                    {
                        row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                    }
                    dt.Rows.Add(row);
                }
            }

            return dt;
        }


        public static List<dynamic> ConvertDataTableToList(DataTable dt)
        {
            var dynamicList = new List<dynamic>();

            foreach (DataRow row in dt.Rows)
            {
                // Create a dynamic ExpandoObject for each row
                dynamic expandoObj = new ExpandoObject();
                var dictionary = (IDictionary<string, object>)expandoObj;

                foreach (DataColumn column in dt.Columns)
                {
                    // Add each column as a key-value pair
                    dictionary[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                }

                dynamicList.Add(expandoObj);
            }

            return dynamicList;
        }



        public static ResponseModel ViewLogs<T>(ResponseViewModel<T> data, dynamic parameters)
        {
            _rabbitMQService = new RabbitMQService();
            cancellationToken = new CancellationToken();

            MongoHelper mongo = new MongoHelper();
            data.dataList = mongo.GetLogsAsync<T>(data.collectionName, parameters).GetAwaiter().GetResult();


            List<T> LogListData = new List<T>();
            LogListData.AddRange(data.dataList);

            DataTable dtLog = ConvertListToDataTableWithEmpName(LogListData);

            EmployeeMasterRequest objEmp = new EmployeeMasterRequest();
            EmployeeMasterAllData objReq = new EmployeeMasterAllData();
            EmployeeMasterAllData objemployee = JsonConvert.DeserializeObject<EmployeeMasterAllData>(objEmp.RequestText);

            var EmpDataMaster = CommonFunctions.ProcessDBData(data, "s", "usp_Employee_Master", objemployee);
            List<T> ListEmpMaster = new List<T>();
            ListEmpMaster.AddRange(data.dataList);
            DataTable dtEmpMaster = ConvertListToDataTable(ListEmpMaster);


            var query = from log in dtLog.AsEnumerable()
                        let operationBy = Guid.TryParse(log.Field<string>("OperationBy"), out Guid parsedGuid) ? parsedGuid : (Guid?)null
                        where operationBy.HasValue // Only proceed if the GUID is valid
                        join emp in dtEmpMaster.AsEnumerable()
                        on operationBy equals emp.Field<Guid>("UserID") // Matching the GUIDs between dtLog and dtEmpMaster
                        select new
                        {
                            OperationBy = operationBy,
                            EmployeeName = emp.Field<string>("EmpName") // Directly get the EmployeeName
                        };


            foreach (DataRow row in dtLog.AsEnumerable())
            {
                Guid.TryParse(Convert.ToString(row["OperationBy"]), out Guid operationBy);
                var employeeDetail = query.Where(x => x.OperationBy.Equals(operationBy)).FirstOrDefault();
                row["CreatedbyName"] = employeeDetail?.EmployeeName;

            }
            dtLog.AcceptChanges();




            List<dynamic> dynamicList = ConvertDataTableToList(dtLog);

            data.dataList = dynamicList.ConvertAll(item => (T)item);

            if (data.dataList.Count > 0)
            {
                data.returnCode = "200";
                data.returnMessage = "Data Found";
            }
            else
            {
                data.returnCode = "201";
                data.returnMessage = "Data Not Found";
            }
            return ProcessResult(data);
        }

        public static string createHtml(string content, string hotelName)
        {
            StringBuilder _sb = new StringBuilder();

            _sb.Append("<html>");
            _sb.Append("<body>");
            _sb.Append("<table border='1' width='400px'>");
            _sb.Append("<tr><td colspan='2'>" + hotelName + "</td></tr>");
            _sb.Append("<tr><td>Hotel Information </td><td>" + content + "</td></tr>");
            _sb.Append("</table>");
            _sb.Append("</body>");
            _sb.Append("</html>");


            return _sb.ToString();
        }

        public static string SerializeAndEncryptResponse(object value)
        {
            throw new NotImplementedException();
        }

        public static TRequest DecryptAndDeserializeRequest<TRequest>(string requestText)
        {
            string tokenId = "ODA4MDgwODA4MDgwODA4MA==";
            string isEncrypted = "Y";

            // Use the existing method that handles both arrays and objects
            var resultList = DecryptAndDeserialize<TRequest>(requestText, tokenId, isEncrypted);

            // Return the first item in the list (or default if empty)
            return resultList.FirstOrDefault();
        }

        public static List<T> DecryptAndDeserialize<T>(string requestText, string tokenId = "ODA4MDgwODA4MDgwODA4MA==", string isEncrypted = "Y")
        {
            try
            {
                string decryptedText = isEncrypted == "Y"
                    ? Cryptography.DecryptStringAES(requestText, tokenId)
                    : requestText;

                decryptedText = decryptedText?.Trim() ?? string.Empty;

                if (decryptedText.StartsWith("["))
                {
                    return JsonConvert.DeserializeObject<List<T>>(decryptedText);
                }

                if (decryptedText.StartsWith("{"))
                {
                    var singleObj = JsonConvert.DeserializeObject<T>(decryptedText);
                    return singleObj != null ? new List<T> { singleObj } : new List<T>();
                }

                throw new JsonReaderException("Invalid JSON. Must start with '{' or '['.");
            }
            catch (JsonException ex)
            {
                throw new Exception("JSON deserialization failed: " + ex.Message, ex);
            }
        }

        public static ResponseModel BlankResponse(string v)
        {
            throw new NotImplementedException();
        }

        public static string AmountToWords(decimal amount)
        {
            // Arrays for number-to-words conversion
            string[] units = { "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
                      "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
                      "Eighteen", "Nineteen" };
            string[] tens = { "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

            // Local function to convert integer to words
            string ConvertNumber(int num)
            {
                if (num >= 10000000)
                    return ConvertNumber(num / 10000000) + " Crore " + ConvertNumber(num % 10000000);
                if (num >= 100000)
                    return ConvertNumber(num / 100000) + " Lakh " + ConvertNumber(num % 100000);
                if (num >= 1000)
                    return ConvertNumber(num / 1000) + " Thousand " + ConvertNumber(num % 1000);
                if (num >= 100)
                    return ConvertNumber(num / 100) + " Hundred " + ConvertNumber(num % 100);
                if (num >= 20)
                    return tens[num / 10] + " " + ConvertNumber(num % 10);
                if (num >= 1)
                    return units[num];
                return "";
            }

            // Handle decimal amount
            if (amount == 0) return "Zero Rupees Only";

            int rupees = (int)amount;
            int paise = (int)((amount - rupees) * 100);

            string rupeesText = ConvertNumber(rupees).Trim();
            string paiseText = ConvertNumber(paise).Trim();

            if (string.IsNullOrEmpty(rupeesText)) rupeesText = "Zero";
            if (string.IsNullOrEmpty(paiseText)) paiseText = "Zero";

            return paise == 0
                ? $"{rupeesText} Rupees Only"
                : $"{rupeesText} Rupees and {paiseText} Paise Only";
        }

        public static string AmountToWords(decimal amount, string currencyCode)
        {
            // Defines units and tens (common for all)
            string[] units = { "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
                       "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
                       "Eighteen", "Nineteen" };
            string[] tens = { "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

            // Currency details for supported currencies
            var currencyDetails = new Dictionary<string, (string MainUnit, string SubUnit, bool UseIndianSystem)>
    {
        {"INR", ("Rupee", "Paisa", true)},
        {"USD", ("Dollar", "Cent", false)},
        {"AED", ("Dirham", "Fils", false)},
        {"GBP", ("Pound", "Penny", false)},
        {"EUR", ("Euro", "Cent", false)},
        {"AUD", ("Dollar", "Cent", false)},
        {"CAD", ("Dollar", "Cent", false)},
        {"SGD", ("Dollar", "Cent", false)},
        {"SAR", ("Riyal", "Halalah", false)}
    };

            // Normalize currency code input
            string ccy = currencyCode.Trim().ToUpperInvariant();

            // Use INR as default if not found
            (string MainUnit, string SubUnit, bool UseIndianSystem) ccyDetail =
                currencyDetails.ContainsKey(ccy) ? currencyDetails[ccy] : ("Rupee", "Paisa", true);

            string mainUnit = ccyDetail.MainUnit;
            string subUnit = ccyDetail.SubUnit;
            bool isINR = ccyDetail.UseIndianSystem;

            // Recursive number conversion based on numbering system
            string ConvertNumber(int num, bool indian)
            {
                //if (num == 0) return "Zero";
                if (num == 0) return "";
                if (num < 20)
                    return units[num];
                if (num < 100)
                    return tens[num / 10] + (num % 10 > 0 ? " " + units[num % 10] : "");
                if (num < 1000)
                    return units[num / 100] + " Hundred" + (num % 100 > 0 ? " " + ConvertNumber(num % 100, indian) : "");

                if (indian)
                {
                    if (num >= 10000000)
                        return ConvertNumber(num / 10000000, true) + " Crore " + (num % 10000000 > 0 ? ConvertNumber(num % 10000000, true) : "");
                    if (num >= 100000)
                        return ConvertNumber(num / 100000, true) + " Lakh " + (num % 100000 > 0 ? ConvertNumber(num % 100000, true) : "");
                    if (num >= 1000)
                        return ConvertNumber(num / 1000, true) + " Thousand " + (num % 1000 > 0 ? ConvertNumber(num % 1000, true) : "");
                }
                else
                {
                    if (num >= 1000000000)
                        return ConvertNumber(num / 1000000000, false) + " Billion " + (num % 1000000000 > 0 ? ConvertNumber(num % 1000000000, false) : "");
                    if (num >= 1000000)
                        return ConvertNumber(num / 1000000, false) + " Million " + (num % 1000000 > 0 ? ConvertNumber(num % 1000000, false) : "");
                    if (num >= 1000)
                        return ConvertNumber(num / 1000, false) + " Thousand " + (num % 1000 > 0 ? ConvertNumber(num % 1000, false) : "");
                }
                return "";
            }

            if (amount == 0)
                return $"Zero {mainUnit}s Only";

            //int mainAmount = (int)amount;
            //int subAmount = (int)Math.Round((amount - mainAmount) * 100);

            //string mainWords = ConvertNumber(mainAmount, isINR).Trim();
            //string subWords = ConvertNumber(subAmount, isINR).Trim();

            //if (string.IsNullOrEmpty(mainWords)) mainWords = "Zero";
            //mainUnit = mainAmount == 1 ? mainUnit : mainUnit + "s";
            //subUnit = subAmount == 1 ? subUnit : subUnit + "s";

            //if (subAmount == 0)
            //    return $"{mainWords} {mainUnit} Only";
            //else
            //    return $"{mainWords} {mainUnit} and {subWords} {subUnit} Only";



            int mainAmount = (int)amount;
            int subAmount = (int)Math.Round((amount - mainAmount) * 100);

            string mainWords = ConvertNumber(mainAmount, isINR).Trim();
            string subWords = subAmount > 0 ? ConvertNumber(subAmount, isINR).Trim() : "";

            if (string.IsNullOrEmpty(mainWords)) mainWords = "Zero";
            mainUnit = mainAmount == 1 ? mainUnit : mainUnit + "s";
            subUnit = subAmount == 1 ? subUnit : subUnit + "s";

            if (subAmount == 0)
                return $"{mainWords} {mainUnit} Only";
            else
                return $"{mainWords} {mainUnit} and {subWords} {subUnit} Only";

        }

        public static byte[] ExtractFileFromResponse(ResponseModel response)
        {
            try
            {
                Console.WriteLine(" ExtractFileFromResponse called");

                if (response == null)
                {
                    Console.WriteLine(" Response is null");
                    return null;
                }

                // Method 1: Direct access to FileContent property
                if (response.FileContent != null && response.FileContent is byte[] fileBytes)
                {
                    Console.WriteLine($" Extracted {fileBytes.Length} bytes from FileContent");
                    return fileBytes;
                }

                // Method 2: Extract from responseText (FileResponseViewModel structure)
                if (!string.IsNullOrEmpty(response.responseText) && response.returnCode == "200")
                {
                    try
                    {
                        string decryptedData = response.responseText;

                        // Try to decrypt if encrypted
                        if (isEncrypted == "Y")
                        {
                            try
                            {
                                decryptedData = Cryptography.DecryptStringAES(response.responseText, _base64Key);
                                Console.WriteLine("🔓 Response decrypted successfully");
                            }
                            catch (Exception decEx)
                            {
                                Console.WriteLine($"⚠️ Decryption failed, using original: {decEx.Message}");
                                decryptedData = response.responseText;
                            }
                        }

                        if (!string.IsNullOrEmpty(decryptedData))
                        {
                            // Try to parse as FileResponseViewModel JSON
                            try
                            {
                                JObject jsonObj = JObject.Parse(decryptedData);

                                // Look for the data field (which contains byte array)
                                if (jsonObj["data"] != null)
                                {
                                    var dataToken = jsonObj["data"];

                                    // If data is a byte array serialized as JSON array
                                    if (dataToken.Type == JTokenType.Array)
                                    {
                                        var byteArray = dataToken.ToObject<byte[]>();
                                        Console.WriteLine($"Extracted {byteArray.Length} bytes from JSON array");
                                        return byteArray;
                                    }
                                    // If data is a base64 string, decode it
                                    else if (dataToken.Type == JTokenType.String)
                                    {
                                        string base64Data = dataToken.ToString();
                                        if (IsBase64String(base64Data))
                                        {
                                            var decodedBytes = Convert.FromBase64String(base64Data);
                                            Console.WriteLine($"Extracted {decodedBytes.Length} bytes from base64 string");
                                            return decodedBytes;
                                        }
                                    }
                                }
                            }
                            catch (JsonException jsonEx)
                            {
                                Console.WriteLine($" JSON parsing failed: {jsonEx.Message}");

                                // Try direct base64 decode
                                if (IsBase64String(decryptedData))
                                {
                                    var directBytes = Convert.FromBase64String(decryptedData);
                                    Console.WriteLine($" Extracted {directBytes.Length} bytes from direct base64");
                                    return directBytes;
                                }

                                // Last resort: return as UTF8 bytes
                                var utf8Bytes = Encoding.UTF8.GetBytes(decryptedData);
                                Console.WriteLine($"Created {utf8Bytes.Length} bytes from UTF8 string");
                                return utf8Bytes;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($" Error processing responseText: {ex.Message}");
                    }
                }

                Console.WriteLine(" No file data could be extracted");
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($" ExtractFileFromResponse failed: {ex.Message}");
                return null;
            }
        }

        // Helper method to check if string is valid base64
        private static bool IsBase64String(string s)
        {
            if (string.IsNullOrEmpty(s))
                return false;

            try
            {
                Convert.FromBase64String(s);
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}