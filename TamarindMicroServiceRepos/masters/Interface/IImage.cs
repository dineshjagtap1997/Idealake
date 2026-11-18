using CommonClass;

namespace TamarindAstraMasters.Interface
{
    public interface IImage
    {
        Task<ResponseModel> UploadImage(RequestModel request);

    }
}
