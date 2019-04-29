{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Progress dialog             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Progress;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Consts;

const
  CM_BeforeModal = WM_USER + 1;

type
  TfrProgressForm = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FOnBeforeModal: TNotifyEvent;
    FOnTerminate: TNotifyEvent;
    procedure CMBeforeModal(var Message: TMessage); message CM_BeforeModal;
  public
    FirstCaption: String;
    property OnBeforeModal: TNotifyEvent read FOnBeforeModal write FOnBeforeModal;
    property OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
    function ShowProgressModal: Word;
  end;

implementation

{$R *.DFM}

function TfrProgressForm.ShowProgressModal: Word;
begin
  PostMessage(Handle, CM_BeforeModal, 0, 0);
  Result := ShowModal;
end;

procedure TfrProgressForm.Button1Click(Sender: TObject);
begin
  if Assigned(FOnTerminate) then
    FOnTerminate(Self);
  ModalResult := mrCancel;
end;

procedure TfrProgressForm.CMBeforeModal(var Message: TMessage);
begin
  if Assigned(FOnBeforeModal) then
    FOnBeforeModal(Self);
end;

procedure TfrProgressForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caHide;
end;

end.

