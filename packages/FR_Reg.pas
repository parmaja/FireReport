{*****************************************}
{                                         }
{             FastReport v2.3             }
{            Registration unit            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}


unit FR_Reg;

interface

{$I '..\source\FR.inc'}

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes,
  DesignIntf, DesignEditors, DesignWindows, DsnConst,
  FR_Classes, FR_Dataset, FR_DBDataset,
  FR_CheckBox, FR_Shape, FR_Barcodes, FR_BarcodeUtils,
  FR_Design, FR_Preview, FR_Dock,
  FR_E_TXT, FR_E_RTF, FR_E_CSV, FR_E_HTM, FR_Consts;

{-----------------------------------------------------------------------}
type
  TfrRepEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
    procedure DoDesign;
  end;

procedure TfrRepEditor.ExecuteVerb(Index: Integer);
begin
  DoDesign;
end;

function TfrRepEditor.GetVerb(Index: Integer): String;
begin
  Result := 'Design Report';
end;

function TfrRepEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TfrRepEditor.DoDesign;
begin
  if TfrReport(Component).DesignReport then
    Designer.Modified;
end;

{-----------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents('FireReport',
    [TfrReport, TfrDBDataSet, TfrUserDataset, TfrOLEObject, TfrCheckBoxObject,
     TfrShapeObject, TfrBarcodeObject, TfrTextExport, TfrRTFExport, TfrCSVExport,
     TfrHTMExport,  TfrDesigner,  TfrPreview]);
  RegisterComponentEditor(TfrReport, TfrRepEditor);
end;

end.
