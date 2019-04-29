{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Designer options            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_DesignOptions;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, FR_Consts, FR_Classes;

type
  TfrDesOptionsForm = class(TfrEditorForm)
    PageControl1: TPageControl;
    Tab1: TTabSheet;
    GroupBox1: TGroupBox;
    CB1: TCheckBox;
    CB2: TCheckBox;
    GroupBox2: TGroupBox;
    RB4: TRadioButton;
    RB5: TRadioButton;
    GroupBox3: TGroupBox;
    RB6: TRadioButton;
    RB7: TRadioButton;
    RB8: TRadioButton;
    GroupBox4: TGroupBox;
    RB1: TRadioButton;
    RB2: TRadioButton;
    RB3: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    GroupBox5: TGroupBox;
    CB3: TCheckBox;
    CB4: TCheckBox;
    CB5: TCheckBox;
  private
  public
  end;

implementation

{$R *.DFM}

end.

