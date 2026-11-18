using BusinessLogic.Repositories;
using CommonClass;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TamarindAstra.Common;
using TamarindAstraLoginDashboardReport.Interface;
using TamarindAstraLoginDashboardReport.Repository;

var builder = WebApplication.CreateBuilder(args);

// Register SmtpSettings configuration
builder.Services.Configure<SmtpSettings>(builder.Configuration.GetSection("SmtpSettings"));



// Add services to the container
builder.Services.AddControllers();

// Add authentication FIRST
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
        };
    });

// Then add authorization
builder.Services.AddAuthorization();

// Add session
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30); // Set session timeout
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// Add IHttpContextAccessor
builder.Services.AddHttpContextAccessor();

// Register other services
builder.Services.AddScoped<CommonFunctions>();
builder.Services.AddScoped<ILogin, LoginRepository>();
builder.Services.AddScoped<IAuth, AuthService>();
builder.Services.AddScoped<IEmailService, EmailService>();
builder.Services.AddScoped<IDashboard, DashboardRepository>();

// Enable Swagger for API documentation
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add distributed memory cache for session management
builder.Services.AddDistributedMemoryCache();
// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policyBuilder =>
        policyBuilder.AllowAnyOrigin()
                      .AllowAnyHeader()
                      .AllowAnyMethod());
});

var app = builder.Build();

// Middleware order is critical
app.UseHttpsRedirection();
app.UseCors("AllowAll");

app.UseAuthentication(); // Ensure authentication comes before authorization
app.UseAuthorization();
app.UseSession();

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
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "TamarindAstraLoginDashboardReport");
        c.RoutePrefix = string.Empty;
    });
}
// Map controllers
app.MapControllers();
app.Run();