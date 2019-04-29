object frHilightForm: TfrHilightForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Highlight attributes'
  ClientHeight = 253
  ClientWidth = 229
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
    Top = 56
    Width = 221
    Height = 85
    Caption = '&Condition'
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 140
      Top = 48
      Width = 70
      Height = 25
      Caption = 'C&olor...'
      NumGlyphs = 2
      OnClick = SpeedButton1Click
    end
    object CB1: TCheckBox
      Left = 8
      Top = 20
      Width = 97
      Height = 17
      HelpContext = 67
      Caption = '&Bold'
      TabOrder = 0
    end
    object CB2: TCheckBox
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      HelpContext = 76
      Caption = '&Italic'
      TabOrder = 1
    end
    object CB3: TCheckBox
      Left = 8
      Top = 60
      Width = 105
      Height = 17
      HelpContext = 85
      Caption = '&Underline'
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 148
    Width = 221
    Height = 65
    Caption = 'Background'
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 140
      Top = 28
      Width = 70
      Height = 25
      Caption = 'Co&lor...'
      OnClick = SpeedButton2Click
    end
    object RB1: TRadioButton
      Left = 8
      Top = 20
      Width = 113
      Height = 17
      HelpContext = 92
      Caption = '&Transparent'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RB1Click
    end
    object RB2: TRadioButton
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      HelpContext = 103
      Caption = 'Ot&her'
      TabOrder = 1
      OnClick = RB1Click
    end
  end
  object Button3: TButton
    Left = 70
    Top = 224
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button4: TButton
    Left = 150
    Top = 224
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox3: TGroupBox
    Left = 4
    Top = 4
    Width = 221
    Height = 45
    Caption = 'Font'
    TabOrder = 4
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 205
      Height = 21
      HelpContext = 113
      TabOrder = 0
    end
  end
  object ColorDialog: TColorDialog
    Left = 170
    Top = 56
  end
end
