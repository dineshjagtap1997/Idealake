using BusinessLogic.Interface;
using BusinessLogic.isEncrypted;
using BusinessLogic.Repositories;
using CommonClass.Repositories;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Net.Http.Headers;
using System.Text;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;

using TamarindAstraMasters.Repositories;
using TamarindAstraReports.Interface;


var builder = WebApplication.CreateBuilder(args);

builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())  // This is optional, depending on where the file is
    .AddJsonFile("appsettings.Masters.json", optional: true, reloadOnChange: true);

//var app = builder.Build();
// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddScoped<CommonFunctions>();
builder.Services.AddScoped<RabbitMQService>();
//builder.Services.AddScoped<MongoHelper>();
builder.Services.AddScoped<IAuditLogService, AuditLogs>();
builder.Services.AddScoped<ILevel2Repository, Level2Repository>();
builder.Services.AddScoped<ILevel1Repository, Level1Repository>(); // Added this line
builder.Services.AddScoped<IReport, ReportRepository>(); // Added this line
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<ICommonService, ExportToCSV>();
builder.Services.AddScoped<IUploadDocument, UploadDocumentRepository>();
builder.Services.AddScoped<IImage, UploadImageRepository>();
builder.Services.AddScoped<ICustomerRegistration, CustomerRegistrationRepository>();
builder.Services.AddScoped<IHotelRegistration, HotelRegistrationRepository>();
builder.Services.AddScoped<IVendorRegistration, VendorRegistrationRepository>();
builder.Services.AddScoped<ISearch, SearchRepository>();

// Configure HTTP Client for Zoop API
builder.Services.AddHttpClient("ZoopAPI", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Zoop:BaseUrl"]);
    client.DefaultRequestHeaders.Accept.Add(
        new MediaTypeWithQualityHeaderValue("application/json"));
});

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policyBuilder =>
        policyBuilder.AllowAnyOrigin()
                      .AllowAnyHeader()
                      .AllowAnyMethod());
});



// Configure JWT Authentication
var key = Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]);
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.RequireHttpsMetadata = false;
        options.SaveToken = true;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(key),
            //ValidateIssuer = true,
            ValidateIssuer = false,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            //ValidateAudience = true,
            ValidateAudience = false,
            ValidAudience = builder.Configuration["Jwt:Audience"],
            ValidateLifetime = true
        };
    });
var app = builder.Build();
app.UseStaticFiles();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "TamarindAstraMasters v1");
        c.RoutePrefix = string.Empty;
    });
}
app.UseCors("AllowAll");
app.UseStaticFiles();
app.UseAuthentication(); // Added this line
app.UseAuthorization();
app.MapControllers();
app.Run();

