using AutoMapper;
using CommonClass;
using iText.Kernel.Utils;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.draw;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;
using NLog;
using System.Data;
using System.Text.RegularExpressions;
using TamarindAstra.Common;
using TamarindAstra_Operations.Interface;
using TamarindAstra_Operations.Model;
using Document = iTextSharp.text.Document;
using PdfDocument = iText.Kernel.Pdf.PdfDocument;

namespace TamarindAstra_Operations.Repository
{
    public class InvoiceRepository : IInvoice
    {

        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger();
        private readonly string isEncrypted;
        private readonly string _connectionString;
        private readonly IMapper _mapper;
        private readonly IWebHostEnvironment _hostingEnvironment;

        public InvoiceRepository(IConfiguration config, IOptions<Cryptography> options, IOptions<SmtpSettings> smtpSettings, IWebHostEnvironment hostingEnvironment)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
            _hostingEnvironment = hostingEnvironment;
            //_connectionString = _config.GetConnectionString("DefaultConnection");
        }

        public async Task<ResponseModel> FetchInvoice(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("FetchInvoice method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @BookingID = req.BookingID
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_FetchInvoiceDataByQuotationID]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }




        public async Task<ResponseModel> ServiceTaxByInvoice(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<OtherServiceTax>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @AgentID = req.AgentID,
                        @CompanyID = req.CompanyID,
                        @DATE = req.DATE,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<OtherServiceTax>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "Usp_ServiceTaxByInvoice", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        public async Task<ResponseModel> FetchInvoice_PrimaryInfo(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("FetchInvoice_PrimaryInfo method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_FetchInvoicePrimaryInfoByInvocieID]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> FetchInvoice_fromBookingScreenInfo(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("FetchInvoice_fromBookingScreenInfo method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_FetchInvoicePrimaryFromBookingByBookingID]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> FetchInvoiceDetails(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("FetchInvoice_PrimaryInfo method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @ID = req.ID,
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_FetchInvoiceDetailsByInvocieID]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }




        public async Task<ResponseModel> FetchInvoiceTaxCalculation(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("FetchInvoice_PrimaryInfo method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @AgentID = req.AgentID,
                        @CompanyID = req.CompanyID,
                        @TaxID = req.Tax_ID,
                        @TCSTaxID = req.TCSTaxID,
                        @TotalAmount = req.TotalAmount,
                        @ServiceTaxableAmount = req.ServiceTaxableAmount,
                        @InvoiceTaxType = req.InvoiceTaxType
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[USP_GetInvoiceDetailsTaxCalculation]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        public async Task<ResponseModel> FetchAddendumDetails(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("FetchAddendumDetails method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @InvoiceID = req.InvoiceID
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_FetchAddendumDetailsByInvocieID]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> InsertUpdate_Invoice_PrimaryInfo(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Insert_Invoice_PrimaryInfo method called");


                var parameters = new
                {

                    @Action = req.Action,
                    @ID = req.ID,
                    @InvoiceID = req.InvoiceID,
                    @TypeOfDoc = req.TypeofDoc,
                    @Invoice_Date = req.Invoice_Date,
                    @PlaceOfSupplierId = req.PlaceOfSupplierId,
                    @Tax_ID = req.Tax_ID,
                    @GuestName = req.GuestName,
                    @AgentID = req.AgentID,
                    @Curr_ID = req.Curr_ID,
                    @AgentBookerName = req.AgentBookerName,
                    @AgentRefPO = req.AgentRefPO,
                    @InvoiceType = req.InvoiceType,
                    @FileCode = req.FileCode,
                    @BookingID = req.BookingID,
                    @QuotationID = req.QuotationID,
                    @CompanyID = req.CompanyID,
                    @YearCode = req.YearCode,
                    @CreatedBy = req.CreatedBy,
                    @isTDSDeduction = req.isTDSDeduction,
                    @TANNumber = req.TANNumber,
                    @PanNumber = req.PanNumber,
                    @TAXNumber = req.TAXNumber,

                };

                var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_InsertUpdateInvoice_PrimaryInfo]", parameters);


            }

            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " Insert_Booking_PrimaryInfo Failed");
            }
        }

        public async Task<ResponseModel> InsertUpdateInvoiceDetails(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceDetails>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("InsertUpdateInvoiceDetails method called");


                var parameters = new
                {
                    @Action = req.Action,
                    @ID = req.ID,
                    @InvoiceID = req.InvoiceID,
                    @Invoice_Desc = req.Invoice_Desc,
                    @SACID = req.SACID,
                    @Tax_ID = req.Tax_ID,
                    @TCS_ID = req.TCSRateID,
                    @TotalBasicAmount = req.TotalBasicAmount,
                    @Taxable_Amount = req.TaxableAmount,
                    @TotalTax_Amount = req.TaxAmount,
                    @TotalInvoiceAmt = req.TotalInvoiceAmount,
                    @TCSAmount = req.TCSAmount,
                    @YearCode = req.YearCode,
                    @CGST = req.CGST,
                    @SGST = req.SGST,
                    @UTGST = req.UTGST,
                    @IGST = req.IGST,
                    @Invoice_Desc_ID = req.Invoice_Desc_ID,
                    @AddendumTotalAmount = req.AddendumTotalAmount,
                    @TaxableAmountDetail = req.TaxableAmountDetail,
                    @TotalAmount = req.TotalAmount,
                    @TaxAmount = req.TaxAmount,
                    @BasicAmount = req.BasicAmount,
                    @CreatedBy = req.CreatedBy,
                };


                var data = new CommonClass.ResponseViewModel<InvoiceDetails>();
                return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_InsertUpdateInvoiceDetails]", parameters);


            }

            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " InsertUpdateInvoiceDetails Failed");
            }
        }

        public async Task<ResponseModel> AddAgentRefrenceNumber(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("AddAgentRefrenceNumber method called");


                var parameters = new
                {

                    @Action = req.Action,
                    @ID = req.ID,
                    @AgentRefPO = req.AgentRefPO,
                    @isVoid = req.isVoid

                };

                var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_InsertUpdateAgentRefNumberandVoid]", parameters);


            }

            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " Insert_Booking_PrimaryInfo Failed");
            }
        }

        public async Task<ResponseModel> InvInsertUpdateAddendumwithDetails(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Addendum>(request.RequestText);
                logger.Debug("InsertUpdateAddendumWithDetails method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @AddendumJSON = req.AddendumJSON
                    };

                    var data = new CommonClass.ResponseViewModel<Addendum>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_InsertUpdateAddendumWithDetails]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        public async Task<ResponseModel> InvInsertUpdateAddendum(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Addendum>(request.RequestText);
                logger.Debug("InvInsertUpdateAddendum method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        Action = req.Action,
                        ID = req.ID,
                        InvoiceID = req.InvoiceID,
                        Description = req.Description,
                        Amount = req.Amount,
                        CreatedBy = req.CreatedBy,
                        YearCode = req.YearCode
                    };

                    var data = new CommonClass.ResponseViewModel<Addendum>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_InsertUpdateAddendum]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        public async Task<ResponseModel> GetInvoiceDetailsBTCCommisionTaxCalculation(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("GetInvoiceDetailsBTCCommisionTaxCalculation method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @AgentID = req.AgentID,
                        @CompanyID = req.CompanyID,
                        @TaxID = req.Tax_ID,
                        @TotalAmount = req.TotalAmount,
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[USP_GetInvoiceDetailsBTCCommisionTaxCalculation]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        public async Task<ResponseModel> ConvertPerfomaToInvoice(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("ConvertPerfomaToInvoice method called");


                var parameters = new
                {
                    @Action = req.Action,
                    @ID = req.ID,
                    @InvoiceID = req.InvoiceID,
                    @YearCode = req.YearCode,
                };


                var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_ConvertPerfomaToInvoice]", parameters);


            }

            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " ConvertPerfomaToInvoice Failed");
            }
        }

        public async Task<ResponseModel> InsertbtccommissionInvoice(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("InsertbtccommissionInvoice method called");


                var parameters = new
                {
                    @Action = req.Action,
                    @XOID = req.XOID,
                    @YearCode = req.YearCode,
                    @BookingID = req.BookingID,
                    @GroupKey = req.GroupKey,
                    @CreatedBy = req.CreatedBy,
                };



                var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[USP_InsertBTCCommisionInvoice]", parameters);
            }

            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " ConvertPerfomaToInvoice Failed");
            }
        }

        public async Task<ResponseModel> FetchInvoiceDetailsforEdit(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceMaster>(request.RequestText);
                logger.Debug("FetchInvoiceDetailsforEdit method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @InvoiceID = req.InvoiceID
                    };

                    var data = new CommonClass.ResponseViewModel<InvoiceMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Invoice].[usp_FetchEditInvoiceDetailsByInvocieID]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        //public async Task<ResponseModel> PrintInvoiceAddendum(RequestModel request)
        //{
        //    try
        //    {
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<TaxInvoiceRequest>(request.RequestText);

        //        if (req == null || req.Invoices == null || !req.Invoices.Any())
        //            return CommonFunctions.BlankResponse("201", "Invalid request");

        //        if (req.Type == 1)
        //        {
        //            using (var stream = new MemoryStream())
        //            {
        //                Document document = new Document(PageSize.A4, 36, 36, 36, 36);
        //                PdfWriter.GetInstance(document, stream);
        //                document.Open();

        //                // Process each invoice
        //                foreach (var invoice in req.Invoices)
        //                {
        //                    var combinedDataSet = await GetTaxInvoiceData(new
        //                    {
        //                        InvoiceID = invoice.InvoiceID,
        //                        QuotationID = invoice.QuotationID,
        //                        Action = req.Action
        //                    }, "[Invoice].[USP_GetInvoiceReportNewHorizontalOne]");

        //                    if (combinedDataSet.Tables.Count == 0 || combinedDataSet.Tables[0].Rows.Count == 0)
        //                        continue;

        //                    GenerateSingleInvoice(document, combinedDataSet);

        //                    // Add page break between invoices except for the last one
        //                    if (invoice != req.Invoices.Last())
        //                    {
        //                        document.NewPage();
        //                    }
        //                }

        //                document.Close();
        //                return CommonFunctions.ProcessFileResult(new CommonClass.FileResponseViewModel<FileResponseModel>(), stream.ToArray());
        //            }
        //        }
        //        return CommonFunctions.BlankResponse("400", "Invalid PDF generation option");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Failed to generate invoice PDF");
        //    }
        //}

        //private void GenerateSingleInvoice(Document document, DataSet ds)
        //{
        //    // Font setup
        //    BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
        //    Font normalFont = new Font(bf, 10, Font.NORMAL);
        //    Font boldFont = new Font(bf, 10, Font.BOLD);
        //    Font headerFont = new Font(bf, 16, Font.BOLD);
        //    Font smallFont = new Font(bf, 8, Font.NORMAL);

        //    DataRow invoiceData = ds.Tables[0].Rows[0];

        //    // Add logo
        //    AddCompanyLogo(document);

        //    // === 1. COMPANY HEADER ===
        //    Paragraph companyHeader = new Paragraph("TAMARIND GLOBAL SERVICES PRIVATE LIMITED", headerFont);
        //    companyHeader.Alignment = Element.ALIGN_LEFT;
        //    companyHeader.SpacingAfter = 5f;
        //    document.Add(companyHeader);

        //    // Company address
        //    Paragraph address = new Paragraph("6th Floor, 601. AJ House, Macd Maroshi Road, Andheri (E), Mumbai – 400059", normalFont);
        //    address.Alignment = Element.ALIGN_LEFT;
        //    address.SpacingAfter = 10f;
        //    document.Add(address);

        //    // Horizontal line
        //    document.Add(new Chunk(new iTextSharp.text.pdf.draw.LineSeparator(0.5f, 100f, BaseColor.BLACK, Element.ALIGN_LEFT, -1)));
        //    document.Add(Chunk.NEWLINE);

        //    // === 2. COMPANY DETAILS ===
        //    PdfPTable detailsTable = new PdfPTable(2);
        //    detailsTable.WidthPercentage = 100;
        //    detailsTable.SetWidths(new float[] { 15, 85 });
        //    detailsTable.HorizontalAlignment = Element.ALIGN_LEFT;

        //    AddLeftAlignedDetailRow(detailsTable, "State :", "27-Maharashtra", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "PAN :", "AACCT4874D", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "GSTIN :", "27AACCT4874D1Z8", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "CIN :", "U63040MH2009PTC16M45", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "MSMEReg :", "UDYAM-MH-19-0152586", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "LUTNo :", "", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "ACKNo :", "", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "IRN :", "", boldFont, normalFont);
        //    AddLeftAlignedDetailRow(detailsTable, "ACKDate :", "", boldFont, normalFont);

        //    document.Add(detailsTable);
        //    document.Add(new Chunk(new iTextSharp.text.pdf.draw.LineSeparator(0.5f, 100f, BaseColor.BLACK, Element.ALIGN_LEFT, -1)));
        //    document.Add(Chunk.NEWLINE);

        //    // === 3. TAX INVOICE HEADER ===
        //    Paragraph invoiceHeader = new Paragraph("Tax Invoice", new Font(bf, 14, Font.BOLD));
        //    invoiceHeader.Alignment = Element.ALIGN_CENTER;
        //    invoiceHeader.SpacingAfter = 10f;
        //    document.Add(invoiceHeader);

        //    // === 4. INVOICE DETAILS ===
        //    PdfPTable invoiceDetailsTable = new PdfPTable(2);
        //    invoiceDetailsTable.WidthPercentage = 100;
        //    invoiceDetailsTable.SetWidths(new float[] { 30, 70 });
        //    invoiceDetailsTable.HorizontalAlignment = Element.ALIGN_LEFT;

        //    // Get values from DataRow
        //    string invoiceDate = "";//Convert.ToDateTime(invoiceData["Invoice_Date"]).ToString("dd MMM yyyy");
        //    string invoiceNo = "";//invoiceData["Invoice_No"].ToString();
        //    string fileNo = "";// invoiceData["File_No"].ToString();
        //    string commercialId = "";// invoiceData["Commercial_ID"].ToString();
        //    string placeOfSupply = "";// invoiceData["PlaceOfSupply"].ToString();
        //    string currency = "";// invoiceData["Curr_Name"].ToString();

        //    AddLeftAlignedDetailRow(invoiceDetailsTable, "Date", invoiceDate, boldFont, normalFont);
        //    AddLeftAlignedDetailRow(invoiceDetailsTable, "Invoice No.", invoiceNo, boldFont, normalFont);
        //    AddLeftAlignedDetailRow(invoiceDetailsTable, "File No", fileNo, boldFont, normalFont);
        //    AddLeftAlignedDetailRow(invoiceDetailsTable, "Commercial ID Ref", commercialId, boldFont, normalFont);
        //    AddLeftAlignedDetailRow(invoiceDetailsTable, "Place of Supply", placeOfSupply, boldFont, normalFont);
        //    AddLeftAlignedDetailRow(invoiceDetailsTable, "Currency", currency, boldFont, normalFont);

        //    document.Add(invoiceDetailsTable);
        //    document.Add(Chunk.NEWLINE);

        //    // === 5. CLIENT ADDRESS ===
        //    Paragraph clientHeader = new Paragraph("I World Travel Services, Mumbai, parel", boldFont);
        //    clientHeader.Alignment = Element.ALIGN_LEFT;
        //    document.Add(clientHeader);

        //    Paragraph clientAddress = new Paragraph("Shop No 3, Gods Gift CHS, Kondivita Road, MIDC,", normalFont);
        //    clientAddress.Alignment = Element.ALIGN_LEFT;
        //    document.Add(clientAddress);

        //    Paragraph clientAddress2 = new Paragraph("Andheri East, Mumbai - 400093.", normalFont);
        //    clientAddress2.Alignment = Element.ALIGN_LEFT;
        //    document.Add(clientAddress2);
        //    document.Add(Chunk.NEWLINE);

        //    // === 6. CLIENT DETAILS ===
        //    PdfPTable clientTable = new PdfPTable(4);
        //    clientTable.WidthPercentage = 100;
        //    clientTable.SetWidths(new float[] { 15, 25, 10, 50 });
        //    clientTable.HorizontalAlignment = Element.ALIGN_LEFT;

        //    AddLeftAlignedDetailRow(clientTable, "StateCode :", "27-Maharashtra", boldFont, normalFont);
        //    clientTable.AddCell(new PdfPCell(new Phrase("")));
        //    clientTable.AddCell(new PdfPCell(new Phrase("")));
        //    clientTable.AddCell(new PdfPCell(new Phrase("Client : INVOICE DATE CHECK", normalFont)));

        //    AddLeftAlignedDetailRow(clientTable, "GSTIN :", "", boldFont, normalFont);
        //    clientTable.AddCell(new PdfPCell(new Phrase("")));
        //    clientTable.AddCell(new PdfPCell(new Phrase("")));
        //    clientTable.AddCell(new PdfPCell(new Phrase("")));

        //    document.Add(clientTable);
        //    document.Add(Chunk.NEWLINE);

        //    // === 7. INVOICE ITEMS TABLE ===
        //    PdfPTable invoiceTable = new PdfPTable(8);
        //    invoiceTable.WidthPercentage = 100;
        //    invoiceTable.SetWidths(new float[] { 25, 10, 8, 12, 12, 12, 8, 13 });

        //    // Headers
        //    AddLeftAlignedTableHeader(invoiceTable, "Booked By", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "TEST", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "Your Ref :", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "", boldFont);

        //    AddLeftAlignedTableHeader(invoiceTable, "Description", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "HSN/SAC", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "Tax %", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "Basic Amt", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "Taxable Amt", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "Tax Amount", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "TCS", boldFont);
        //    AddLeftAlignedTableHeader(invoiceTable, "Amount", boldFont);

        //    // Data row
        //    string description = invoiceData["Invoice_Desc"].ToString();
        //    string sacCode = invoiceData["SAC"].ToString();
        //    string taxPercent = invoiceData["Tax_Per"].ToString();
        //    string basicAmount = Convert.ToDecimal(invoiceData["TotalBasicAmount"]).ToString("N2");
        //    string taxableAmount = Convert.ToDecimal(invoiceData["TotalTaxable_Amount"]).ToString("N2");
        //    string taxAmount = Convert.ToDecimal(invoiceData["Tax_Amount"]).ToString("N2");
        //    string tcsAmount = invoiceData["TCSAmount"] != DBNull.Value ? Convert.ToDecimal(invoiceData["TCSAmount"]).ToString("N2") : "";
        //    string totalAmount = Convert.ToDecimal(invoiceData["SUM_Taxable_Amount"]).ToString("N2");

        //    AddLeftAlignedTableRow(invoiceTable, description, normalFont);
        //    AddLeftAlignedTableRow(invoiceTable, sacCode, normalFont);
        //    AddLeftAlignedTableRow(invoiceTable, taxPercent, normalFont);
        //    AddLeftAlignedTableRow(invoiceTable, basicAmount, normalFont);
        //    AddLeftAlignedTableRow(invoiceTable, taxableAmount, normalFont);
        //    AddLeftAlignedTableRow(invoiceTable, taxAmount, normalFont);
        //    AddLeftAlignedTableRow(invoiceTable, tcsAmount, normalFont);
        //    AddLeftAlignedTableRow(invoiceTable, totalAmount, normalFont);

        //    // Total row
        //    AddLeftAlignedTableRow(invoiceTable, "Total :", boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, "NTR", boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, NumberToWords(Convert.ToInt32(Math.Round(Convert.ToDecimal(totalAmount)))), boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, "", boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, "", boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, taxableAmount, boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, taxAmount, boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, "", boldFont);
        //    AddLeftAlignedTableRow(invoiceTable, totalAmount, boldFont);

        //    document.Add(invoiceTable);
        //    document.Add(Chunk.NEWLINE);

        //    // === 8. TAX BREAKDOWN ===
        //    PdfPTable taxTable = new PdfPTable(4);
        //    taxTable.WidthPercentage = 40;
        //    taxTable.HorizontalAlignment = Element.ALIGN_RIGHT;

        //    AddCenteredTableHeader(taxTable, "IGST", boldFont);
        //    AddCenteredTableHeader(taxTable, "CGST", boldFont);
        //    AddCenteredTableHeader(taxTable, "SGST", boldFont);
        //    AddCenteredTableHeader(taxTable, "UTGST", boldFont);

        //    decimal totalTax = Convert.ToDecimal(taxAmount);
        //    decimal cgst = totalTax / 2;
        //    decimal sgst = totalTax / 2;

        //    AddCenteredTableRow(taxTable, "0.00", normalFont);
        //    AddCenteredTableRow(taxTable, cgst.ToString("N2"), normalFont);
        //    AddCenteredTableRow(taxTable, sgst.ToString("N2"), normalFont);
        //    AddCenteredTableRow(taxTable, "0.00", normalFont);

        //    document.Add(taxTable);
        //    document.Add(Chunk.NEWLINE);

        //    // === 9. BANK DETAILS ===
        //    Paragraph bankHeader = new Paragraph("Account Name:", boldFont);
        //    bankHeader.Alignment = Element.ALIGN_LEFT;
        //    document.Add(bankHeader);

        //    Paragraph bankName = new Paragraph("TAMARIND GLOBAL SERVICES PVT LTD", normalFont);
        //    bankName.Alignment = Element.ALIGN_LEFT;
        //    document.Add(bankName);

        //    Paragraph accountNo = new Paragraph("Account No: 003805004063", normalFont);
        //    accountNo.Alignment = Element.ALIGN_LEFT;
        //    document.Add(accountNo);
        //    document.Add(Chunk.NEWLINE);

        //    Paragraph ifscCode = new Paragraph("IFSC Code : ICIC0000038 | SWIFT Code : ICICINBECTS", normalFont);
        //    ifscCode.Alignment = Element.ALIGN_LEFT;
        //    document.Add(ifscCode);

        //    Paragraph bankInfo = new Paragraph("Bank Name: ICICI Bank Ltd. | Bank Address : Pkt No.206-221, Krystal Bldg, Waterfield Road, Bandra(West), Mumbai 400050.", normalFont);
        //    bankInfo.Alignment = Element.ALIGN_LEFT;
        //    document.Add(bankInfo);
        //    document.Add(Chunk.NEWLINE);

        //    // === 10. NOTES ===
        //    Paragraph notesHeader = new Paragraph("Notes :", boldFont);
        //    notesHeader.Alignment = Element.ALIGN_LEFT;
        //    document.Add(notesHeader);

        //    List list = new List(List.UNORDERED);
        //    list.IndentationLeft = 20f;
        //    list.Add(new ListItem("Please share a copy of the remittance advice at receivables@tamarindiglobal.com while remitting payment to our account.", normalFont));
        //    list.Add(new ListItem("TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)", normalFont));
        //    document.Add(list);
        //    document.Add(Chunk.NEWLINE);

        //    // === 11. FOOTER ===
        //    Paragraph footer = new Paragraph("For TAMARIND GLOBAL SERVICES PRIVATE LIMITED", normalFont);
        //    footer.Alignment = Element.ALIGN_RIGHT;
        //    document.Add(footer);
        //    document.Add(Chunk.NEWLINE);

        //    Paragraph signatory = new Paragraph("Chiri DiSouza", normalFont);
        //    signatory.Alignment = Element.ALIGN_RIGHT;
        //    document.Add(signatory);
        //    document.Add(Chunk.NEWLINE);

        //    // === 12. DISCLAIMER ===
        //    Paragraph disclaimer = new Paragraph("Tax Payable under RCIM : No | Original for Receivers | Disputes subject to Mumbai Jurisdiction only | This is a computer generated document and does not require Signature", smallFont);
        //    disclaimer.Alignment = Element.ALIGN_CENTER;
        //    document.Add(disclaimer);

        //    Paragraph officeAddress = new Paragraph("Corporate Office : 6th Floor, 601. AJ House, Macd Maroshi Road, Andheri (E), Mumbai – 400059", smallFont);
        //    officeAddress.Alignment = Element.ALIGN_CENTER;
        //    document.Add(officeAddress);
        //}

        private async Task<DataSet> GetTaxInvoiceData(object parameters, string storedProcedure)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(SharedConfiguration.GetConnectionString()))
            {
                await conn.OpenAsync();
                using (SqlCommand cmd = new SqlCommand(storedProcedure, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    var props = parameters.GetType().GetProperties();
                    foreach (var prop in props)
                    {
                        cmd.Parameters.AddWithValue($"@{prop.Name}", prop.GetValue(parameters));
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        private void AddCompanyLogo(Document document)
        {
            string logoFileName = "Tamarind Tours Logo Small.jpg";
            string logoPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Images", logoFileName);

            if (File.Exists(logoPath))
            {
                try
                {
                    Image logo = Image.GetInstance(logoPath);
                    logo.ScaleToFit(150f, 60f);
                    logo.Alignment = Element.ALIGN_RIGHT;
                    document.Add(logo);
                    document.Add(new Paragraph("\n"));
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Logo load error: " + ex.Message);
                }
            }
            else
            {
                Console.WriteLine("Logo not found at path: " + logoPath);
            }
        }
        private void AddCompanyLogoForAddendum(Document document)
        {
            string logoFileName = "Tamarind Tours Logo Small.jpg";
            string logoPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Images", logoFileName);

            if (File.Exists(logoPath))
            {
                try
                {
                    Image logo = Image.GetInstance(logoPath);
                    logo.ScaleToFit(150f, 60f);
                    logo.Alignment = Element.ALIGN_CENTER;
                    document.Add(logo);
                    document.Add(new Paragraph("\n"));
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Logo load error: " + ex.Message);
                }
            }
            else
            {
                Console.WriteLine("Logo not found at path: " + logoPath);
            }
        }

        //private string NumberToWords(int number)
        //{
        //    if (number == 0)
        //        return "Zero Only";

        //    if (number < 0)
        //        return "Minus " + NumberToWords(Math.Abs(number));

        //    string words = "";

        //    if ((number / 10000000) > 0)
        //    {
        //        words += NumberToWords(number / 10000000) + " Crore ";
        //        number %= 10000000;
        //    }

        //    if ((number / 100000) > 0)
        //    {
        //        words += NumberToWords(number / 100000) + " Lakh ";
        //        number %= 100000;
        //    }

        //    if ((number / 1000) > 0)
        //    {
        //        words += NumberToWords(number / 1000) + " Thousand ";
        //        number %= 1000;
        //    }

        //    if ((number / 100) > 0)
        //    {
        //        words += NumberToWords(number / 100) + " Hundred ";
        //        number %= 100;
        //    }

        //    if (number > 0)
        //    {
        //        if (words != "")
        //            words += "and ";

        //        var unitsMap = new[]
        //        {
        //        "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
        //        "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
        //        "Eighteen", "Nineteen"
        //    };
        //        var tensMap = new[]
        //        {
        //        "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy",
        //        "Eighty", "Ninety"
        //    };

        //        if (number < 20)
        //            words += unitsMap[number];
        //        else
        //        {
        //            words += tensMap[number / 10];
        //            if ((number % 10) > 0)
        //                words += "-" + unitsMap[number % 10];
        //        }
        //    }

        //    return words + " Only";
        //}

        // Helper methods for table creation
        //private void AddLeftAlignedDetailRow(PdfPTable table, string label, string value, Font labelFont, Font valueFont)
        //{
        //    PdfPCell labelCell = new PdfPCell(new Phrase(label, labelFont));
        //    labelCell.Border = PdfPCell.NO_BORDER;
        //    labelCell.HorizontalAlignment = Element.ALIGN_LEFT;
        //    table.AddCell(labelCell);

        //    PdfPCell valueCell = new PdfPCell(new Phrase(value, valueFont));
        //    valueCell.Border = PdfPCell.NO_BORDER;
        //    valueCell.HorizontalAlignment = Element.ALIGN_LEFT;
        //    table.AddCell(valueCell);
        //}

        //private void AddLeftAlignedTableHeader(PdfPTable table, string text, Font font)
        //{
        //    PdfPCell cell = new PdfPCell(new Phrase(text, font));
        //    cell.HorizontalAlignment = Element.ALIGN_LEFT;
        //    cell.BackgroundColor = new BaseColor(240, 240, 240);
        //    table.AddCell(cell);
        //}

        //private void AddLeftAlignedTableRow(PdfPTable table, string text, Font font)
        //{
        //    PdfPCell cell = new PdfPCell(new Phrase(text, font));
        //    cell.HorizontalAlignment = Element.ALIGN_LEFT;
        //    cell.BorderWidth = 0.5f;
        //    table.AddCell(cell);
        //}

        //private void AddCenteredTableHeader(PdfPTable table, string text, Font font)
        //{
        //    PdfPCell cell = new PdfPCell(new Phrase(text, font));
        //    cell.HorizontalAlignment = Element.ALIGN_CENTER;
        //    cell.BackgroundColor = new BaseColor(240, 240, 240);
        //    table.AddCell(cell);
        //}

        //private void AddCenteredTableRow(PdfPTable table, string text, Font font)
        //{
        //    PdfPCell cell = new PdfPCell(new Phrase(text, font));
        //    cell.HorizontalAlignment = Element.ALIGN_CENTER;
        //    table.AddCell(cell);
        //}


        public async Task<ResponseModel> PrintInvoiceAddendum(RequestModel request)
        {
            try
            {
                List<byte[]> pdfList = new List<byte[]>();
                var req = CommonFunctions.DecryptAndDeserializeRequest<TaxInvoiceRequest>(request.RequestText);

                if (req == null || req.Invoices == null || !req.Invoices.Any())
                    return CommonFunctions.BlankResponse("201", "Invalid request");

                if (req.Type == 1)
                {
                    foreach (var invoice in req.Invoices)
                    {
                        var combinedDataSet = await GetTaxInvoiceData(new
                        {
                            InvoiceID = invoice.InvoiceID,
                            BookingID = invoice.BookingID,
                            Action = req.Action
                        }, "[Invoice].[USP_GetInvoiceReportNewHorizontalOne]");

                        if (combinedDataSet.Tables.Count == 0 || combinedDataSet.Tables[0].Rows.Count == 0)
                            continue;

                        var generatePdf = GeneratePrintWithTaxUIForDoc(combinedDataSet);
                        byte[] pdfByte = File.ReadAllBytes(generatePdf);

                        pdfList.Add(pdfByte);
                    }

                    if (pdfList.Count == 0)
                        return CommonFunctions.BlankResponse("201", "No invoice data found.");

                    // Merge all PDFs into a single PDF in memory
                    byte[] mergedPdf = MergePdfFiles(pdfList);

                    return CommonFunctions.ProcessFileResult(new CommonClass.FileResponseViewModel<FileResponseModel>(), mergedPdf);
                }
                else if (req.Type == 2)
                {
                    foreach (var invoice in req.Invoices)
                    {
                        var combinedDataSet = await GetTaxInvoiceData(new
                        {
                            InvoiceID = invoice.InvoiceID,
                            BookingID = invoice.BookingID,
                            Action = req.Action
                        }, "[Invoice].[USP_GetInvoiceReportNewHorizontalOne]");

                        if (combinedDataSet.Tables.Count == 0 || combinedDataSet.Tables[0].Rows.Count == 0)
                            continue;

                        var generatePdf = GeneratePrintWithoutTaxUIForDoc(combinedDataSet);
                        byte[] pdfByte = File.ReadAllBytes(generatePdf);

                        pdfList.Add(pdfByte);
                    }

                    if (pdfList.Count == 0)
                        return CommonFunctions.BlankResponse("201", "No invoice data found.");

                    // Merge all PDFs into a single PDF in memory
                    byte[] mergedPdf = MergePdfFiles(pdfList);

                    return CommonFunctions.ProcessFileResult(new CommonClass.FileResponseViewModel<FileResponseModel>(), mergedPdf);
                }
                else if (req.Type == 3)
                {
                    foreach (var invoice in req.Invoices)
                    {
                        var combinedDataSetTI = await GetTaxInvoiceData(new
                        {
                            InvoiceID = invoice.InvoiceID,
                            BookingID = invoice.BookingID,
                            Action = req.Action
                        }, "[Invoice].[USP_GetInvoiceReportNewHorizontalOne]");
                        var combinedDataSet = await GetTaxInvoiceData(new
                        {
                            InvoiceID = invoice.InvoiceID,
                            BookingID = invoice.BookingID
                        }, "[Invoice].[USP_GetAddendumReportPrint]");

                        if (combinedDataSet.Tables.Count == 0 || combinedDataSet.Tables[0].Rows.Count == 0)
                            continue;

                        var generatePdf = GeneratePrintWithoutTaxUIANDAddendum(combinedDataSet, combinedDataSetTI);
                        byte[] pdfByte = File.ReadAllBytes(generatePdf);

                        pdfList.Add(pdfByte);
                    }

                    if (pdfList.Count == 0)
                        return CommonFunctions.BlankResponse("201", "No invoice data found.");

                    // Merge all PDFs into a single PDF in memory
                    byte[] mergedPdf = MergePdfFiles(pdfList);

                    return CommonFunctions.ProcessFileResult(new CommonClass.FileResponseViewModel<FileResponseModel>(), mergedPdf);

                }
                else if (req.Type == 4)
                {
                    foreach (var invoice in req.Invoices)
                    {
                        var combinedDataSetTI = await GetTaxInvoiceData(new
                        {
                            InvoiceID = invoice.InvoiceID,
                            BookingID = invoice.BookingID,
                            Action = req.Action
                        }, "[Invoice].[USP_GetInvoiceReportNewHorizontalOne]");

                        var combinedDataSet = await GetTaxInvoiceData(new
                        {
                            InvoiceID = invoice.InvoiceID,
                            BookingID = invoice.BookingID
                        }, "[Invoice].[USP_GetAddendumReportPrint]");

                        if (combinedDataSet.Tables.Count == 0 || combinedDataSet.Tables[0].Rows.Count == 0)
                            continue;

                        var generatePdf = GeneratePrintWithTaxUIANDAddendum(combinedDataSet, combinedDataSetTI);
                        byte[] pdfByte = File.ReadAllBytes(generatePdf);

                        pdfList.Add(pdfByte);
                    }

                    if (pdfList.Count == 0)
                        return CommonFunctions.BlankResponse("201", "No invoice data found.");

                    // Merge all PDFs into a single PDF in memory
                    byte[] mergedPdf = MergePdfFiles(pdfList);

                    return CommonFunctions.ProcessFileResult(new CommonClass.FileResponseViewModel<FileResponseModel>(), mergedPdf);

                }
                return CommonFunctions.BlankResponse("400", "Invalid PDF generation option");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Failed to generate invoice PDF");
            }
        }
        public static byte[] MergePdfFiles(List<byte[]> pdfFiles)
        {
            using (var ms = new MemoryStream())
            {
                PdfDocument pdf = new PdfDocument(new iText.Kernel.Pdf.PdfWriter(ms));
                PdfMerger merger = new PdfMerger(pdf);

                foreach (var pdfBytes in pdfFiles)
                {
                    using (var pdfStream = new MemoryStream(pdfBytes))
                    {
                        PdfDocument srcDoc = new PdfDocument(new iText.Kernel.Pdf.PdfReader(pdfStream));
                        merger.Merge(srcDoc, 1, srcDoc.GetNumberOfPages());
                        srcDoc.Close();
                    }
                }
                pdf.Close();
                return ms.ToArray();
            }
        }
        private void GeneratePrintWithTaxUI(Document document, DataSet ds)
        {
            // Font setup matching the sample PDF
            BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            Font normalFont = new Font(bf, 10, Font.NORMAL);
            Font boldFont = new Font(bf, 10, Font.BOLD);
            Font headerFont = new Font(bf, 16, Font.BOLD);
            Font smallFont = new Font(bf, 8, Font.NORMAL);

            if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0 && ds.Tables[2].Rows.Count > 0)
            {

                DataRow CompanyDetails = ds.Tables[0].Rows[0];
                DataRow TaxInvoiceDetails = ds.Tables[1].Rows[0];
                DataRow invoiceData = ds.Tables[2].Rows[0];

                string Invoice_Date = "", InvoiceNo = "", FileNo = "", CommercialIDRef = "", PlaceOfSupply = "", Currency = "",
                    AgentAddress = "", StateCode = "", GSTIN = "", Client = "", EmployeeName = "";

                string CompanyName = "", CompAddress = "", CompanyStateCode = "", CompanyPan = "", CompanyGSTIN = "", CompanyCIN = "",
                    CompanyMSMEReg = "", FooterAddress = "",
                    CompanyLUTNo = "", CompanyAckNo = "", CompanyACKDate = "", CompanyIRN = "", CompanyAccountName = "", CompanyAccountNo = "";


                Invoice_Date = TaxInvoiceDetails["Invoice_Date"].ToString();
                InvoiceNo = TaxInvoiceDetails["InvoiceNumber"].ToString();
                FileNo = TaxInvoiceDetails["FileCode"].ToString();
                CommercialIDRef = "";
                PlaceOfSupply = TaxInvoiceDetails["StateCode"].ToString();
                Currency = TaxInvoiceDetails["Curr_Name"].ToString();
                AgentAddress = TaxInvoiceDetails["AgentAddress"].ToString();
                StateCode = TaxInvoiceDetails["StateCode"].ToString();
                GSTIN = TaxInvoiceDetails["GSTIN"].ToString();
                Client = TaxInvoiceDetails["CustomerName"].ToString();
                EmployeeName = TaxInvoiceDetails["EmployeeName"].ToString();

                CompanyName = CompanyDetails["CompanyName"].ToString();
                CompAddress = CompanyDetails["BranchAddress"].ToString();
                FooterAddress = CompanyDetails["Address"].ToString();
                CompanyStateCode = CompanyDetails["STATE"].ToString();
                CompanyPan = CompanyDetails["PAN"].ToString();
                CompanyGSTIN = CompanyDetails["GSTIN"].ToString();
                CompanyCIN = CompanyDetails["CIN"].ToString();
                CompanyMSMEReg = CompanyDetails["MSMERegNo"].ToString();
                CompanyLUTNo = CompanyDetails["LUTNumber"].ToString();
                CompanyAckNo = CompanyDetails["ACKNo"].ToString();
                CompanyACKDate = CompanyDetails["ACKDate"].ToString();
                CompanyIRN = CompanyDetails["IRN"].ToString();

                CompanyAccountName = CompanyDetails["AccountName"].ToString();
                CompanyAccountNo = CompanyDetails["AccountNo"].ToString();

                AddCompanyLogo(document);

                // 1. Company Header (Left Aligned)
                Paragraph companyHeader = new Paragraph(CompanyName, headerFont);
                companyHeader.Alignment = Element.ALIGN_LEFT;
                companyHeader.SpacingAfter = 5f;
                document.Add(companyHeader);

                // Company Address (Left Aligned)
                Paragraph address = new Paragraph(CompAddress, normalFont);
                address.Alignment = Element.ALIGN_LEFT;
                address.SpacingAfter = 10f;
                document.Add(address);

                // Horizontal line separator
                document.Add(new Chunk(new LineSeparator(0.5f, 100f, BaseColor.BLACK, Element.ALIGN_LEFT, -1)));
                document.Add(Chunk.NEWLINE);

                // 2. Company Details Table (2 columns)
                PdfPTable companyDetails = new PdfPTable(2);
                companyDetails.WidthPercentage = 100;
                companyDetails.SetWidths(new float[] { 15, 85 });

                AddDetailRow(companyDetails, "State :", CompanyStateCode, boldFont, normalFont);
                AddDetailRow(companyDetails, "PAN :", CompanyPan, boldFont, normalFont);
                AddDetailRow(companyDetails, "GSTIN :", CompanyGSTIN, boldFont, normalFont);
                AddDetailRow(companyDetails, "CIN :", CompanyCIN, boldFont, normalFont);
                AddDetailRow(companyDetails, "MSMEReg :", CompanyMSMEReg, boldFont, normalFont);
                AddDetailRow(companyDetails, "LUTNo :", CompanyLUTNo, boldFont, normalFont);
                AddDetailRow(companyDetails, "ACKNo :", CompanyAckNo, boldFont, normalFont);
                AddDetailRow(companyDetails, "IRN :", CompanyIRN, boldFont, normalFont);
                AddDetailRow(companyDetails, "ACKDate :", CompanyACKDate, boldFont, normalFont);

                document.Add(companyDetails);
                document.Add(new Chunk(new LineSeparator(0.5f, 100f, BaseColor.BLACK, Element.ALIGN_LEFT, -1)));
                document.Add(Chunk.NEWLINE);

                //=== 3.TAX INVOICE HEADER ===
                Paragraph invoiceHeader = new Paragraph("Tax Invoice", new Font(bf, 14, Font.BOLD));
                invoiceHeader.Alignment = Element.ALIGN_CENTER;
                invoiceHeader.SpacingAfter = 10f;
                document.Add(invoiceHeader);

                // === 4. INVOICE DETAILS ===
                PdfPTable invoiceDetailsTable = new PdfPTable(2);
                invoiceDetailsTable.WidthPercentage = 100;
                invoiceDetailsTable.SetWidths(new float[] { 30, 70 });
                invoiceDetailsTable.HorizontalAlignment = Element.ALIGN_LEFT;

                //AddLeftAlignedDetailRow(invoiceDetailsTable, "Date", invoiceDate, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Date : ", Invoice_Date, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Invoice No.", InvoiceNo, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "File No", FileNo, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Commercial ID Ref", CommercialIDRef, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Place of Supply", PlaceOfSupply, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Currency", Currency, boldFont, normalFont);

                document.Add(invoiceDetailsTable);
                document.Add(Chunk.NEWLINE);

                // 3. Client Information Section
                Paragraph clientHeader = new Paragraph(AgentAddress, boldFont);
                clientHeader.Alignment = Element.ALIGN_LEFT;
                document.Add(clientHeader);

                document.Add(Chunk.NEWLINE);

                // Client Details Table
                PdfPTable clientDetails = new PdfPTable(2);
                clientDetails.WidthPercentage = 100;
                clientDetails.SetWidths(new float[] { 15, 85 });

                AddDetailRow(clientDetails, "StateCode :", StateCode, boldFont, normalFont);
                AddDetailRow(clientDetails, "GSTIN :", GSTIN, boldFont, normalFont);
                AddDetailRow(clientDetails, "Client :", Client, boldFont, normalFont);

                document.Add(clientDetails);
                document.Add(Chunk.NEWLINE);

                // 4. Invoice Items Table (8 columns)
                PdfPTable invoiceTable = new PdfPTable(8);
                invoiceTable.WidthPercentage = 100;
                invoiceTable.SetWidths(new float[] { 25, 10, 8, 12, 12, 12, 8, 13 });

                // Header Row 1
                AddTableHeader(invoiceTable, "Booked By", boldFont);
                AddTableHeader(invoiceTable, "TEST", boldFont);
                AddTableHeader(invoiceTable, "Your Ref :", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);

                // Header Row 2
                AddTableHeader(invoiceTable, "Description", boldFont);
                AddTableHeader(invoiceTable, "HSN/SAC", boldFont);
                AddTableHeader(invoiceTable, "Tax %", boldFont);
                AddTableHeader(invoiceTable, "Basic Amt", boldFont);
                AddTableHeader(invoiceTable, "Taxable Amt", boldFont);
                AddTableHeader(invoiceTable, "Tax Amount", boldFont);
                AddTableHeader(invoiceTable, "TCS", boldFont);
                AddTableHeader(invoiceTable, "Amount", boldFont);

                // Data Row (using actual data from dataset)
                string description = invoiceData["Invoice_Desc"].ToString();
                string sacCode = invoiceData["SAC"].ToString();
                string taxPercent = invoiceData["Tax_Per"].ToString();
                string basicAmount = Convert.ToDecimal(invoiceData["TotalBasicAmount"]).ToString("N2");
                string taxableAmount = Convert.ToDecimal(invoiceData["TotalTaxable_Amount"]).ToString("N2");
                string taxAmount = Convert.ToDecimal(invoiceData["Tax_Amount"]).ToString("N2");
                string tcsAmount = invoiceData["TCSAmount"] != DBNull.Value ? Convert.ToDecimal(invoiceData["TCSAmount"]).ToString("N2") : "";
                string totalAmount = Convert.ToDecimal(invoiceData["SUM_Taxable_Amount"]).ToString("N2");

                AddTableDataRow(invoiceTable, description, sacCode, taxPercent, basicAmount, taxableAmount, taxAmount, tcsAmount, totalAmount, normalFont);

                // Total Row
                AddTableDataRow(invoiceTable, "Total :", "", "", "", taxableAmount, taxAmount, "", totalAmount, boldFont);

                document.Add(invoiceTable);
                document.Add(Chunk.NEWLINE);

                // 5. Tax Breakdown Table (Right Aligned)
                PdfPTable taxTable = new PdfPTable(4);
                taxTable.WidthPercentage = 40;
                taxTable.HorizontalAlignment = Element.ALIGN_LEFT;

                AddCenteredTableHeader(taxTable, "IGST", boldFont);
                AddCenteredTableHeader(taxTable, "CGST", boldFont);
                AddCenteredTableHeader(taxTable, "SGST", boldFont);
                AddCenteredTableHeader(taxTable, "UTGST", boldFont);

                AddCenteredTableRow(taxTable, "", normalFont);
                AddCenteredTableRow(taxTable, "", normalFont);
                AddCenteredTableRow(taxTable, "", normalFont);
                AddCenteredTableRow(taxTable, "", normalFont);

                document.Add(taxTable);
                document.Add(Chunk.NEWLINE);

                // 6. Bank Details
                Paragraph bankHeader = new Paragraph("Account Name:" + CompanyAccountName, normalFont);
                bankHeader.Alignment = Element.ALIGN_LEFT;
                document.Add(bankHeader);



                Paragraph accountNo = new Paragraph("Account No: " + CompanyAccountNo, normalFont);
                accountNo.Alignment = Element.ALIGN_LEFT;
                document.Add(accountNo);
                document.Add(Chunk.NEWLINE);

                Paragraph ifscCode = new Paragraph("IFSC Code : | SWIFT Code : ", normalFont);
                ifscCode.Alignment = Element.ALIGN_LEFT;
                document.Add(ifscCode);

                Paragraph bankInfo = new Paragraph("Bank Name: | Bank Address : ", normalFont);
                bankInfo.Alignment = Element.ALIGN_LEFT;
                document.Add(bankInfo);
                document.Add(Chunk.NEWLINE);

                // 7. Notes Section
                Paragraph notesHeader = new Paragraph("Notes :", boldFont);
                notesHeader.Alignment = Element.ALIGN_LEFT;
                document.Add(notesHeader);

                List list = new List(List.UNORDERED);
                list.IndentationLeft = 20f;
                list.Add(new ListItem("Please share a copy of the remittance advice at receivables@tamarindiglobal.com while remitting payment to our account.", normalFont));
                list.Add(new ListItem("TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)", normalFont));
                document.Add(list);
                document.Add(Chunk.NEWLINE);

                // 8. Footer

                AddSignature(document);

                Paragraph footer = new Paragraph("For " + CompanyName, normalFont);
                footer.Alignment = Element.ALIGN_RIGHT;
                document.Add(footer);
                document.Add(Chunk.NEWLINE);

                Paragraph signatory = new Paragraph(EmployeeName, normalFont);
                signatory.Alignment = Element.ALIGN_RIGHT;
                document.Add(signatory);
                document.Add(Chunk.NEWLINE);

                // 9. Disclaimer
                Paragraph disclaimer = new Paragraph("Tax Payable under RCIM : No | Original for Recipient | Disputes subject to Mumbai Jurisdiction only | This is a computer generated document and does not require Signature", smallFont);
                disclaimer.Alignment = Element.ALIGN_CENTER;
                document.Add(disclaimer);

                Paragraph officeAddress = new Paragraph(FooterAddress, smallFont);
                officeAddress.Alignment = Element.ALIGN_CENTER;
                document.Add(officeAddress);
            }
        }

        private string GeneratePrintWithTaxUIForDoc(DataSet dsTI)
        {

            string Invoice_Date = "", InvoiceNo = "", FileNo = "", CommercialIDRef = "", PlaceOfSupply = "", Currency = "",
                AgentAddress = "", AgentName = "", StateCode = "", GSTIN = "", Client = "",
                EmployeeName = "", IGSTP = "", CGSTP = "", SGSTP = "", UTGSTP = "", BookedBy = "", YourRef = "";

            string CompanyName = "", CompAddress = "", CompanyStateCode = "", CompanyPan = "", CompanyGSTIN = "", CompanyCIN = "",
                CompanyMSMEReg = "", FooterAddress = "",
                CompanyLUTNo = "", CompanyAckNo = "", CompanyACKDate = "", CompanyIRN = "", CompanyAccountName = "", CompanyAccountNo = ""
                , description = "", sacCode = "", taxPercent = "", basicAmount = "", taxableAmount = "",
                taxAmount = "", tcsAmount = "", totalAmountP = "", amountToWords = "", BankDetails = "", TCS_Per = "", InvoiceDesc = "", Type_Of_Doc = "";
            if (dsTI.Tables[0].Rows.Count > 0 && dsTI.Tables[1].Rows.Count > 0 && dsTI.Tables[2].Rows.Count > 0)
            {
                DataRow CompanyDetails = dsTI.Tables[0].Rows[0];
                DataRow TaxInvoiceDetails = dsTI.Tables[1].Rows[0];
                DataRow invoiceData = dsTI.Tables[2].Rows[0];

                Invoice_Date = TaxInvoiceDetails["Invoice_Date"].ToString();
                InvoiceNo = TaxInvoiceDetails["InvoiceNumber"].ToString();
                FileNo = TaxInvoiceDetails["FileCode"].ToString();
                InvoiceDesc = TaxInvoiceDetails["InvoiceDesc"].ToString();
                Type_Of_Doc = TaxInvoiceDetails["Type_Of_Doc"].ToString();

                PlaceOfSupply = TaxInvoiceDetails["StateCode"].ToString();
                Currency = TaxInvoiceDetails["Curr_Name"].ToString();
                AgentAddress = TaxInvoiceDetails["AgentAddress"].ToString();
                AgentName = TaxInvoiceDetails["AgentName"].ToString();
                StateCode = TaxInvoiceDetails["StateCode"].ToString();
                GSTIN = TaxInvoiceDetails["GSTIN"].ToString();
                Client = TaxInvoiceDetails["CustomerName"].ToString();
                EmployeeName = TaxInvoiceDetails["EmployeeName"].ToString();
                BookedBy = TaxInvoiceDetails["BookedBy"].ToString();
                YourRef = TaxInvoiceDetails["YourRef"].ToString();

                IGSTP = TaxInvoiceDetails["IGST"].ToString();
                CGSTP = TaxInvoiceDetails["CGST"].ToString();
                SGSTP = TaxInvoiceDetails["SGST"].ToString();
                UTGSTP = TaxInvoiceDetails["UTGST"].ToString();

                CompanyName = CompanyDetails["CompanyName"].ToString();
                CompAddress = CompanyDetails["BranchAddress"].ToString();
                FooterAddress = CompanyDetails["Address"].ToString();
                CompanyStateCode = CompanyDetails["STATE"].ToString();
                CompanyPan = CompanyDetails["PAN"].ToString();
                CompanyGSTIN = CompanyDetails["GSTIN"].ToString() == "" ? "" : CompanyDetails["GSTIN"].ToString();
                CompanyCIN = CompanyDetails["CIN"].ToString();
                CompanyMSMEReg = CompanyDetails["MSMERegNo"].ToString();
                CompanyLUTNo = CompanyDetails["LUTNumber"].ToString();
                CompanyAckNo = CompanyDetails["ACKNo"].ToString();
                CompanyACKDate = CompanyDetails["ACKDate"].ToString();
                CompanyIRN = CompanyDetails["IRN"].ToString();

                CommercialIDRef = CompanyDetails["CommercialIDRef"].ToString();
                BankDetails = CompanyDetails["BankDetails"].ToString();

                CompanyAccountName = CompanyDetails["AccountName"].ToString();
                CompanyAccountNo = CompanyDetails["AccountNo"].ToString();


                description = invoiceData["Invoice_Desc"].ToString();
                sacCode = invoiceData["SAC"].ToString();
                taxPercent = invoiceData["Tax_Per"].ToString();
                TCS_Per = invoiceData["TCS_Per"].ToString();
                basicAmount = Convert.ToDecimal(invoiceData["TotalBasicAmount"]).ToString("N2");
                taxableAmount = Convert.ToDecimal(invoiceData["TotalTaxable_Amount"]).ToString("N2");
                taxAmount = Convert.ToDecimal(invoiceData["Tax_Amount"]).ToString("N2");
                tcsAmount = invoiceData["TCSAmount"] != DBNull.Value ? Convert.ToDecimal(invoiceData["TCSAmount"]).ToString("N2") : "";
                totalAmountP = Convert.ToDecimal(invoiceData["SUM_Taxable_Amount"]).ToString("N2");
                amountToWords = CommonFunctions.AmountToWords(Convert.ToDecimal(totalAmountP), invoiceData["CurrencyCode"].ToString());
            }
            // Remove HTML tags
            string resultBankDetails = Regex.Replace(BankDetails, "<.*?>", string.Empty);

            // Decode HTML entities like &nbsp;, &amp;, etc.
            resultBankDetails = System.Net.WebUtility.HtmlDecode(resultBankDetails);

            var replacements = new Dictionary<string, string>
            {
    // Main Invoice Section
    {"CompanyNameP", CompanyName},
    {"CompanyAddressP", CompAddress},
    {"CompanyStateCodeP", CompanyStateCode},
    {"CompanyPanP", CompanyPan},
    {"CompanyGSTINP", CompanyGSTIN},
    {"CompanyCINP", CompanyCIN},
    {"CompanyMSMEP", CompanyMSMEReg},
    {"CompanyLUTNoP", CompanyLUTNo},
    {"CompanyACKNoP", CompanyAckNo},
    {"CompanyACKDP", CompanyACKDate},
    {"CompanyIRNP", CompanyIRN},
    {"AgentAddressP", AgentAddress},{"AgentNameP", AgentName},
    {"StateCodeP", StateCode},
    {"GSTINP", GSTIN},
    {"ClientP", Client},
    {"BookedBy", BookedBy},
    {"YourRef", YourRef},
    {"DateP", Invoice_Date},
    {"InvoiceNoP", InvoiceNo},
    {"FileNoP", FileNo},
    {"CommercialIDP", CommercialIDRef},
    {"PlaceOfSupplyP", PlaceOfSupply},
    {"CurrencyP", Currency},
    {"DescriptionP", description},
    {"SACP", sacCode},
    {"TaxP", taxPercent},
    {"TCS_Per", TCS_Per},
    {"BasicAmtP", basicAmount},
    {"BasicAmtTP", basicAmount},
    {"taxableAmtP", taxableAmount},
    {"taxableAmtTP", taxableAmount},
    {"TaxAmountP", taxAmount},
    {"TaxAmountTP", taxAmount},
    {"TCSP", tcsAmount},
    {"TotalAmountP", totalAmountP},
    {"TotalAmountTP", totalAmountP},
    {"cP", Currency},
    {"AmountTPInWord", amountToWords},
    {"IGSTP", IGSTP},
    {"CGSTP", CGSTP},
    {"SGSTP", SGSTP},
    {"UTGSTP", UTGSTP},
    {"BankDetails", resultBankDetails},
    {"CompanyAccountNameP", CompanyAccountName},
    {"AccountNoP", CompanyAccountNo},
    {"IFSCCodeP", ""},
    {"SwiftCodeP", ""},
    {"BankNameP", ""},
    {"BankAddressP", ""},
    {"EmployeeP", EmployeeName},
    {"FooterAddressP", FooterAddress},
    {"InvoiceDesc", InvoiceDesc},
    {"Type_Of_Doc", Type_Of_Doc}
};
            ConvertWordToPDF convertWordToPDF = new ConvertWordToPDF(_hostingEnvironment);
            return convertWordToPDF.CodeToConvertInvoiceWithTax(replacements);
        }

        private void GeneratePrintWithoutTaxUI(Document document, DataSet ds)
        {
            // Font setup matching the sample PDF
            BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            Font normalFont = new Font(bf, 10, Font.NORMAL);
            Font boldFont = new Font(bf, 10, Font.BOLD);
            Font headerFont = new Font(bf, 16, Font.BOLD);
            Font smallFont = new Font(bf, 8, Font.NORMAL);



            if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0 && ds.Tables[2].Rows.Count > 0)
            {
                DataRow CompanyDetails = ds.Tables[0].Rows[0];
                DataRow TaxInvoiceDetails = ds.Tables[1].Rows[0];
                DataRow invoiceData = ds.Tables[2].Rows[0];

                string Invoice_Date = "", InvoiceNo = "", FileNo = "", CommercialIDRef = "", PlaceOfSupply = "", Currency = "",
                    AgentAddress = "", StateCode = "", GSTIN = "", Client = "", EmployeeName = "";

                string CompanyName = "", CompAddress = "", CompanyStateCode = "", CompanyPan = "", CompanyGSTIN = "", CompanyCIN = "",
                    CompanyMSMEReg = "", FooterAddress = "",
                    CompanyLUTNo = "", CompanyAckNo = "", CompanyACKDate = "", CompanyIRN = "", CompanyAccountName = "", CompanyAccountNo = "";

                Invoice_Date = TaxInvoiceDetails["Invoice_Date"].ToString();
                InvoiceNo = TaxInvoiceDetails["InvoiceNumber"].ToString();
                FileNo = TaxInvoiceDetails["FileCode"].ToString();
                CommercialIDRef = "";
                PlaceOfSupply = TaxInvoiceDetails["StateCode"].ToString();
                Currency = TaxInvoiceDetails["Curr_Name"].ToString();
                AgentAddress = TaxInvoiceDetails["AgentAddress"].ToString();
                StateCode = TaxInvoiceDetails["StateCode"].ToString();
                GSTIN = TaxInvoiceDetails["GSTIN"].ToString();
                Client = TaxInvoiceDetails["CustomerName"].ToString();
                EmployeeName = TaxInvoiceDetails["EmployeeName"].ToString();

                CompanyName = CompanyDetails["CompanyName"].ToString();
                CompAddress = CompanyDetails["BranchAddress"].ToString();
                CompanyStateCode = CompanyDetails["STATE"].ToString();
                CompanyPan = CompanyDetails["PAN"].ToString();
                CompanyGSTIN = CompanyDetails["GSTIN"].ToString();
                CompanyCIN = CompanyDetails["CIN"].ToString();
                CompanyMSMEReg = CompanyDetails["MSMERegNo"].ToString();
                CompanyLUTNo = CompanyDetails["LUTNumber"].ToString();
                CompanyAckNo = CompanyDetails["ACKNo"].ToString();
                CompanyACKDate = CompanyDetails["ACKDate"].ToString();
                CompanyIRN = CompanyDetails["IRN"].ToString();

                CompanyAccountName = CompanyDetails["AccountName"].ToString();
                CompanyAccountNo = CompanyDetails["AccountNo"].ToString();

                AddCompanyLogo(document);

                // 1. Company Header (Left Aligned)
                Paragraph companyHeader = new Paragraph(CompanyName, headerFont);
                companyHeader.Alignment = Element.ALIGN_LEFT;
                companyHeader.SpacingAfter = 5f;
                document.Add(companyHeader);

                // Company Address (Left Aligned)
                Paragraph address = new Paragraph(CompAddress, normalFont);
                address.Alignment = Element.ALIGN_LEFT;
                address.SpacingAfter = 10f;
                document.Add(address);

                // Horizontal line separator
                document.Add(new Chunk(new LineSeparator(0.5f, 100f, BaseColor.BLACK, Element.ALIGN_LEFT, -1)));
                document.Add(Chunk.NEWLINE);

                // 2. Company Details Table (2 columns)
                PdfPTable companyDetails = new PdfPTable(2);
                companyDetails.WidthPercentage = 100;
                companyDetails.SetWidths(new float[] { 15, 85 });

                AddDetailRow(companyDetails, "State :", CompanyStateCode, boldFont, normalFont);
                AddDetailRow(companyDetails, "PAN :", CompanyPan, boldFont, normalFont);
                AddDetailRow(companyDetails, "GSTIN :", CompanyGSTIN, boldFont, normalFont);
                AddDetailRow(companyDetails, "CIN :", CompanyCIN, boldFont, normalFont);
                AddDetailRow(companyDetails, "MSMEReg :", CompanyMSMEReg, boldFont, normalFont);
                AddDetailRow(companyDetails, "LUTNo :", CompanyLUTNo, boldFont, normalFont);
                AddDetailRow(companyDetails, "ACKNo :", CompanyAckNo, boldFont, normalFont);
                AddDetailRow(companyDetails, "IRN :", CompanyIRN, boldFont, normalFont);
                AddDetailRow(companyDetails, "ACKDate :", CompanyACKDate, boldFont, normalFont);

                document.Add(companyDetails);
                document.Add(new Chunk(new LineSeparator(0.5f, 100f, BaseColor.BLACK, Element.ALIGN_LEFT, -1)));
                document.Add(Chunk.NEWLINE);

                //=== 3.TAX INVOICE HEADER ===
                Paragraph invoiceHeader = new Paragraph("Tax Invoice", new Font(bf, 14, Font.BOLD));
                invoiceHeader.Alignment = Element.ALIGN_CENTER;
                invoiceHeader.SpacingAfter = 10f;
                document.Add(invoiceHeader);

                // === 4. INVOICE DETAILS ===
                PdfPTable invoiceDetailsTable = new PdfPTable(2);
                invoiceDetailsTable.WidthPercentage = 100;
                invoiceDetailsTable.SetWidths(new float[] { 30, 70 });
                invoiceDetailsTable.HorizontalAlignment = Element.ALIGN_LEFT;

                AddDetailRow(invoiceDetailsTable, "Date : ", Invoice_Date, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Invoice No.", InvoiceNo, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "File No", FileNo, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Commercial ID Ref", CommercialIDRef, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Place of Supply", PlaceOfSupply, boldFont, normalFont);
                AddDetailRow(invoiceDetailsTable, "Currency", Currency, boldFont, normalFont);

                document.Add(invoiceDetailsTable);
                document.Add(Chunk.NEWLINE);

                // 3. Client Information Section
                Paragraph clientHeader = new Paragraph(AgentAddress, boldFont);
                clientHeader.Alignment = Element.ALIGN_LEFT;
                document.Add(clientHeader);
                document.Add(Chunk.NEWLINE);

                // Client Details Table
                PdfPTable clientDetails = new PdfPTable(2);
                clientDetails.WidthPercentage = 100;
                clientDetails.SetWidths(new float[] { 15, 85 });


                AddDetailRow(clientDetails, "StateCode :", StateCode, boldFont, normalFont);
                AddDetailRow(clientDetails, "GSTIN :", GSTIN, boldFont, normalFont);
                AddDetailRow(clientDetails, "Client :", Client, boldFont, normalFont);

                document.Add(clientDetails);
                document.Add(Chunk.NEWLINE);

                // 4. Invoice Items Table (8 columns)
                PdfPTable invoiceTable = new PdfPTable(4);
                invoiceTable.WidthPercentage = 100;
                invoiceTable.SetWidths(new float[] { 25, 10, 8, 12 });

                // Header Row 1
                AddTableHeader(invoiceTable, "Booked By", boldFont);
                AddTableHeader(invoiceTable, "TEST", boldFont);
                AddTableHeader(invoiceTable, "Your Ref :", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);

                // Header Row 2
                AddTableHeader(invoiceTable, "Description", boldFont);
                AddTableHeader(invoiceTable, "Amount", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);
                AddTableHeader(invoiceTable, "", boldFont);

                // Data Row (using actual data from dataset)
                string description = invoiceData["Invoice_Desc"].ToString();

                string totalAmount = Convert.ToDecimal(invoiceData["SUM_Taxable_Amount"]).ToString("N2");

                AddTableDataRowPrintWithoutTax(invoiceTable, description, totalAmount, normalFont);

                // Total Row
                AddTableDataRowPrintWithoutTax(invoiceTable, "Total :", totalAmount, boldFont);

                document.Add(invoiceTable);
                document.Add(Chunk.NEWLINE);



                // 6. Bank Details
                Paragraph bankHeader = new Paragraph("Account Name:" + CompanyAccountName, normalFont);
                bankHeader.Alignment = Element.ALIGN_LEFT;
                document.Add(bankHeader);


                Paragraph accountNo = new Paragraph("Account No: " + CompanyAccountNo, normalFont);
                accountNo.Alignment = Element.ALIGN_LEFT;
                document.Add(accountNo);
                document.Add(Chunk.NEWLINE);

                Paragraph ifscCode = new Paragraph("IFSC Code : | SWIFT Code : ", normalFont);
                ifscCode.Alignment = Element.ALIGN_LEFT;
                document.Add(ifscCode);

                Paragraph bankInfo = new Paragraph("Bank Name: | Bank Address : ", normalFont);
                bankInfo.Alignment = Element.ALIGN_LEFT;
                document.Add(bankInfo);
                document.Add(Chunk.NEWLINE);

                // 7. Notes Section
                Paragraph notesHeader = new Paragraph("Notes :", boldFont);
                notesHeader.Alignment = Element.ALIGN_LEFT;
                document.Add(notesHeader);

                List list = new List(List.UNORDERED);
                list.IndentationLeft = 20f;
                list.Add(new ListItem("Please share a copy of the remittance advice at receivables@tamarindiglobal.com while remitting payment to our account.", normalFont));
                list.Add(new ListItem("TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)", normalFont));
                document.Add(list);
                document.Add(Chunk.NEWLINE);

                // 8. Footer

                AddSignature(document);

                Paragraph footer = new Paragraph("For " + CompanyName, normalFont);
                footer.Alignment = Element.ALIGN_RIGHT;
                document.Add(footer);
                document.Add(Chunk.NEWLINE);

                Paragraph signatory = new Paragraph(EmployeeName, normalFont);
                signatory.Alignment = Element.ALIGN_RIGHT;
                document.Add(signatory);
                document.Add(Chunk.NEWLINE);

                // 9. Disclaimer
                Paragraph disclaimer = new Paragraph("Tax Payable under RCIM : No | Original for Recipient | Disputes subject to Mumbai Jurisdiction only | This is a computer generated document and does not require Signature", smallFont);
                disclaimer.Alignment = Element.ALIGN_CENTER;
                document.Add(disclaimer);

                Paragraph officeAddress = new Paragraph(FooterAddress, smallFont);
                officeAddress.Alignment = Element.ALIGN_CENTER;
                document.Add(officeAddress);
            }
        }

        public string GeneratePrintWithoutTaxUIForDoc(DataSet dsTI)
        {

            string Invoice_Date = "", InvoiceNo = "", FileNo = "", CommercialIDRef = "", PlaceOfSupply = "", Currency = "",
                AgentAddress = "", AgentName = "", StateCode = "", GSTIN = "", Client = "",
                EmployeeName = "", IGSTP = "", CGSTP = "", SGSTP = "", UTGSTP = "", BookedBy = "", YourRef = "";

            string CompanyName = "", CompAddress = "", CompanyStateCode = "", CompanyPan = "", CompanyGSTIN = "", CompanyCIN = "",
                CompanyMSMEReg = "", FooterAddress = "",
                CompanyLUTNo = "", CompanyAckNo = "", CompanyACKDate = "", CompanyIRN = "", CompanyAccountName = "", CompanyAccountNo = ""
                , description = "", sacCode = "", taxPercent = "", basicAmount = "", taxableAmount = "",
                taxAmount = "", tcsAmount = "", totalAmountP = "", amountToWords = "", BankDetails = "", TCS_Per = "", InvoiceDesc = "", Type_Of_Doc = "";
            ;

            if (dsTI.Tables[0].Rows.Count > 0 && dsTI.Tables[1].Rows.Count > 0 && dsTI.Tables[2].Rows.Count > 0)
            {
                DataRow CompanyDetails = dsTI.Tables[0].Rows[0];
                DataRow TaxInvoiceDetails = dsTI.Tables[1].Rows[0];
                DataRow invoiceData = dsTI.Tables[2].Rows[0];

                Invoice_Date = TaxInvoiceDetails["Invoice_Date"].ToString();
                InvoiceNo = TaxInvoiceDetails["InvoiceNumber"].ToString();
                FileNo = TaxInvoiceDetails["FileCode"].ToString();
                InvoiceDesc = TaxInvoiceDetails["InvoiceDesc"].ToString();
                Type_Of_Doc = TaxInvoiceDetails["Type_Of_Doc"].ToString();

                PlaceOfSupply = TaxInvoiceDetails["StateCode"].ToString();
                Currency = TaxInvoiceDetails["Curr_Name"].ToString();
                AgentAddress = TaxInvoiceDetails["AgentAddress"].ToString();
                AgentName = TaxInvoiceDetails["AgentName"].ToString();
                StateCode = TaxInvoiceDetails["StateCode"].ToString();
                GSTIN = TaxInvoiceDetails["GSTIN"].ToString();
                Client = TaxInvoiceDetails["CustomerName"].ToString();
                EmployeeName = TaxInvoiceDetails["EmployeeName"].ToString();
                BookedBy = TaxInvoiceDetails["BookedBy"].ToString();
                YourRef = TaxInvoiceDetails["YourRef"].ToString();

                IGSTP = TaxInvoiceDetails["IGST"].ToString();
                CGSTP = TaxInvoiceDetails["CGST"].ToString();
                SGSTP = TaxInvoiceDetails["SGST"].ToString();
                UTGSTP = TaxInvoiceDetails["UTGST"].ToString();

                CompanyName = CompanyDetails["CompanyName"].ToString();
                CompAddress = CompanyDetails["BranchAddress"].ToString();
                FooterAddress = CompanyDetails["Address"].ToString();
                CompanyStateCode = CompanyDetails["STATE"].ToString();
                CompanyPan = CompanyDetails["PAN"].ToString();
                CompanyGSTIN = CompanyDetails["GSTIN"].ToString() == "" ? "" : CompanyDetails["GSTIN"].ToString();
                CompanyCIN = CompanyDetails["CIN"].ToString();
                CompanyMSMEReg = CompanyDetails["MSMERegNo"].ToString();
                CompanyLUTNo = CompanyDetails["LUTNumber"].ToString();
                CompanyAckNo = CompanyDetails["ACKNo"].ToString();
                CompanyACKDate = CompanyDetails["ACKDate"].ToString();
                CompanyIRN = CompanyDetails["IRN"].ToString();

                CommercialIDRef = CompanyDetails["CommercialIDRef"].ToString();
                BankDetails = CompanyDetails["BankDetails"].ToString();

                CompanyAccountName = CompanyDetails["AccountName"].ToString();
                CompanyAccountNo = CompanyDetails["AccountNo"].ToString();


                description = invoiceData["Invoice_Desc"].ToString();
                sacCode = invoiceData["SAC"].ToString();
                taxPercent = invoiceData["Tax_Per"].ToString();
                TCS_Per = invoiceData["TCS_Per"].ToString();
                basicAmount = Convert.ToDecimal(invoiceData["TotalBasicAmount"]).ToString("N2");
                taxableAmount = Convert.ToDecimal(invoiceData["TotalTaxable_Amount"]).ToString("N2");
                taxAmount = Convert.ToDecimal(invoiceData["Tax_Amount"]).ToString("N2");
                tcsAmount = invoiceData["TCSAmount"] != DBNull.Value ? Convert.ToDecimal(invoiceData["TCSAmount"]).ToString("N2") : "";
                totalAmountP = Convert.ToDecimal(invoiceData["SUM_Taxable_Amount"]).ToString("N2");
                amountToWords = CommonFunctions.AmountToWords(Convert.ToDecimal(totalAmountP), invoiceData["CurrencyCode"].ToString());
            }
            // Remove HTML tags
            string resultBankDetails = Regex.Replace(BankDetails, "<.*?>", string.Empty);

            // Decode HTML entities like &nbsp;, &amp;, etc.
            resultBankDetails = System.Net.WebUtility.HtmlDecode(resultBankDetails);

            var replacements = new Dictionary<string, string>
{
    // Main Invoice Section
    {"CompanyNameP", CompanyName},
    {"CompanyAddressP", CompAddress},
    {"CompanyStateCodeP", CompanyStateCode},
    {"CompanyPanP", CompanyPan},
    {"CompanyGSTINP", CompanyGSTIN},
    {"CompanyCINP", CompanyCIN},
    {"CompanyMSMEP", CompanyMSMEReg},
    {"CompanyLUTNoP", CompanyLUTNo},
    {"CompanyACKNoP", CompanyAckNo},
    {"CompanyACKDP", CompanyACKDate},
    {"CompanyIRNP", CompanyIRN},
    {"AgentAddressP", AgentAddress},{"AgentNameP", AgentName},
    {"StateCodeP", StateCode},
    {"GSTINP", GSTIN},
    {"ClientP", Client},
    {"BookedBy", BookedBy},
    {"YourRef", YourRef},
    {"DateP", Invoice_Date},
    {"InvoiceNoP", InvoiceNo},
    {"FileNoP", FileNo},
    {"CommercialIDP", CommercialIDRef},
    {"PlaceOfSupplyP", PlaceOfSupply},
    {"CurrencyP", Currency},
    {"DescriptionP", description},
    {"SACP", sacCode},
    {"TaxP", taxPercent},
    {"TCS_Per", TCS_Per},
    {"BasicAmtP", basicAmount},
    {"BasicAmtTP", basicAmount},
    {"taxableAmtP", taxableAmount},
    {"taxableAmtTP", taxableAmount},
    {"TaxAmountP", taxAmount},
    {"TaxAmountTP", taxAmount},
    {"TCSP", tcsAmount},
    {"TotalAmountP", totalAmountP},
    {"TotalAmountTP", totalAmountP},
    {"cP", Currency},
    {"AmountTPInWord", amountToWords},
    {"IGSTP", IGSTP},
    {"CGSTP", CGSTP},
    {"SGSTP", SGSTP},
    {"UTGSTP", UTGSTP},
    {"BankDetails", resultBankDetails},
    {"CompanyAccountNameP", CompanyAccountName},
    {"AccountNoP", CompanyAccountNo},
    {"IFSCCodeP", ""},
    {"SwiftCodeP", ""},
    {"BankNameP", ""},
    {"BankAddressP", ""},
    {"EmployeeP", EmployeeName},
    {"FooterAddressP", FooterAddress},
    {"InvoiceDesc", InvoiceDesc},
    {"Type_Of_Doc", Type_Of_Doc}
};

            ConvertWordToPDF convertWordToPDF = new ConvertWordToPDF(_hostingEnvironment);
            return convertWordToPDF.CodeToConvertInvoiceWithoutTax(replacements);
        }
        private void AddSignature(Document document)
        {

            string logoFileName = "Signature2.jpg";
            string logoPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Images", logoFileName);

            if (File.Exists(logoPath))
            {
                try
                {
                    Image logo = Image.GetInstance(logoPath);
                    logo.ScaleToFit(150f, 60f);
                    logo.Alignment = Element.ALIGN_RIGHT;
                    document.Add(logo);
                    document.Add(new Paragraph("\n"));
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Logo load error: " + ex.Message);
                }
            }
            else
            {
                Console.WriteLine("Logo not found at path: " + logoPath);
            }
        }
        // Helper Methods
        private void AddDetailRow(PdfPTable table, string label, string value, Font labelFont, Font valueFont)
        {
            table.AddCell(new PdfPCell(new Phrase(label, labelFont)) { Border = PdfPCell.NO_BORDER, HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(value, valueFont)) { Border = PdfPCell.NO_BORDER, HorizontalAlignment = Element.ALIGN_LEFT });
        }
        private void AddDetailRowFroAddendum(PdfPTable table, string label, string value, Font labelFont, Font valueFont)
        {
            table.AddCell(new PdfPCell(new Phrase(label, labelFont)) { Border = PdfPCell.NO_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT });
            table.AddCell(new PdfPCell(new Phrase(value, valueFont)) { Border = PdfPCell.NO_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT });
        }

        private void AddTableHeader(PdfPTable table, string text, Font font)
        {
            table.AddCell(new PdfPCell(new Phrase(text, font))
            {
                HorizontalAlignment = Element.ALIGN_LEFT,
                BackgroundColor = new BaseColor(240, 240, 240)
            });
        }

        private void AddTableDataRow(PdfPTable table, string desc, string sac, string taxPct, string basicAmt,
                                   string taxableAmt, string taxAmt, string tcs, string amount, Font font)
        {
            table.AddCell(new PdfPCell(new Phrase(desc, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(sac, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(taxPct, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(basicAmt, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(taxableAmt, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(taxAmt, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(tcs, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(amount, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
        }


        private void AddTableDataRowPrintWithoutTax(PdfPTable table, string desc, string amount, Font font)
        {
            table.AddCell(new PdfPCell(new Phrase(desc, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase(amount, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase("", font)) { HorizontalAlignment = Element.ALIGN_LEFT });
            table.AddCell(new PdfPCell(new Phrase("", font)) { HorizontalAlignment = Element.ALIGN_LEFT });
        }

        private void AddCenteredTableHeader(PdfPTable table, string text, Font font)
        {
            table.AddCell(new PdfPCell(new Phrase(text, font))
            {
                HorizontalAlignment = Element.ALIGN_CENTER,
                BackgroundColor = new BaseColor(240, 240, 240)
            });
        }

        private void AddCenteredTableRow(PdfPTable table, string text, Font font)
        {
            table.AddCell(new PdfPCell(new Phrase(text, font)) { HorizontalAlignment = Element.ALIGN_CENTER });
        }

        private string GeneratePrintWithoutTaxUIANDAddendum(DataSet ds, DataSet dsTI)
        {
            DataRow CompanyDetails = dsTI.Tables[0].Rows[0];
            DataRow TaxInvoiceDetails = dsTI.Tables[1].Rows[0];
            DataRow invoiceData = dsTI.Tables[2].Rows[0];
            string Invoice_Date = "", InvoiceNo = "", FileNo = "", CommercialIDRef = "", PlaceOfSupply = "", Currency = "",
                AgentAddress = "", AgentName = "", StateCode = "", GSTIN = "", Client = "",
                EmployeeName = "", IGSTP = "", CGSTP = "", SGSTP = "", UTGSTP = "", BookedBy = "", YourRef = "";

            string CompanyName = "", CompAddress = "", CompanyStateCode = "", CompanyPan = "", CompanyGSTIN = "", CompanyCIN = "",
                CompanyMSMEReg = "", FooterAddress = "",
                CompanyLUTNo = "", CompanyAckNo = "", CompanyACKDate = "", CompanyIRN = "", CompanyAccountName = "", CompanyAccountNo = ""
                , description = "", sacCode = "", taxPercent = "", basicAmount = "", taxableAmount = "",
                taxAmount = "", tcsAmount = "", totalAmountP = "", amountToWords = "", BankDetails = "", InvoiceDesc = "", Type_Of_Doc = "";
            if (dsTI.Tables[0].Rows.Count > 0 && dsTI.Tables[1].Rows.Count > 0 && dsTI.Tables[2].Rows.Count > 0)
            {
                Invoice_Date = TaxInvoiceDetails["Invoice_Date"].ToString();
                InvoiceNo = TaxInvoiceDetails["InvoiceNumber"].ToString();
                FileNo = TaxInvoiceDetails["FileCode"].ToString();
                InvoiceDesc = TaxInvoiceDetails["InvoiceDesc"].ToString();
                Type_Of_Doc = TaxInvoiceDetails["Type_Of_Doc"].ToString();

                PlaceOfSupply = TaxInvoiceDetails["StateCode"].ToString();
                Currency = TaxInvoiceDetails["Curr_Name"].ToString();
                AgentAddress = TaxInvoiceDetails["AgentAddress"].ToString();
                AgentName = TaxInvoiceDetails["AgentName"].ToString();
                StateCode = TaxInvoiceDetails["StateCode"].ToString();
                GSTIN = TaxInvoiceDetails["GSTIN"].ToString();
                Client = TaxInvoiceDetails["CustomerName"].ToString();
                EmployeeName = TaxInvoiceDetails["EmployeeName"].ToString();
                BookedBy = TaxInvoiceDetails["BookedBy"].ToString();
                YourRef = TaxInvoiceDetails["YourRef"].ToString();

                IGSTP = TaxInvoiceDetails["IGST"].ToString();
                CGSTP = TaxInvoiceDetails["CGST"].ToString();
                SGSTP = TaxInvoiceDetails["SGST"].ToString();
                UTGSTP = TaxInvoiceDetails["UTGST"].ToString();

                CompanyName = CompanyDetails["CompanyName"].ToString();
                CompAddress = CompanyDetails["BranchAddress"].ToString();
                FooterAddress = CompanyDetails["Address"].ToString();
                CompanyStateCode = CompanyDetails["STATE"].ToString();
                CompanyPan = CompanyDetails["PAN"].ToString();
                CompanyGSTIN = CompanyDetails["GSTIN"].ToString() == "" ? "" : CompanyDetails["GSTIN"].ToString();
                CompanyCIN = CompanyDetails["CIN"].ToString();
                CompanyMSMEReg = CompanyDetails["MSMERegNo"].ToString();
                CompanyLUTNo = CompanyDetails["LUTNumber"].ToString();
                CompanyAckNo = CompanyDetails["ACKNo"].ToString();
                CompanyACKDate = CompanyDetails["ACKDate"].ToString();
                CompanyIRN = CompanyDetails["IRN"].ToString();

                CommercialIDRef = CompanyDetails["CommercialIDRef"].ToString();
                BankDetails = CompanyDetails["BankDetails"].ToString();

                CompanyAccountName = CompanyDetails["AccountName"].ToString();
                CompanyAccountNo = CompanyDetails["AccountNo"].ToString();


                description = invoiceData["Invoice_Desc"].ToString();
                sacCode = invoiceData["SAC"].ToString();
                taxPercent = invoiceData["Tax_Per"].ToString();
                basicAmount = Convert.ToDecimal(invoiceData["TotalBasicAmount"]).ToString("N2");
                taxableAmount = Convert.ToDecimal(invoiceData["TotalTaxable_Amount"]).ToString("N2");
                taxAmount = Convert.ToDecimal(invoiceData["Tax_Amount"]).ToString("N2");
                tcsAmount = invoiceData["TCSAmount"] != DBNull.Value ? Convert.ToDecimal(invoiceData["TCSAmount"]).ToString("N2") : "";
                totalAmountP = Convert.ToDecimal(invoiceData["SUM_Taxable_Amount"]).ToString("N2");
                amountToWords = CommonFunctions.AmountToWords(Convert.ToDecimal(totalAmountP), invoiceData["CurrencyCode"].ToString());
            }
            // Remove HTML tags
            string resultBankDetails = Regex.Replace(BankDetails, "<.*?>", string.Empty);

            // Decode HTML entities like &nbsp;, &amp;, etc.
            resultBankDetails = System.Net.WebUtility.HtmlDecode(resultBankDetails);
            string totalAmount = Convert.ToDecimal(ds.Tables[0].Rows[0]["ADTotalAmount"]).ToString("N2");
            var ItemDescriptionList = new List<ItemDescriptionModel>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                ItemDescriptionList.Add(new ItemDescriptionModel
                {
                    ItemDescription = row["Description"].ToString(),
                    TotalAmount = row["Amount"].ToString()
                });
            }
            var replacements = new Dictionary<string, string>
{
    // Main Invoice Section
    {"CompanyNameP", CompanyName},
    {"CompanyAddressP", CompAddress},
    {"CompanyStateCodeP", CompanyStateCode},
    {"CompanyPanP", CompanyPan},
    {"CompanyGSTINP", CompanyGSTIN},
    {"CompanyCINP", CompanyCIN},
    {"CompanyMSMEP", CompanyMSMEReg},
    {"CompanyLUTNoP", CompanyLUTNo},
    {"CompanyACKNoP", CompanyAckNo},
    {"CompanyACKDP", CompanyACKDate},
    {"CompanyIRNP", CompanyIRN},
    {"AgentAddressP", AgentAddress},{"AgentNameP", AgentName},
    {"StateCodeP", StateCode},
    {"GSTINP", GSTIN},
    {"ClientP", Client},
    {"BookedBy", BookedBy},
    {"YourRef", YourRef},
    {"DateP", Invoice_Date},
    {"InvoiceNoP", InvoiceNo},
    {"FileNoP", FileNo},
    {"CommercialIDP", CommercialIDRef},
    {"PlaceOfSupplyP", PlaceOfSupply},
    {"CurrencyP", Currency},
    {"DescriptionP", description},
    {"SACP", sacCode},
    {"TaxP", taxPercent},
    {"BasicAmtP", basicAmount},
    {"BasicAmtTP", basicAmount},
    {"taxableAmtP", taxableAmount},
    {"taxableAmtTP", taxableAmount},
    {"TaxAmountP", taxAmount},
    {"TaxAmountTP", taxAmount},
    {"TCSP", tcsAmount},
    {"TotalAmountP", totalAmountP},
    {"TotalAmountTP", totalAmountP},
    {"cP", Currency},
    {"AmountTPInWord", amountToWords},
    {"IGSTP", IGSTP},
    {"CGSTP", CGSTP},
    {"SGSTP", SGSTP},
    {"UTGSTP", UTGSTP},
    {"BankDetails", resultBankDetails},
    {"CompanyAccountNameP", CompanyAccountName},
    {"AccountNoP", CompanyAccountNo},
    {"IFSCCodeP", ""},
    {"SwiftCodeP", ""},
    {"BankNameP", ""},
    {"BankAddressP", ""},
    {"EmployeeP", EmployeeName},
    {"FooterAddressP", FooterAddress},
    {"InvoiceDesc", InvoiceDesc},
    {"Type_Of_Doc", Type_Of_Doc},

    // Addendum Section
    {"DateAd", ds.Tables[0].Rows[0]["Invoice_Date"].ToString()},
    {"InvoiceNoAd", ds.Tables[0].Rows[0]["InvoiceNumber"].ToString()},
    {"FileNoAd", ds.Tables[0].Rows[0]["FileCode"].ToString()},
    {"StateCodeAd", ds.Tables[0].Rows[0]["STATE"].ToString()},
    {"AgentGSTINADDE", "27AACCT4974D1Z8"},
    {"DescriptionAd", ds.Tables[0].Rows[0]["Description"].ToString()},
    {"AmountAd", ds.Tables[0].Rows[0]["Amount"].ToString()},
    {"TotalAmountAd", totalAmount},
    {"cAd", "INR"},
    {"AmountInWordsAD", CommonFunctions.AmountToWords(Convert.ToDecimal(totalAmount), invoiceData["CurrencyCode"].ToString())},
    {"cd", invoiceData["CurrencyCode"].ToString()}
};

            ConvertWordToPDF convertWordToPDF = new ConvertWordToPDF(_hostingEnvironment);
            return convertWordToPDF.CodeToConvertInvoiceWithoutTaxAddem(replacements, ItemDescriptionList);
        }
        private string GeneratePrintWithTaxUIANDAddendum(DataSet ds, DataSet dsTI)
        {
            DataRow CompanyDetails = dsTI.Tables[0].Rows[0];
            DataRow TaxInvoiceDetails = dsTI.Tables[1].Rows[0];
            DataRow invoiceData = dsTI.Tables[2].Rows[0];
            string Invoice_Date = "", InvoiceNo = "", FileNo = "", CommercialIDRef = "", PlaceOfSupply = "", Currency = "",
                AgentAddress = "", AgentName = "", StateCode = "", GSTIN = "", Client = "",
                EmployeeName = "", IGSTP = "", CGSTP = "", SGSTP = "", UTGSTP = "", BookedBy = "", YourRef = "";

            string CompanyName = "", CompAddress = "", CompanyStateCode = "", CompanyPan = "", CompanyGSTIN = "", CompanyCIN = "",
                CompanyMSMEReg = "", FooterAddress = "",
                CompanyLUTNo = "", CompanyAckNo = "", CompanyACKDate = "", CompanyIRN = "", CompanyAccountName = "", CompanyAccountNo = ""
                , description = "", sacCode = "", taxPercent = "", basicAmount = "", taxableAmount = "",
                taxAmount = "", tcsAmount = "", totalAmountP = "", amountToWords = "", BankDetails = "", TCS_Per = "", InvoiceDesc = "", Type_Of_Doc = "";
            if (dsTI.Tables[0].Rows.Count > 0 && dsTI.Tables[1].Rows.Count > 0 && dsTI.Tables[2].Rows.Count > 0)
            {
                Invoice_Date = TaxInvoiceDetails["Invoice_Date"].ToString();
                InvoiceNo = TaxInvoiceDetails["InvoiceNumber"].ToString();
                FileNo = TaxInvoiceDetails["FileCode"].ToString();
                InvoiceDesc = TaxInvoiceDetails["InvoiceDesc"].ToString();
                Type_Of_Doc = TaxInvoiceDetails["Type_Of_Doc"].ToString();

                PlaceOfSupply = TaxInvoiceDetails["StateCode"].ToString();
                Currency = TaxInvoiceDetails["Curr_Name"].ToString();
                AgentAddress = TaxInvoiceDetails["AgentAddress"].ToString(); AgentName = TaxInvoiceDetails["AgentName"].ToString();
                StateCode = TaxInvoiceDetails["StateCode"].ToString();
                GSTIN = TaxInvoiceDetails["GSTIN"].ToString();
                Client = TaxInvoiceDetails["CustomerName"].ToString();
                EmployeeName = TaxInvoiceDetails["EmployeeName"].ToString();
                BookedBy = TaxInvoiceDetails["BookedBy"].ToString();
                YourRef = TaxInvoiceDetails["YourRef"].ToString();

                IGSTP = TaxInvoiceDetails["IGST"].ToString();
                CGSTP = TaxInvoiceDetails["CGST"].ToString();
                SGSTP = TaxInvoiceDetails["SGST"].ToString();
                UTGSTP = TaxInvoiceDetails["UTGST"].ToString();

                CompanyName = CompanyDetails["CompanyName"].ToString();
                CompAddress = CompanyDetails["BranchAddress"].ToString();
                FooterAddress = CompanyDetails["Address"].ToString();
                CompanyStateCode = CompanyDetails["STATE"].ToString();
                CompanyPan = CompanyDetails["PAN"].ToString();
                CompanyGSTIN = CompanyDetails["GSTIN"].ToString() == "" ? "" : CompanyDetails["GSTIN"].ToString();
                CompanyCIN = CompanyDetails["CIN"].ToString();
                CompanyMSMEReg = CompanyDetails["MSMERegNo"].ToString();
                CompanyLUTNo = CompanyDetails["LUTNumber"].ToString();
                CompanyAckNo = CompanyDetails["ACKNo"].ToString();
                CompanyACKDate = CompanyDetails["ACKDate"].ToString();
                CompanyIRN = CompanyDetails["IRN"].ToString();

                CommercialIDRef = CompanyDetails["CommercialIDRef"].ToString();
                BankDetails = CompanyDetails["BankDetails"].ToString();

                CompanyAccountName = CompanyDetails["AccountName"].ToString();
                CompanyAccountNo = CompanyDetails["AccountNo"].ToString();


                description = invoiceData["Invoice_Desc"].ToString();
                sacCode = invoiceData["SAC"].ToString();
                taxPercent = invoiceData["Tax_Per"].ToString();
                TCS_Per = invoiceData["TCS_Per"].ToString();
                basicAmount = Convert.ToDecimal(invoiceData["TotalBasicAmount"]).ToString("N2");
                taxableAmount = Convert.ToDecimal(invoiceData["TotalTaxable_Amount"]).ToString("N2");
                taxAmount = Convert.ToDecimal(invoiceData["Tax_Amount"]).ToString("N2");
                tcsAmount = invoiceData["TCSAmount"] != DBNull.Value ? Convert.ToDecimal(invoiceData["TCSAmount"]).ToString("N2") : "";
                totalAmountP = Convert.ToDecimal(invoiceData["SUM_Taxable_Amount"]).ToString("N2");
                amountToWords = CommonFunctions.AmountToWords(Convert.ToDecimal(totalAmountP), invoiceData["CurrencyCode"].ToString());
            }
            // Remove HTML tags
            string resultBankDetails = Regex.Replace(BankDetails, "<.*?>", string.Empty);

            // Decode HTML entities like &nbsp;, &amp;, etc.
            resultBankDetails = System.Net.WebUtility.HtmlDecode(resultBankDetails);
            string totalAmount = Convert.ToDecimal(ds.Tables[0].Rows[0]["ADTotalAmount"]).ToString("N2");
            var ItemDescriptionList = new List<ItemDescriptionModel>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                ItemDescriptionList.Add(new ItemDescriptionModel
                {
                    ItemDescription = row["Description"].ToString(),
                    TotalAmount = row["Amount"].ToString()
                });
            }
            var replacements = new Dictionary<string, string>
{
    {"CompanyNameP", CompanyName},
    {"CompanyAddressP", CompAddress},
    {"CompanyStateCodeP", CompanyStateCode},
    {"CompanyPanP", CompanyPan},
    {"CompanyGSTINP", CompanyGSTIN},
    {"CompanyCINP", CompanyCIN},
    {"CompanyMSMEP", CompanyMSMEReg},
    {"CompanyLUTNoP", CompanyLUTNo},
    {"CompanyACKNoP", CompanyAckNo},
    {"CompanyACKDP", CompanyACKDate},
    {"CompanyIRNP", CompanyIRN},
    {"AgentAddressP", AgentAddress}, {"AgentNameP", AgentName},
    {"StateCodeP", StateCode},
    {"GSTINP", GSTIN},
    {"ClientP", Client},
    {"BookedBy", BookedBy},
    {"YourRef", YourRef},
    {"DateP", Invoice_Date},
    {"InvoiceNoP", InvoiceNo},
    {"FileNoP", FileNo},
    {"CommercialIDP", CommercialIDRef},
    {"PlaceOfSupplyP", PlaceOfSupply},
    {"CurrencyP", Currency},
    {"DescriptionP", description},
    {"SACP", sacCode},
    {"TaxP", taxPercent},
    {"TCS_Per", TCS_Per},
    {"BasicAmtP", basicAmount},
    {"BasicAmtTP", basicAmount},
    {"taxableAmtP", taxableAmount},
    {"taxableAmtTP", taxableAmount},
    {"TaxAmountP", taxAmount},
    {"TaxAmountTP", taxAmount},
    {"TCSP", tcsAmount},
    {"TotalAmountP", totalAmountP},
    {"TotalAmountTP", totalAmountP},
    {"cP", Currency},
    {"AmountTPInWord", amountToWords},
    {"IGSTP", IGSTP},
    {"CGSTP", CGSTP},
    {"SGSTP", SGSTP},
    {"UTGSTP", UTGSTP},
    {"BankDetails", resultBankDetails},
    {"CompanyAccountNameP", CompanyAccountName},
    {"AccountNoP", CompanyAccountNo},
    {"IFSCCodeP", ""},
    {"SwiftCodeP", ""},
    {"BankNameP", ""},
    {"BankAddressP", ""},
    {"EmployeeP", EmployeeName},
    {"FooterAddressP", FooterAddress},
    {"InvoiceDesc", InvoiceDesc},
    {"Type_Of_Doc", Type_Of_Doc},

    // Addendum Section
    {"DateAd", ds.Tables[0].Rows[0]["Invoice_Date"].ToString()},
    {"InvoiceNoAd", ds.Tables[0].Rows[0]["InvoiceNumber"].ToString()},
    {"FileNoAd", ds.Tables[0].Rows[0]["FileCode"].ToString()},
    {"StateCodeAd", ds.Tables[0].Rows[0]["STATE"].ToString()},
    {"AgentGSTINADDE", "27AACCT4974D1Z8"},
    {"DescriptionAd",ds.Tables[0].Rows[0]["Description"].ToString()},
    {"AmountAd", ds.Tables[0].Rows[0]["Amount"].ToString()},
    {"TotalAmountAd", totalAmount},
    {"cAd", "INR"},
    {"AmountInWordsAD", CommonFunctions.AmountToWords(Convert.ToDecimal(totalAmount), invoiceData["CurrencyCode"].ToString())},
    {"cd", "INR"}
};

            ConvertWordToPDF convertWordToPDF = new ConvertWordToPDF(_hostingEnvironment);
            return convertWordToPDF.CodeToConvertInvoiceForWithTaxAddendum(replacements, ItemDescriptionList);
        }

    }
}
