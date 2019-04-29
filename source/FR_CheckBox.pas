
{*****************************************}
{                                         }
{             FastReport v2.3             }
{         Checkbox Add-In Object          }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_CheckBox;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Menus, FR_Classes;

type
  TfrCheckBoxView = class(TfrView)
  private
    Bmp: TBitmap;
    procedure DrawCheck(ARect: TRect; Checked: Boolean);
  public
    constructor Create(AReport: TfrReport); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas); override;
    procedure Print(Stream: TStream); override;
    procedure ExportData; override;
    procedure DefinePopupMenu(frDesigner:TfrReportDesigner; Popup: TPopupMenu); override;
  end;

implementation

uses
  FR_Interpreter, FR_Parser, FR_Utils, FR_Consts;

{$R *.RES}

procedure TfrCheckBoxView.DrawCheck(ARect: TRect; Checked: Boolean);
  procedure Line(x, y, x1, y1: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x1, y1);
  end;
begin
  InflateRect(ARect, Round(-4 * ScaleX), Round(-4 * ScaleY));
  with Canvas, ARect do
  begin
    Pen.Mode := pmCopy;
    Pen.Style := psSolid;
    Pen.Color := clBlack;
    if Checked then
    begin
      Pen.Color := clBlack;
      Pen.Width := Round(3 * ScaleX);
      Line(Left, Top, Right, Bottom);
      Line(Left, Bottom, Right, Top);
    end;
  end;
end;

constructor TfrCheckBoxView.Create(AReport: TfrReport);
begin
  inherited;
  Bmp := TBitmap.Create;
  Bmp.LoadFromResourceName(hInstance, 'FR_CheckBox');
  Typ := gtAddIn;
  FrameWidth := 2;
  BaseName := 'Check';
end;

procedure TfrCheckBoxView.Draw(Canvas: TCanvas);
var
  Res: Boolean;
begin
  BeginDraw(Canvas);
  Contents.Assign(Memo);
  CalcGaps;
  ShowBackground;
  Res := False;
  if (Report.DocMode = dmPrinting) and (Contents.Count > 0) and (Contents[0] <> '') then
    Res := Contents[0][1] <> '0';
  if Report.DocMode = dmDesigning then
    Res := True;
  DrawCheck(DRect, Res);
  ShowFrame;
  RestoreCoord;
end;

procedure TfrCheckBoxView.Print(Stream: TStream);
begin
  BeginDraw(Canvas);
  Contents.Assign(Memo);
  Report.InternalOnEnterRect(Contents, Self);
  if not Visible then Exit;

  if Contents.Count > 0 then
    Contents[0] := IntToStr(Trunc(frParser.Calc(Contents[0])));
  Stream.Write(Typ, 1);
  frWriteString(Stream, ClassName);
  SaveToStream(Stream);
end;

procedure TfrCheckBoxView.ExportData;
var
  s: String;
begin
  inherited;
  s := '';
  if (Memo.Count > 0) and (Memo[0] <> '') then
    if Memo[0][1] <> '0' then
      s := 'X';
  Report.InternalOnExportText(x, y, s, Self);
end;

procedure TfrCheckBoxView.DefinePopupMenu(frDesigner:TfrReportDesigner; Popup: TPopupMenu);
begin
  // no specific items in popup menu
end;

destructor TfrCheckBoxView.Destroy;
begin
  Bmp.Free;
  inherited;
end;

initialization
  frRegisterObject(TfrCheckBoxView, 0, nil, 'CheckBox object', nil);
finalization
end.
