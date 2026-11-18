using iText.IO.Font.Constants;
using iText.IO.Image;
using iText.Kernel.Font;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Kernel.Pdf.Canvas.Draw;
using iText.Kernel.Utils;
using iText.Layout;
using iText.Layout.Borders;
using iText.Layout.Element;
using iText.Layout.Properties;
using System.Data;
using static TamarindAstra_Operations.Model.Xomodel;

public class XoPdfGenerate
{
    private PdfFont _boldFont;
    private PdfFont _normalFont;

    public XoPdfGenerate()
    {
        _boldFont = PdfFontFactory.CreateFont(StandardFonts.HELVETICA_BOLD);
        _normalFont = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
    }

    public byte[] GenerateXOReportPDF(XOReportModel req, DataSet ds)
    {
        using (var stream = new MemoryStream())
        using (var writer = new PdfWriter(stream))
        using (var pdf = new PdfDocument(writer))
        using (var document = new Document(pdf, new PageSize(640f, 920f)))
        {
            _boldFont = PdfFontFactory.CreateFont(StandardFonts.HELVETICA_BOLD);
            _normalFont = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);

            DataRow company = ds.Tables[0].Rows[0];
            DataTable voucherTable = ds.Tables[1];
            DataRow voucher = voucherTable.Rows[0];

            AddHeader(document, req, company);
            AddGSTAndInstructions(document, company);
            AddHotelAndVoucherInfo(document, voucher);
            AddBookingTable(document, voucherTable);
            AddRemarksAndSpecialInstructions(document, req, voucher, company);
            AddAuthorizationSection(document, voucher);
            AddFooter(document, company);
            document.Close();
            return stream.ToArray();
        }
    }

    private void AddHeader(Document doc, XOReportModel req, DataRow company)
    {
        // Create table with proper column distribution for logo alignment
        Table headerTable = new Table(UnitValue.CreatePercentArray(new float[] { 50, 50 }))
            .UseAllAvailableWidth()
            .SetMarginBottom(5);

        // Left cell - empty or agent logo
        Cell leftCell = new Cell()
            .SetBorder(Border.NO_BORDER)
            .SetVerticalAlignment(VerticalAlignment.TOP);

        if (req.IncludeAgentLogo)
        {
            iText.Layout.Element.Image agentLogo = null;
            var logoObj = company.Table.Columns.Contains("AgentLogoImage") ? company["AgentLogoImage"] : null;

            if (logoObj != null && logoObj != DBNull.Value)
            {
                try
                {
                    byte[] imageBytes = Convert.FromBase64String(logoObj.ToString());
                    agentLogo = new iText.Layout.Element.Image(ImageDataFactory.Create(imageBytes));
                }
                catch { /* Ignore decode errors */ }
            }

            if (agentLogo == null)
            {
                string logoPath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Logo", "AirTravel.jpg");
                if (File.Exists(logoPath))
                    agentLogo = new iText.Layout.Element.Image(ImageDataFactory.Create(logoPath));
            }

            if (agentLogo != null)
            {
                agentLogo.ScaleToFit(80, 40);
                leftCell.Add(agentLogo);
            }
        }

        headerTable.AddCell(leftCell);

        // Right cell - company logo positioned at top right
        Cell rightCell = new Cell()
            .SetBorder(Border.NO_BORDER)
            .SetVerticalAlignment(VerticalAlignment.TOP)
            .SetTextAlignment(TextAlignment.RIGHT);

        if (req.IncludeCompanyLogo)
        {
            iText.Layout.Element.Image companyLogo = null;
            var logoObj = company.Table.Columns.Contains("CompanyLogoImage") ? company["CompanyLogoImage"] : null;

            if (logoObj != null && logoObj != DBNull.Value)
            {
                try
                {
                    byte[] imageBytes = Convert.FromBase64String(logoObj.ToString());
                    companyLogo = new iText.Layout.Element.Image(ImageDataFactory.Create(imageBytes));
                }
                catch { /* Ignore decode errors */ }
            }

            if (companyLogo == null)
            {
                string logoPath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Images", "Tamarind Tours Logo Small.jpg");
                if (File.Exists(logoPath))
                    companyLogo = new iText.Layout.Element.Image(ImageDataFactory.Create(logoPath));
            }

            if (companyLogo != null)
            {
                companyLogo.ScaleToFit(100, 50);
                companyLogo.SetHorizontalAlignment(HorizontalAlignment.RIGHT);
                rightCell.Add(companyLogo);
            }
        }

        headerTable.AddCell(rightCell);
        doc.Add(headerTable);

        // Company info centered below logos
        doc.Add(new Paragraph(req.CompanyName ?? "TAMARIND GLOBAL SERVICES PRIVATE LIMITED")
            .SetFont(_normalFont)
            .SetFontSize(9)
            .SetTextAlignment(TextAlignment.CENTER)
            .SetMarginTop(5)
            .SetMarginBottom(2));

        doc.Add(new Paragraph("Billing Address: " + (req.Address ?? company["Address"]?.ToString() ?? ""))
            .SetFont(_normalFont)
            .SetFontSize(8)
            .SetTextAlignment(TextAlignment.CENTER)
            .SetMarginTop(0)
            .SetMarginBottom(2));

        doc.Add(new Paragraph("Email: " + (req.Email ?? company["Email"]?.ToString() ?? "") +
                              "   Website: " + (req.Website ?? company["Website"]?.ToString() ?? ""))
            .SetFont(_normalFont)
            .SetFontSize(8)
            .SetTextAlignment(TextAlignment.CENTER)
            .SetMarginTop(0)
            .SetMarginBottom(5));
    }

    private void AddGSTAndInstructions(Document doc, DataRow company)
    {
        doc.Add(new Paragraph("GSTIN: " + (company["GSTIN"]?.ToString() ?? ""))
            .SetFont(_boldFont)
            .SetTextAlignment(TextAlignment.CENTER)
            .SetFontSize(9)
            .SetMarginTop(0)
            .SetMarginBottom(2));

        doc.Add(new Paragraph()
            .Add("PLEASE EMAIL YOUR TAX INVOICE TO: ")
            .Add(new Text(company["InvoiceEmail"]?.ToString() ?? "")
                .SetUnderline()
                .SetFont(_normalFont))
            .SetFont(_boldFont)
            .SetFontSize(8)
            .SetTextAlignment(TextAlignment.CENTER)
            .SetMarginTop(0)
            .SetMarginBottom(2));

        doc.Add(new Paragraph()
            .Add("PLEASE ENSURE THAT THE ")
            .Add(new Text("GST NUMBER AND BILLING ADDRESS MENTIONED ON THIS VOUCHER")
                .SetUnderline()
                .SetFont(_boldFont))
            .Add(" IS DISPLAYED")
            .SetFont(_boldFont)
            .SetFontSize(8)
            .SetTextAlignment(TextAlignment.CENTER)
            .SetMarginTop(0)
            .SetMarginBottom(0));

        doc.Add(new Paragraph("ON YOUR TAX INVOICE. THIS REQUIREMENT IS MANDATORY!")
            .SetFont(_boldFont)
            .SetFontSize(8)
            .SetTextAlignment(TextAlignment.CENTER)
            .SetMarginTop(0)
            .SetMarginBottom(8));
    }

    private void AddHotelAndVoucherInfo(Document doc, DataRow v)
    {
        // Create main container table with 2 columns - left for hotel info, right for voucher details
        Table mainTable = new Table(UnitValue.CreatePercentArray(new float[] { 60, 40 }))
            .SetWidth(UnitValue.CreatePercentValue(100))
            .SetMarginTop(5)
            .SetMarginBottom(5);

        // LEFT COLUMN - Hotel Information
        Paragraph hotelInfo = new Paragraph()
            .Add(new Text("The Duty Manager,\n").SetFont(_normalFont).SetFontSize(9))
            .Add(new Text((v["SupplierName"]?.ToString() ?? "") + "\n").SetFont(_normalFont).SetFontSize(9))
            .Add(new Text(v["SupplierAddress"]?.ToString() ?? "").SetFont(_normalFont).SetFontSize(9))
            .SetMarginTop(0)
            .SetMarginBottom(0);

        Cell leftCell = new Cell()
            .Add(hotelInfo)
            .SetBorder(Border.NO_BORDER)
            .SetVerticalAlignment(VerticalAlignment.TOP)
            .SetTextAlignment(TextAlignment.LEFT)
            .SetPaddingRight(10);

        // RIGHT COLUMN - Voucher Details (right-aligned)
        Table rightInfoTable = new Table(UnitValue.CreatePercentArray(new float[] { 50, 50 }))
            .SetWidth(UnitValue.CreatePercentValue(100));

        // Helper method to add right-aligned info rows
        void AddRightInfoRow(string label, string value)
        {
            rightInfoTable.AddCell(new Cell()
                .Add(new Paragraph(label).SetFont(_normalFont).SetFontSize(9))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT)
                .SetPaddingTop(1)
                .SetPaddingBottom(1)
                .SetPaddingLeft(0)
                .SetPaddingRight(2));

            rightInfoTable.AddCell(new Cell()
                .Add(new Paragraph(value).SetFont(_normalFont).SetFontSize(9))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT)
                .SetPaddingTop(1)
                .SetPaddingBottom(1)
                .SetPaddingLeft(2)
                .SetPaddingRight(0));
        }

        AddRightInfoRow("Date                  :", AsDateText(v["VoucherDate"]).Replace("-", " "));
        AddRightInfoRow("Voucher No       :", SafeStr(v["VoucherNo"]));
        AddRightInfoRow("File No               :", SafeStr(v["FileNo"]));
        AddRightInfoRow("No Of Pax          :", SafeStr(v["NoOfGuests"]));
        AddRightInfoRow("Membership No :", SafeStr(v["MembershipNo"]));

        Cell rightCell = new Cell()
            .Add(rightInfoTable)
            .SetBorder(Border.NO_BORDER)
            .SetVerticalAlignment(VerticalAlignment.TOP)
            .SetTextAlignment(TextAlignment.RIGHT);

        mainTable.AddCell(leftCell);
        mainTable.AddCell(rightCell);
        doc.Add(mainTable);

        // Add remaining fields below the main table, left-aligned
        doc.Add(new Paragraph("Phone                :  " + SafeStr(v["HotelPhone"]))
            .SetFont(_normalFont)
            .SetFontSize(9)
            .SetTextAlignment(TextAlignment.LEFT)
            .SetMarginTop(0)
            .SetMarginBottom(0));

        doc.Add(new Paragraph("Confirmed By    :  " + SafeStr(v["ConfirmedBy"]))
            .SetFont(_normalFont)
            .SetFontSize(9)
            .SetTextAlignment(TextAlignment.LEFT)
            .SetMarginTop(0)
            .SetMarginBottom(0));

        doc.Add(new Paragraph("Name Of Guest :  " + SafeStr(v["GuestName"]))
            .SetFont(_normalFont)
            .SetFontSize(9)
            .SetTextAlignment(TextAlignment.LEFT)
            .SetMarginTop(0)
            .SetMarginBottom(5));
    }

    private void AddRemarksAndSpecialInstructions(Document doc, XOReportModel req, DataRow v, DataRow dr)
    {
        doc.Add(new Paragraph("Special Instruction : " + SafeStr(v["SpecialInstruction"]))
            .SetFont(_boldFont)
            .SetFontSize(10)
            .SetTextAlignment(TextAlignment.LEFT)
            .SetMarginTop(10)
            .SetMarginBottom(4));

        string combined = SafeStr(dr["IsDirectPayment"]);

        Table box = new Table(1)
            .SetWidth(UnitValue.CreatePercentValue(100))
            .SetMarginTop(5);

        Cell cell = new Cell()
            .Add(new Paragraph(combined)
                .SetFont(_boldFont)
                .SetFontSize(9)
                .SetTextAlignment(TextAlignment.LEFT)) // Changed from CENTER to LEFT
            .SetPadding(3) // Reduced from 8 to 3
            .SetBorder(new SolidBorder(1))
            .SetMinHeight(20) // Reduced from 30 to 20
            .SetTextAlignment(TextAlignment.LEFT) // Changed from CENTER to LEFT
            .SetVerticalAlignment(VerticalAlignment.MIDDLE); // Added for better vertical positioning

        box.AddCell(cell);
        doc.Add(box);
        doc.Add(new Paragraph("\n"));
    }
    private void AddAuthorizationSection(Document doc, DataRow v)
    {
        // Create a 7-column table with specified relative widths
        Table table = new Table(UnitValue.CreatePercentArray(new float[] { 10, 20, 10, 20, 10, 20, 20 }))
            .SetWidth(UnitValue.CreatePercentValue(100));

        // Headers
        table.AddCell(CreateAuthCell("Arrival", false, true, TextAlignment.LEFT).SetUnderline());
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("Departure", false, true, TextAlignment.LEFT).SetUnderline());
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("Authorised Signatory", false, true, TextAlignment.RIGHT));

        // Dates only (time not required)
        table.AddCell(CreateAuthCell("Date :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(AsDateText(v["ArrivalDate"]).Replace("-", " "), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("Date :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(AsDateText(v["DepartureDate"]).Replace("-", " "), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));

        table.AddCell(CreateAuthCell("From :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["ArrivalFrom"]), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("To   :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["DepartureTo"]), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));

        table.AddCell(CreateAuthCell("By   :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["ArrivalBy"]), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("By   :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["DepartureBy"]), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["FileHandlerName"]), false, false, TextAlignment.RIGHT));

        table.AddCell(CreateAuthCell("Time :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["FromTime"]), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("Time :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["ToTime"]), false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell("Mobile No :", false, false, TextAlignment.LEFT));
        table.AddCell(CreateAuthCell(SafeStr(v["FileHandlerMobile"]), false, false, TextAlignment.RIGHT));

        doc.Add(table);
        doc.Add(new LineSeparator(new SolidLine()).SetPaddingTop(1)
            .SetPaddingBottom(1).SetMarginTop(0).SetMarginBottom(0));
    }

    private void AddFooter(Document doc, DataRow company)
    {
        string corporateId = company["CorporateIdentityNumber"]?.ToString() ?? "";

        Table table = new Table(new float[] { 1, 1 })
            .SetWidth(UnitValue.CreatePercentValue(100))
            .SetBorder(Border.NO_BORDER)
            .SetMarginTop(20);

        table.AddCell(new Cell()
            .Add(new Paragraph("This is a computer generated document and does not require Signature.")
                .SetFont(_normalFont)
                .SetFontSize(8))
            .SetBorder(Border.NO_BORDER)
            .SetTextAlignment(TextAlignment.LEFT)
            .SetVerticalAlignment(VerticalAlignment.MIDDLE));

        table.AddCell(new Cell()
            .Add(new Paragraph("Corporate Identity Number: " + corporateId)
                .SetFont(_normalFont)
                .SetFontSize(8))
            .SetBorder(Border.NO_BORDER)
            .SetTextAlignment(TextAlignment.RIGHT)
            .SetVerticalAlignment(VerticalAlignment.MIDDLE));

        doc.Add(table);
    }

    private Cell CreateAuthCell(string text, bool isBold, bool useBaseFont, TextAlignment alignment)
    {
        PdfFont font = isBold ? _boldFont : _normalFont;
        Paragraph p = new Paragraph(text)
            .SetFont(font)
            .SetFontSize(9)
            .SetMarginTop(0)
            .SetMarginBottom(0)
            .SetMultipliedLeading(0.9f);
        return new Cell()
            .Add(p)
            .SetBorder(Border.NO_BORDER)
            .SetPaddingTop(0)
            .SetPaddingBottom(0)
            .SetTextAlignment(alignment)
            .SetMinHeight(18)
            .SetMarginTop(0)
            .SetMarginBottom(0);
    }

    private void AddBookingTable(Document doc, DataTable data)
    {
        if (data == null || data.Rows.Count == 0) return;

        string currentXOType = "";
        Table table = null;

        foreach (DataRow row in data.Rows)
        {
            string xoType = SafeStr(row["XoType"]);
            if (xoType != currentXOType)
            {
                if (table != null)
                {
                    doc.Add(table);
                    doc.Add(new Paragraph(" ").SetMarginBottom(5));
                }
                currentXOType = xoType;
                doc.Add(new LineSeparator(new SolidLine()).SetMarginTop(0).SetMarginBottom(0));
                table = CreateTableForXOType(xoType);
            }
            if (table != null)
                AddDataRowToTable(table, row, xoType);
        }

        if (table != null)
        {
            doc.Add(table);
            doc.Add(new LineSeparator(new SolidLine()).SetMarginTop(0).SetMarginBottom(0));
        }
    }
     private Table CreateTableForXOType(string xoType)
    {
        (string[] Headers, float[] Widths)? cfg = xoType switch
        {
            "H" => (new[] { "Check In", "Check Out", "Room Type", "Sgl", "Dbl", "Twin", "Ex Bed\nAdult", "Ex Bed\nChild", "Child No Bed", "Plan" },
                    new float[] { 12f, 12f, 25f, 6f, 6f, 6f, 8f, 8f, 8f, 9f }),
            "G" => (new[] { "Date", "Guide Service", "Language", "Guides" },
                    new float[] { 15f, 55f, 15f, 15f }),
            "S" => (new[] { "Date", "Special Service", "Adult", "Child", "Unit" },
                    new float[] { 15f, 45f, 15f, 15f, 10f }),
            "M" => (new[] { "Date", "Monument Service", "Nationality", "Adult", "Child" },
                    new float[] { 15f, 45f, 15f, 12.5f, 12.5f }),
            "T" => (new[] { "Date", "Transport Service", "Vehicle Type", "Vehicles" },
                    new float[] { 15f, 50f, 20f, 15f }),
            // Optimized column widths for XO type A
            "A" => (new[] { "Date", "MOT", "Name", "Class", "Sectors", "Adult", "Child" },
         new float[] { 15f, 15f, 14f, 20f, 12f, 9f, 9f }),

            _ => null
        };

        if (cfg == null)
            return null;

        Table table = new Table(UnitValue.CreatePercentArray(cfg.Value.Widths))
            .SetWidth(UnitValue.CreatePercentValue(100))
            .SetBorder(Border.NO_BORDER);

        foreach (var header in cfg.Value.Headers)
            table.AddHeaderCell(CreateSubHeaderCell(header));

        return table;
    }

    private Cell CreateSubHeaderCell(string text)
    {
        return new Cell()
            .Add(new Paragraph(text)
                .SetFont(_boldFont)
                .SetFontSize(9)
                .SetTextAlignment(TextAlignment.CENTER)
                .SetMarginTop(0)
                .SetMarginBottom(0))
            .SetPadding(3)
            .SetMinHeight(25)
            .SetBorder(Border.NO_BORDER)
            .SetBorderBottom(new SolidBorder(1))
            .SetTextAlignment(TextAlignment.CENTER)
            .SetVerticalAlignment(VerticalAlignment.MIDDLE);
    }

    private Cell CreateCellWithCustomPadding(string text, bool center = false, float paddingLeft = 5, float paddingRight = 5)
    {
        var cell = new Cell()
            .Add(new Paragraph(text)
                .SetFont(_normalFont)
                .SetFontSize(9)
                .SetMarginTop(0)
                .SetMarginBottom(0))
            .SetPaddingLeft(paddingLeft)
            .SetPaddingRight(paddingRight)
            .SetPaddingTop(3)
            .SetPaddingBottom(3)
            .SetBorder(Border.NO_BORDER)
            .SetMinHeight(20);

        if (center)
            cell.SetTextAlignment(TextAlignment.CENTER);
        else
            cell.SetTextAlignment(TextAlignment.LEFT);

        return cell;
    }
     private void AddDataRowToTable(Table table, DataRow r, string xoType)
    {
        string Val(string col)
        {
            var v = SafeStr(r[col]);
            if (string.IsNullOrWhiteSpace(v) || v == "0") return "--";
            return v;
        }

        switch (xoType)
        {
            case "H":
                // Dates and RoomType left-aligned
                table.AddCell(CreateCellWithCustomPadding(AsDateText(r["CheckIn"]).Replace("-", " "), false, 8, 5));
                table.AddCell(CreateCellWithCustomPadding(AsDateText(r["CheckOut"]).Replace("-", " "), false, 8, 5));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["RoomType"]), false, 8, 5));

                // Numeric fields centered
                table.AddCell(CreateCellWithCustomPadding(Val("Sgl"), true, 2, 2));
                table.AddCell(CreateCellWithCustomPadding(Val("Dbl"), true, 2, 2));
                table.AddCell(CreateCellWithCustomPadding(Val("twin"), true, 2, 2));
                table.AddCell(CreateCellWithCustomPadding(Val("EBA"), true, 2, 2));
                table.AddCell(CreateCellWithCustomPadding(Val("EBC"), true, 2, 2));
                table.AddCell(CreateCellWithCustomPadding(Val("CNB"), true, 2, 2));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Plan"]), true, 2, 2));
                break;
            case "G":
                table.AddCell(CreateCellWithCustomPadding(AsDateText(r["CheckIn"]).Replace("-", " ")));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Services"])));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Language"]), true));
                table.AddCell(CreateCellWithCustomPadding(Val("Count"), true));
                break;
            case "S":
                table.AddCell(CreateCellWithCustomPadding(AsDateText(r["CheckIn"]).Replace("-", " ")));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Services"])));
                table.AddCell(CreateCellWithCustomPadding(Val("Adult"), true));
                table.AddCell(CreateCellWithCustomPadding(Val("Child"), true));
                table.AddCell(CreateCellWithCustomPadding(Val("Unit"), true));
                break;
            case "M":
                table.AddCell(CreateCellWithCustomPadding(AsDateText(r["CheckIn"]).Replace("-", " ")));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Services"])));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Nationality"]), true));
                table.AddCell(CreateCellWithCustomPadding(Val("Adult"), true));
                table.AddCell(CreateCellWithCustomPadding(Val("Child"), true));
                break;
            case "T":
                table.AddCell(CreateCellWithCustomPadding(AsDateText(r["CheckIn"]).Replace("-", " ")));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Services"])));
                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["VehicleCategory"]), true));
                table.AddCell(CreateCellWithCustomPadding(Val("Count"), true));
                break;

            case "A": // Air/MOT XO format with correct column mapping
                      // Date - left aligned, from CheckIn field (08 Sept 2025)
                table.AddCell(CreateCellWithCustomPadding(AsDateText(r["CheckIn"]).Replace("-", " "), true, 3, 2));

                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["MOT"]), true, 3, 2));


                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Name"]), true, 3, 2));


                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Class"]), true, 3, 2));

                table.AddCell(CreateCellWithCustomPadding(SafeStr(r["Sectors"]), true, 3, 2));

                table.AddCell(CreateCellWithCustomPadding(Val("Adult"), true, 1, 1));

                table.AddCell(CreateCellWithCustomPadding(Val("Child"), true, 1, 1));

                break;

        }

        string remarks = SafeStr(r["XoRemarks"]);
        if (!string.IsNullOrWhiteSpace(remarks))
        {
            Cell remarkCell = new Cell(1, table.GetNumberOfColumns())
                .Add(new Paragraph(remarks)
                    .SetFont(_normalFont)
                    .SetFontSize(9)
                    .SetTextAlignment(TextAlignment.LEFT))
                .SetPaddingLeft(15)
                .SetPaddingRight(15)
                .SetPaddingTop(2)
                .SetPaddingBottom(3)
                .SetBorder(Border.NO_BORDER)
                .SetMarginTop(0)
                .SetMarginBottom(0);
            table.AddCell(remarkCell);
        }
    }
    private string SafeStr(object obj)
    {
        return obj == null || obj == DBNull.Value ? "" : obj.ToString();
    }

    private string AsDateText(object obj)
    {
        if (obj == null || obj == DBNull.Value) return "";
        if (DateTime.TryParse(obj.ToString(), out var date))
            return date.ToString("dd-MMM-yyyy");
        return obj.ToString();
    }

    public byte[] MergePDFs(List<byte[]> pdfFiles)
    {
        using (var memoryStream = new MemoryStream())
        {
            using (var pdfDoc = new PdfDocument(new PdfWriter(memoryStream)))
            {
                var merger = new PdfMerger(pdfDoc);

                foreach (var pdf in pdfFiles)
                {
                    using (var srcStream = new MemoryStream(pdf))
                    using (var srcDoc = new PdfDocument(new PdfReader(srcStream)))
                    {
                        merger.Merge(srcDoc, 1, srcDoc.GetNumberOfPages());
                    }
                }
            }
            return memoryStream.ToArray();
        }
    }
}