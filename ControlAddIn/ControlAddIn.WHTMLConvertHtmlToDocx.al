controladdin "WHTML ConvertHtmlToDocx"
{
    Scripts = 'html-to-docx/Script.js', 'html-to-docx/html-docx.js', 'https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js';

    StartupScript = 'html-to-docx/Startup.js';

    RequestedHeight = 500;
    MinimumHeight = 1;
    HorizontalStretch = true;

    event ControlAddinReady();
    event ReturnDOCX(DOCXAsTxt: text)
    procedure LoadHtmlView(txt: Text)
    procedure ConvertToDocx(HTMLData: Text)
    procedure DownloadAsDocx(HTMLData: Text; FileName: text)
}