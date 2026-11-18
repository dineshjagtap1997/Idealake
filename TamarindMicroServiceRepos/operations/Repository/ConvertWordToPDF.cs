using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Diagnostics;
using System.Text;
using TamarindAstra_Operations.Model;
using TamarindAstra_Operations.Repository;

class ConvertWordToPDF
{
    private readonly IWebHostEnvironment _hostingEnvironment;
    public ConvertWordToPDF(IWebHostEnvironment hostingEnvironment)
    {
        _hostingEnvironment = hostingEnvironment;
    }
    public string CodeToConvertInvoiceForWithTaxAddendum(Dictionary<string, string> replacements, List<ItemDescriptionModel> itemDescriptions)
    {
        string outputPath = @_hostingEnvironment.WebRootPath + "\\Uploads\\Invoice\\Invoice_" + replacements["InvoiceNoP"] + ".pdf";
        GenerateInvoicePDF invoicePDF = new GenerateInvoicePDF();
        invoicePDF.GenerateInvoiceForWithTaxAddendum(outputPath, replacements, itemDescriptions);
        return outputPath;
    }

    public string CodeToConvertInvoiceWithTax(Dictionary<string, string> replacements)
    {
        //string inputPath = @_hostingEnvironment.WebRootPath + "\\Uploads\\Invoice\\Invoice_VariableWithTax.docx";

        string outputPath = @_hostingEnvironment.WebRootPath + "\\Uploads\\Invoice\\Invoice_" + replacements["InvoiceNoP"] + ".pdf";

        // Copy to avoid overwriting original
        //File.Copy(inputPath, outputPath, true);


        //ReplacePlaceholders(outputPath, replacements);
        GenerateInvoicePDF invoicePDF = new GenerateInvoicePDF();
        invoicePDF.GenerateInvoiceForWithTax(outputPath, replacements);
        //string pdfPath = ConvertDocxToPdf("Invoice_" + replacements["#InvoiceNoP"]);
        //if (File.Exists(outputPath))
        //{
        //    File.Delete(outputPath);
        //}
        return outputPath;
    }
    public string CodeToConvertInvoiceWithoutTax(Dictionary<string, string> replacements)
    {
        //string inputPath = @_hostingEnvironment.WebRootPath + "\\Uploads\\Invoice\\Invoice_VariableWithoutTax.docx";

        string outputPath = @_hostingEnvironment.WebRootPath + "\\Uploads\\Invoice\\Invoice_" + replacements["InvoiceNoP"] + ".pdf";
        GenerateInvoicePDF invoicePDF = new GenerateInvoicePDF();
        invoicePDF.GenerateInvoiceForWithoutTax(outputPath, replacements);
        return outputPath;
    }
    public string CodeToConvertInvoiceWithoutTaxAddem(Dictionary<string, string> replacements,List<ItemDescriptionModel> itemDescriptions)
    {
        string outputPath = @_hostingEnvironment.WebRootPath + "\\Uploads\\Invoice\\Invoice_" + replacements["InvoiceNoP"] + ".pdf";
        GenerateInvoicePDF invoicePDF = new GenerateInvoicePDF();
        invoicePDF.GenerateInvoiceForWithoutTaxAddendum(outputPath, replacements,itemDescriptions);
        return outputPath;
    }

    static void ReplacePlaceholders(string filePath, Dictionary<string, string> replacements)
    {
        using (var doc = WordprocessingDocument.Open(filePath, true))
        {
            var body = doc.MainDocumentPart.Document.Body;

            foreach (var para in body.Descendants<Paragraph>())
            {
                ReplaceInParagraph(para, replacements);
            }

            doc.MainDocumentPart.Document.Save();
        }
    }

    static void ReplaceInParagraph(Paragraph paragraph, Dictionary<string, string> replacements)
    {
        // Flatten all runs to single text
        var runs = paragraph.Elements<Run>().ToList();
        var allText = new StringBuilder();
        var runMap = new List<(Run run, Text text, int start, int length)>();
        int currentPos = 0;

        foreach (var run in runs)
        {
            var textElement = run.GetFirstChild<Text>();
            if (textElement != null)
            {
                var text = textElement.Text;
                runMap.Add((run, textElement, currentPos, text.Length));
                allText.Append(text);
                currentPos += text.Length;
            }
        }

        string fullText = allText.ToString();
        bool replaced = false;

        foreach (var pair in replacements)
        {
            if (fullText.Contains(pair.Key))
            {
                fullText = fullText.Replace(pair.Key, pair.Value);
                replaced = true;
            }
        }

        if (!replaced) return;

        // Clear old runs
        foreach (var (run, text, _, _) in runMap)
        {
            text.Text = "";
        }

        // Assign updated text to runs
        int pos = 0;
        foreach (var (run, text, _, length) in runMap)
        {
            int remaining = fullText.Length - pos;
            if (remaining <= 0) break;

            int take = Math.Min(length, remaining);
            text.Text = fullText.Substring(pos, take);
            pos += take;
        }

        // Add overflow text to last run if any
        if (pos < fullText.Length)
        {
            var lastText = runMap.Last().text;
            lastText.Text += fullText.Substring(pos);
        }
    }
    public string ConvertDocxToPdf(string fileName)
    {
        string uploadsPath = Path.Combine(_hostingEnvironment.WebRootPath, "Uploads", "Invoice");
        string inputPath = Path.Combine(uploadsPath, $"{fileName}.docx");
        string outputPathPdf = Path.Combine(uploadsPath, $"{fileName}.pdf");
        string sofficePath = @"C:\Program Files\LibreOffice\program\soffice.exe";

        if (!File.Exists(inputPath))
            throw new FileNotFoundException("Input DOCX file not found.", inputPath);

        if (!File.Exists(sofficePath))
            throw new FileNotFoundException("LibreOffice CLI not found. Check soffice.exe path.", sofficePath);

        var process = new Process();
        process.StartInfo.FileName = sofficePath;
        process.StartInfo.Arguments = $"--headless --convert-to pdf --outdir \"{uploadsPath}\" \"{inputPath}\"";
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.RedirectStandardError = true;
        process.StartInfo.CreateNoWindow = true;

        process.Start();

        string output = process.StandardOutput.ReadToEnd();
        string error = process.StandardError.ReadToEnd();

        process.WaitForExit();

        Console.WriteLine("LibreOffice output: " + output);
        Console.WriteLine("LibreOffice error: " + error);

        if (File.Exists(outputPathPdf))
        {
            Console.WriteLine("Conversion successful: " + outputPathPdf);
            return outputPathPdf;
        }
        else
        {
            throw new Exception($"PDF conversion failed.\nOutput: {output}\nError: {error}");
        }
    }
}
