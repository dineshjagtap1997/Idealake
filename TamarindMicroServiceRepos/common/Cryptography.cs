using CommonClass;
using Newtonsoft.Json.Linq;
using System.Reflection;
using System.Security.Cryptography;


namespace TamarindAstra.Common
{
    public class Cryptography
    {
      
        public string SecretKey = SharedConfiguration.GetCryptoSecretKey();

        // Encrypt a string using AES
        public static string EncryptStringAES(string plainText, string base64Key)
        {
            if (string.IsNullOrWhiteSpace(plainText) || string.IsNullOrWhiteSpace(base64Key))
                throw new ArgumentException("Invalid input data or key.");

            byte[] keyBytes = Convert.FromBase64String(base64Key);
            byte[] iv = new byte[16]; // Default IV (16 bytes of zeros)

            using (Aes aes = Aes.Create())
            {
                aes.Key = keyBytes;
                aes.IV = iv;

                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        using (StreamWriter writer = new StreamWriter(cs))
                        {
                            writer.Write(plainText);
                        }
                        return Convert.ToBase64String(ms.ToArray());
                    }
                }
            }
        }

      

        public static string DecryptStringAES(string encryptedData, string base64Key)
        {
            if (string.IsNullOrWhiteSpace(encryptedData) || string.IsNullOrWhiteSpace(base64Key))
                throw new ArgumentException("Invalid input data or key.");

            byte[] keyBytes = Convert.FromBase64String(base64Key);
            byte[] iv = new byte[16]; // Default IV (16 bytes of zeros)
            byte[] buffer = Convert.FromBase64String(encryptedData);

            using (Aes aes = Aes.Create())
            {
                aes.Key = keyBytes;
                aes.IV = iv;



                using (MemoryStream ms = new MemoryStream(buffer))
                {
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateDecryptor(), CryptoStreamMode.Read))
                    {
                        using (StreamReader reader = new StreamReader(cs))
                        {
                            return reader.ReadToEnd();
                        }
                    }
                }
            }
        }

        #region Common Method for Encryption
        public static JObject DecryptionData(string requestText, string TokenId, string isEncrypted)
        {
            JObject obj = new JObject();
            string currentMethod = MethodBase.GetCurrentMethod().Name;
            if (isEncrypted == "Y")
            {
                string plainTxtReq = Cryptography.DecryptStringAES(requestText, TokenId);
                obj = JObject.Parse(plainTxtReq);
            }
            else if (isEncrypted == "N")
            {
                obj = JObject.Parse(requestText);
            }
            //ExceptionManage(x, currentMethod, "");

            return obj;
        }
        public static JArray DecryptArrayData(string requestText, string TokenId, string isEncrypted)
        {
            JArray obj = new();
            if (isEncrypted == "Y")
            {
                string plainText = Cryptography.DecryptStringAES(requestText, TokenId);
                obj = JArray.Parse(plainText);
            }
            else if (isEncrypted == "N")
            {
                obj = JArray.Parse(requestText);
            }
            return obj;
        }


        public static JObject EncryptionData(string requestText, string TokenId, string isEncrypted)
        {
            JObject obj = new JObject();
            string currentMethod = MethodBase.GetCurrentMethod().Name;
            try
            {
                if (isEncrypted == "Y")
                {
                    string plainTxtReq = Cryptography.DecryptStringAES(requestText, TokenId);
                    obj = JObject.Parse(plainTxtReq);
                }
                else if (isEncrypted == "N")
                {
                    obj = JObject.Parse(requestText);
                }
            }
            catch (Exception ex)
            {
                //ExceptionManage(x, currentMethod, "");
            }
            return obj;
        }
        #endregion Common Method for Encryption


    }
}
