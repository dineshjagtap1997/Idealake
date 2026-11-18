using BusinessLogic.isEncrypted;
using TamarindAstraReports.Interface;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Add CORS services with "AllowAll" policy
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policyBuilder =>
    {
        policyBuilder.AllowAnyOrigin()  // Allow all origins (can be restricted to specific origins).
                      .AllowAnyHeader()  // Allow any headers.
                      .AllowAnyMethod(); // Allow any HTTP method (GET, POST, etc.).
    });
});
builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())  // This is optional, depending on where the file is
    .AddJsonFile("appsettings.Reports.json", optional: true, reloadOnChange: true);
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<IReport, ReportRepository>();

var app = builder.Build();

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
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "TamarindAstraReports v1");
        c.RoutePrefix = string.Empty;
    });
}
// Apply CORS policy globally using "AllowAll" policy
app.UseCors("AllowAll");

//app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();