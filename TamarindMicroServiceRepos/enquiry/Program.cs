using TamarindAstra.Common;
using TamarindAstraEnquiry.Interface;
using TamarindAstraEnquiry.Repository;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<IEnquiry, Enquiry>();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policyBuilder =>
        policyBuilder.AllowAnyOrigin()
                      .AllowAnyHeader()
                      .AllowAnyMethod());
});
var app = builder.Build();
app.UseStaticFiles();

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
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "TamarindAstraEnquiry v1");
        c.RoutePrefix = string.Empty;
    });
}
app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();

app.Run();

