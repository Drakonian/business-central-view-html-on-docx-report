table 70000 "WHTML Content Storage"
{
    Caption = 'Content Storage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[200])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "HTML Content"; Blob)
        {
            Caption = 'HTML Content';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        WHTMLContentStorage: Record "WHTML Content Storage";
    begin
        if WHTMLContentStorage.FindLast() then
            Rec."Entry No." := WHTMLContentStorage."Entry No." + 1
        else
            Rec."Entry No." := 1;
    end;

    /// <summary>
    /// Get current value of HTML content as text.
    /// </summary>
    /// <returns>Return value of HTML Content as text.</returns>
    procedure GetHTMLContentAsText() HTMLContent: Text;
    var
        InStreamVar: InStream;
    begin
        if not Rec."HTML Content".HasValue() then
            exit;
        Rec.CalcFields("HTML Content");
        Rec."HTML Content".CreateInStream(InStreamVar);
        InStreamVar.ReadText(HTMLContent);
    end;
}
