{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Variables form              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Variable;

interface

{$I FR.inc}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FR_Consts, FR_Classes;

type
  TfrVarForm = class(TfrEditorForm)
    ValList: TListBox;
    ValCombo: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure ValListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ValComboClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ValListDblClick(Sender: TObject);
  private
    { Private declarations }
    function CurVal: String;
    function CurDataSet: String;
    procedure GetVariables;
    procedure GetSpecValues;
    procedure GetFRVariables;
    procedure FillValCombo;
  public
    SelectedItem: String;
  end;

implementation

{$R *.DFM}

var
  LastCategory: String;

function TfrVarForm.CurVal: String;
begin
  Result := '';
  if ValList.ItemIndex <> -1 then
    Result := ValList.Items[ValList.ItemIndex];
end;

function TfrVarForm.CurDataSet: String;
begin
  Result := '';
  if ValCombo.ItemIndex <> -1 then
    Result := ValCombo.Items[ValCombo.ItemIndex];
end;

procedure TfrVarForm.FillValCombo;
var
  s: TStringList;
begin
  s := TStringList.Create;
  frDesigner.Report.GetCategoryList(s);
  s.Add('Other');
  s.Add('FR variables');
  ValCombo.Items.Assign(s);
  s.Free;
end;

procedure TfrVarForm.ValComboClick(Sender: TObject);
begin
  if CurDataSet = 'FR variables' then
    GetFRVariables
  else if CurDataSet = 'Other' then
    GetSpecValues else
    GetVariables;
end;

procedure TfrVarForm.GetVariables;
begin
  frDesigner.Report.GetVarList(ValCombo.ItemIndex, ValList.Items);
end;

procedure TfrVarForm.GetSpecValues;
var
  i: Integer;
begin
  with ValList.Items do
  begin
    Clear;
    for i := 0 to frSpecCount-1 do
      if i <> 1 then
        Add(frSpecArr[i]);
  end;
end;

procedure TfrVarForm.GetFRVariables;
var
  i: Integer;
begin
  with ValList.Items do
  begin
    Clear;
    for i := 0 to frVariables.Count - 1 do
      Add(frVariables.Name[i]);
  end;
end;

procedure TfrVarForm.ValListDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrVarForm.ValListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then ModalResult := mrOk;
end;

procedure TfrVarForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Escape then
    ModalResult := mrCancel;
end;

procedure TfrVarForm.FormActivate(Sender: TObject);
begin
  FillValCombo;
  if ValCombo.Items.IndexOf(LastCategory) <> -1 then
    ValCombo.ItemIndex := ValCombo.Items.IndexOf(LastCategory) else
    ValCombo.ItemIndex := 0;
  ValComboClick(nil);
end;

procedure TfrVarForm.FormDeactivate(Sender: TObject);
begin
  if ModalResult = mrOk then
    if CurDataSet <> 'Other' then//zaher ya zaher
      SelectedItem := CurVal
    else
      if ValList.ItemIndex > 0 then
        SelectedItem := frSpecFuncs[ValList.ItemIndex + 1] else
        SelectedItem := frSpecFuncs[0];
  LastCategory := ValCombo.Items[ValCombo.ItemIndex];
end;

end.

