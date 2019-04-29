object frDocOptForm: TfrDocOptForm
  Left = 215
  Top = 162
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Report options'
  ClientHeight = 168
  ClientWidth = 213
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
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 205
    Height = 73
    Caption = 'Printer'
    TabOrder = 0
    object ComB1: TComboBox
      Left = 8
      Top = 16
      Width = 189
      Height = 21
      HelpContext = 68
      Style = csDropDownList
      TabOrder = 0
    end
    object CB1: TCheckBox
      Left = 8
      Top = 48
      Width = 185
      Height = 17
      HelpContext = 77
      Caption = '&Select when report loaded'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 84
    Width = 205
    Height = 45
    Caption = 'Other'
    TabOrder = 1
    object CB2: TCheckBox
      Left = 8
      Top = 18
      Width = 181
      Height = 17
      HelpContext = 86
      Caption = '&Two-pass report'
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 54
    Top = 140
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 134
    Top = 140
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
