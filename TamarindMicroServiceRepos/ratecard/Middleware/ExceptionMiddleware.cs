using System.Net;
using System.Text.Json;

namespace TamarindAstra.WebApi.RateCards.Middleware
{
    public class CustomException : Exception
    {
        public CustomException(string message) : base(message) { }
    }
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;

        public ExceptionMiddleware(RequestDelegate next)
        {
            _next = next;
        }
        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context); // Proceed to the next middleware
            }
            catch (Exception ex)
            {
                Common.CommonFunctions.CreateErrorResponse(ex,"500", "An unexpected error occurred");
                await HandleExceptionAsync(context, ex);
            }
        }
        private static Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = exception switch
            {
                CustomException => 422, // Unprocessable Entity
                _ => (int)HttpStatusCode.InternalServerError
            };

            var errorResponse = new
            {
                StatusCode = context.Response.StatusCode,
                Message = exception.Message,
                StackTrace = exception.StackTrace // Optional, remove for production
            };

            var jsonResponse = JsonSerializer.Serialize(errorResponse);
            return context.Response.WriteAsync(jsonResponse);
        }
    }
}
