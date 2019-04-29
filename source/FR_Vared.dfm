object frVaredForm: TfrVaredForm
  Left = 200
  Top = 108
  ActiveControl = Memo1
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Variables list'
  ClientHeight = 269
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 7
    Width = 116
    Height = 13
    Caption = '&Categories and variables'
    FocusControl = Memo1
  end
  object Button4: TButton
    Left = 88
    Top = 240
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button5: TButton
    Left = 168
    Top = 240
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 4
    Top = 24
    Width = 241
    Height = 209
    HelpContext = 79
    TabOrder = 2
  end
end
