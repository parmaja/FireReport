object frBarCodeForm: TfrBarCodeForm
  Left = 191
  Top = 150
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Barcode editor'
  ClientHeight = 281
  ClientWidth = 269
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 25
    Height = 13
    Caption = 'Code'
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 54
    Height = 13
    Caption = 'Type of bar'
  end
  object RatioLbl: TLabel
    Left = 8
    Top = 92
    Width = 25
    Height = 13
    Caption = 'Ratio'
  end
  object ModuleLbl: TLabel
    Left = 142
    Top = 91
    Width = 35
    Height = 13
    Caption = 'Module'
  end
  object bCancel: TButton
    Left = 188
    Top = 253
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bOk: TButton
    Left = 108
    Top = 253
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = bOkClick
  end
  object M1: TEdit
    Left = 8
    Top = 24
    Width = 215
    Height = 21
    HelpContext = 260
    TabOrder = 0
    Text = '0'
  end
  object cbType: TComboBox
    Left = 8
    Top = 68
    Width = 253
    Height = 21
    HelpContext = 261
    Style = csDropDownList
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 225
    Top = 26
    Width = 34
    Height = 17
    BevelOuter = bvNone
    TabOrder = 4
    object DBBtn: TSpeedButton
      Left = 0
      Top = 0
      Width = 17
      Height = 17
      Hint = 'Insert DB field'
      Caption = 'D'
      Margin = 4
      OnClick = DBBtnClick
    end
    object VarBtn: TSpeedButton
      Left = 17
      Top = 0
      Width = 17
      Height = 17
      Hint = 'Insert variable'
      Caption = 'V'
      OnClick = VarBtnClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 133
    Width = 253
    Height = 61
    Caption = 'Options'
    TabOrder = 5
    object ckCheckSum: TCheckBox
      Left = 8
      Top = 16
      Width = 201
      Height = 17
      HelpContext = 262
      Caption = 'Checksum '
      TabOrder = 0
    end
    object ckViewText: TCheckBox
      Left = 8
      Top = 36
      Width = 201
      Height = 17
      HelpContext = 263
      Caption = 'Human readable'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 202
    Width = 253
    Height = 41
    Caption = 'Rotation'
    TabOrder = 6
    object RB1: TRadioButton
      Left = 8
      Top = 16
      Width = 37
      Height = 17
      HelpContext = 264
      Caption = '0'#176
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RB2: TRadioButton
      Left = 72
      Top = 16
      Width = 37
      Height = 17
      HelpContext = 264
      Caption = '90'#176
      TabOrder = 1
    end
    object RB3: TRadioButton
      Left = 136
      Top = 16
      Width = 45
      Height = 17
      HelpContext = 264
      Caption = '180'#176
      TabOrder = 2
    end
    object RB4: TRadioButton
      Left = 200
      Top = 16
      Width = 45
      Height = 17
      HelpContext = 264
      Caption = '270'#176
      TabOrder = 3
    end
  end
  object RatioCbo: TComboBox
    Left = 8
    Top = 108
    Width = 120
    Height = 21
    HelpContext = 261
    TabOrder = 7
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6')
  end
  object ModuleCbo: TComboBox
    Left = 141
    Top = 108
    Width = 120
    Height = 21
    HelpContext = 261
    TabOrder = 8
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6')
  end
end
