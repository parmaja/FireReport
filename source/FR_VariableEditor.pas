{*****************************************}
{                                         }
{             FastReport v2.3             }
{        'Values' property editor         }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_VariableEditor;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Classes, ExtCtrls, Buttons;

type
  TfrEvForm = class(TfrEditorForm)
    VarCombo: TComboBox;
    VarList: TListBox;
    ValCombo: TComboBox;
    ValList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Label3: TLabel;
    Button2: TButton;
    Button3: TButton;
    SB1: TSpeedButton;
    SB2: TSpeedButton;
    Bevel1: TBevel;
    procedure VarComboClick(Sender: TObject);
    procedure ValComboClick(Sender: TObject);
    procedure VarListClick(Sender: TObject);
    procedure ValListClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SB1Click(Sender: TObject);
    procedure SB2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function CurVar: String;
    function CurVal: String;
    function CurDataSet: String;
    procedure GetFields(Value: String);
    procedure GetSpecValues;
    procedure GetFRVariables;
    procedure FillVarCombo;
    procedure FillValCombo;
    procedure ShowVarValue(Value: String);
    procedure SetValTo(Value: String);
    procedure CheckForExpr;
    procedure PostVal;
  public
    Str: TMemoryStream;
    Sl: TStringList;
    procedure Init;
    procedure RefreshVarList(Memo: TStrings);
    procedure CancelChanges;
  end;

function ShowEvEditor(frDesigner: TfrReportDesigner): Boolean;
procedure InitProc;
procedure FinalProc;

implementation

{$R *.DFM}

uses
  FR_Vared, FR_Consts, FR_Utils, DB;

var
  SMemo: TStringList;
  VarClipbd: TMemoryStream;

function ShowEvEditor(frDesigner: TfrReportDesigner): Boolean;
begin
  Result := False;
  with TfrEvForm.Create(frDesigner) do
  try
    Str := TMemoryStream.Create;
    Sl := TStringList.Create;
    frDesigner.Report.Values.WriteBinaryData(Str);
    frDesigner.Report.Values.Items.Sorted := False;
    Sl.Assign(frDesigner.Report.Variables);
    Init;
    SB2.Enabled := VarClipbd.Size <> 0;
    if ShowModal = mrOk then
      Result := True else
      CancelChanges;
  finally
    Str.Free;
    Sl.Free;
    Free;
  end
end;

procedure TfrEvForm.Button3Click(Sender: TObject);
begin
  with TfrVaredForm.Create(frDesigner) do
  try
    if ShowModal = mrOk then
      RefreshVarList(Memo1.Lines);
  finally
    Free;
  end
end;

procedure TfrEvForm.Init;
begin
  FillVarCombo;
  FillValCombo;
  VarCombo.ItemIndex := 0;
  ValCombo.ItemIndex := 0;
  VarComboClick(nil);
  ValComboClick(nil);
  CheckForExpr;
end;

procedure TfrEvForm.RefreshVarList(Memo: TStrings);
var
  i, j, n: Integer;
  l: TStringList;
begin
  l := TStringList.Create;
  frDesigner.Report.Variables.Assign(Memo);
  with frDesigner.Report.Values do
  for i := Items.Count-1 downto 0 do
    if frDesigner.Report.FindVariable(Items[i]) = -1 then
    begin
      Objects[i].Free;
      Items.Delete(i);
    end;
  frDesigner.Report.GetCategoryList(l);
  n := l.Count;
  for i := 0 to n-1 do
  begin
    frDesigner.Report.GetVarList(i, l);
    for j := 0 to l.Count-1 do
      with frDesigner.Report.Values do
      if FindVariable(l[j]) = nil then
        Items[AddValue] := l[j];
  end;
  FillVarCombo;
  VarCombo.ItemIndex := 0;
  VarComboClick(nil);
  l.Free;
end;

procedure TfrEvForm.CancelChanges;
begin
  Str.Position := 0;
  frDesigner.Report.Values.ReadBinaryData(Str);
  frDesigner.Report.Variables.Assign(Sl);
end;

function TfrEvForm.CurVar: String;
begin
  Result := '';
  if VarList.ItemIndex <> -1 then
    Result := VarList.Items[VarList.ItemIndex];
end;

function TfrEvForm.CurVal: String;
begin
  Result := '';
  if ValList.ItemIndex <> -1 then
    Result := ValList.Items[ValList.ItemIndex];
end;

function TfrEvForm.CurDataSet: String;
begin
  Result := '';
  if ValCombo.ItemIndex <> -1 then
    Result := ValCombo.Items[ValCombo.ItemIndex];
end;

procedure TfrEvForm.FillVarCombo;
begin
  frDesigner.Report.GetCategoryList(VarCombo.Items);
end;

procedure TfrEvForm.FillValCombo;
var
  s: TStringList;
begin
  s := TStringList.Create;
  frGetComponents(frDesigner.Report.Owner, TDataSet, s, nil, frDesigner.Report.WholeDatasources);
  s.Sort;
  s.Add('Other');
  s.Add('FR variables');
  ValCombo.Items.Assign(s);
  s.Free;
end;

procedure TfrEvForm.VarComboClick(Sender: TObject);
begin
  frDesigner.Report.GetVarList(VarCombo.ItemIndex, VarList.Items);
end;

procedure TfrEvForm.ValComboClick(Sender: TObject);
begin
  if CurDataSet = 'FR variables' then//zaher: that very stupid
    GetFRVariables
  else if CurDataSet <> 'Other' then//zaher: oh my god :-(
    GetFields(CurDataSet) else
    GetSpecValues;
end;

procedure TfrEvForm.VarListClick(Sender: TObject);
begin
  ShowVarValue(CurVar);
end;

procedure TfrEvForm.GetFields(Value: String);
var
  DataSet: TDataSet;
begin
  ValList.Items.Clear;
  DataSet := frGetDataSet(frDesigner.Report, Value);
  if DataSet <> nil then
  try
    frGetFieldNames(DataSet, ValList.Items);
  except
  end;
  ValList.Items.Insert(0, '[None]');
end;

procedure TfrEvForm.GetSpecValues;
var
  i: Integer;
begin
  with ValList.Items do
  begin
    Clear;
    Add('[None]');
    for i := 0 to frSpecCount - 1 do
      Add(frSpecArr[i]);
  end;
end;

procedure TfrEvForm.GetFRVariables;
var
  i: Integer;
begin
  with ValList.Items do
  begin
    Clear;
    Add('[None]');
    for i := 0 to frVariables.Count - 1 do
      Add(frVariables.Name[i]);
  end;
end;

procedure TfrEvForm.ShowVarValue(Value: String);
begin
  with frDesigner.Report.Values.FindVariable(Value) do
    case Typ of
      vtNotAssigned:
        SetValTo(CurDataSet + '.' + '[None]');
      vtDBField:
        SetValTo(DataSet + '.' + Field);
      vtFRVar:
        SetValTo('FR variables' + '.' + Field);
      vtOther:
        begin
          SetValTo('Other' + '.' + frSpecArr[OtherKind]);
          if OtherKind = 1 then
            Edit1.Text := Field;
        end;
    end;
end;

procedure TfrEvForm.SetValTo(Value: String);
var
  s1, s2, s3: String;
  i, j: Integer;
begin
  s1 := Copy(Value, 1, Pos('.', Value) - 1);
  s2 := Copy(Value, Pos('.', Value) + 1, 255);
  if Pos('.', s2) <> 0 then
  begin
    s3 := Copy(s2, Pos('.', s2) + 1, 255);
    s2 := Copy(s2, 1, Pos('.', s2) - 1);
    if AnsiCompareText(s1, frDesigner.Report.Owner.Name) = 0 then
      s1 := s2 else
      s1 := s1 + '.' + s2;
    s2 := s3;
  end;
  with ValCombo do
  for i := 0 to Items.Count-1 do
    if Items[i] = s1 then
    begin
      if ItemIndex <> i then
      begin
        ItemIndex := i;
        ValComboClick(nil);
      end;
      with ValList do
      for j := 0 to Items.Count-1 do
        if Items[j] = s2 then
        begin
          ItemIndex := j;
          break;
        end;
      break;
    end;
  CheckForExpr;
end;

procedure TfrEvForm.ValListClick(Sender: TObject);
begin
  if VarList.ItemIndex < 0 then Exit;
  CheckForExpr;
end;

procedure TfrEvForm.CheckForExpr;
begin
  Edit1.Enabled := (CurDataSet = 'Other') and//zaher: ya zaher
    (CurVal = frSpecArr[1]);
  Label3.Enabled := Edit1.Enabled;
  if not Edit1.Enabled then
  begin
    Edit1.Text := '';
    Edit1.Color := clBtnFace;
  end
  else
    Edit1.Color := clWindow;
end;

procedure TfrEvForm.Edit1Exit(Sender: TObject);
begin
  PostVal;
end;

procedure TfrEvForm.PostVal;
var
  Val: TfrValue;
  i: Integer;
  s: String;
begin
  Val := frDesigner.Report.Values.FindVariable(CurVar);
  if Val <> nil then
  with Val do
  begin
    if CurVal = '[NONE]' then //zaher: ooooo
      Typ := vtNotAssigned
    else if CurDataSet = 'Other' then
    begin
      Typ := vtOther;
      s := CurVal;
      for i := 0 to frSpecCount - 1 do
        if s = frSpecArr[i] then
        begin
          OtherKind := i;
          if i = 1 then // SExpr
            Field := Edit1.Text;
          break;
        end;
    end
    else if CurDataSet = 'FR variables' then
    begin
      Typ := vtFRVar;
      Field := CurVal;
    end
    else
    begin
      Typ := vtDBField;
      DataSet := CurDataSet;
      Field := CurVal;
      OtherKind := 0;
    end;
  end;
end;

procedure TfrEvForm.SB1Click(Sender: TObject);
begin
  VarClipbd.Position := 0;
  frDesigner.Report.Values.WriteBinaryData(VarClipbd);
  SMemo.Assign(frDesigner.Report.Variables);
  frWriteMemo(VarClipbd, SMemo);
  SB2.Enabled := True;
end;

procedure TfrEvForm.SB2Click(Sender: TObject);
begin
  VarClipbd.Position := 0;
  frDesigner.Report.Values.ReadBinaryData(VarClipbd);
  frReadMemo(VarClipbd, SMemo);
  frDesigner.Report.Variables.Assign(SMemo);
  Init;
end;

procedure TfrEvForm.Button1Click(Sender: TObject);
begin
  PostVal;
end;

procedure InitProc;
begin
  SMemo := TStringList.Create;
  VarClipbd := TMemoryStream.Create;
end;

procedure FinalProc;
begin
  SMemo.Free;
  VarClipbd.Free;
end;

initialization
  InitProc;
finalization
  FinalProc;
end.
