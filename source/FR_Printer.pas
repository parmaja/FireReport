
{*****************************************}
{                                         }
{             FastReport v2.3             }
{              Printer info               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Printer;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Printers, WinSpool, FR_Classes, FR_Consts;

type
  TfrPrinter = class
  private
    FDevice: PChar;
    FDriver: PChar;
    FPort: PChar;
    FDeviceMode: THandle;
    FMode: PDeviceMode;
    FPrinter: TPrinter;
    FPaperNames: TStringList;
    FPrinters: TStringList;
    FPrinterIndex: Integer;
    FDefaultPrinter: Integer;
    procedure GetSettings;
    procedure SetSettings;
    procedure SetPrinter(Value: TPrinter);
    procedure SetPrinterIndex(Value: Integer);
  public
    Orientation: TPrinterOrientation;
    PaperSize: Integer;
    PaperWidth: Integer;
    PaperHeight: Integer;
    PaperSizes: Array[0..255] of Word;
    PaperSizesNum: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure FillPrnInfo(var p: TfrPrnInfo);
    procedure SetPrinterInfo(pgSize, pgWidth, pgHeight: Integer;
      pgOr: TPrinterOrientation);
    function IsEqual(pgSize, pgWidth, pgHeight: Integer;
      pgOr: TPrinterOrientation): Boolean;
    function GetArrayPos(pgSize: Integer): Integer;
    property PaperNames: TStringList read FPaperNames;
    property Printer: TPrinter read FPrinter write SetPrinter;
    property Printers: TStringList read FPrinters;
    property PrinterIndex: Integer read FPrinterIndex write SetPrinterIndex;
  end;

function Prn: TfrPrinter;

implementation

var
  FfrPrinter:TfrPrinter = nil;

function Prn: TfrPrinter;
begin
  if not Assigned(FfrPrinter) then
  begin
    FfrPrinter:=TfrPrinter.Create;
    FfrPrinter.Printer := Printer;
  end;
  Result := FfrPrinter;
end;

type
  TPaperInfo = record
    Typ: Integer;
    Name: String;
    X, Y: Integer;
  end;

const
  PAPERCOUNT = 67;
  PaperInfo: Array[0..PAPERCOUNT - 1] of TPaperInfo = (
    (Typ:1;  Name: 'Letter, 8 1/2 x 11""'; X:2159; Y:2794),
    (Typ:2;  Name: 'Letter small, 8 1/2 x 11""'; X:2159; Y:2794),
    (Typ:3;  Name: 'Tabloid, 11 x 17""'; X:2794; Y:4318),
    (Typ:4;  Name: 'Ledger, 17 x 11""'; X:4318; Y:2794),
    (Typ:5;  Name: 'Legal, 8 1/2 x 14""'; X:2159; Y:3556),
    (Typ:6;  Name: 'Statement, 5 1/2 x 8 1/2""'; X:1397; Y:2159),
    (Typ:7;  Name: 'Executive, 7 1/4 x 10 1/2""'; X:1842; Y:2667),
    (Typ:8;  Name: 'A3 297 x 420 mm'; X:2970; Y:4200),
    (Typ:9;  Name: 'A4 210 x 297 mm'; X:2100; Y:2970),
    (Typ:10; Name: 'A4 small sheet, 210 x 297 mm'; X:2100; Y:2970),
    (Typ:11; Name: 'A5 148 x 210 mm'; X:1480; Y:2100),
    (Typ:12; Name: 'B4 250 x 354 mm'; X:2500; Y:3540),
    (Typ:13; Name: 'B5 182 x 257 mm'; X:1820; Y:2570),
    (Typ:14; Name: 'Folio, 8 1/2 x 13""'; X:2159; Y:3302),
    (Typ:15; Name: 'Quarto Sheet, 215 x 275 mm'; X:2150; Y:2750),
    (Typ:16; Name: '10 x 14""'; X:2540; Y:3556),
    (Typ:17; Name: '11 x 17""'; X:2794; Y:4318),
    (Typ:18; Name: 'Note, 8 1/2 x 11""'; X:2159; Y:2794),
    (Typ:19; Name: '9 Envelope, 3 7/8 x 8 7/8""'; X:984;  Y:2254),
    (Typ:20; Name: '10 Envelope, 4 1/8  x 9 1/2""'; X:1048; Y:2413),
    (Typ:21; Name: '11 Envelope, 4 1/2 x 10 3/8""'; X:1143; Y:2635),
    (Typ:22; Name: '12 Envelope, 4 3/4 x 11""'; X:1207; Y:2794),
    (Typ:23; Name: '14 Envelope, 5 x 11 1/2""'; X:1270; Y:2921),
    (Typ:24; Name: 'C Sheet, 17 x 22""'; X:4318; Y:5588),
    (Typ:25; Name: 'D Sheet, 22 x 34""'; X:5588; Y:8636),
    (Typ:26; Name: 'E Sheet, 34 x 44""'; X:8636; Y:11176),
    (Typ:27; Name: 'DL Envelope, 110 x 220 mm'; X:1100; Y:2200),
    (Typ:28; Name: 'C5 Envelope, 162 x 229 mm'; X:1620; Y:2290),
    (Typ:29; Name: 'C3 Envelope,  324 x 458 mm'; X:3240; Y:4580),
    (Typ:30; Name: 'C4 Envelope,  229 x 324 mm'; X:2290; Y:3240),
    (Typ:31; Name: 'C6 Envelope,  114 x 162 mm'; X:1140; Y:1620),
    (Typ:32; Name: 'C65 Envelope, 114 x 229 mm'; X:1140; Y:2290),
    (Typ:33; Name: 'B4 Envelope,  250 x 353 mm'; X:2500; Y:3530),
    (Typ:34; Name: 'B5 Envelope,  176 x 250 mm'; X:1760; Y:2500),
    (Typ:35; Name: 'B6 Envelope,  176 x 125 mm'; X:1760; Y:1250),
    (Typ:36; Name: 'Italy Envelope, 110 x 230 mm'; X:1100; Y:2300),
    (Typ:37; Name: 'Monarch Envelope, 3 7/8 x 7 1/2""'; X:984;  Y:1905),
    (Typ:38; Name: '6 3/4 Envelope, 3 5/8 x 6 1/2""'; X:920;  Y:1651),
    (Typ:39; Name: 'US Std Fanfold, 14 7/8 x 11""'; X:3778; Y:2794),
    (Typ:40; Name: 'German Std Fanfold, 8 1/2 x 12""'; X:2159; Y:3048),
    (Typ:41; Name: 'German Legal Fanfold, 8 1/2 x 13""'; X:2159; Y:3302),
    (Typ:42; Name: 'B4 (ISO) 250 x 353 mm'; X:2500; Y:3530),
    (Typ:43; Name: 'Japanese Postcard 100 x 148 mm'; X:1000; Y:1480),
    (Typ:44; Name: '9 x 11""'; X:2286; Y:2794),
    (Typ:45; Name: '10 x 11""'; X:2540; Y:2794),
    (Typ:46; Name: '15 x 11""'; X:3810; Y:2794),
    (Typ:47; Name: 'Envelope Invite 220 x 220 mm'; X:2200; Y:2200),
    (Typ:50; Name: 'Letter Extra 9/275 x 12""'; X:2355; Y:3048),
    (Typ:51; Name: 'Legal Extra 9/275 x 15""'; X:2355; Y:3810),
    (Typ:52; Name: 'Tabloid Extra 11.69 x 18""'; X:2969; Y:4572),
    (Typ:53; Name: 'A4 Extra 9.27 x 12.69""'; X:2354; Y:3223),
    (Typ:54; Name: 'Letter Transverse 8/275 x 11""'; X:2101; Y:2794),
    (Typ:55; Name: 'A4 Transverse 210 x 297 mm'; X:2100; Y:2970),
    (Typ:56; Name: 'Letter Extra Transverse 9/275 x 12""'; X:2355; Y:3048),
    (Typ:57; Name: 'SuperASuperAA4 227 x 356 mm'; X:2270; Y:3560),
    (Typ:58; Name: 'SuperBSuperBA3 305 x 487 mm'; X:3050; Y:4870),
    (Typ:59; Name: 'Letter Plus 8.5 x 12.69""'; X:2159; Y:3223),
    (Typ:60; Name: 'A4 Plus 210 x 330 mm'; X:2100; Y:3300),
    (Typ:61; Name: 'A5 Transverse 148 x 210 mm'; X:1480; Y:2100),
    (Typ:62; Name: 'B5 (JIS) Transverse 182 x 257 mm'; X:1820; Y:2570),
    (Typ:63; Name: 'A3 Extra 322 x 445 mm'; X:3220; Y:4450),
    (Typ:64; Name: 'A5 Extra 174 x 235 mm'; X:1740; Y:2350),
    (Typ:65; Name: 'B5 (ISO) Extra 201 x 276 mm'; X:2010; Y:2760),
    (Typ:66; Name: 'A2 420 x 594 mm'; X:4200; Y:5940),
    (Typ:67; Name: 'A3 Transverse 297 x 420 mm'; X:2970; Y:4200),
    (Typ:68; Name: 'A3 Extra Transverse 322 x 445 mm'; X:3220; Y:4450),
    (Typ:256;Name: 'Custom'; X:0;    Y:0));


function DeviceCapabilities(pDevice, pPort: PChar; fwCapability: Word; pOutput: PChar;
  DevMode: PDeviceMode): Integer; stdcall; external winspl name 'DeviceCapabilitiesA';

{----------------------------------------------------------------------------}
constructor TfrPrinter.Create;
begin
  inherited Create;
  GetMem(FDevice, 128);
  GetMem(FDriver, 128);
  GetMem(FPort, 128);
  FPaperNames := TStringList.Create;
  FPrinters := TStringList.Create;
end;

destructor TfrPrinter.Destroy;
begin
  FreeMem(FDevice, 128);
  FreeMem(FDriver, 128);
  FreeMem(FPort, 128);
  FPaperNames.Free;
  FPrinters.Free;
  inherited Destroy;
end;

procedure TfrPrinter.GetSettings;
var
  i: Integer;
  PaperNames: PChar;
  Size: TPoint;
begin
  FPrinter.GetPrinter(FDevice, FDriver, FPort, FDeviceMode);
  try
    FMode := GlobalLock(FDeviceMode);

    PaperSize := FMode.dmPaperSize;

    Escape(FPrinter.Handle, GetPhysPageSize, 0, nil, @Size);
    PaperWidth := Round(Size.X / GetDeviceCaps(FPrinter.Handle, LOGPIXELSX) * 254);
    PaperHeight := Round(Size.Y / GetDeviceCaps(FPrinter.Handle, LOGPIXELSY) * 254);

    FillChar(PaperSizes, SizeOf(PaperSizes), 0);
    PaperSizesNum := DeviceCapabilities(FDevice, FPort, DC_PAPERS, @PaperSizes, FMode);

    GetMem(PaperNames, PaperSizesNum * 64);
    DeviceCapabilities(FDevice, FPort, DC_PAPERNAMES, PaperNames, FMode);
    FPaperNames.Clear;
    for i := 0 to PaperSizesNum - 1 do
      FPaperNames.Add(StrPas(PaperNames + i * 64));
    FreeMem(PaperNames, PaperSizesNum * 64);
  finally
    GlobalUnlock(FDeviceMode);
  end;
end;

procedure TfrPrinter.SetSettings;
var
  i, n: Integer;
begin
  if FPrinterIndex = FDefaultPrinter then
  begin
    FPaperNames.Clear;
    for i := 0 to PAPERCOUNT - 1 do
    begin
      FPaperNames.Add(PaperInfo[i].Name);
      PaperSizes[i] := PaperInfo[i].Typ;
      if (PaperSize <> $100) and (PaperSize = PaperInfo[i].Typ) then
      begin
        PaperWidth := PaperInfo[i].X;
        PaperHeight := PaperInfo[i].Y;
        if Orientation = poLandscape then
        begin
          n := PaperWidth; PaperWidth := PaperHeight; PaperHeight := n;
        end;
      end;
    end;
    PaperSizesNum := PAPERCOUNT;
    Exit;
  end;

  FPrinter.GetPrinter(FDevice, FDriver, FPort, FDeviceMode);
  try
    FMode := GlobalLock(FDeviceMode);
    if PaperSize = $100 then
    begin
      FMode.dmFields := FMode.dmFields or DM_PAPERLENGTH or DM_PAPERWIDTH;
//      FMode.dmFormName := //zaher
      FMode.dmPaperLength := PaperHeight;
      FMode.dmPaperWidth := PaperWidth;
    end;

    if (FMode.dmFields and DM_PAPERSIZE) <> 0 then
      FMode.dmPaperSize := PaperSize;

    if (FMode.dmFields and DM_ORIENTATION) <> 0 then
      if Orientation = poPortrait then
        FMode.dmOrientation := DMORIENT_PORTRAIT else
        FMode.dmOrientation := DMORIENT_LANDSCAPE;

    if (FMode.dmFields and DM_COPIES) <> 0 then
      FMode.dmCopies := 1;

    FPrinter.SetPrinter(FDevice, FDriver, FPort, FDeviceMode);
  finally
    GlobalUnlock(FDeviceMode);
  end;
  GetSettings;
end;

procedure TfrPrinter.FillPrnInfo(var p: TfrPrnInfo);
var
  kx, ky: Double;
begin
  kx := 93 / 1.022;
  ky := 93 / 1.015;
  if FPrinterIndex = FDefaultPrinter then
    with p do
    begin
      Pgw := Round(PaperWidth * kx / 254);
      Pgh := Round(PaperHeight * ky / 254);
      Ofx := Round(50 * kx / 254);
      Ofy := Round(50 * ky / 254);
      Pw := Pgw - Ofx * 2;
      Ph := Pgh - Ofy * 2;
    end
  else
    with p, FPrinter do
    begin
      kx := kx / GetDeviceCaps(Handle, LOGPIXELSX);
      ky := ky / GetDeviceCaps(Handle, LOGPIXELSY);
      PPgw := GetDeviceCaps(Handle, PHYSICALWIDTH); Pgw := Round(PPgw * kx);
      PPgh := GetDeviceCaps(Handle, PHYSICALHEIGHT); Pgh := Round(PPgh * ky);
      POfx := GetDeviceCaps(Handle, PHYSICALOFFSETX); Ofx := Round(POfx * kx);
      POfy := GetDeviceCaps(Handle, PHYSICALOFFSETY); Ofy := Round(POfy * ky);
      PPw := PageWidth; Pw := Round(PPw * kx);
      PPh := PageHeight; Ph := Round(PPh * ky);
    end;
end;

function TfrPrinter.IsEqual(pgSize, pgWidth, pgHeight: Integer;
  pgOr: TPrinterOrientation): Boolean;
begin
  if (PaperSize = pgSize) and (pgSize = $100) then
    Result := (PaperSize = pgSize) and (PaperWidth = pgWidth) and
     (PaperHeight = pgHeight) and (Orientation = pgOr)
  else
    Result := (PaperSize = pgSize) and (Orientation = pgOr);
end;

procedure TfrPrinter.SetPrinterInfo(pgSize, pgWidth, pgHeight: Integer;
  pgOr: TPrinterOrientation);
begin
  if IsEqual(pgSize, pgWidth, pgHeight, pgOr) then Exit;
  PaperSize := pgSize;
  PaperWidth := pgWidth;
  PaperHeight := pgHeight;
  Orientation := pgOr;
  SetSettings;
end;

function TfrPrinter.GetArrayPos(pgSize: Integer): Integer;
var
  i: Integer;
begin
  Result := PaperSizesNum - 1;
  for i := 0 to PaperSizesNum - 1 do
    if PaperSizes[i] = pgSize then
    begin
      Result := i;
      break;
    end;
end;

procedure TfrPrinter.SetPrinterIndex(Value: Integer);
begin
  FPrinterIndex := Value;
  if Value = FDefaultPrinter then
    SetSettings
  else if FPrinter.Printers.Count > 0 then
  begin
    FPrinter.PrinterIndex := Value;
    GetSettings;
  end;
end;

procedure TfrPrinter.SetPrinter(Value: TPrinter);
begin
  FPrinters.Clear;
  FPrinterIndex := 0;
  FPrinter := Value;
  if FPrinter.Printers.Count > 0 then
  begin
    FPrinters.Assign(FPrinter.Printers);
    FPrinterIndex := FPrinter.PrinterIndex;
    GetSettings;
  end;
  FPrinters.Add('Default printer');
  FDefaultPrinter := FPrinters.Count - 1;
end;


{----------------------------------------------------------------------------}

initialization
finalization
  FreeAndNil(FfrPrinter);
end.
