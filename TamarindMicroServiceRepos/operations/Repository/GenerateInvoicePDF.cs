using iText.IO.Font.Constants;
using iText.IO.Image;
using iText.Kernel.Font;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Borders;
using iText.Layout.Element;
using iText.Layout.Properties;
using TamarindAstra_Operations.Model;
namespace TamarindAstra_Operations.Repository
{
    public class GenerateInvoicePDF
    {
        private readonly PdfFont _boldFont;
        private readonly PdfFont _normalFont;

        public GenerateInvoicePDF()
        {
            _boldFont = PdfFontFactory.CreateFont(StandardFonts.HELVETICA_BOLD);
            _normalFont = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
        }
        public void GenerateInvoiceForWithTax(string outputPath, Dictionary<string, string> replacements)
        {
            PdfWriter writer = new PdfWriter(outputPath);
            PdfDocument pdf = new PdfDocument(writer);
            PageSize customSize = new PageSize(740f, 720f);
            Document document = new Document(pdf, customSize);

            // Set smaller margins to maximize space
            document.SetMargins(20, 20, 20, 20);

            AddMainInvoiceSectionForWithTax(document, replacements);

            document.Close();
        }
        public void GenerateInvoiceForWithoutTax(string outputPath, Dictionary<string, string> replacements)
        {
            PdfWriter writer = new PdfWriter(outputPath);
            PdfDocument pdf = new PdfDocument(writer);
            PageSize customSize = new PageSize(740f, 720f);
            Document document = new Document(pdf, customSize);

            // Set smaller margins to maximize space
            document.SetMargins(20, 20, 20, 20);

            AddMainInvoiceSectionForWithoutTax(document, replacements);

            document.Close();
        }
        public void GenerateInvoiceForWithoutTaxAddendum(string outputPath, Dictionary<string, string> replacements, List<ItemDescriptionModel> itemDescriptions)
        {
            PdfWriter writer = new PdfWriter(outputPath);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);
            PageSize invoicePageSize = new PageSize(790f, 720f);
            pdf.SetDefaultPageSize(invoicePageSize);
            document.SetMargins(20, 20, 20, 20);
            AddMainInvoiceSectionForWithoutTax(document, replacements);
            PageSize addendumPageSize = new PageSize(680f, 650f);
            pdf.AddNewPage(addendumPageSize);
            document.SetMargins(20, 20, 20, 20);
            AddAddendumSection(document, replacements, itemDescriptions);
            document.Close();
        }
        public void GenerateInvoiceForWithTaxAddendum(string outputPath, Dictionary<string, string> replacements, List<ItemDescriptionModel> itemDescriptions)
        {
            PdfWriter writer = new PdfWriter(outputPath);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);
            PageSize invoicePageSize = new PageSize(790f, 720f);
            pdf.SetDefaultPageSize(invoicePageSize);
            document.SetMargins(20, 20, 20, 20);
            AddMainInvoiceSectionForWithTax(document, replacements);
            PageSize addendumPageSize = new PageSize(680f, 650f);
            pdf.AddNewPage(addendumPageSize);
            document.SetMargins(20, 20, 20, 20);
            AddAddendumSection(document, replacements, itemDescriptions);
            document.Close();
        }

        private void AddMainInvoiceSectionForWithTax(Document document, Dictionary<string, string> replacements)
        {
            Table headerTable = new Table(new float[] { 260, 1 })
    .SetWidth(UnitValue.CreatePercentValue(70))
    .SetBorder(Border.NO_BORDER);

            // Company info cell (company name and multiline address)
            Cell companyInfoCell = new Cell()
     .Add(
         new Paragraph()
             .Add(new Text(replacements["CompanyNameP"] + "\n").SetFont(_boldFont).SetFontSize(10))
             .Add(new Text(replacements["CompanyAddressP"] + "\n")
                  .SetFont(_normalFont).SetFontSize(8))
             .SetTextAlignment(TextAlignment.LEFT)
     )
     .SetBorder(Border.NO_BORDER);

            // Logo cell (add your logo here)
            Cell logoCell = new Cell().SetBorder(Border.NO_BORDER);
            AddCompanyLogo(logoCell); // Assuming your AddCompanyLogo method accepts a Cell

            headerTable.AddCell(companyInfoCell);
            headerTable.AddCell(logoCell);

            document.Add(headerTable);

            //     // 4-column table
            //     Table companyDetailsTable = new Table(new float[] { 20, 30, 20, 30 })
            //.SetWidth(UnitValue.CreatePercentValue(35))
            //.SetHorizontalAlignment(HorizontalAlignment.LEFT)
            //.SetBorder(Border.NO_BORDER);

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("State :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyStateCodeP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER)); // empty cells, span two columns

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("PAN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyPanP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("GSTIN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyGSTINP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("CIN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyCINP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("MSMEReg :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyMSMEP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("LUTNo :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyLUTNoP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     // ACKNo and ACKDate on same row, one per pair (col1: label, col2: value, col3: label, col4: value)
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("ACKNo :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyACKNoP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("| ACKDate :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyACKDP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));

            //     // IRN, spans all 4 columns
            //     companyDetailsTable.AddCell(new Cell(1, 4).Add(new Paragraph("IRN :"+ replacements["CompanyIRNP"]).SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));

            //     // Add the table to the document
            //     document.Add(companyDetailsTable);

            // 4-column table: tighter column widths
            Table companyDetailsTable = new Table(new float[] { 20, 12, 20, 12 })
                .SetWidth(UnitValue.CreatePercentValue(35))
                .SetHorizontalAlignment(HorizontalAlignment.LEFT)
                .SetBorder(Border.NO_BORDER);

            // Helper to create label cells
            Cell LabelCell(string text) => new Cell()
                .Add(new Paragraph(text).SetFont(_boldFont).SetFontSize(8)
                    .SetMultipliedLeading(1.5f)
                    .SetMarginTop(0).SetMarginBottom(0))
                .SetBorder(Border.NO_BORDER)
                .SetPadding(0)
                .SetPaddingRight(0);

            // Helper to create value cells
            Cell ValueCell(string text) => new Cell()
                .Add(new Paragraph(text).SetFont(_normalFont).SetFontSize(8)
                    .SetMultipliedLeading(1.5f)
                    .SetMarginTop(0).SetMarginBottom(0))
                .SetBorder(Border.NO_BORDER)
                .SetPadding(0)
                .SetPaddingLeft(0);

            // Rows
            companyDetailsTable.AddCell(LabelCell("State :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyStateCodeP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("PAN :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyPanP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("Tax Reg. No. :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyGSTINP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("CIN :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyCINP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("MSMEReg :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyMSMEP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("LUTNo :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyLUTNoP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("ACKNo :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyACKNoP"]));
            companyDetailsTable.AddCell(LabelCell("ACKDate :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyACKDP"]));

            companyDetailsTable.AddCell(new Cell(1, 4)
                .Add(new Paragraph("IRN :" + replacements["CompanyIRNP"])
                    .SetFont(_boldFont)
                    .SetFontSize(8)
                    .SetMultipliedLeading(0.9f)
                    .SetMarginTop(0).SetMarginBottom(0))
                .SetBorder(Border.NO_BORDER)
                .SetPadding(0));

            document.Add(companyDetailsTable);



            Table invoiceDetails = new Table(new float[] { 250, 250, 105 })
                .SetWidth(UnitValue.CreatePercentValue(100))
                .SetHorizontalAlignment(HorizontalAlignment.LEFT)
                .SetBorder(new SolidBorder(1));
            // Create a cell with agent address text that spans 3 rows vertically
            Cell agentAddressCell = new Cell(3, 1) // 3 rows span, 1 column
                .Add(new Paragraph(replacements["AgentNameP"]).SetFont(_normalFont).SetFontSize(8))
                .Add(new Paragraph(replacements["AgentAddressP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT)
                .SetPadding(5);

            // Add the spanning cell in the first column of the first row
            invoiceDetails.AddCell(agentAddressCell);

            // Since this cell spans 3 rows, skip adding cells to the first column in the next 2 rows
            // Add cells for second and third columns for row 1
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.CENTER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Date", replacements["DateP"]));

            // Row 2: No first column cell here since it's spanned, add second and third columns
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph(replacements["Type_Of_Doc"]).SetFont(_boldFont).SetFontSize(11))
                .SetBorder(Border.NO_BORDER)
                //.SetTextAlignment(TextAlignment.CENTER).SetPaddingRight(60));
                .SetTextAlignment(TextAlignment.CENTER).SetPaddingLeft(5));
            invoiceDetails.AddCell(CreateThirdColumnCell("Invoice No.", replacements["InvoiceNoP"]));

            // Row 3: No first column cell here either, add second and third columns
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.CENTER));
            invoiceDetails.AddCell(CreateThirdColumnCell("File No", replacements["FileNoP"]));


            // Row 4: Empty | Empty | Commercial Ref
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Booked By ", replacements["BookedBy"]));

            // Row 5: State Code | Empty | Place of Supply
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("StateCode :" + replacements["PlaceOfSupplyP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Place of Supply", replacements["PlaceOfSupplyP"]));

            // Row 6: GSTIN | Empty | Currency
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("Tax Reg. No. :" + replacements["GSTINP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Currency", replacements["CurrencyP"]));

            // Row 7: Client Info | Empty | Empty
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("Guest Name : " + replacements["ClientP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.RIGHT).SetBorder(Border.NO_BORDER));

            document.Add(invoiceDetails);

            //document.Add(new Paragraph()
            //    .AddTabStops(new TabStop(PageSize.A4.GetWidth() / 2, TabAlignment.CENTER))
            //    .Add(new Text($"Booked By:{replacements["BookedBy"]}").SetFont(_normalFont).SetFontSize(10))
            //    .Add(new Tab())
            //    .Add(new Text($"Your Ref:{replacements["YourRef"]}").SetFont(_normalFont).SetFontSize(10))
            //    .SetTextAlignment(TextAlignment.LEFT));
            document.Add(new Paragraph()
           //.Add(new Text($"Booked By: {replacements["BookedBy"]}").SetFont(_normalFont).SetFontSize(10))
           //.Add(new Text("              ")) // small space between fields
           .Add(new Text($"Your Ref: {replacements["YourRef"]}").SetFont(_normalFont).SetFontSize(10))
           .SetTextAlignment(TextAlignment.LEFT));

            Table itemsTable;

            if (replacements["TCS_Per"] != "0.00%")
            {
                itemsTable = new Table(new float[] { 3, 2, 2, 2, 2, 2, 2, 2 })
                .SetWidth(UnitValue.CreatePercentValue(100));
            }
            else
            {
                itemsTable = new Table(new float[] { 3, 2, 2, 2, 2, 2, 2 })
               .SetWidth(UnitValue.CreatePercentValue(100));
            }

            itemsTable.AddHeaderCell(CreateNormalCellForHeader("Description"));
            itemsTable.AddHeaderCell(CreateNormalCell("HSN/SAC"));
            itemsTable.AddHeaderCell(CreateNormalCell("Tax %"));
            itemsTable.AddHeaderCell(CreateNormalCell("Basic Amt"));
            itemsTable.AddHeaderCell(CreateNormalCell("Taxable Amt"));
            itemsTable.AddHeaderCell(CreateNormalCell("Tax Amount"));

            if (replacements["TCS_Per"] != "0.00%")
                itemsTable.AddHeaderCell(CreateNormalCell("TCS @" + replacements["TCS_Per"]));

            itemsTable.AddHeaderCell(CreateNormalCell("Amount"));

            itemsTable.AddCell(CreateNormalCellForHeader(replacements["InvoiceDesc"]));
            itemsTable.AddCell(CreateNormalCell(replacements["SACP"]));
            itemsTable.AddCell(CreateNormalCell(replacements["TaxP"]));
            itemsTable.AddCell(CreateNormalCell(replacements["BasicAmtP"]));
            itemsTable.AddCell(CreateNormalCell(replacements["taxableAmtP"]));
            itemsTable.AddCell(CreateNormalCell(replacements["TaxAmountP"]));

            if (replacements["TCS_Per"] != "0.00%")
                itemsTable.AddCell(CreateNormalCell(replacements["TCSP"]));

            itemsTable.AddCell(CreateNormalCell(replacements["TotalAmountP"]));

            itemsTable.AddCell(new Cell(1, 3).Add(new Paragraph("")));
            itemsTable.AddCell(CreateNormalCell(replacements["BasicAmtTP"]));
            itemsTable.AddCell(CreateNormalCell(replacements["taxableAmtTP"]));
            itemsTable.AddCell(CreateNormalCell(replacements["TaxAmountTP"]));

            if (replacements["TCS_Per"] != "0.00%")
                itemsTable.AddCell(CreateNormalCell(replacements["TCSP"]));

            itemsTable.AddCell(CreateNormalCell(replacements["TotalAmountTP"]));

            document.Add(itemsTable);

            Table totalTable = new Table(new float[] { 70, 30 })
                .SetWidth(UnitValue.CreatePercentValue(100))
                .SetBorder(Border.NO_BORDER);

            totalTable.AddCell(new Cell()
                .Add(new Paragraph("Total: " + replacements["AmountTPInWord"]).SetFont(_normalFont).SetFontSize(10))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            totalTable.AddCell(new Cell()
                .Add(new Paragraph("E & O.E.").SetFont(_normalFont).SetFontSize(10))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.RIGHT));

            document.Add(totalTable);

            Table taxTable = new Table(4, false).SetWidth(UnitValue.CreatePercentValue(100));
            taxTable.AddCell(CreateNormalCell("IGST").SetTextAlignment(TextAlignment.RIGHT));
            taxTable.AddCell(CreateNormalCell("CGST").SetTextAlignment(TextAlignment.RIGHT));
            taxTable.AddCell(CreateNormalCell("SGST").SetTextAlignment(TextAlignment.RIGHT));
            taxTable.AddCell(CreateNormalCell("UTGST").SetTextAlignment(TextAlignment.RIGHT));
            taxTable.AddCell(CreateNormalCell(replacements["IGSTP"]).SetTextAlignment(TextAlignment.RIGHT));
            taxTable.AddCell(CreateNormalCell(replacements["CGSTP"]).SetTextAlignment(TextAlignment.RIGHT));
            taxTable.AddCell(CreateNormalCell(replacements["SGSTP"]).SetTextAlignment(TextAlignment.RIGHT));
            taxTable.AddCell(CreateNormalCell(replacements["UTGSTP"]).SetTextAlignment(TextAlignment.RIGHT));

            document.Add(taxTable.SetWidth(250));

            Table bankAndSignTable = new Table(new float[] { 450, 15 })
                .SetWidth(UnitValue.CreatePercentValue(100))
                .SetBorder(Border.NO_BORDER);

            Cell bankDetailsCell = new Cell().Add(new Paragraph("Account Name: " + replacements["CompanyAccountNameP"]))
                .Add(new Paragraph("Account No: " + replacements["AccountNoP"]))
                .Add(new Paragraph(replacements["BankDetails"]))
                .SetFont(_normalFont)
                .SetFontSize(8)
                .SetBorder(Border.NO_BORDER)
                .SetVerticalAlignment(VerticalAlignment.MIDDLE);

            Cell signatureCell = new Cell()
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.RIGHT)
                .SetVerticalAlignment(VerticalAlignment.MIDDLE);

            AddCompanySignatureLogo(signatureCell);

            signatureCell.Add(new Paragraph("For TAMARIND GLOBAL SERVICES PVT LTD")
                .SetFont(_normalFont)
                .SetUnderline()
                .SetFontSize(9)
                .SetMarginTop(2)
                .SetTextAlignment(TextAlignment.RIGHT));
            signatureCell.Add(new Paragraph("Clint Dsouza")
                .SetFont(_normalFont)
                .SetFontSize(9)
                .SetMarginTop(2)
                .SetTextAlignment(TextAlignment.RIGHT));

            bankAndSignTable.AddCell(bankDetailsCell);
            bankAndSignTable.AddCell(signatureCell);

            document.Add(bankAndSignTable);
            document.Add(new Paragraph().Add(""));
            document.Add(new Paragraph().Add(""));

            document.Add(new Paragraph()
                .Add("Notes:\n")
                .SetFont(_normalFont)
                .Add(new Text("1. Please share a copy of the remittance advice at receivables@tamarindglobal.com while remitting payment to our account.\n")
                    .SetFont(_normalFont).SetFontSize(8))
                //.Add(new Text("2. TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)\n\n\n\n")
                //    .SetFont(_boldFont).SetFontSize(8))
                .SetFontSize(8));

            document.Add(new Paragraph()
                .Add("Tax Payable under RCM : No | Original for Recipient | Disputes subject to Mumbai Jurisdiction only.| This is a computer generated document and does not require Signature\n")
                .Add(replacements["FooterAddressP"])
                .SetFont(_normalFont)
                .SetFontSize(8));
        }
        private void AddMainInvoiceSectionForWithoutTax(Document document, Dictionary<string, string> replacements)
        {
            Table headerTable = new Table(new float[] { 260, 1 })
    .SetWidth(UnitValue.CreatePercentValue(70))
    .SetBorder(Border.NO_BORDER);

            // Company info cell (company name and multiline address)
            Cell companyInfoCell = new Cell()
     .Add(
         new Paragraph()
             .Add(new Text(replacements["CompanyNameP"] + "\n").SetFont(_boldFont).SetFontSize(10))
             .Add(new Text(replacements["CompanyAddressP"] + "\n")
                  .SetFont(_normalFont).SetFontSize(8))
             .SetTextAlignment(TextAlignment.LEFT)
     )
     .SetBorder(Border.NO_BORDER);

            // Logo cell (add your logo here)
            Cell logoCell = new Cell().SetBorder(Border.NO_BORDER);
            AddCompanyLogo(logoCell); // Assuming your AddCompanyLogo method accepts a Cell

            headerTable.AddCell(companyInfoCell);
            headerTable.AddCell(logoCell);

            document.Add(headerTable);

            //     // 4-column table
            //     Table companyDetailsTable = new Table(new float[] { 20, 30, 20, 30 })
            //.SetWidth(UnitValue.CreatePercentValue(35))
            //.SetHorizontalAlignment(HorizontalAlignment.LEFT)
            //.SetBorder(Border.NO_BORDER);

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("State :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyStateCodeP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER)); // empty cells, span two columns

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("PAN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyPanP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("GSTIN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyGSTINP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("CIN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyCINP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("MSMEReg :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyMSMEP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("LUTNo :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyLUTNoP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            //     // ACKNo and ACKDate on same row, one per pair (col1: label, col2: value, col3: label, col4: value)
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("ACKNo :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyACKNoP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph("| ACKDate :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            //     companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyACKDP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));

            //     // IRN, spans all 4 columns
            //     companyDetailsTable.AddCell(new Cell(1, 4).Add(new Paragraph("IRN :" + replacements["CompanyIRNP"]).SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));

            //     // Add the table to the document
            //     document.Add(companyDetailsTable);

            // 4-column table: tighter column widths for closer columns
            Table companyDetailsTable = new Table(new float[] { 20, 12, 20, 12 })
                .SetWidth(UnitValue.CreatePercentValue(35))
                .SetHorizontalAlignment(HorizontalAlignment.LEFT)
                .SetBorder(Border.NO_BORDER);

            // Helper to create label cells with tight vertical and horizontal spacing
            Cell LabelCell(string text) => new Cell()
                .Add(new Paragraph(text)
                    .SetFont(_boldFont)
                    .SetFontSize(8)
                    .SetMultipliedLeading(1.5f)       // tighter line spacing
                    .SetMarginTop(0)
                    .SetMarginBottom(0))
                .SetBorder(Border.NO_BORDER)
                .SetPadding(0)
                .SetPaddingRight(0);                // no right padding for close spacing

            // Helper to create value cells with tight vertical and horizontal spacing
            Cell ValueCell(string text) => new Cell()
                .Add(new Paragraph(text)
                    .SetFont(_normalFont)
                    .SetFontSize(8)
                    .SetMultipliedLeading(1.5f)
                    .SetMarginTop(0)
                    .SetMarginBottom(0))
                .SetBorder(Border.NO_BORDER)
                .SetPadding(0)
                .SetPaddingLeft(0);                 // no left padding

            // Add rows with label and value cells
            companyDetailsTable.AddCell(LabelCell("State :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyStateCodeP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0)); // empty span

            companyDetailsTable.AddCell(LabelCell("PAN :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyPanP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("Tax Reg. No. :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyGSTINP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("CIN :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyCINP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("MSMEReg :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyMSMEP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            companyDetailsTable.AddCell(LabelCell("LUTNo :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyLUTNoP"]));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER).SetPadding(0));

            // For ACKNo and ACKDate on same row with close spacing
            companyDetailsTable.AddCell(LabelCell("ACKNo :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyACKNoP"]));
            companyDetailsTable.AddCell(LabelCell("ACKDate :"));
            companyDetailsTable.AddCell(ValueCell(replacements["CompanyACKDP"]));

            // IRN spanning all 4 columns with reduced vertical spacing
            companyDetailsTable.AddCell(new Cell(1, 4)
                .Add(new Paragraph("IRN :" + replacements["CompanyIRNP"])
                    .SetFont(_boldFont)
                    .SetFontSize(8)
                    .SetMultipliedLeading(0.9f)
                    .SetMarginTop(0)
                    .SetMarginBottom(0))
                .SetBorder(Border.NO_BORDER)
                .SetPadding(0));

            // Add the table to the document
            document.Add(companyDetailsTable);



            Table invoiceDetails = new Table(new float[] { 250, 250, 105 })
                .SetWidth(UnitValue.CreatePercentValue(100))
                .SetHorizontalAlignment(HorizontalAlignment.LEFT)
                .SetBorder(new SolidBorder(1));
            // Create a cell with agent address text that spans 3 rows vertically
            Cell agentAddressCell = new Cell(3, 1) // 3 rows span, 1 column
               .Add(new Paragraph("\n"))
               .Add(new Paragraph(replacements["AgentNameP"]).SetFont(_normalFont).SetFontSize(8))
               .Add(new Paragraph(replacements["AgentAddressP"]).SetFont(_normalFont).SetFontSize(8))
               .SetBorder(Border.NO_BORDER)
               .SetTextAlignment(TextAlignment.LEFT)
               .SetPadding(5);

            // Add the spanning cell in the first column of the first row
            invoiceDetails.AddCell(agentAddressCell);

            // Since this cell spans 3 rows, skip adding cells to the first column in the next 2 rows
            // Add cells for second and third columns for row 1
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.CENTER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Date", replacements["DateP"]));

            // Row 2: No first column cell here since it's spanned, add second and third columns
            //invoiceDetails.AddCell(new Cell()
            //    .Add(new Paragraph(replacements["Type_Of_Doc"]).SetFont(_boldFont).SetFontSize(11))
            //    .SetBorder(Border.NO_BORDER)
            //    .SetTextAlignment(TextAlignment.CENTER).SetPaddingRight(60));

            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph(replacements["Type_Of_Doc"]).SetFont(_boldFont).SetFontSize(11))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.CENTER).SetPaddingLeft(5));

            invoiceDetails.AddCell(CreateThirdColumnCell("Invoice No.", replacements["InvoiceNoP"]));

            // Row 3: No first column cell here either, add second and third columns
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.CENTER));
            invoiceDetails.AddCell(CreateThirdColumnCell("File No", replacements["FileNoP"]));


            // Row 4: Empty | Empty | Commercial Ref
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Booked By", replacements["BookedBy"]));

            // Row 5: State Code | Empty | Place of Supply
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("StateCode :" + replacements["PlaceOfSupplyP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Place of Supply", replacements["PlaceOfSupplyP"]));

            // Row 6: GSTIN | Empty | Currency
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("Tax Reg. No. :").SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Currency", replacements["CurrencyP"]));

            // Row 7: Guest Name Info | Empty | Empty
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("Guest Name : " + replacements["ClientP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.RIGHT).SetBorder(Border.NO_BORDER));

            document.Add(invoiceDetails);

            //document.Add(new Paragraph()
            //    .AddTabStops(new TabStop(PageSize.A4.GetWidth() / 2, TabAlignment.CENTER))
            //    .Add(new Text("Booked By: TEST").SetFont(_normalFont).SetFontSize(10))
            //    .Add(new Tab())
            //    .Add(new Text("Your Ref:").SetFont(_normalFont).SetFontSize(10))
            //    .SetTextAlignment(TextAlignment.LEFT));
            document.Add(new Paragraph()
           //.Add(new Text($"Booked By: {replacements["BookedBy"]}").SetFont(_normalFont).SetFontSize(10))
           //.Add(new Text("              ")) // small space between fields
           .Add(new Text($"Your Ref: {replacements["YourRef"]}").SetFont(_normalFont).SetFontSize(10))
           .SetTextAlignment(TextAlignment.LEFT));

            Table itemsTable = new Table(new float[] { 2, 2 })
     .SetWidth(UnitValue.CreatePercentValue(100));

            // Header row (Row 1)
            itemsTable.AddHeaderCell(CreateNormalCellForHeader("Description"));
            itemsTable.AddHeaderCell(CreateNormalCell("Amount"));

            // Detail row 1 (Row 2)
            itemsTable.AddCell(CreateNormalCellForHeader(replacements["InvoiceDesc"]));
            itemsTable.AddCell(CreateNormalCell(replacements["TotalAmountP"]));

            // Detail row 2 (Row 3)
            itemsTable.AddCell(CreateNormalCell(replacements["DescriptionP"])); // or use any other appropriate key/value
            itemsTable.AddCell(CreateNormalCell(replacements["TotalAmountTP"])); // or use any other appropriate key/value

            document.Add(itemsTable);

            Table totalTable = new Table(new float[] { 70, 30 })
                .SetWidth(UnitValue.CreatePercentValue(100))
                .SetBorder(Border.NO_BORDER);

            totalTable.AddCell(new Cell()
                .Add(new Paragraph("Total: " + replacements["AmountTPInWord"]).SetFont(_normalFont).SetFontSize(10))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            totalTable.AddCell(new Cell()
                .Add(new Paragraph("E & O.E.").SetFont(_normalFont).SetFontSize(10))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.RIGHT));

            document.Add(totalTable);

            Table bankAndSignTable = new Table(new float[] { 450, 15 })
                .SetWidth(UnitValue.CreatePercentValue(100))
                .SetBorder(Border.NO_BORDER);

            Cell bankDetailsCell = new Cell().Add(new Paragraph("Account Name: " + replacements["CompanyAccountNameP"]))
                .Add(new Paragraph("Account No: " + replacements["AccountNoP"]))
                .Add(new Paragraph(replacements["BankDetails"]))
                .SetFont(_normalFont)
                .SetFontSize(8)
                .SetBorder(Border.NO_BORDER)
                .SetVerticalAlignment(VerticalAlignment.MIDDLE);

            Cell signatureCell = new Cell()
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.RIGHT)
                .SetVerticalAlignment(VerticalAlignment.MIDDLE);

            AddCompanySignatureLogo(signatureCell);

            signatureCell.Add(new Paragraph("For TAMARIND GLOBAL SERVICES PVT LTD")
                .SetFont(_normalFont)
                .SetUnderline()
                .SetFontSize(9)
                .SetMarginTop(2)
                .SetTextAlignment(TextAlignment.RIGHT));
            signatureCell.Add(new Paragraph("Clint Dsouza")
                .SetFont(_normalFont)
                .SetFontSize(9)
                .SetMarginTop(2)
                .SetTextAlignment(TextAlignment.RIGHT));

            bankAndSignTable.AddCell(bankDetailsCell);
            bankAndSignTable.AddCell(signatureCell);

            document.Add(bankAndSignTable);
            document.Add(new Paragraph().Add(""));
            document.Add(new Paragraph().Add(""));
            document.Add(new Paragraph()
                .Add("Notes:\n")
                .SetFont(_normalFont)
                .Add(new Text("1. Please share a copy of the remittance advice at receivables@tamarindglobal.com while remitting payment to our account.\n")
                    .SetFont(_normalFont).SetFontSize(8))
                //.Add(new Text("2. TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)\n\n\n\n")
                //    .SetFont(_boldFont).SetFontSize(8))
                .SetFontSize(8));

            document.Add(new Paragraph()
                .Add("Tax Payable under RCM : No | Original for Recipient | Disputes subject to Mumbai Jurisdiction only.| This is a computer generated document and does not require Signature\n")
                .Add(replacements["FooterAddressP"])
                .SetFont(_normalFont)
                .SetFontSize(8));
        }
        private void AddCompanyLogo(Cell logoCell)
        {
            string logoPath = System.IO.Path.Combine(
                Directory.GetCurrentDirectory(),
                "wwwroot", "Uploads", "Documents", "Images", "Tamarind Tours Logo Small.jpg"
            );

            try
            {
                ImageData imageData = ImageDataFactory.Create(logoPath);
                Image logo = new Image(imageData)
                    .SetWidth(150f)
                    //.SetHeight(60f)
                    .SetHorizontalAlignment(HorizontalAlignment.CENTER);

                logoCell.Add(logo)
                    .SetHorizontalAlignment(HorizontalAlignment.CENTER)
                    .SetVerticalAlignment(VerticalAlignment.MIDDLE)
                    .SetPaddingBottom(10f);
            }
            catch
            {
                logoCell.Add(new Paragraph("[TAMARIND GLOBAL SERVICES LOGO]")
                    .SetTextAlignment(TextAlignment.CENTER)
                    .SetFont(_boldFont)
                    .SetFontColor(iText.Kernel.Colors.ColorConstants.GRAY)
                    .SetFontSize(10)
                    .SetMarginBottom(10f));
            }
        }

        private void AddCompanySignatureLogo(Cell logoCell)
        {
            string logoPath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Images", "Signature2.jpg");
            try
            {
                ImageData imageData = ImageDataFactory.Create(logoPath);
                Image logo = new Image(imageData)
                    .ScaleToFit(70f, 40f)
                    .SetHorizontalAlignment(HorizontalAlignment.RIGHT)
                    .SetMarginRight(2);

                logoCell.Add(logo)
                    .SetVerticalAlignment(VerticalAlignment.BOTTOM)
                    .SetPaddingTop(2);
            }
            catch
            {
                logoCell.Add(new Paragraph("[SIGNATURE]")
                    .SetFont(_normalFont)
                    .SetFontSize(8)
                    .SetTextAlignment(TextAlignment.RIGHT)
                    .SetPaddingTop(5));
            }
        }

        private Cell CreateNormalCellForHeader(string text)
        {
            return new Cell().Add(new Paragraph(text)
                .SetFont(_normalFont)
                .SetFontSize(9));
        }

        //private Cell CreateThirdColumnCell(string label, string value)
        //{
        //    Table innerTable = new Table(new float[] { 70, 140 })
        //        .SetWidth(UnitValue.CreatePercentValue(70))
        //        .SetBorder(Border.NO_BORDER);

        //    innerTable.AddCell(
        //        new Cell().Add(new Paragraph(label)
        //            .SetFont(_normalFont)
        //            .SetFontSize(8)
        //            .SetTextAlignment(TextAlignment.LEFT))   // Changed to LEFT
        //        .SetBorder(Border.NO_BORDER)
        //    );
        //    innerTable.AddCell(
        //        new Cell().Add(new Paragraph(": " + value)
        //            .SetFont(_normalFont)
        //            .SetFontSize(8)
        //            .SetTextAlignment(TextAlignment.LEFT))
        //        .SetBorder(Border.NO_BORDER)
        //    );

        //    return new Cell()
        //        .Add(innerTable)
        //        .SetBorder(Border.NO_BORDER)
        //        .SetPaddingLeft(40)
        //        .SetPaddingRight(1)
        //        .SetMinWidth(100); // Adjust as needed
        //}

        private Cell CreateThirdColumnCell(string label, string value)
        {
            // Three columns: label, colon, value.
            Table innerTable = new Table(new float[] { 90, 10, 110 }) // Adjust widths as needed
                .SetWidth(UnitValue.CreatePercentValue(100))
                .SetBorder(Border.NO_BORDER);

            // Label, right aligned
            innerTable.AddCell(
                new Cell()
                    .Add(new Paragraph(label)
                        .SetFont(_normalFont)
                        .SetFontSize(8)
                        .SetTextAlignment(TextAlignment.RIGHT))
                    .SetBorder(Border.NO_BORDER)
            );

            // Colon, centered or right
            innerTable.AddCell(
                new Cell()
                    .Add(new Paragraph(":")
                        .SetFont(_normalFont)
                        .SetFontSize(8)
                        .SetTextAlignment(TextAlignment.CENTER))
                    .SetBorder(Border.NO_BORDER)
            );

            // Value, left aligned
            innerTable.AddCell(
                new Cell()
                    .Add(new Paragraph(value)
                        .SetFont(_normalFont)
                        .SetFontSize(8)
                        .SetTextAlignment(TextAlignment.LEFT))
                    .SetBorder(Border.NO_BORDER)
            );

            return new Cell()
                .Add(innerTable)
                .SetBorder(Border.NO_BORDER)
                .SetPaddingLeft(5)
                .SetMinWidth(120); // Adjust as needed
        }


        private void AddAddendumSection(Document document, Dictionary<string, string> replacements, List<ItemDescriptionModel> itemDescriptions)
        {
            Table headerTable = new Table(new float[] { 260, 1 })
  .SetWidth(UnitValue.CreatePercentValue(70))
  .SetBorder(Border.NO_BORDER);

            // Company info cell (company name and multiline address)
            Cell companyInfoCell = new Cell()
     .Add(
         new Paragraph()
             .Add(new Text(replacements["CompanyNameP"] + "\n").SetFont(_boldFont).SetFontSize(10))
             .Add(new Text(replacements["CompanyAddressP"] + "\n")
                  .SetFont(_normalFont).SetFontSize(8))
             .SetTextAlignment(TextAlignment.LEFT)
     )
     .SetBorder(Border.NO_BORDER);

            // Logo cell (add your logo here)
            Cell logoCell = new Cell().SetBorder(Border.NO_BORDER);
            AddCompanyLogo(logoCell); // Assuming your AddCompanyLogo method accepts a Cell

            headerTable.AddCell(companyInfoCell);
            headerTable.AddCell(logoCell);

            document.Add(headerTable);

            // 4-column table
            Table companyDetailsTable = new Table(new float[] { 20, 30, 20, 30 })
       .SetWidth(UnitValue.CreatePercentValue(35))
       .SetHorizontalAlignment(HorizontalAlignment.LEFT)
       .SetBorder(Border.NO_BORDER);

            companyDetailsTable.AddCell(new Cell().Add(new Paragraph("State :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyStateCodeP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER)); // empty cells, span two columns

            companyDetailsTable.AddCell(new Cell().Add(new Paragraph("PAN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyPanP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            companyDetailsTable.AddCell(new Cell().Add(new Paragraph("Tax Reg. No. :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyGSTINP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            companyDetailsTable.AddCell(new Cell(1, 2).SetBorder(Border.NO_BORDER));

            companyDetailsTable.AddCell(new Cell().Add(new Paragraph("CIN :").SetFont(_boldFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            companyDetailsTable.AddCell(new Cell().Add(new Paragraph(replacements["CompanyCINP"]).SetFont(_normalFont).SetFontSize(8)).SetBorder(Border.NO_BORDER));
            // Add the table to the document
            document.Add(companyDetailsTable);

            Table invoiceDetails = new Table(new float[] { 250, 185, 105 })
                 .SetWidth(UnitValue.CreatePercentValue(100))
                 .SetHorizontalAlignment(HorizontalAlignment.LEFT)
                 .SetBorder(new SolidBorder(1));
            // Create a cell with agent address text that spans 3 rows vertically
            Cell agentAddressCell = new Cell(3, 1) // 3 rows span, 1 column
                .Add(new Paragraph(replacements["AgentNameP"]).SetFont(_normalFont).SetFontSize(8))
                .Add(new Paragraph(replacements["AgentAddressP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT)
                .SetPadding(5);

            // Add the spanning cell in the first column of the first row
            invoiceDetails.AddCell(agentAddressCell);

            // Since this cell spans 3 rows, skip adding cells to the first column in the next 2 rows
            // Add cells for second and third columns for row 1
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.CENTER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Date", replacements["DateP"]));

            //// Row 2: No first column cell here since it's spanned, add second and third columns
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(CreateThirdColumnCell("Invoice No.", replacements["InvoiceNoP"]));

            // Row 3: No first column cell here either, add second and third columns
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.CENTER));
            invoiceDetails.AddCell(CreateThirdColumnCell("File No", replacements["FileNoP"]));


            // Row 4: Empty | Empty | Commercial Ref
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER).SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));

            // Row 5: State Code | Empty | Place of Supply
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("StateCode :" + replacements["PlaceOfSupplyP"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell()
               .Add(new Paragraph("ADDENDUM").SetFont(_boldFont).SetFontSize(11))
               .SetBorder(Border.NO_BORDER)
               .SetTextAlignment(TextAlignment.CENTER).SetPaddingRight(60));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.RIGHT).SetBorder(Border.NO_BORDER));


            // Row 6: GSTIN | Empty | Currency
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("Agent Tax Reg. No. :" + replacements["AgentGSTINADDE"]).SetFont(_normalFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("NOT A TAX INVOICE").SetUnderline().SetFontSize(11))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.CENTER).SetPaddingRight(60));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));

            // Row 7: Client Info | Empty | Empty
            invoiceDetails.AddCell(new Cell()
                .Add(new Paragraph("Guest Name : " + replacements["ClientP"]).SetFont(_boldFont).SetFontSize(8))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.CENTER).SetBorder(Border.NO_BORDER));
            invoiceDetails.AddCell(new Cell().Add(new Paragraph("")).SetTextAlignment(TextAlignment.RIGHT).SetBorder(Border.NO_BORDER));

            document.Add(invoiceDetails);
            Table bookedRefTable = new Table(UnitValue.CreatePercentArray(new float[] { 1, 1, 1 }))
     .SetWidth(UnitValue.CreatePercentValue(100))
     .SetHorizontalAlignment(HorizontalAlignment.LEFT);

            //// First column: Booked By (left border only)
            //bookedRefTable.AddCell(new Cell()
            //    .Add(new Paragraph("Booked By: " + replacements["BookedBy"])
            //        .SetFont(_normalFont)
            //        .SetFontSize(10))
            //    .SetTextAlignment(TextAlignment.LEFT)
            //    .SetBorder(Border.NO_BORDER)
            //    .SetBorderLeft(new SolidBorder(1)));

            // Second column: Your Ref (no border)
            bookedRefTable.AddCell(new Cell()
                .Add(new Paragraph("Your Ref: " + replacements["YourRef"])
                    .SetFont(_normalFont)
                    .SetFontSize(10))
                .SetTextAlignment(TextAlignment.LEFT)
                .SetBorder(Border.NO_BORDER));

            // Third column: blank, no border
            bookedRefTable.AddCell(new Cell()
                .Add(new Paragraph("")));

            document.Add(bookedRefTable);
            Table addendumTable = new Table(new float[] { 490, 241 })  // 2 columns
                .SetWidth(UnitValue.CreatePercentValue(100)) // Optional: adjust width as needed
                .SetHorizontalAlignment(HorizontalAlignment.LEFT);
            // Header Row 1: Description | Amount
            addendumTable.AddHeaderCell(new Cell().Add(new Paragraph("Description").SetFont(_boldFont).SetFontSize(9)));
            addendumTable.AddHeaderCell(new Cell().Add(new Paragraph("Amount").SetFont(_boldFont).SetFontSize(9)));
            foreach (var dt in itemDescriptions)
            {
                addendumTable.AddCell(new Cell().Add(new Paragraph(dt.ItemDescription).SetFont(_normalFont).SetFontSize(9)));
                addendumTable.AddCell(new Cell().Add(new Paragraph(dt.TotalAmount).SetFont(_normalFont).SetFontSize(9)));
            }
            // Data Row 2

            addendumTable.AddCell(new Cell().Add(new Paragraph("").SetFont(_normalFont).SetFontSize(9)));
            addendumTable.AddCell(new Cell().Add(new Paragraph(replacements["TotalAmountAd"]).SetFont(_normalFont).SetFontSize(9)));

            document.Add(addendumTable);


            Table bankAndSignTable = new Table(new float[] { 250, 150 })
               .SetWidth(UnitValue.CreatePercentValue(100))
               .SetBorder(Border.NO_BORDER);

            Cell bankDetailsCell = new Cell().Add(new Paragraph("Total: " + replacements["AmountInWordsAD"]).SetFont(_normalFont).SetFontSize(10))
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.LEFT);

            Cell signatureCell = new Cell()
                .SetBorder(Border.NO_BORDER)
                .SetTextAlignment(TextAlignment.RIGHT)
                .SetVerticalAlignment(VerticalAlignment.MIDDLE);

            AddCompanySignatureLogo(signatureCell);

            signatureCell.Add(new Paragraph("For TAMARIND GLOBAL SERVICES PVT LTD")
                .SetFont(_normalFont)
                .SetUnderline()
                .SetFontSize(9)
                .SetMarginTop(2)
                .SetTextAlignment(TextAlignment.RIGHT));
            signatureCell.Add(new Paragraph("Clint Dsouza")
                .SetFont(_normalFont)
                .SetFontSize(9)
                .SetMarginTop(2)
                .SetTextAlignment(TextAlignment.RIGHT));

            bankAndSignTable.AddCell(bankDetailsCell);
            bankAndSignTable.AddCell(signatureCell);

            document.Add(bankAndSignTable);

            document.Add(new Paragraph("Corporate Office: 6th Floor, 601, AJ House, Marol Maroshi Road, Andheri (E), Mumbai -- 400059")
                .SetFont(_normalFont)
                .SetFontSize(10));
        }

        private void AddInvoiceDetailRow(Table table, string label, string value)
        {
            table.AddCell(CreateBoldCell(label));
            table.AddCell(CreateNormalCell(value));
        }

        private Cell CreateBoldCell(string text)
        {
            return new Cell().Add(new Paragraph(text)
                .SetFont(_boldFont)
                .SetFontSize(10));
        }

        private Cell CreateNormalCell(string text)
        {
            return new Cell().Add(new Paragraph(text)
                .SetFont(_normalFont)
                .SetFontSize(9)
                .SetTextAlignment(TextAlignment.RIGHT))
                .SetTextAlignment(TextAlignment.RIGHT);
        }
    }
}


