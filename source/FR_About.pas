
{*****************************************}
{                                         }
{             FastReport v2.3             }
{              About window               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_About;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FR_Consts;

type
  TfrAboutForm = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Bevel2: TBevel;
  private
  public
  end;

implementation

{$R *.DFM}

end.

