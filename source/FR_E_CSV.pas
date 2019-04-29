{*****************************************}
{                                         }
{             FastReport v2.3             }
{            CSV export filter            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_E_CSV;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Forms, StdCtrls,
  FR_Classes, FR_E_TXT;

type
  TfrCSVExportFilter = class(TfrTextExportFilter)
  public
    procedure OnEndPage; override;
  end;

procedure InitProc;
procedure FinalProc;

implementation

uses FR_Consts;


procedure TfrCSVExportFilter.OnEndPage;
var
  i, j, n, tc1, tc2: Integer;
  p: TfrTextInfo;
  s: String;
begin
  n := Lines.Count - 1;
  while n >= 0 do
  begin
    if Lines[n] <> nil then break;
    Dec(n);
  end;

  for i := 0 to n do
  begin
    s := '';
    tc1 := 0;
    p := (Lines[i] as TfrTextInfo);
    while p <> nil do
    begin
      tc2 := p.X div 64;
      for j := 0 to tc2 - tc1 - 1 do
        s := s + ';';
      s := s + p.Text;
      tc1 := tc2;
      p := p.Next;
    end;
    s := s + #13#10;
    Stream.Write(s[1], Length(s));
  end;
end;


procedure InitProc;
begin
  frRegisterExportFilter(TfrCSVExportFilter, 'CSV File' + ' (*.csv)', '*.csv');
end;

procedure FinalProc;
begin
end;

initialization
  InitProc;
finalization
  FinalProc;
end.
