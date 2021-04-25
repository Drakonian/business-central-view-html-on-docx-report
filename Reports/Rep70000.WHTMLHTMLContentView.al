report 70000 "WHTML HTML Content View"
{
    WordLayout = './Reports/Layouts/ContentView.docx';
    Caption = 'Content View';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(ContentStorage; "WHTML Content Storage")
        {
            DataItemTableView = sorting("Entry No.");
            column(HTMLAsText; GetHTMLContentAsText())
            {

            }
        }
    }
}