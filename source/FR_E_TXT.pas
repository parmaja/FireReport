{*****************************************}
{                                         }
{             FastReport v2.3             }
{           Text export filter            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_E_TXT;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Dialogs, FR_Classes;

type
  TfrTextExportFilter = class(TfrExportFilter)
  public
    constructor Create(AStream: TStream); override;
    procedure OnEndPage; override;
    procedure OnBeginPage; override;
    procedure OnText(X, Y: Integer; const Text: String; View: TfrView); override;
  end;

implementation

uses
  FR_Utils, FR_Consts;

var
  UsedFont: Integer = 16;

constructor TfrTextExportFilter.Create(AStream: TStream);
var
  s: String;
begin
  inherited;
  s := InputBox('Filter properties', 'Average font height:', '16');
  UsedFont := StrToIntDef(s, 16);
end;

procedure TfrTextExportFilter.OnEndPage;
var
  i, n, x, tc1: Integer;
  p: TfrTextInfo;
  s: String;
  function Dup(Count: Integer): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to Count do
      Result := Result + ' ';
  end;

begin
  n := Lines.Count - 1;
  while n >= 0 do
  begin
    if Lines[n] <> nil then
      break;
    Dec(n);
  end;

  for i := 0 to n do
  begin
    s := '';
    tc1 := 0;
    p := (Lines[i] as TfrTextInfo);
    while p <> nil do
    begin
      x := Round(p.X / 6.5);
      s := s + Dup(x - tc1) + p.Text;
      tc1 := x + Length(p.Text);
      p := p.Next;
    end;
    s := s + #13#10;
    Stream.Write(s[1], Length(s));
  end;
  s := #12#13#10;
  Stream.Write(s[1], Length(s));
end;

procedure TfrTextExportFilter.OnBeginPage;
var
  i: Integer;
begin
  Clear;
  for i := 0 to 200 do
    Lines.Add(nil);
end;

procedure TfrTextExportFilter.OnText(X, Y: Integer; const Text: String;
  View: TfrView);
var
  p, p1, p2: TfrTextInfo;
begin
  if View = nil then
    Exit;
  Y := Round(Y / UsedFont);
  p1 := (Lines[Y] as TfrTextInfo);
  p := TfrTextInfo.Create;
  p.Next := nil;
  p.X := X;
  p.Text := Text;
  if View is TfrMemoView then
    with View as TfrMemoView do
    begin
      p.FontName := Font.Name;
      p.FontSize := Font.Size;
      p.FontStyle := frGetFontStyle(Font.Style);
      p.FontColor := Font.Color;
      p.FontCharset := Font.Charset;
    end;
  p.FillColor := View.FillColor;
  if p1 = nil then
    Lines[Y] := TObject(p)
  else
  begin
    p2 := p1;
    while (p1 <> nil) and (p1.X < p.X) do
    begin
      p2 := p1;
      p1 := p1.Next;
    end;
    if p2 <> p1 then
    begin
      p2.Next := p;
      p.Next := p1;                   
    end
    else
    begin
      Lines[Y] := TObject(p);
      p.Next := p1;
    end;
  end;
end;

initialization
  frRegisterExportFilter(TfrTextExportFilter, 'Text file' + ' (*.txt)', '*.txt');
finalization
end.
