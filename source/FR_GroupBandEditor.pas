{*****************************************}
{                                         }
{             FastReport v2.3             }
{            Group band editor            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_GroupBandEditor;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Classes, FR_Consts, ExtCtrls, Buttons;

type
  TfrGroupEditorForm = class(TfrObjEditorForm)
    Button1: TButton;
    Button2: TButton;
    GB1: TGroupBox;
    Edit1: TEdit;
    Panel1: TPanel;
    frSpeedButton1: TSpeedButton;
    procedure frSpeedButton1Click(Sender: TObject);
  private
  public
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

{$R *.DFM}

uses FR_Fields;

procedure TfrGroupEditorForm.ShowEditor(t: TfrView);
begin
  Edit1.Text := (t as TfrBandView).GroupCondition;
  if ShowModal = mrOk then
  begin
    frDesigner.BeforeChange;
    (t as TfrBandView).GroupCondition := Edit1.Text;
  end;
end;

procedure TfrGroupEditorForm.frSpeedButton1Click(Sender: TObject);
var
  frFieldsForm :TfrFieldsForm;
begin
  frFieldsForm := TfrFieldsForm.Create(frDesigner);
  try
    with frFieldsForm do
    if ShowModal = mrOk then
      Edit1.Text := DBField;
  finally
    frFieldsForm.Free;
  end;
end;

end.

