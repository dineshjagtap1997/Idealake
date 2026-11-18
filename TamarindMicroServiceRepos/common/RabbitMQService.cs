using CommonClass;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.ComponentModel;
using System.Dynamic;
using System.Text;

namespace TamarindAstra.Common
{
    public class RabbitMQService
    {
        private static readonly string _hostName = SharedConfiguration.GetRabbitMQSetting("HostName");
        private static readonly int _Port = SharedConfiguration.GetRabbitMQPort();
        private static readonly string _userName = SharedConfiguration.GetRabbitMQSetting("UserName");
        private static readonly string _password = SharedConfiguration.GetRabbitMQSetting("Password");
        private static readonly string _queueName = SharedConfiguration.GetRabbitMQSetting("QueueName");
        private static readonly string _exchange = SharedConfiguration.GetRabbitMQSetting("Exchange");
        private static readonly string _virtualHost = "/";
        CancellationToken cancellationToken = new CancellationToken();

        static string GetEnumDescription(DatabaseObjects value)
        {
            var field = value.GetType().GetField(value.ToString());
            var attribute = (DescriptionAttribute)Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute));
            return attribute != null ? attribute.Description : value.ToString();
        }

        public static void StoreDataInQueue(dynamic parameters, long? data, string SPName)
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
            SendMessage(JsonConvert.SerializeObject(jsonObject));
        }

        public static async Task SendMessage(string jsonString, CancellationToken cancellationToken = default)
        {
            var factory = new ConnectionFactory
            {
                HostName = _hostName,
                UserName = _userName,
                Password = _password,
                VirtualHost = _virtualHost,
                Port = _Port,
                AutomaticRecoveryEnabled = true,
                NetworkRecoveryInterval = TimeSpan.FromSeconds(10)
            };

            try
            {
                using (var connection = await factory.CreateConnectionAsync().ConfigureAwait(false))
                {
                    using (var channel = await connection.CreateChannelAsync().ConfigureAwait(false))
                    {

                        await channel.QueueDeclareAsync(_queueName, durable: true, exclusive: false, autoDelete: false, arguments: null);
                        var body = Encoding.UTF8.GetBytes(jsonString);

                        // Corrected the exchange name and routing key usage
                        await channel.BasicPublishAsync(exchange: "",
                                                       routingKey: _queueName,
                                                       mandatory: false,
                                                       body: body,
                                                       cancellationToken: cancellationToken);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"RabbitMQ Error: {ex.Message}");
                // Consider logging the exception for better error tracking
            }
        }
    }
}