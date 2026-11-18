using BusinessLogic.Interface;
using BusinessLogic.Repositories;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();

//builder.Services.AddScoped<ILevel2Repository, Level2Repository>();

builder.Services.AddScoped<IAdmin, AdminRepository>();

builder.Services.AddScoped<ICPP, CPPRepository>();

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

// Configure the HTTP request pipeline.

if (app.Environment.IsDevelopment())

{

    app.UseSwagger();

    app.UseSwaggerUI();

}

app.UseCors("AllowAll");
app.UseStaticFiles();
    
//app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
 