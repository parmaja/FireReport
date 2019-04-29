{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Object Inspector            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Inspector;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, FR_Classes, FR_Consts, Contnrs;

type
  TModifyEvent = procedure(Item: Integer; var EditText: String) of object;

  TCtrlStyle = (csEdit, csDefEditor);

  TFRObjectValue = class(TObject)
  public
    Name: string;
    Value: string; //TODO Variant
    procedure Clear;
  end;

  TFRObjectValues = class(TObjectList)
  private
    function GetItems(Index: Integer): TFRObjectValue;
  public
    property Items[Index: Integer]: TFRObjectValue read GetItems; default;
    procedure Add(AName: string);
  end;

  TFRItemObject = class(TObject)
  protected
  public
    Name: string;
    ObjectValue: TFRObjectValue;
    Style: TCtrlStyle;
    Editor: TPropEditorForm;
    Enabled: Boolean;
    constructor Create(AObjectValue: TFRObjectValue; AStyle: TCtrlStyle; AEditor: TPropEditorForm); virtual;
  end;

  TFRItemObjects = class(TObjectList)
  private
    function GetItems(Index: Integer): TFRItemObject;
  public
    procedure AddObject(Name: string; AObject: TFRItemObject);
    property Items[Index: Integer]: TFRItemObject read GetItems; default;
  end;

  TfrInspForm = class(TPropEditorForm)
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    SpeedButton1: TSpeedButton;
    ValueEdit: TEdit;
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ValueEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ValueEditDblClick(Sender: TObject);
    procedure ValueEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
  private
    FItems: TFRItemObjects;
    FItemIndex: Integer;
    FOnModify: TModifyEvent;
    FRowHeight: Integer;
    w, w1: Integer;
    b: TBitmap;
    procedure SetItemIndex(Value: Integer);
    function GetCount: Integer;
    procedure DrawOneLine(i: Integer; a: Boolean);
    procedure SetItemValue(Value: String);
    function GetItemValue(i: Integer):String;
    function CurItem: TFRItemObject;
    procedure WMNCLButtonDblClk(var Message: TMessage); message WM_NCLBUTTONDBLCLK;
  public
    V: TfrView;
    HideProperties: Boolean;
    DefHeight, DefWidth: Integer;
    procedure ClearItems;
    procedure ItemsChanged;
    procedure EnableItem(Index: Integer; Enable: Boolean);
    property Items: TFRItemObjects read FItems; //write SetItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property Count: Integer read GetCount;
    property OnModify: TModifyEvent read FOnModify write FOnModify;
  end;

implementation

{$R *.DFM}

function TfrInspForm.CurItem: TFRItemObject;
begin
  Result := nil;
  if (FItemIndex <> -1) and (Count > 0) then
    Result := FItems[FItemIndex];
end;


procedure TfrInspForm.SetItemValue(Value: String);
var
  p: TFRItemObject;
begin
  if HideProperties then
    Exit;
  p := FItems[FItemIndex];
  p.ObjectValue.Value := Value;
  if Assigned(FOnModify) then
    FOnModify(FItemIndex, Value);
  ValueEdit.Text := Value;
  ValueEdit.SelectAll;
  ValueEdit.Modified := False;
end;

function TfrInspForm.GetItemValue(i: Integer): String;
var
  p: TFRItemObject;
begin
  Result := '';
  p := FItems[i];
  if p = nil then
    Exit;
  Result := p.ObjectValue.Value;
end;

procedure TfrInspForm.SetItemIndex(Value: Integer);
var
  ww: Integer;
begin
  if Value > Count - 1 then
    Value := Count - 1;
  if not FItems[Value].Enabled then
    Exit;
  ValueEdit.Visible := (Count > 0) and not HideProperties;
  if (Count = 0) or (FItemIndex = Value) then
    Exit;
  if FItemIndex <> -1 then
    if ValueEdit.Modified then
      SetItemValue(ValueEdit.Text);
  FItemIndex := Value;
  SpeedButton1.Visible := (CurItem.Style = csDefEditor) and not HideProperties;
  ValueEdit.ReadOnly := CurItem.Style = csDefEditor;
  ww := w - w1 - 4;
  if SpeedButton1.Visible then
  begin
    SpeedButton1.SetBounds(w - 16, 2 + FItemIndex * FRowHeight + 1, 14, FRowHeight - 2);
    Dec(ww, 15);
    ValueEdit.Text := '(' + FItems[FItemIndex].Name + ')';
  end
  else
    ValueEdit.Text := GetItemValue(FItemIndex);
  ValueEdit.SetBounds(w1 + 2, 2 + FItemIndex * FRowHeight + 1, ww, FRowHeight - 2);
  ValueEdit.SelectAll;
  ValueEdit.Modified := False;
  PaintBox1Paint(nil);
end;

function TfrInspForm.GetCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TfrInspForm.ItemsChanged;
begin
  FItemIndex := -1;
  ItemIndex := 0;
end;

procedure TfrInspForm.EnableItem(Index: Integer; Enable: Boolean);
begin
  FItems[Index].Enabled := Enable;
  PaintBox1Paint(nil);
end;

procedure TfrInspForm.DrawOneLine(i: Integer; a: Boolean);
  procedure Line(x, y, dx, dy: Integer);
  begin
    b.Canvas.MoveTo(x, y);
    b.Canvas.LineTo(x + dx, y + dy);
  end;
begin
  if not FItems[i].Enabled then
    Exit;
  if Count > 0 then
  with b.Canvas do
  begin
    Brush.Color := clBtnFace;
    Pen.Color := clBtnShadow;
    Font.Name := 'MS Sans Serif';
    Font.Size := 8;
    Font.Style := [];
    Font.Color := clBlack;
    if a then
    begin
      Pen.Color := clBtnShadow;
      Line(2, 0 + i * FRowHeight, w - 4, 0);
      Line(w1 - 1, 2 + i * FRowHeight, 0, FRowHeight);
      Pen.Color := clBlack;
      Line(2, 1 + i * FRowHeight, w - 4, 0);
      Line(2, 1 + i * FRowHeight, 0, FRowHeight + 1);
      Pen.Color := clBtnHighlight;
      Line(3, FRowHeight + 1 + i * FRowHeight, w - 5, 0);
      Line(ValueEdit.Left, 2 + i * FRowHeight, ValueEdit.Width, 0);
      Line(w1, 2 + i * FRowHeight, 0, FRowHeight);
      Line(w1 + 1, 2 + i * FRowHeight, 0, FRowHeight);
      TextOut(7, 3 + i * FRowHeight, FItems[i].Name);
    end
    else
    begin
      Line(2, FRowHeight + 1 + i * FRowHeight, w - 4, 0);
      Line(w1 - 1, 2 + i * FRowHeight, 0, FRowHeight);
      Pen.Color := clBtnHighlight;
      Line(w1, 2 + i * FRowHeight, 0, FRowHeight);
      TextOut(7, 3 + i * FRowHeight, FItems[i].Name);
      Font.Color := clNavy;
      if FItems[i].Style = csEdit then
        TextOut(w1 + 2, 3 + i * FRowHeight, GetItemValue(i)) else
        TextOut(w1 + 2, 3 + i * FRowHeight, '(' + FItems[i].Name + ')');
    end;
  end;
end;

procedure TfrInspForm.PaintBox1Paint(Sender: TObject);
var
  i: Integer;
  r: TRect;
begin
  r := PaintBox1.BoundsRect;
  b.Canvas.Brush.Color := clBtnFace;
  b.Canvas.FillRect(r);
  if not HideProperties then
  begin
    for i := 0 to Count-1 do
      if i <> FItemIndex then
        DrawOneLine(i, False);
    if FItemIndex <> -1 then DrawOneLine(FItemIndex, True);
  end;
  DrawEdge(b.Canvas.Handle, r, EDGE_SUNKEN, BF_RECT);
  PaintBox1.Canvas.Draw(0, 0, b);
end;

procedure TfrInspForm.FormCreate(Sender: TObject);
begin
  w := PaintBox1.Width;
  w1 := w div 2;
  b := TBitmap.Create;
  b.Width := w;
  b.Height := PaintBox1.Height;
  SpeedButton1.Visible := False;
  FItemIndex := -1;
  FItems := TFRItemObjects.Create(True);
  DefHeight := Height - 3;
  DefWidth := Width;
  FRowHeight := -Font.Height + 5;
  FormResize(nil);
end;

procedure TfrInspForm.FormDestroy(Sender: TObject);
begin
  b.Free;
  ClearItems;
  FItems.Free;
end;

procedure TfrInspForm.ClearItems;
begin
  FItems.Clear;
end;

procedure TfrInspForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if HideProperties then Exit;
  ItemIndex := y div FRowHeight;
  ValueEdit.SetFocus;
end;

procedure TfrInspForm.ValueEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if HideProperties then Exit;
  if Key = vk_Up then
  begin
    if ItemIndex > 0 then
      ItemIndex := ItemIndex - 1;
    Key := 0;
  end
  else if Key = vk_Down then
  begin
    if ItemIndex < Count - 1 then
      ItemIndex := ItemIndex + 1;
    Key := 0;
  end;
end;

procedure TfrInspForm.ValueEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if CurItem.Style = csEdit then
    begin
      if ValueEdit.Modified then SetItemValue(ValueEdit.Text);
      ValueEdit.Modified := False;
    end
    else
      SpeedButton1Click(nil);
    ValueEdit.SelectAll;
    Key := #0;
  end;
end;

procedure TfrInspForm.SpeedButton1Click(Sender: TObject);
var
  s: String;
begin
  if HideProperties then Exit;
  with CurItem.Editor do
  begin
    View := V;
    s := '';
    if ShowEditor = mrOk then
      if Assigned(FOnModify) then FOnModify(FItemIndex, s);
  end;
end;

procedure TfrInspForm.ValueEditDblClick(Sender: TObject);
begin
  if CurItem.Style = csDefEditor then
    SpeedButton1Click(nil);
end;

procedure TfrInspForm.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
    SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure TfrInspForm.FormDeactivate(Sender: TObject);
begin
  if CurItem = nil then Exit;
  if CurItem.Style = csEdit then
  begin
    if ValueEdit.Modified then SetItemValue(ValueEdit.Text);
    ValueEdit.Modified := False;
  end;
end;

procedure TfrInspForm.WMNCLButtonDblClk(var Message: TMessage);
begin
  if Height = DefHeight then
  begin
    Height := 0;
    Width := DefWidth div 2;
    Panel1.Hide;
  end
  else
  begin
    Height := DefHeight;
    Width := DefWidth;
    Panel1.Show;
  end;
end;

procedure TfrInspForm.FormResize(Sender: TObject);
begin
  Panel1.Width := ClientWidth - 4;
  Panel1.Height := ClientHeight - 4;
  w := PaintBox1.Width;
  b.Width := w;
  b.Height := PaintBox1.Height;
  ValueEdit.Width := w - w1 - 4;
end;

{ TFRItemObject }

constructor TFRItemObject.Create(AObjectValue: TFRObjectValue; AStyle: TCtrlStyle; AEditor: TPropEditorForm);
begin
  inherited Create;
  ObjectValue := AObjectValue;
  Style := AStyle;
  Editor := AEditor;
  Enabled := True;
end;

{ TFRItemObjects }

procedure TFRItemObjects.AddObject(Name: string; AObject: TFRItemObject);
begin
  Add(AObject);
  AObject.Name := Name;
end;

function TFRItemObjects.GetItems(Index: Integer): TFRItemObject;
begin
  Result := inherited Items[Index] as TFRItemObject;
end;

{ TFRObjectValue }

procedure TFRObjectValues.Add(AName: string);
var
  item: TFRObjectValue;
begin
  item := TFRObjectValue.Create;
  item.Clear;
  item.Name := AName;
  inherited Add(Item);
end;

procedure TFRObjectValue.Clear;
begin
  Value := '';
end;

{ TFRObjectValues }

function TFRObjectValues.GetItems(Index: Integer): TFRObjectValue;
begin
  Result := (inherited Items[Index]) as TFRObjectValue;
end;

end.

