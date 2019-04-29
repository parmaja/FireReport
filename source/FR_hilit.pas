{*****************************************}
{                                         }
{             FastReport v2.3             }
{       Highlight attributes dialog       }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Hilit;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, FR_Design, FR_Consts, FR_Classes;

type
  TfrHilightForm = class(TfrEditorForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    CB1: TCheckBox;
    CB2: TCheckBox;
    CB3: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    ColorDialog: TColorDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    RB1: TRadioButton;
    RB2: TRadioButton;
    GroupBox3: TGroupBox;
    Edit1: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RB1Click(Sender: TObject);
  private
  public
    FontColor, FillColor: TColor;
  end;

implementation

{$R *.DFM}


procedure TfrHilightForm.SpeedButton1Click(Sender: TObject);
begin
  ColorDialog.Color := FontColor;
  if ColorDialog.Execute then
  begin
    FontColor := ColorDialog.Color;
//    frSetGlyph(frDesigner, FontColor, SpeedButton1, 0);
  end;
end;

procedure TfrHilightForm.SpeedButton2Click(Sender: TObject);
begin
  ColorDialog.Color := FillColor;
  if ColorDialog.Execute then
  begin
    FillColor := ColorDialog.Color;
//    frSetGlyph(frDesigner, FillColor, SpeedButton2, 1);
  end;
end;

procedure TfrHilightForm.FormActivate(Sender: TObject);
begin
//  frSetGlyph(frDesigner, FontColor, SpeedButton1, 0);
//  frSetGlyph(frDesigner, FillColor, SpeedButton2, 1);
  if FillColor = clNone then
    RB1.Checked := True else
    RB2.Checked := True;
  RB1Click(nil);
end;

procedure TfrHilightForm.RB1Click(Sender: TObject);
begin
  SpeedButton2.Enabled := RB2.Checked;
  if RB1.Checked then FillColor := clNone;
end;

end.

