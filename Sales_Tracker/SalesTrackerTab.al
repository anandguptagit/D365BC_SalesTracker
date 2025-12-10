table 50117 "Sales Tracker"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; User; Code[50])
        {
            Caption = 'User';
            DataClassification = ToBeClassified;

        }
        field(2; Month; Integer)
        {
            Caption = 'Month';
            DataClassification = ToBeClassified;
        }
        field(3; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Month Name" := GetMonthName(Month, Year);
            end;
        }
        field(4; Target; Decimal)
        {
            Caption = 'Target Steps';
            DataClassification = ToBeClassified;
        }
        field(5; Actual; Decimal)
        {
            Caption = 'Actual Steps';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF Target = 0 then
                    Error('Target can not be 0.');
                if Actual >= Target then
                    "Target Achieved" := true
                else
                    "Target Achieved" := false;
            end;
        }
        field(6; "Target Achieved"; Boolean)
        {
            Caption = 'Target Achieved';
            DataClassification = ToBeClassified;
        }
        field(7; "Month Name"; Text[20])
        {
            Caption = 'Month Name';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; User, Month, Year)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure GetMonthName(MonthNumber: Integer; Year: integer): Text
    var
        MyDate: Date;
        MonthName: Text;
    begin
        if (MonthNumber >= 1) and (MonthNumber <= 12) then begin
            MyDate := DMY2Date(1, MonthNumber, Year);
            MonthName := Format(MyDate, 0, '<Month Text>');
        end else begin
            MonthName := 'Invalid Month Number';
        end;
        exit(MonthName);
    end;
}