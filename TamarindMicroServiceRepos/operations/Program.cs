//using CommonClass;
//using Dapper;
//using Microsoft.AspNetCore.Authentication.JwtBearer;
//using Microsoft.IdentityModel.Tokens;
//using System.Net.Http.Headers;
//using System.Text;
//using TamarindAstra.Common;
//using TamarindAstra_Operations.Interface;
//using TamarindAstra_Operations.Model;
//using TamarindAstra_Operations.Repository;

//var builder = WebApplication.CreateBuilder(args);

//// Load configuration from custom appsettings
//builder.Configuration
//    .SetBasePath(Directory.GetCurrentDirectory())
//    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
//    //.AddJsonFile("appsettings.shared.json", optional: true, reloadOnChange: true);

//// Register AutoMapper
//builder.Services.AddAutoMapper(typeof(MonumentRateProfile));
//builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

//// Add Controllers
//builder.Services.AddControllers();

////builder.Services.Configure<SmtpSettings>(builder.Configuration.GetSection("SmtpSettings"));
//builder.Services.Configure<Cryptography>(builder.Configuration.GetSection("Cryptography"));
//// Register Swagger
//builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();

//// Register Services
//builder.Services.AddScoped<CommonFunctions>();
//builder.Services.AddScoped<IQuotation, QuotationRepository>();
//builder.Services.AddScoped<IOperations, OperationsRepository>();
//builder.Services.AddScoped<IBooking, BookingRepository>();
//builder.Services.AddScoped<Ixo, xomodelrepositorycs>();
//builder.Services.AddScoped<IInvoice, InvoiceRepository>();



//// Register Dapper JSON handler
//SqlMapper.AddTypeHandler(new JsonTypeHandler<List<QuotationMasterVersionSequenceDetail>>());

//// Configure CORS
//builder.Services.AddCors(options =>
//{
//    options.AddPolicy("AllowAll", policyBuilder =>
//        policyBuilder.AllowAnyOrigin()
//                     .AllowAnyHeader()
//                     .AllowAnyMethod());
//});


//var app = builder.Build();

//// Use static files
//app.UseStaticFiles();

//// Use Swagger in Development
//if (app.Environment.IsDevelopment())
//{
//    app.UseSwagger();
//    app.UseSwaggerUI();
//}

//// Apply CORS policy
//app.UseCors("AllowAll");

//// Enable authentication and authorization
//app.UseAuthentication();
//app.UseAuthorization();

//// Map controllers
//app.MapControllers();

//// Run the application
//app.Run();


using Dapper;
using TamarindAstra.Common;
using TamarindAstra_Operations.Interface;
using TamarindAstra_Operations.Model;
using TamarindAstra_Operations.Repository;

var builder = WebApplication.CreateBuilder(args);

// Load configuration from custom appsettings - UNCOMMENT THE SHARED FILE
builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .AddJsonFile("appsettings.shared.json", optional: true, reloadOnChange: true); // UNCOMMENTED THIS LINE

// Register AutoMapper
builder.Services.AddAutoMapper(typeof(MonumentRateProfile));
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

// Add Controllers
builder.Services.AddControllers();

//builder.Services.Configure<SmtpSettings>(builder.Configuration.GetSection("SmtpSettings"));
builder.Services.Configure<Cryptography>(builder.Configuration.GetSection("Cryptography"));

// Register Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register Services
builder.Services.AddScoped<CommonFunctions>();
builder.Services.AddScoped<IQuotation, QuotationRepository>();
builder.Services.AddScoped<IOperations, OperationsRepository>();
builder.Services.AddScoped<IBooking, BookingRepository>();
builder.Services.AddScoped<Ixo, xomodelrepositorycs>();
builder.Services.AddScoped<IInvoice, InvoiceRepository>();
builder.Services.AddScoped<XoPdfGenerate>();

// Register Dapper JSON handler
SqlMapper.AddTypeHandler(new JsonTypeHandler<List<QuotationMasterVersionSequenceDetail>>());

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policyBuilder =>
        policyBuilder.AllowAnyOrigin()
                     .AllowAnyHeader()
                     .AllowAnyMethod());
});

var app = builder.Build();

// Use static files
app.UseStaticFiles();

// Use Swagger in Development
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Apply CORS policy
app.UseCors("AllowAll");

// Enable authentication and authorization
app.UseAuthentication();
app.UseAuthorization();

// Map controllers
app.MapControllers();

// Run the application
app.Run();
