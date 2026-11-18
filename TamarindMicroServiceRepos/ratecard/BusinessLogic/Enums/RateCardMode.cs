namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Enums
{
    public enum RateCardModeType
    {
        Contract = 1,
        Adhoc = 2,
        Negotiated = 3,
    }
    public enum CommissionType
    {
        BTC = 1
    }
    public enum PaymentType
    {
        Direct = 1,
        BTC = 2
    }
    public enum RateType
    {
        AdhocRate = 1,
        SpecialRate = 2,
        PLB = 3,
        BAR = 4
    }
    public enum RateSheet
    {
        Inbound = 1,
        Indian = 2
    }
    public enum FITorGITType
    {
        FIT = 1,
        GIT = 2
    }
}
