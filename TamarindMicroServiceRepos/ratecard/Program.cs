using System.Text.Json.Serialization;
using TamarindAstra.WebApi.RateCards.Configurations.Dependency;
using TamarindAstra.WebApi.RateCards.Middleware;
using AutoMapper;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument; 

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddServices();

builder.Services.AddAutoMapper(typeof(MonumentRateProfile));
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());


builder.Services.AddControllers()
    .AddJsonOptions(options => options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter()));

// Swagger/OpenAPI configuration
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.TagActionsBy(api => new[] { api.GroupName });
    options.DocInclusionPredicate((docName, description) => true);
});

// CORS configuration
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policyBuilder =>
    {
        policyBuilder.AllowAnyOrigin()
                      .AllowAnyHeader()
                      .AllowAnyMethod();
    });
});

var app = builder.Build();

// Register the middleware for global error handling
app.UseMiddleware<ExceptionMiddleware>();

// Configure the HTTP request pipeline.
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
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "TamarindAstra.WebApi.RateCards v1");
        c.RoutePrefix = string.Empty;
    });
}

// Use CORS policy after defining it
app.UseCors("AllowAll");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();