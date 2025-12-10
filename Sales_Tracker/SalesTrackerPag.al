page 50118 "Sales Tracker"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Tracker";
    Caption = 'Sales Tracker';

    layout
    {
        area(Content)
        {
            group(Header)
            {
                field(cMonth; SaleTracker.GetMonthName(CurrMonth, CurrYear))
                {
                    ApplicationArea = all;
                    Caption = 'Current Month';
                    Editable = false;
                }
                field(cYear; CurrYear)
                {
                    ApplicationArea = all;
                    Caption = 'Current Year';
                    Editable = false;
                }
                field(LogYearly; IsYearly)
                {
                    ApplicationArea = all;
                    Caption = 'Log Year';
                }
                field(cTarget; CurrTarget)
                {
                    ApplicationArea = all;
                    Caption = 'Current Target';
                }
                field(cActual; ActualSale)
                {
                    ApplicationArea = all;
                    Caption = 'Actual Sales';
                }


            }
            repeater(TrackerLines)
            {
                field(User; rec.User)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Sales Person';
                }
                field(MonthName; rec."Month Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Month';
                }
                field(Year; rec.Year)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Year';
                }
                field(Target; rec.Target)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Target';
                }
                field(Actual; rec.Actual)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Actual Sale';
                }
                field(TargetAchieved; rec."Target Achieved")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LogSteps)
            {
                Caption = 'Log Sales';
                //Promoted = true;
                //PromotedIsBig = true;
                //PromotedOnly = true;
                Image = Log;
                trigger OnAction()
                var
                    newCurrMonth: Integer;
                begin
                    newCurrMonth := CurrMonth;
                    if (CurrTarget = 0) then
                        Error('Target can not be 0.');
                    if not IsYearly then
                        calcSteps.CalcSteps(newCurrMonth, CurrYear, CurrTarget, ActualSale)
                    else begin
                        SaleTracker.SetRange(User, UserId);
                        if SaleTracker.findset then
                            SaleTracker.DeleteAll();
                        for NoOfMonth := newCurrMonth to 12 do begin
                            calcSteps.CalcSteps(newCurrMonth, CurrYear, CurrTarget, ActualSale);
                            newCurrMonth := newCurrMonth + 1;
                        end;
                    end;
                    ;
                end;
            }
            action(UpdateLog)
            {
                Caption = 'Update Actual';
                //Promoted = true;
                //PromotedIsBig = true;
                //PromotedOnly = true;
                Image = UpdateUnitCost;
                trigger OnAction()
                begin
                    if (ActualSale = 0) then
                        Error('Actual Sale can not be 0.');
                    if SaleTracker.Get(UserId, CurrMonth, CurrYear) then begin
                        SaleTracker.Validate(Actual, ActualSale);
                        SaleTracker.Modify(true);
                    end;
                end;
            }
            action(GetSales)
            {
                Caption = 'Get Sales';
                //Promoted = true;
                //PromotedIsBig = true;
                //PromotedOnly = true;
                Image = Sales;
                trigger OnAction()
                begin
                    //if (ActualSale = 0) then
                    //Error('Actual Sale can not be 0.');
                    if SaleTracker.Get(UserId, CurrMonth, CurrYear) then begin
                        ActualSale := abs(calcSteps.GetMonthlySales(CurrMonth, CurrYear));
                        SaleTracker.Validate(Actual, ActualSale);
                        SaleTracker.Modify(true);
                    end;
                end;
            }
            action(ShowEntries)

            {
                ApplicationArea = all;
                Caption = 'Show Entries';
                RunObject = query "MyQuery";
                Image = ShowList;
                // trigger OnAction()
                // begin
                //     CurrPage.SetSelectionFilter(Rec);
                //     MyQry.GetMonthYear(rec.Month, rec.Year);
                //     run
                //     //MyQry.Read();
                //     //MyQry.Open();                    
                // end;
            }

        }
    }

    var
        CurrYear: Integer;
        CurrMonth: Integer;
        CurrTarget: Decimal;
        ActualSale: Decimal;
        calcSteps: Codeunit "Calculate Steps";
        saleTracker: Record "Sales Tracker";
        IsYearly: Boolean;
        NoOfMonth: Integer;
        MyQry: Query MyQuery;

    trigger OnOpenPage()
    begin
        CurrMonth := Date2DMY(Today, 2);
        CurrYear := Date2DMY(Today, 3);
        //MyQry.GetMonthYear(rec.Month, rec.Year);
    end;
}