using CommonClass;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Dynamic;
using System.Globalization;

namespace MongoDB.Repositories
{
    public class MongoHelper
    {
        private readonly MongoClient _client;
        private readonly IMongoDatabase _mongoDatabase;
        
        public MongoHelper()
        {
            _client = new MongoClient(SharedConfiguration.GetMongoConnection());
            _mongoDatabase = _client.GetDatabase(SharedConfiguration.GetMongoDatabaseName());
        }

        // Method to get logs from the collection
        public Task<List<dynamic>> GetLogsAsync<T>(string collectionName, dynamic parameters)
        {
            var coll = _mongoDatabase.GetCollection<BsonDocument>(collectionName);
            if (collectionName == "InsertUpdateSAPJobsTime")
            {
                object logId = parameters?.DataToSplit != null ? Convert.ToString(parameters.DataToSplit) : 0;
                var filter = Builders<BsonDocument>.Filter.Eq("DataToSplit", logId);
                var sort = Builders<BsonDocument>.Sort.Descending("OperationOn");
                return coll.Find(filter).Sort(sort).ToListAsync().ContinueWith(task =>
                {
                    var logs = task.Result;

                    return logs.Select(doc => BsonToDynamic(doc)).ToList();
                });
            }
            else if (collectionName == "LockDateMaster")
            {
                object logId = parameters?.MonthName != null ? Convert.ToString(parameters.MonthName) : 0;
                var filter = Builders<BsonDocument>.Filter.Eq("MonthName", logId);
                var sort = Builders<BsonDocument>.Sort.Descending("OperationOn");
                return coll.Find(filter).Sort(sort).ToListAsync().ContinueWith(task =>
                {
                    var logs = task.Result;

                    return logs.Select(doc => BsonToDynamic(doc)).ToList();
                });
            }
            else if (collectionName == "UpdateLockUnlockQuotationModel")
            {
                object logId = parameters?.FileCode != null ? Convert.ToString(parameters.FileCode) : 0;
                var filter = Builders<BsonDocument>.Filter.Eq("FileCode", logId);
                var sort = Builders<BsonDocument>.Sort.Descending("OperationOn");
                return coll.Find(filter).Sort(sort).ToListAsync().ContinueWith(task =>
                {
                    var logs = task.Result;

                    return logs.Select(doc => BsonToDynamic(doc)).ToList();
                });
            }
            else if (collectionName == "ReportDownloads")
            {
                var logId = parameters?.LogId?.ToString();
                var reportType = parameters?.ReportType?.ToString();
                var fromDate = parameters?.dtFromDate?.ToString("yyyy-MM-dd");
                var toDate = parameters?.dtToDate?.ToString("yyyy-MM-dd");

                FilterDefinition<BsonDocument> filter = Builders<BsonDocument>.Filter.Empty;
                SortDefinition<BsonDocument> sort = Builders<BsonDocument>.Sort.Descending("OperationOn");

                if (fromDate != null && toDate != null)
                {
                    string startDateTimeStr = DateTime.ParseExact(fromDate + "T00:00:00.000", "yyyy-MM-ddTHH:mm:ss.fff", CultureInfo.InvariantCulture)
                                                      .ToString("yyyy-MM-dd HH:mm:ss.fff");

                    string endDateTimeStr = DateTime.ParseExact(toDate + "T20:30:00.000", "yyyy-MM-ddTHH:mm:ss.fff", CultureInfo.InvariantCulture)
                                                    .ToString("yyyy-MM-dd HH:mm:ss.fff");

                    if (!string.IsNullOrEmpty(reportType))
                    {
                        filter = new BsonDocument
            {
                { "OperationOn", new BsonDocument {
                    { "$gte", startDateTimeStr },
                    { "$lte", endDateTimeStr }
                }},
                { "ReportType", new BsonDocument("$eq", reportType) }
            };
                    }
                    else
                    {
                        filter = new BsonDocument
            {
                { "OperationOn", new BsonDocument {
                    { "$gte", startDateTimeStr },
                    { "$lte", endDateTimeStr }
                }}
            };
                    }
                }
                else if (!string.IsNullOrEmpty(reportType))
                {
                    filter = Builders<BsonDocument>.Filter.Eq("ReportType", reportType);
                }
                else if (logId == "null" || string.IsNullOrEmpty(logId))
                {
                    filter &= Builders<BsonDocument>.Filter.Eq("LogId", BsonNull.Value);
                }

                return coll.Find(filter)
                           .Sort(sort)
                           .ToListAsync()
                           .ContinueWith(task =>
                           {
                               var logs = task.Result;
                               return logs.Select(doc => BsonToDynamic(doc)).ToList();
                           });
            }
            else
            {
                int logId = parameters?.LogId != null ? Convert.ToInt32(parameters.LogId) : 0;
                var filter = Builders<BsonDocument>.Filter.Eq("LogId", logId);
                var sort = Builders<BsonDocument>.Sort.Descending("OperationOn");
                return coll.Find(filter).Sort(sort).ToListAsync().ContinueWith(task =>
                {
                    var logs = task.Result;

                    return logs.Select(doc => BsonToDynamic(doc)).ToList();
                });
            }
            
        }


        private dynamic BsonToDynamic(BsonDocument doc)
        {
            dynamic expando = new ExpandoObject();
            var expandoDict = (IDictionary<string, object>)expando;
            foreach (var element in doc.Elements)
            {
                expandoDict[element.Name] = BsonTypeMapper.MapToDotNetValue(element.Value);
            }

            return expando;
        }

        public async Task SaveLogAsync<T>(string jsonData)
       {
            try
            {
                var messageDict = JsonConvert.DeserializeObject<Dictionary<string, object>>(jsonData);

                string collectionName = messageDict["collectionName"].ToString();
                var log = JsonConvert.DeserializeObject<Dictionary<string, object>>(messageDict["jsonData"].ToString());

                // Convert all DateTime values to UTC
                var normalizedLog = NormalizeDateTimes(log);

                var coll = _mongoDatabase.GetCollection<BsonDocument>(collectionName);
                var bsonDocument = new BsonDocument(normalizedLog);

                bool isDraft = log.ContainsKey("QuotationDraft") && Convert.ToBoolean(log["QuotationDraft"]);

                bool isHotelCode = log.ContainsKey("IsHotelCode") && Convert.ToBoolean(log["IsHotelCode"]);

                if (isHotelCode)
                {
                    if (!bsonDocument.Contains("HotelCode"))
                    {
                        throw new Exception("HotelCode is required for HotelMaster update.");
                    }

                    if (!bsonDocument.Contains("SAPCode"))
                    {
                        throw new Exception("HotelSAPCode is required for HotelMaster update.");
                    }

                    var HotelId = bsonDocument["HotelID"].ToInt64();
                    var filter = Builders<BsonDocument>.Filter.Eq("HotelID", HotelId);

                    var existingDoc = await coll.Find(filter).FirstOrDefaultAsync();
                    if (existingDoc != null)
                    {
                        var hotelCode = bsonDocument["HotelCode"];
                        var hotelSAPCode = bsonDocument["SAPCode"];

                        var update = Builders<BsonDocument>.Update
                            .Set("HotelCode", hotelCode)
                            .Set("SAPCode", hotelSAPCode);

                        await coll.UpdateManyAsync(filter, update);
                    }



                }
                else if (isDraft)
                {
                    if (!bsonDocument.Contains("QuotationID"))
                    {
                        throw new Exception("QuotationID is required for DraftQuotation update.");
                    }


                    var quotationId = bsonDocument["QuotationID"].ToInt64(); // adjust based on actual type
                    var filter = Builders<BsonDocument>.Filter.Eq("QuotationID", quotationId);

                    var existingDoc = await coll.Find(filter).FirstOrDefaultAsync();
                    if (existingDoc != null)
                    {
                        var existingId = existingDoc["_id"]; // Get the existing MongoDB _id

                        bsonDocument["_id"] = existingId;

                        // Perform the replace operation
                        await coll.ReplaceOneAsync(
                            Builders<BsonDocument>.Filter.Eq("_id", existingId), // filter by the existing _id
                            bsonDocument, // replace with the new data
                            new ReplaceOptions { IsUpsert = false } // don't insert if not found
                        );
                    }
                    else
                    {
                        await coll.InsertOneAsync(bsonDocument);
                    }
                }
                else
                {
                    await coll.InsertOneAsync(bsonDocument);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"MongoError: {ex.Message}");
            }
        }


        private Dictionary<string, object> NormalizeDateTimes(Dictionary<string, object> dict)
        {
            var result = new Dictionary<string, object>();

            foreach (var kvp in dict)
            {
                if (kvp.Value is DateTime dt)
                {
                    result[kvp.Key] = DateTime.SpecifyKind(dt, DateTimeKind.Utc);
                }
                else if (kvp.Value is JObject jObject)
                {
                    var nestedDict = jObject.ToObject<Dictionary<string, object>>();
                    result[kvp.Key] = NormalizeDateTimes(nestedDict);
                }
                else if (kvp.Value is JArray jArray)
                {
                    var list = jArray.Select(item =>
                    {
                        if (item.Type == JTokenType.Date)
                        {
                            var date = item.ToObject<DateTime>();
                            return DateTime.SpecifyKind(date, DateTimeKind.Utc);
                        }
                        else if (item.Type == JTokenType.Object)
                        {
                            var subDict = item.ToObject<Dictionary<string, object>>();
                            return NormalizeDateTimes(subDict);
                        }
                        else
                        {
                            return item.ToObject<object>();
                        }
                    }).ToList();

                    result[kvp.Key] = list;
                }
                else
                {
                    result[kvp.Key] = kvp.Value;
                }
            }

            return result;
        }
    }
}