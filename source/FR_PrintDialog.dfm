object frPrintForm: TfrPrintForm
  Left = 208
  Top = 147
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Print'
  ClientHeight = 230
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 76
    Width = 35
    Height = 13
    Caption = '&Copies:'
    FocusControl = E1
  end
  object Image1: TImage
    Left = 192
    Top = 64
    Width = 18
    Height = 16
    AutoSize = True
    Picture.Data = {
      07544269746D617036010000424D360100000000000076000000280000001200
      0000100000000100040000000000C00000000000000000000000100000000000
      000000000000000080000080000000808000800000008000800080800000C0C0
      C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00333333333333333333000000333333300033333333000000333330088800
      33333300000033300887888800333300000030088777888888003300000038F7
      777F888888880300000038F77FF7778888880300000038FFF779977788880300
      000038F77AA777770788030000003388F77777FF070033000000333388F8FFFF
      F0333300000033333388FFFFFF0333000000333333338FFFFFF0030000003333
      333338FFF8833300000033333333338883333300000033333333333333333300
      0000}
    Visible = False
  end
  object E1: TEdit
    Left = 64
    Top = 72
    Width = 61
    Height = 21
    HelpContext = 99
    TabOrder = 0
    Text = '1'
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 104
    Width = 253
    Height = 117
    Caption = 'Page range'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 82
      Width = 237
      Height = 29
      AutoSize = False
      Caption = 
        'Enter page numbers and/or page ranges, separated by commas. For ' +
        'example, 1,3,5-12'
      WordWrap = True
    end
    object RB1: TRadioButton
      Left = 8
      Top = 20
      Width = 77
      Height = 17
      HelpContext = 108
      Caption = '&All'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RB2: TRadioButton
      Left = 8
      Top = 40
      Width = 93
      Height = 17
      HelpContext = 118
      Caption = 'Current &page'
      TabOrder = 1
    end
    object RB3: TRadioButton
      Left = 8
      Top = 60
      Width = 77
      Height = 17
      HelpContext = 124
      Caption = '&Numbers:'
      TabOrder = 2
      OnClick = RB3Click
    end
    object E2: TEdit
      Left = 88
      Top = 58
      Width = 155
      Height = 21
      HelpContext = 133
      TabOrder = 3
      OnClick = E2Click
    end
  end
  object Panel1: TPanel
    Left = 106
    Top = 74
    Width = 17
    Height = 17
    BevelOuter = bvNone
    TabOrder = 2
    object frSpeedButton1: TSpeedButton
      Left = 0
      Top = 0
      Width = 17
      Height = 8
      Glyph.Data = {
        86000000424D8600000000000000760000002800000007000000040000000100
        0400000000001000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF0F000
        00F0FF000FF0FFF0FFF0}
      Spacing = 0
      OnClick = frSpeedButton1Click
    end
    object frSpeedButton2: TSpeedButton
      Left = 0
      Top = 9
      Width = 17
      Height = 8
      Glyph.Data = {
        86000000424D8600000000000000760000002800000007000000040000000100
        0400000000001000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF0FFF0FF00
        0FF0F00000F0FFFFFFF0}
      OnClick = frSpeedButton2Click
    end
  end
  object Button1: TButton
    Left = 276
    Top = 108
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 276
    Top = 136
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 349
    Height = 49
    Caption = 'Printer'
    TabOrder = 5
    object CB1: TComboBox
      Left = 8
      Top = 17
      Width = 245
      Height = 22
      HelpContext = 142
      Style = csOwnerDrawFixed
      TabOrder = 0
      OnClick = CB1Click
      OnDrawItem = CB1DrawItem
    end
    object PropButton: TButton
      Left = 264
      Top = 15
      Width = 75
      Height = 25
      HelpContext = 152
      Caption = 'Properties'
      TabOrder = 1
      OnClick = PropButtonClick
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 281
    Top = 61
  end
end
