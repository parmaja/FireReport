object frPreviewSearchForm: TfrPreviewSearchForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Find text'
  ClientHeight = 158
  ClientWidth = 262
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
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Text to &find'
    FocusControl = Edit1
  end
  object Edit1: TEdit
    Left = 4
    Top = 24
    Width = 253
    Height = 21
    HelpContext = 98
    TabOrder = 0
  end
  object OkBtn: TButton
    Left = 102
    Top = 128
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 182
    Top = 128
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 52
    Width = 141
    Height = 65
    Caption = 'Options'
    TabOrder = 3
    object CB1: TCheckBox
      Left = 8
      Top = 20
      Width = 121
      Height = 17
      HelpContext = 107
      Caption = '&Case sensitive'
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 152
    Top = 52
    Width = 105
    Height = 65
    Caption = 'Origin'
    TabOrder = 4
    object RB1: TRadioButton
      Left = 8
      Top = 20
      Width = 77
      Height = 17
      HelpContext = 116
      Caption = '&1st page'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RB2: TRadioButton
      Left = 8
      Top = 40
      Width = 85
      Height = 17
      HelpContext = 123
      Caption = 'Current &page'
      TabOrder = 1
    end
  end
end
