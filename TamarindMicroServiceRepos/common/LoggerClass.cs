using Newtonsoft.Json;
using NLog;
namespace TamarindAstra.Common
{
    public class LoggerClass
    {
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        public void LogDebug(string message)
        {
            logger.Debug(message);
        }
        public static void LogError(Exception ex,string message,string collectionName)
        {
            DateTimeOffset utcDateTimeOffset = DateTimeOffset.Parse(DateTime.Now.ToString());
            DateTime localDateTime = utcDateTimeOffset.LocalDateTime;
            string apiName = "";
            if (ex != null)
            {
                var stackTrace = ex.StackTrace;
                var lines = stackTrace.Split('\n');
                foreach (var line in lines)
                {
                    if (line.Contains("at"))
                    {
                        apiName = line.Split(' ').Last().Split('+')[0];
                        break;
                    }
                }
            }
            var jsonData = new
            {
                Date = localDateTime.ToString("yyyy-MM-dd HH:mm:ss.fff"),
                ApiName = apiName,
                ApiRequest = message,
                // ApiResponse = ApiResponse,
                ApiException = ex != null ? ex.ToString() : string.Empty
            };
            var jsonObject = new { collectionName, jsonData };
            string jsonString = JsonConvert.SerializeObject(jsonObject);
            RabbitMQService.SendMessage(jsonString);
        }
        public void LogInfo(string message)
        {
            logger.Info(message);
        }
        public void LogWarn(string message)
        {
            logger.Warn(message);
        }
    }
}
