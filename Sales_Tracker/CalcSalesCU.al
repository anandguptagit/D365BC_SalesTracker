codeunit 50118 "Calculate Steps"
{
    trigger OnRun()
    begin

    end;

    procedure CalcSteps(Month: Integer; Year: integer; Target: Decimal; Actual: Decimal)
    var
        SaleTracker: Record "Sales Tracker";
    begin
        SaleTracker.init;
        SaleTracker.Validate(User, UserId);
        SaleTracker.Validate(Month, month);
        SaleTracker.Validate(Year, year);
        SaleTracker.Validate(Target, Target);

        if not SaleTracker.Insert(true) then begin
            SaleTracker.Modify(true);
            Message('%1-%2 sales have been logged.', SaleTracker.GetMonthName(month, Year), Year);
        end;
    end;

    procedure GetMonthlySales(Month: Integer; Year: Integer): Decimal
    var
        GLAccounts: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        SalesAmt: Decimal;
    begin
        Clear(GLEntry);
        GLEntry.Reset();
        GLEntry.Setfilter("G/L Account No.", GetSalesGLAccounts());
        GLEntry.SetFilter("Posting Date", '%1..%2', DMY2Date(1, Month, Year), CalcDate('<CM>', Today));
        if GLEntry.FindSet then
            repeat
                SalesAmt := SalesAmt + GLEntry.Amount;
            until GLEntry.Next = 0;
        exit(SalesAmt);
    end;

    procedure GetSalesGLAccounts(): Text
    var
        SalesGLAccFilter: Text;
        GenPostSetup: Record "General Posting Setup";
    begin
        Clear(GenPostSetup);
        GenPostSetup.Reset();
        GenPostSetup.SetRange(Blocked, false);
        GenPostSetup.SetFilter("Sales Account", '<>%1', '');
        if GenPostSetup.findset then
            repeat
                SalesGLAccFilter := SalesGLAccFilter + GenPostSetup."Sales Account" + '|'
            until GenPostSetup.Next = 0;
        SalesGLAccFilter := CopyStr(SalesGLAccFilter, 1, StrLen(SalesGLAccFilter) - 1);
        exit(SalesGLAccFilter);
    end;

}