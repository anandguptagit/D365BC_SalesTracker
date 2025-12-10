query 50118 MyQuery
{
    Caption = 'Monthly Sales';
    QueryType = normal;

    elements
    {
        dataitem(General_Posting_Setup; "General Posting Setup")
        {
            DataItemTableFilter = Blocked = const(false);
            //filter(Blocked;Blocked)
            //{
            //    ColumnFilter = Blocked = const(false);
            //}
            dataitem(G_L_Entry; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = General_Posting_Setup."Sales Account";

                column(Posting_Date; "Posting Date")
                {

                }
                column(G_L_Account_No_; "G/L Account No.")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Description; Description)
                {

                }
                filter(Document_Type; "Document Type")
                {

                }

            }
        }
    }
    // var
    //     myInt: Integer;
    trigger OnBeforeOpen()

    begin
        currMonth := Date2DMY(Today, 2);
        currYear := Date2DMY(Today, 3);
        //GetMonthYear(currMonth, currYear);
        CurrQuery.SetFilter(Posting_date, '%1..%2', DMY2Date(1, currMonth, currYear), CalcDate('CM', Today));
    end;

    var
        currMonth: Integer;
        currYear: Integer;

    procedure GetMonthYear(var selMonth: Integer; var selYear: Integer)
    var
        myInt: Integer;
    begin
        CurrMonth := selMonth;
        CurrYear := selYear;
    end;
}