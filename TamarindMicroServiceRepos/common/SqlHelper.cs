using CommonClass;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.Data;
using static Dapper.SqlMapper;

namespace TamarindAstra.Common
{
    public class SqlHelper
    {
        private readonly IConfiguration _config;
        private static string connectionId = SharedConfiguration.GetConnectionString();

        public SqlHelper(IConfiguration config)
        {
            _config = config;
          //  connectionId = config.GetConnectionString("DefaultConnection");
        }
        public static IEnumerable<T> LoadData<T, U>(string storedProcedure,
                                                      U parameters)
        {
            if (string.IsNullOrEmpty(connectionId))
                throw new Exception("Connection string not found.");
            using IDbConnection connection = new SqlConnection(connectionId);

            return connection.Query<T>(storedProcedure,
                                                  parameters,
                                                  commandType: CommandType.StoredProcedure);
        }


        public static IEnumerable<T> LoadDataOutput<T, U>(string storedProcedure,
                                              U parameters)
        {
            if (string.IsNullOrEmpty(connectionId))
                throw new Exception("Connection string not found.");
            using IDbConnection connection = new SqlConnection(connectionId);

            return connection.Query<T>(storedProcedure,
                                                  parameters,
                                                  commandType: CommandType.StoredProcedure);
        }

        public static async Task<IEnumerable<T>> QueryAsync<T, U>(string storedProcedure, U parameters)
        {
            using IDbConnection connection = new SqlConnection(connectionId);
            var result = await connection.QueryAsync<T>(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public static async Task<(IEnumerable<T1>, IEnumerable<T2>)> QueryMultipleAsync<T1, T2, U>(string storedProcedure, U parameters)
        {
            using IDbConnection connection = new SqlConnection(connectionId);
            using var multi = await connection.QueryMultipleAsync(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
            var result1 = multi.Read<T1>().AsList();
            var result2 = multi.Read<T2>().AsList();
            return (result1, result2);
        }
        public static async Task<(IEnumerable<T0>, IEnumerable<T1>, IEnumerable<T2>)> QueryMultipleAsync<T0, T1, T2, U>(string storedProcedure, U parameters)
        {
            using IDbConnection connection = new SqlConnection(connectionId);
            using var multi = await connection.QueryMultipleAsync(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
            var result1 = multi.Read<T0>();
            var result2 = multi.Read<T1>();
            var result3 = multi.Read<T2>();
            return (result1, result2, result3);
        }
        public static async Task<(IEnumerable<T0>, IEnumerable<T1>, IEnumerable<T2>, IEnumerable<T3>)> QueryMultipleAsync<T0, T1, T2, T3, U>(string storedProcedure, U parameters)
        {
            using IDbConnection connection = new SqlConnection(connectionId);
            using var multi = await connection.QueryMultipleAsync(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
            var result1 = multi.Read<T0>();
            var result2 = multi.Read<T1>();
            var result3 = multi.Read<T2>();
            var result4 = multi.Read<T3>();
            return (result1, result2, result3, result4);
        }
        public static async Task<T> QuerySingleAsync<T, U>(string spName, U parameters)
        {
            using IDbConnection connection = new SqlConnection(connectionId);
            var result = await connection.QuerySingleAsync<T>(spName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }

        public static ResponseViewModel<T> LoadDataMultiple<T, U>(string storedProcedure, U parameters)
        {
            if (string.IsNullOrEmpty(connectionId))
                throw new Exception("Connection string not found.");

            using IDbConnection connection = new SqlConnection(connectionId);

            using var multi = connection.QueryMultiple(storedProcedure, parameters, commandType: CommandType.StoredProcedure);

            var response = new ResponseViewModel<T>
            {
                dataList = multi.Read<T>().ToList() // Fetch main data list
            };

            // Read row count, ensuring the result exists
            var rowCountData = multi.Read<int>().FirstOrDefault();
            response.count = rowCountData;

            return response;
        }

        public static async Task SaveAsync<T>(string storedProcedures, T parameters)
        {
            using IDbConnection connection = new SqlConnection(connectionId);
            await connection.ExecuteAsync(storedProcedures, parameters, commandType: CommandType.StoredProcedure);
        }

        public static (T1 Table1, List<T2> Table2) LoadDataWithTable<T1, T2, U>(string storedProcedure, U parameters)
        {
            {
                if (string.IsNullOrEmpty(connectionId))
                    throw new Exception("Connection string not found.");
                using IDbConnection connection = new SqlConnection(connectionId);
                var result = connection.QueryMultiple(storedProcedure,
                                                      parameters,
                                                      commandType: CommandType.StoredProcedure);
                var table2 = new List<T2>();
                var table1 = result.ReadFirstOrDefault<T1>();
                try
                {
                    table2 = result.Read<T2>().ToList(); // Read first result set
                                                         // Read second result set
                }
                catch (Exception ex)
                {

                }

                return (table1, table2);
            }
        }

        public static async Task<(List<T1> Table1, T2 Table2)> LoadDataWithTable1<T1, T2, U>(string storedProcedure, U parameters)
        {
            if (string.IsNullOrEmpty(connectionId))
                throw new Exception("Connection string not found.");

            // Use 'await' to ensure the connection is opened asynchronously
            using IDbConnection connection = new SqlConnection(connectionId);

            // Use 'QueryMultipleAsync' to execute the stored procedure and retrieve multiple result sets
            var result = await connection.QueryMultipleAsync(storedProcedure,
                                                              parameters,
                                                              commandType: CommandType.StoredProcedure);

            var table1 = await result.ReadAsync<T1>().ConfigureAwait(false);
            var table1List = table1.ToList();

            var table2 = await result.ReadAsync<T2>().ConfigureAwait(false);
            var table2Single = table2.SingleOrDefault(); // Assuming a single record, use `SingleOrDefault` or `FirstOrDefault`

            // Return both tables
            return (table1List, table2Single);
        }

        public static async Task<T> SaveDataAsync<T>(string storedProcedures, DynamicParameters parameters)
        {

            if (string.IsNullOrEmpty(connectionId))
                throw new Exception("Connection string not found.");

            using IDbConnection connection = new SqlConnection(connectionId);

            // Query the stored procedure and return the result as the specified type T
            var result = await connection.QuerySingleOrDefaultAsync<T>(storedProcedures, parameters, commandType: CommandType.StoredProcedure);

            // If no result is returned, return the default value of T (null for reference types, etc.)
            return result;


        }

        //DO NOT REMOVE THIS CODE AS IT WILL BE NEEDED FURTHER
        //public static async Task<string> GetNewAgentCodeAsync(string agentName, string Country_IATACode)
        //{
        //    try
        //    {
        //        string iniPrefix = "DR";
        //        string iniPrefix2 = Country_IATACode.ToUpper() == "IN" ? "D" : "O";
        //        string codeFormat = $"{iniPrefix}{iniPrefix2}{agentName.ToUpper()[0]}";

        //        using (var connection = new SqlConnection(connectionId))
        //        {
        //            await connection.OpenAsync();

        //            // Get the latest Code_No
        //            var parameters = new DynamicParameters();
        //            parameters.Add("@Code_Format", codeFormat, DbType.String);

        //            int codeNo = await connection.ExecuteScalarAsync<int>("Usp_GetAgent_Code_Format", parameters, commandType: CommandType.StoredProcedure);
        //            codeNo++;

        //            string newagentCode = $"{codeFormat}{codeNo.ToString().PadLeft(3, '0')}";

        //            // Update the new code number in the database
        //            var updateParameters = new DynamicParameters();
        //            updateParameters.Add("@Code_No", codeNo, DbType.Int32);
        //            updateParameters.Add("@Code_Format", codeFormat, DbType.String);

        //            await connection.ExecuteAsync("Usp_Update_Agent_Code_Format", updateParameters, commandType: CommandType.StoredProcedure);

        //            return newagentCode;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new Exception("Error generating agent code", ex);
        //    }
        //}
        /*public static async Task<string> GenerateNewAgentCode()
        {
            string newCode = "DRO0000001"; // Default if no records exist

            *//*using (var connection = new SqlConnection(connectionId))
            {
                string query = "SELECT MAX(AgentCode) FROM AgentMaster WHERE AgentCode LIKE 'DRO%'";
                var lastCode = await connection.QueryFirstOrDefaultAsync<string>(query);

                if (!string.IsNullOrEmpty(lastCode) && Regex.IsMatch(lastCode, @"^DRO0{6}\d+$"))
                {
                    // Extract the numeric part after "DRO000000"
                    int lastNumber = int.Parse(lastCode.Substring(9)); // Get only the counter part
                    newCode = $"DRO000000{(lastNumber + 1)}"; // Increment the counter
                }
            }*//*

            using (var connection = new SqlConnection(connectionId))
            {
                await connection.OpenAsync();

                // Get the count of existing DRO agent codes
                string query = "SELECT COUNT(AgentCode) FROM AgentMaster WHERE AgentCode LIKE 'DRO%'";
                int count = await connection.QueryFirstOrDefaultAsync<int>(query);

                // Increment the count and generate the new code
                int newCounter = count + 1;
                newCode = $"DRO000000{newCounter}";
            }

            return newCode;

        }*/
        public static async Task<string> GetNewHotelCodeAsync(string ChainIATACode)
        {
            try
            {
                if (string.IsNullOrEmpty(ChainIATACode) || ChainIATACode.Length < 3)
                {
                    throw new ArgumentException("ChainIATACode must be at least 3 characters long.", nameof(ChainIATACode));
                }

                string initialPrefix = "C";
                string hotelPrefix = ChainIATACode.ToUpper().Substring(0, 3);
                string codeFormat = $"{initialPrefix}{hotelPrefix}";
                int type = 1;

                using (var connection = new SqlConnection(connectionId))
                {
                    await connection.OpenAsync();

                    // Get the latest HotelCode
                    var parameters = new DynamicParameters();
                    parameters.Add("@Type", type, DbType.Int32);
                    parameters.Add("@Prefix", hotelPrefix, DbType.String);

                    int hotelCode = await connection.QueryFirstOrDefaultAsync<int>("usp_GetMaxNoID", parameters, commandType: CommandType.StoredProcedure);

                    hotelCode++;

                    string newHotelCode = $"{codeFormat}{hotelCode.ToString().PadLeft(4, '0')}";

                    return newHotelCode;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error generating hotel code", ex);
            }
        }

        public static async Task<string> GetNewVendorCodeAsync(string VendorSAPCode)
        {
            try
            {
                int type = 2;

                using (var connection = new SqlConnection(connectionId))
                {
                    await connection.OpenAsync();

                    // Get the latest HotelCode
                    var parameters = new DynamicParameters();
                    parameters.Add("@Type", type, DbType.Int32);
                    //parameters.Add("@Prefix", vendorPrefix, DbType.String);

                    string VendorCode = await connection.QueryFirstOrDefaultAsync<string>("usp_GetMaxNoID", parameters, commandType: CommandType.StoredProcedure);

                    return VendorCode;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error generating VendorCode code", ex);
            }
        }

        public static async Task<(List<T1> Table1, List<T2> Table2, List<T3> Table3, List<T4> Table4, List<T5> Table5)>
    LoadDataWithMultiTablesAsync<T1, T2, T3, T4, T5, U>(string storedProcedure, U parameters)
        {
            if (string.IsNullOrEmpty(connectionId))
                throw new Exception("Connection string not found.");

            using IDbConnection connection = new SqlConnection(connectionId);
            var result = await connection.QueryMultipleAsync(
                storedProcedure,
                parameters,
                commandType: CommandType.StoredProcedure
            );

            var table1 = (await result.ReadAsync<T1>()).ToList();
            var table2 = (await result.ReadAsync<T2>()).ToList();
            var table3 = (await result.ReadAsync<T3>()).ToList();
            var table4 = (await result.ReadAsync<T4>()).ToList();
            var table5 = (await result.ReadAsync<T5>()).ToList();

            return (table1, table2, table3, table4, table5);
        }
        public static async Task<string> LoadJsonDataAsync<T, U>(string storedProcedure, U parameters)
        {
            if (string.IsNullOrEmpty(connectionId))
                throw new Exception("Connection string not found.");

            using IDbConnection connection = new SqlConnection(connectionId);

            // Execute the stored procedure and get all results
            var results = await connection.QueryAsync(
                storedProcedure,
                parameters,
                commandType: CommandType.StoredProcedure
            );

            // Convert all results to JSON
            return JsonConvert.SerializeObject(results);
        }

    }
}