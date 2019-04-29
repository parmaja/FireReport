{*****************************************}
{                                         }
{             FastReport v2.3             }
{            Variables editor             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Vared;
         
interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, FR_Classes, FR_Consts;

type
  TfrVaredForm = class(TfrEditorForm)
    Button4: TButton;
    Button5: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
  private
  public
    Doc: TfrReport;
  end;

implementation

{$R *.DFM}

procedure TfrVaredForm.FormActivate(Sender: TObject);
begin
  Memo1.Lines.Assign(Doc.Variables);
end;

end.

