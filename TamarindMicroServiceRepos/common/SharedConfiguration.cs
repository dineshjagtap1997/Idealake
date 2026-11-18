using Microsoft.Extensions.Configuration;

namespace CommonClass
{

    public static class SharedConfiguration
    {
        private static IConfigurationRoot _configuration;

        static SharedConfiguration()
        {
            var basePath = AppContext.BaseDirectory;
            var path = Path.Combine(basePath, "CommonSettings", "appsettings.shared.json");

            var builder = new ConfigurationBuilder()
                .AddJsonFile(path, optional: false, reloadOnChange: true);

            _configuration = builder.Build();
        }

        public static IConfigurationRoot Configuration => _configuration;

        // 🔹 Default Connection String
        public static string GetConnectionString(string name = "DefaultConnection")
        {
            return _configuration.GetConnectionString(name);
        }

        // 🔹 RabbitMQ Configs
        public static string GetRabbitMQSetting(string key)
        {
            return _configuration[$"RabbitMQ:{key}"];
        }

        public static int GetRabbitMQPort()
        {
            return int.TryParse(_configuration["RabbitMQ:Port"], out var port) ? port : 5672;
        }

        // 🔹 JWT Config
        public static int GetJwtExpiryInMinutes()
        {
            return int.TryParse(_configuration["Jwt:ExpiryInMinutes"], out var mins) ? mins : 30;
        }

        // 🔹 Cryptography Key
        public static string GetCryptoSecretKey()
        {
            return _configuration["Cryptography:SecretKey"];
        }

        //// 🔹 Common base64Key
        //public static string GetBase64Key()
        //{
        //    return _configuration["Common:base64Key"];
        //}
        public static string GetMongoConnection()
        {
            return _configuration["MongoDB:MongoConnection"];
        }

        public static string GetMongoDatabaseName()
        {
            return _configuration["MongoDB:DatabaseName"];
        }
        public static SmtpSettings GetSmtpSettings()
        {
            return _configuration.GetSection("SmtpSettings").Get<SmtpSettings>();
        }
        public static string GetUploadsBaseUrl()
        {
            return _configuration["Uploads:BaseUrl"];
        }

        public static string GetAdvancePayApproveUrl()
        {
            return _configuration["Common:AdvancePayApproveUrl"];
        }
        
        public static string GetAdvancePayRejectUrl()
        {
            return _configuration["Common:AdvancePayRejectUrl"];
        }
        public static string GetCustomerRegistrationUrl()
        {
            return _configuration["Common:CustomerRegistrationUrl"];
        }
        public static string GetHotelRegistrationUrl()
        {
            return _configuration["Common:HotelRegistrationUrl"];
        }
        public static string GetVendorRegistrationUrl()
        {
            return _configuration["Common:VendorRegistrationUrl"];
        }

    }
}
