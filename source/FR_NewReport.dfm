object frTemplForm: TfrTemplForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'New report'
  ClientHeight = 265
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 246
    Top = 4
    Width = 209
    Height = 221
    Caption = 'Description'
    TabOrder = 0
    object Image1: TImage
      Left = 54
      Top = 104
      Width = 100
      Height = 100
      Center = True
    end
    object Memo1: TMemo
      Left = 8
      Top = 20
      Width = 193
      Height = 69
      HelpContext = 74
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 300
    Top = 236
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 380
    Top = 236
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object LB1: TListBox
    Left = 4
    Top = 8
    Width = 233
    Height = 217
    HelpContext = 65
    ItemHeight = 13
    TabOrder = 3
    OnClick = ListBox1Click
    OnDblClick = LB1DblClick
  end
end
