using BusinessLogic.Interface;
using CommonClass;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

namespace TamarindAstra.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuditLogsController : ControllerBase
    {
        private readonly IMongoCollection<BsonDocument> _auditLogsCollection;
        private readonly IAuditLogService _auditLogService;
        public AuditLogsController(IAuditLogService auditLogService)
        {
            var mongoClient = new MongoClient("mongodb://localhost:27017");
            var database = mongoClient.GetDatabase("MyDatabase");
            _auditLogsCollection = database.GetCollection<BsonDocument>("AuditLogs");
            _auditLogService = auditLogService;
        }

        [HttpPost("FetchAuditLogs")]
        public async Task<ResponseModel> FetchAuditLogs(RequestModel request)
        {
            return await _auditLogService.FetchAuditLogs(request);
        }
    }

}