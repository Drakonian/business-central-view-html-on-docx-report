page 70000 "WHTML Content Storage"
{

    ApplicationArea = All;
    Caption = 'Content Storage';
    PageType = List;
    SourceTable = "WHTML Content Storage";
    UsageCategory = Lists;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            usercontrol(WHTMLConvertHtmlToDocx; "WHTML ConvertHtmlToDocx")
            {
                ApplicationArea = All;

                trigger ControlAddinReady()
                var
                    WHTMLReportMgt: Codeunit "WHTML Report Processing";
                begin
                    CurrPage.WHTMLConvertHtmlToDocx.LoadHtmlView(WHTMLReportMgt.ConvertReportToValidHTML(Report::"WHTML HTML Content View"));
                end;

                trigger ReturnDOCX(DOCXAsTxt: Text)
                begin
                    RunReportWithHTMLContent(DOCXAsTxt);
                end;
            }
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(WHTMLAddHTMLContent)
            {
                ApplicationArea = All;
                Image = Attach;
                Caption = 'Add Content';
                ToolTip = 'Add Content';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    UploadContent();
                end;
            }
            action(WHTMLViewHTMLContent)
            {
                ApplicationArea = All;
                Image = Report;
                Caption = 'View Content';
                ToolTip = 'View Content';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    ConvertReportToDocx();
                end;
            }
            action(WHTMLDownloadAsHtmlorDocx)
            {
                ApplicationArea = All;
                Image = SaveViewAs;
                Caption = 'Download';
                ToolTip = 'Download';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    DownloadAsHtmlorDocx();
                end;
            }
        }
    }
    local procedure UploadContent()
    var
        WHTMLReportMgt: Codeunit "WHTML Report Processing";
        FilePath: Text;
        InStreamVar: InStream;
        OutStreamVar: OutStream;
    begin
        if not UploadIntoStream(HTMLTitleLbl, '', '', FilePath, InStreamVar) then
            exit;
        Rec.Init();
        Rec.Description := CopyStr(FilePath, 1, MaxStrLen(Rec.Description));
        Rec."HTML Content".CreateOutStream(OutStreamVar);
        CopyStream(OutStreamVar, InStreamVar);
        Rec.Insert(true);
        CurrPage.WHTMLConvertHtmlToDocx.LoadHtmlView(WHTMLReportMgt.ConvertReportToValidHTML(Report::"WHTML HTML Content View"));
        CurrPage.Update(false);
    end;

    local procedure DownloadAsHtmlorDocx()
    var
        WHTMLReportMgt: Codeunit "WHTML Report Processing";
        TempBlob: Codeunit "Temp Blob";
        OutStreamVar: OutStream;
        InStreamVar: InStream;
        FileName: text;
        Selected: Integer;
    begin
        Selected := Dialog.STRMENU(OptionsLbl, 2, SelectionLbl);

        case Selected of
            1:
                begin
                    TempBlob.CreateOutStream(OutStreamVar);
                    OutStreamVar.WriteText(WHTMLReportMgt.ConvertReportToValidHTML(Report::"WHTML HTML Content View"));
                    TempBlob.CreateInStream(InStreamVar);
                    FileName := HTMLFileNameLbl;
                    DownloadFromStream(InStreamVar, '', '', '', FileName);
                end;
            2:
                CurrPage.WHTMLConvertHtmlToDocx.DownloadAsDocx(WHTMLReportMgt.ConvertReportToValidHTML(Report::"WHTML HTML Content View"), WordFileNameLbl);

        end;
    end;

    local procedure RunReportWithHTMLContent(Base64DOCX: Text)
    var
        CustomReportLayout: Record "Custom Report Layout";
        Base64Convert: Codeunit "Base64 Convert";
        OutStreamVar2: OutStream;
        DOCXAsTxt: Text;
    begin
        CustomReportLayout.Get(CustomReportLayout.InitBuiltInLayout(Report::"WHTML HTML Content View", CustomReportLayout.Type::Word.AsInteger()));
        CustomReportLayout.Layout.CreateOutStream(OutStreamVar2);
        DOCXAsTxt := Base64DOCX.Remove(StrPos(Base64DOCX, Base64DocxAliasLbl), StrLen(Base64DocxAliasLbl));
        Base64Convert.FromBase64(DOCXAsTxt, OutStreamVar2);
        CustomReportLayout.Modify();
        Commit();
        CustomReportLayout.RunCustomReport();
        CustomReportLayout.Delete();
    end;

    local procedure ConvertReportToDocx()
    var
        WHTMLReportMgt: Codeunit "WHTML Report Processing";
    begin
        CurrPage.WHTMLConvertHtmlToDocx.ConvertToDocx(WHTMLReportMgt.ConvertReportToValidHTML(Report::"WHTML HTML Content View"));
    end;

    var

        HTMLTitleLbl: Label 'HTML Content';
        OptionsLbl: Label 'HTML,Word';
        SelectionLbl: Label 'Download as';
        HTMLFileNameLbl: Label 'ContentViewAsHtml.html';
        WordFileNameLbl: Label 'ContentViewAsDocx.docx';
        Base64DocxAliasLbl: Label 'data:application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64,', Locked = true;
}
