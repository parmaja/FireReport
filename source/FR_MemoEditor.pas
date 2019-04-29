{*****************************************}
{                                         }
{             FastReport v2.3             }
{               Memo editor               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_MemoEditor;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Buttons, ClipBrd, FR_Classes, FR_Inspector, ExtCtrls;

type
  TfrMemoEditorForm = class(TPropEditorForm)
    Label1: TLabel;
    MemoEdit: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    FieldsBtn: TButton;
    Button5: TButton;
    CB3: TCheckBox;
    procedure Button3Click(Sender: TObject);
    procedure MemoEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FieldsBtnClick(Sender: TObject);
    procedure MemoEditEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CB3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SplitterMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FActiveMemo: TMemo;
    FDown: Boolean;
    FLastY: Integer;
  public
    function ShowEditor: TModalResult; override;
  end;

implementation

{$R *.DFM}

uses
  FR_Design, FR_Format, FR_Variable, FR_Fields, FR_Consts;

function TfrMemoEditorForm.ShowEditor: TModalResult;
begin
  Result := mrCancel;
  if View <> nil then
    Result := inherited ShowEditor;
end;

procedure TfrMemoEditorForm.FormShow(Sender: TObject);
begin
  CB3Click(nil);
  MemoEdit.Lines.Assign(View.Memo);
  MemoEdit.SetFocus;
  FActiveMemo := MemoEdit;
  Button5.Visible := View is TfrMemoView;
  MemoEdit.Font.Charset := frCharset;
end;

procedure TfrMemoEditorForm.FormHide(Sender: TObject);
begin
  if ModalResult = mrOk then
  begin
    frDesigner.BeforeChange;
    MemoEdit.WordWrap := False;
    View.Memo.Text := MemoEdit.Text;
  end;
end;

procedure TfrMemoEditorForm.Button3Click(Sender: TObject);
var
  frVarForm :TfrVarForm;
begin
  frVarForm := TfrVarForm.Create(frDesigner);
  try
    with frVarForm do
    if ShowModal = mrOk then
      if SelectedItem <> '' then
      begin
        ClipBoard.Clear;
        ClipBoard.AsText := '[' + SelectedItem + ']';
        FActiveMemo.PasteFromClipboard;
      end;
  finally
    frVarForm.Free;
  end;
  FActiveMemo.SetFocus;
end;

procedure TfrMemoEditorForm.MemoEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Insert) and (Shift = []) then Button3Click(Self);
  if Key = vk_Escape then ModalResult := mrCancel;
end;

procedure TfrMemoEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Chr(Key) = 'F') and (ssCtrl in Shift) and Button5.Visible then
  begin
    Button5Click(nil);
    Key := 0;
  end;
  if (Key = vk_Return) and (ssCtrl in Shift) then
  begin
    ModalResult := mrOk;
    Key := 0;
  end;
end;

procedure TfrMemoEditorForm.FieldsBtnClick(Sender: TObject);
var
  frFieldsForm :TfrFieldsForm;
begin
  frFieldsForm := TfrFieldsForm.Create(frDesigner);
  try
    with frFieldsForm do
      if ShowModal = mrOk then
        if DBField <> '' then
          FActiveMemo.SetSelText('[' + DBField + ']');
  finally
    frFieldsForm.Free;
  end;
  FActiveMemo.SetFocus;
end;

procedure TfrMemoEditorForm.MemoEditEnter(Sender: TObject);
begin
  FActiveMemo := Sender as TMemo;
end;

procedure TfrMemoEditorForm.CB3Click(Sender: TObject);
begin
  MemoEdit.WordWrap := CB3.Checked;
end;

procedure TfrMemoEditorForm.Button5Click(Sender: TObject);
var
  t: TfrMemoView;
  frFmtForm :TfrFmtForm;
begin
  t := TfrMemoView(View);
  frFmtForm := TfrFmtForm.Create(frDesigner);
  try
    with frFmtForm do
    begin
      Format := t.Format;
      Edit1.Text := t.FormatStr;
      if ShowModal = mrOk then
      begin
  //      frDesigner.BeforeChange;
        t.Format := Format;
        t.FormatStr := Edit1.Text;
      end;
    end;
  finally
    frFmtForm.Free;
  end;
end;

procedure TfrMemoEditorForm.SplitterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDown := True;
  FLastY := Y;
end;

end.

