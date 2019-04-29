{*****************************************}
{                                         }
{             FastReport v2.3             }
{              Picture editor             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_PictureEditor;

interface

{$I FR.inc}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, FR_Classes, FR_Consts;

type
  TfrGEditorForm = class(TfrObjEditorForm)
    Image1: TImage;
    Bevel1: TBevel;
    OpenDlg: TOpenDialog;
    CB1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure CB1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
  public
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

{$R *.DFM}

procedure TfrGEditorForm.BitBtn1Click(Sender: TObject);
begin
  OpenDlg.Filter := 'Picture file' + ' (*.bmp *.jpg *.ico *.wmf *.emf)|*.bmp;*.jpg;*.ico;*.wmf;*.emf|' +
    'All files' + '|*.*';
  if OpenDlg.Execute then
    Image1.Picture.LoadFromFile(OpenDlg.FileName);
end;

procedure TfrGEditorForm.CB1Click(Sender: TObject);
begin
  Image1.Stretch := CB1.Checked;
end;

procedure TfrGEditorForm.Button4Click(Sender: TObject);
begin
  Image1.Picture.Assign(nil);
end;

procedure TfrGEditorForm.Button5Click(Sender: TObject);
begin
  if frDesigner <> nil then
    frDesigner.ShowMemoEditor;
end;

procedure TfrGEditorForm.ShowEditor(t: TfrView);
begin
  inherited;
end;

end.

