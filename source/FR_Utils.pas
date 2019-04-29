{*****************************************}
{                                         }
{             FastReport v2.3             }
{            Various routines             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Utils;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls, ClipBrd, Menus, DB,
  System.Types, System.UITypes;

procedure frReadMemo(Stream: TStream; l: TStrings);
procedure frWriteMemo(Stream: TStream; l: TStrings);
function frReadString(Stream: TStream): WideString;
procedure frWriteString(Stream: TStream; s: WideString);
procedure frEnableControls(c: Array of TControl; e: Boolean);
function frControlAtPos(Win: TWinControl; p: TPoint): TControl;
function frGetDataSet(Owner:TComponent; ComplexName: String): TDataSet;
procedure frGetDataSetAndField(Owner:TComponent; ComplexName: String; var DataSet: TDataSet; var Field: TField);
function frGetFontStyle(Style: TFontStyles): Integer;
function frSetFontStyle(Style: Integer): TFontStyles;
function frFindComponent(Owner: TComponent; Name: String): TComponent;
procedure frGetComponents(Owner: TComponent; ClassRef: TClass; List: TStrings; Skip: TComponent);
function frGetWindowsVersion: String;

function frIsBlob(Field: TField): Boolean;
function frIsBookmarksEqual(DataSet: TDataSet; b1, b2: TBookmark): Boolean;
procedure frGetFieldNames(DataSet: TDataSet; List: TStrings);
function frGetBookmark(DataSet: TDataSet): TBookmark;
procedure frFreeBookmark(DataSet: TDataSet; Bookmark: TBookmark);
procedure frGotoBookmark(DataSet: TDataSet; Bookmark: TBookmark);


implementation

uses FR_Classes, FR_Dataset;


function frSetFontStyle(Style: Integer): TFontStyles;
begin
  Result := [];
  if (Style and $1) <> 0 then Result := Result + [fsItalic];
  if (Style and $2) <> 0 then Result := Result + [fsBold];
  if (Style and $4) <> 0 then Result := Result + [fsUnderLine];
end;

function frGetFontStyle(Style: TFontStyles): Integer;
begin
  Result := 0;
  if fsItalic in Style then Result := Result or $1;
  if fsBold in Style then Result := Result or $2;
  if fsUnderline in Style then Result := Result or $4;
end;

procedure RemoveQuotes(var s: String);
begin
  if Length(s) > 2 then
  begin
    if (s[1] = '"') and (s[Length(s)] = '"') then
      s := Copy(s, 2, Length(s) - 2);
  end;
end;

procedure frReadMemo(Stream: TStream; l: TStrings);
var
  b: Byte;
  n: Word;
begin
  l.Clear;
  Stream.Read(n, 2);
  if n > 0 then
    repeat
      l.Add(frReadString(Stream));
      Stream.Read(b, 1);
    until b = 0
  else
    Stream.Read(b, 1);
end;

procedure frWriteMemo(Stream: TStream; l: TStrings);
var
  s: String;
  i: Integer;
  n: Word;
  b: Byte;
begin
  n := l.Count;
  Stream.Write(n, 2);
  for i := 0 to l.Count - 1 do
  begin
    if i > 0 then
    begin
      b := 13;
      Stream.Write(b, 1);
    end;
    s := l[i];
    frWriteString(Stream, s);
  end;
  b := 0;
  Stream.Write(b, 1);
end;

function frReadString(Stream: TStream): WideString;
var
  n: Word;
  buffer: Pointer;
begin
  Stream.Read(n, 2);
  GetMem(buffer, n);
  Stream.Read(Buffer^, n);
  SetString(Result, PWideChar(Buffer), n div SizeOf(WideChar));
  FreeMem(buffer);
end;

procedure frWriteString(Stream: TStream; s: WideString);
var
  n: Word;
begin
  n := ByteLength(s);
  Stream.Write(n, 2);
  Stream.Write(S[1], n);
end;

type
  THackWinControl = class(TWinControl)
  end;

procedure frEnableControls(c: Array of TControl; e: Boolean);
const
  Clr1: Array[Boolean] of TColor = (clGrayText,clWindowText);
  Clr2: Array[Boolean] of TColor = (clBtnFace,clWindow);
var
  i: Integer;
begin
  for i := Low(c) to High(c) do
    if c[i] is TLabel then
      with c[i] as TLabel do
      begin
        Font.Color := Clr1[e];
        Enabled := e;
      end
    else if c[i] is TWinControl then
      with THackWinControl(c[i]) do
      begin
        Color := Clr2[e];
        Enabled := e;
      end;
end;

function frControlAtPos(Win: TWinControl; p: TPoint): TControl;
var
  i: Integer;
  c: TControl;
  p1: TPoint;
begin
  Result := nil;
  with Win do
  begin
    for i := ControlCount - 1 downto 0 do
    begin
      c := Controls[i];
      if c.Visible and PtInRect(Rect(c.Left, c.Top, c.Left + c.Width, c.Top + c.Height), p) then
        if (c is TWinControl) and (csAcceptsControls in c.ControlStyle) and
           (TWinControl(c).ControlCount > 0) then
        begin
          p1 := p;
          Dec(p1.X, c.Left); Dec(p1.Y, c.Top);
          c := frControlAtPos(TWinControl(c), p1);
          if c <> nil then
          begin
            Result := c;
            Exit;
          end;
        end
        else
        begin
          Result := c;
          Exit;
        end;
    end;
  end;
end;

function frGetDataSet(Owner:TComponent; ComplexName: String): TDataSet;
begin
  Result := TDataSet(frFindComponent(Owner, ComplexName));
end;

procedure frGetDataSetAndField(Owner:TComponent; ComplexName: String; var DataSet: TDataSet;
  var Field: TField);
var
  n: Integer;
  f: TComponent;
  s1, s2, s3: String;
begin
  Field := nil;
  f := Owner;
  n := Pos('.', ComplexName);
  if n <> 0 then
  begin
    s1 := Copy(ComplexName, 1, n - 1);        // table name
    s2 := Copy(ComplexName, n + 1, 255);      // field name
    if Pos('.', s2) <> 0 then                 // module name present
    begin
      s3 := Copy(s2, Pos('.', s2) + 1, 255);
      s2 := Copy(s2, 1, Pos('.', s2) - 1);
      f := FindGlobalComponent(s1);
      if f <> nil then
      begin
        DataSet := TDataSet(f.FindComponent(s2));
        RemoveQuotes(s3);
        if DataSet <> nil then
          Field := TField(DataSet.FindField(s3));
      end;
    end
    else
    begin
      DataSet := TDataSet(frFindComponent(f, s1));
      RemoveQuotes(s2);
      if DataSet <> nil then
        Field := TField(DataSet.FindField(s2));
    end;
  end
  else if DataSet <> nil then
  begin
    RemoveQuotes(ComplexName);
    Field := TField(DataSet.FindField(ComplexName));
  end;
end;

function frFindComponent(Owner: TComponent; Name: String): TComponent;
var
  n: Integer;
  s1, s2: String;
begin
  Result := nil;
  n := Pos('.', Name);
  try
    if n = 0 then
      Result := Owner.FindComponent(Name)
    else
    begin
      s1 := Copy(Name, 1, n - 1);        // module name
      s2 := Copy(Name, n + 1, 255);      // component name
      Owner := FindGlobalComponent(s1);
      if Owner <> nil then
        Result := Owner.FindComponent(s2);
    end;
  except
    on Exception do
      raise EClassNotFound.Create('Class not found: ' + Name);
  end;
end;

procedure frGetComponents(Owner: TComponent; ClassRef: TClass; List: TStrings; Skip: TComponent);
var
  i: Integer;
  procedure EnumComponents(f: TComponent);
  var
    i: Integer;
    c: TComponent;
  begin
    for i := 0 to f.ComponentCount - 1 do
    begin
      c := f.Components[i];
      if (c <> Skip) and (c is ClassRef) then
        if f = Owner then
          List.Add(c.Name) else
          List.Add(f.Name + '.' + c.Name);
    end;
  end;
begin
  List.Clear;
  EnumComponents(Owner);
{ for i := 0 to Screen.FormCount - 1 do
    EnumComponents(Screen.Forms[i]);
  for i := 0 to Screen.DataModuleCount - 1 do
    EnumComponents(Screen.DataModules[i])}
end;

function frGetWindowsVersion: String;
var Ver: TOsVersionInfo;
begin
  Ver.dwOSVersionInfoSize := SizeOf(Ver);
  GetVersionEx(Ver);
  with Ver do begin
    case dwPlatformId of
      VER_PLATFORM_WIN32s: Result := '32s';
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          dwBuildNumber := dwBuildNumber and $0000FFFF;
          if (dwMajorVersion > 4) or ((dwMajorVersion = 4) and
            (dwMinorVersion >= 10)) then
            Result := '98' else
            Result := '95';
        end;
      VER_PLATFORM_WIN32_NT: Result := 'NT';
    end;
  end;
end;


function frIsBlob(Field: TField): Boolean;
begin
  Result := (Field <> nil) and (Field.DataType in [ftBlob..ftTypedBinary]);
end;

procedure frGetFieldNames(DataSet: TDataSet; List: TStrings);
begin
  DataSet.GetFieldNames(List);
end;

function frGetBookmark(DataSet: TDataSet): TBookmark;
begin
  Result := DataSet.GetBookmark;
end;

procedure frGotoBookmark(DataSet: TDataSet; Bookmark: TBookmark);
begin
  DataSet.GotoBookmark(BookMark);
end;

procedure frFreeBookmark(DataSet: TDataSet; Bookmark: TBookmark);
begin
  DataSet.FreeBookmark(BookMark);
end;

{$HINTS OFF}

function frIsBookmarksEqual(DataSet: TDataSet; b1, b2: TBookmark): Boolean;
var
  n: Integer;
begin
  Result := DataSet.CompareBookmarks(b1, b2) = 0;
end;

{$HINTS ON}

end.
