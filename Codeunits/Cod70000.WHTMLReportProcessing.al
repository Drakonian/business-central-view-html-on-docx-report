codeunit 70000 "WHTML Report Processing"
{
    /// <summary>
    /// Convert report to valid HTML.
    /// </summary>
    /// <param name="ReportId">Report Id.</param>
    /// <returns>Return valid HTML report as text.</returns>
    procedure ConvertReportToValidHTML(ReportId: Integer): Text
    var
        TempBlob: Codeunit "Temp Blob";
        OutStreamVar: OutStream;
        InStreamVar: InStream;
        ReportAsHTML: Text;
    begin
        TempBlob.CreateOutStream(OutStreamVar);
        Report.SaveAs(ReportId, '', ReportFormat::Html, OutStreamVar);
        TempBlob.CreateInStream(InStreamVar);
        InStreamVar.ReadText(ReportAsHTML);
        exit(ReplaceInvalidHTMLCharacters(ReportAsHTML));
    end;



    procedure ReplaceInvalidHTMLCharacters(pText: Text): Text
    var
        lText: Text;
    begin
        lText := pText;
        lText := lText.Replace('&amp;', '&');
        lText := lText.Replace('&lt;', '<');
        lText := lText.Replace('&gt;', '>');
        lText := lText.Replace('&quot;', '"');
        lText := lText.Replace('&apos;', '''');
        exit(lText);
    end;

}