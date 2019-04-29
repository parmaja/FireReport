{*******************************************}
{                                           }
{            FastReport v2.3                }
{         Barcode Add-in object             }
{                                           }
{  Copyright (c) 1998-99 by Tzyganenko A.   }
{                                           }
{                                           }
{  Barcode Component                        }
{  Version 1.3                              }
{  Copyright 1998-99 Andreas Schmidt and    }
{  friends                                  }
{  Freeware                                 }
{                                           }
{  for use with Delphi 2/3/4                }
{                                           }
{  this component is for private use only!  }
{  i am not responsible for wrong Barcodes  }
{  Code128C not implemented                 }
{                                           }
{  bug-reports, enhancements:               }
{  mailto:shmia@bizerba.de or               }
{  a_j_schmidt@rocketmail.com               }
{                                           }
{  Fr_BarC:     Guilbaud Olivier            }
{               golivier@worldnet.fr        }
{  Ported to FR2.3: Alexander Tzyganenko    }
{                                           }
{*******************************************}

unit FR_Barcodes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, FR_BarcodeUtils, FR_Classes, ExtCtrls, ImgList,
  Buttons;

type
  TfrBarcodeInfo = packed record
    cCheckSum: Boolean;
    cShowText: Boolean;
    cCadr: Boolean;
    cBarType: TBarcodeType;
    cModul: Integer;
    cRatio: Double;
    cAngle: Double;
  end;

  TfrBarcodeView = class(TfrView)
  private
    FBarcode: TBarcode;
  public
    Param: TfrBarcodeInfo;
    constructor Create(AReport: TfrReport); override;
    destructor Destroy; override;
    procedure Assign(From: TfrView); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure Print(Stream: TStream); override;
    procedure DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu); override;
  end;

  TfrBarcodeForm = class(TfrObjEditorForm)
    bCancel: TButton;
    bOk: TButton;
    M1: TEdit;
    Label1: TLabel;
    cbType: TComboBox;
    Label2: TLabel;
    Panel1: TPanel;
    DBBtn: TSpeedButton;
    VarBtn: TSpeedButton;
    GroupBox1: TGroupBox;
    ckCheckSum: TCheckBox;
    ckViewText: TCheckBox;
    GroupBox2: TGroupBox;
    RB1: TRadioButton;
    RB2: TRadioButton;
    RB3: TRadioButton;
    RB4: TRadioButton;
    RatioCbo: TComboBox;
    RatioLbl: TLabel;
    ModuleCbo: TComboBox;
    ModuleLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure VarBtnClick(Sender: TObject);
    procedure DBBtnClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

uses
  FR_Variable, FR_Fields, FR_Consts, FR_Utils;

{$R *.DFM}

const
  cbDefaultText = '12345678';
  bcNames: array[bcCode_2_5_interleaved..bcCodeEAN13, 0..1] of string =
  (('2_5_interleaved', 'A'),
    ('2_5_industrial', 'A'),
    ('2_5_matrix', 'A'),
    ('Code39', 'A'),
    ('Code39 Extended', 'A'),
    ('Code128A', 'A'),
    ('Code128B', 'A'),
    ('Code128C', 'A'),
    ('Code93', 'A'),
    ('Code93 Extended', 'A'),
    ('MSI', 'N'),
    ('PostNet', 'N'),
    ('Codebar', 'N'),
    ('EAN8', 'N'),
    ('EAN13', 'N'));

{$HINTS OFF}

function isNumeric(St: string): Boolean;
var
  R: Double;
  E: Integer;
begin
  Val(St, R, E);
  Result := (E = 0);
end;
{$HINTS ON}

constructor TfrBarcodeView.Create(AReport: TfrReport);
begin
  inherited;
  FBarcode := TBarcode.Create(nil);
  Param.cCheckSum := True;
  Param.cShowText := True;
  Param.cCadr := False;
  Param.cBarType := bcCode39;
  Param.cModul := 1;
  Param.cRatio := 2;
  Param.cAngle := 0;
  Memo.Add(cbDefaultText);
  Typ := gtAddIn;
  BaseName := 'Bar';
end;

destructor TfrBarcodeView.Destroy;
begin
  FBarcode.Free;
  inherited;
end;

procedure TfrBarcodeView.Assign(From: TfrView);
begin
  inherited;
  Param := (From as TfrBarcodeView).Param;
end;

procedure TfrBarcodeView.LoadFromStream(Stream: TStream);
begin
  inherited;
  Stream.Read(Param, SizeOf(Param));
end;

procedure TfrBarcodeView.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(Param, SizeOf(Param));
end;

procedure TfrBarcodeView.Draw(Canvas: TCanvas);
var
  Txt: string;
  hg: Integer;
  m: Integer;
  EMF: TMetafile;
  EMFCanvas: TMetafileCanvas;
  h, oldh: HFont;

  function CreateRotatedFont(Font: TFont; Angle: Integer): HFont;
  var
    F: TLogFont;
  begin
    GetObject(Font.Handle, SizeOf(TLogFont), @F);
    F.lfEscapement := Angle * 10;
    F.lfOrientation := Angle * 10;
    Result := CreateFontIndirect(F);
  end;

begin
  BeginDraw(Canvas);
  Contents.Assign(Memo);

  if Contents.Count > 0 then
    Txt := Contents.Strings[0] else
    Txt := cbDefaultText;

  FBarcode.Angle := Param.cAngle;
  FBarcode.Ratio := Param.cRatio;
  FBarcode.Modul := Param.cModul;
  FBarcode.Checksum := Param.cCheckSum;
  FBarcode.ShowText := False;
  FBarcode.Typ := Param.cBarType;
  if bcNames[Param.cBarType, 1] = 'A' then
    FBarcode.Text := Txt
  else if IsNumeric(Txt) then
    FBarcode.Text := Txt else
    FBarcode.Text := cbDefaultText;

  if (Param.cAngle = 90) or (Param.cAngle = 270) then
  begin
//    dy := FBarcode.Width
    m := (dy - FBarcode.Width) div 2;
  end
  else
  begin
//    dx := FBarcode.Width;
    m := (dx - FBarcode.Width) div 2;
  end;

  if (Param.cAngle = 90) or (Param.cAngle = 270) then
    if Param.cShowText then
      hg := dx - 16
  else
      hg := dx
  else if Param.cShowText then
    hg := dy - 16 else
    hg := dy;

  if Param.cAngle = 0 then
  begin
    FBarcode.Left := m;
    FBarcode.Top := 0;
    FBarcode.Height := hg;
  end
  else if Param.cAngle = 90 then
  begin
    FBarcode.Left := 0;
    FBarcode.Top := dy - m;
    FBarcode.Height := hg;
  end
  else if Param.cAngle = 180 then
  begin
    FBarcode.Left := dx - m;
    FBarcode.Top := dy;
    FBarcode.Height := hg;
  end
  else
  begin
    FBarcode.Left := dx;
    FBarcode.Top := m;
    FBarcode.Height := hg;
  end;

  EMF := TMetafile.Create;
  EMF.Width := dx;
  EMF.Height := dy;
  EMFCanvas := TMetafileCanvas.Create(EMF, 0);
  FBarcode.DrawBarcode(EMFCanvas);

  if Param.cShowText then
    with EMFCanvas do
    begin
      Font.Color := clBlack;
      Font.Name := 'Courier New';
      Font.Height := -12;
      Font.Style := [];
      h := CreateRotatedFont(Font, Round(Param.cAngle));
      oldh := SelectObject(Handle, h);
      if Param.cAngle = 0 then
        TextOut((dx - TextWidth(Txt)) div 2, dy - 14, Txt)
      else if Param.cAngle = 90 then
        TextOut(dx - 14, dy - (dy - TextWidth(Txt)) div 2, Txt)
      else if Param.cAngle = 180 then
        TextOut(dx - (dx - TextWidth(Txt)) div 2, 14, Txt)
      else
        TextOut(14, (dy - TextWidth(Txt)) div 2, Txt);
      SelectObject(Handle, oldh);
      DeleteObject(h);
    end;
  EMFCanvas.Free;

  CalcGaps;
  ShowBackground;
  Canvas.StretchDraw(DRect, EMF);
  EMF.Free;
  ShowFrame;
  RestoreCoord;
end;

procedure TfrBarcodeView.Print(Stream: TStream);
begin
  BeginDraw(Canvas);
  Contents.Assign(Memo);
  Report.InternalOnEnterRect(Contents, Self);

  if not Visible then
    Exit;

  if Contents.Count > 0 then
    if (Length(Contents[0]) > 0) and (Contents[0][1] = '[') then
      Contents[0] := frParser.Calc(Contents[0]);
  Stream.Write(Typ, 1);
  frWriteString(Stream, ClassName);
  SaveToStream(Stream);
end;

procedure TfrBarcodeView.DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu);
begin
  // no specific items in popup menu
end;

//--------------------------------------------------------------------------

procedure TfrBarcodeForm.FormCreate(Sender: TObject);
var
  i: TBarcodeType;
begin
  CbType.Items.Clear;
  for i := bcCode_2_5_interleaved to bcCodeEAN13 do
    cbType.Items.Add(bcNames[i, 0]);
  cbType.ItemIndex := 0;
end;

procedure TfrBarcodeForm.FormActivate(Sender: TObject);
begin
  M1.SetFocus;
end;

procedure TfrBarcodeForm.ShowEditor(t: TfrView);
begin
  if t.Memo.Count > 0 then
    M1.Text := t.Memo.Strings[0];
  with t as TfrBarcodeView do
  begin
    cbType.ItemIndex := ord(Param.cBarType);
    ckCheckSum.checked := Param.cCheckSum;
    ckViewText.Checked := Param.cShowText;
    RatioCbo.Text := FloatToStr(Param.cRatio);
    ModuleCbo.Text := IntToStr(Param.cModul);
    if Param.cAngle = 0 then
      RB1.Checked := True
    else if Param.cAngle = 90 then
      RB2.Checked := True
    else if Param.cAngle = 180 then
      RB3.Checked := True
    else
      RB4.Checked := True;
    if ShowModal = mrOk then
    begin
      Memo.Clear;
      Memo.Add(M1.Text);
      Param.cCheckSum := ckCheckSum.Checked;
      Param.cShowText := ckViewText.Checked;
      Param.cBarType := TBarcodeType(cbType.ItemIndex);
      Param.cRatio := StrToFloatDef(RatioCbo.Text, Param.cRatio);
      Param.cModul := StrToIntDef(ModuleCbo.Text, Param.cModul);
      if RB1.Checked then
        Param.cAngle := 0
      else if RB2.Checked then
        Param.cAngle := 90
      else if RB3.Checked then
        Param.cAngle := 180
      else
        Param.cAngle := 270;
    end;
  end;
end;

procedure TfrBarcodeForm.VarBtnClick(Sender: TObject);
var
  frVarForm: TfrVarForm;
begin
  frVarForm := TfrVarForm.Create(frDesigner);
  try
    with frVarForm do
      if ShowModal = mrOk then
        if SelectedItem <> '' then
          M1.Text := '[' + SelectedItem + ']';
    frVarForm.Free;
  finally
    M1.SetFocus;
  end;
end;

procedure TfrBarcodeForm.DBBtnClick(Sender: TObject);
var
  frFieldsForm: TfrFieldsForm;
begin
  frFieldsForm := TfrFieldsForm.Create(frDesigner);
  try
    with frFieldsForm do
      if ShowModal = mrOk then
        if DBField <> '' then
          M1.Text := '[' + DBField + ']';
  finally
    frFieldsForm.Free;
  end;
  M1.SetFocus;
end;

procedure TfrBarcodeForm.bOkClick(Sender: TObject);
var
  bc: TBarcode;
  Bmp: TBitmap;
begin
  bc := TBarcode.Create(nil);
  bc.Text := M1.Text;
  bc.CheckSum := ckCheckSum.Checked;
  bc.Typ := TBarcodeType(cbType.ItemIndex);
  Bmp := TBitmap.Create;
  Bmp.Width := 16; Bmp.Height := 16;
  try
    bc.DrawBarcode(Bmp.Canvas);
  except
    MessageBox(0, 'Error in barcode', 'Error',
      mb_Ok + mb_IconError);
    ModalResult := 0;
  end;
  Bmp.Free;
end;

initialization
  frRegisterObject(TfrBarcodeView, 53, nil, 'Barcode', TfrBarcodeForm);
finalization
end.

