object frVBandEditorForm: TfrVBandEditorForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Band data sources'
  ClientHeight = 126
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 236
    Top = 96
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 316
    Top = 96
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 185
    Height = 117
    Caption = 'Bands'
    TabOrder = 2
    object LB1: TListBox
      Left = 8
      Top = 16
      Width = 169
      Height = 93
      HelpContext = 105
      ItemHeight = 13
      TabOrder = 0
      OnClick = LB1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 196
    Top = 4
    Width = 197
    Height = 81
    Caption = 'Data source'
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 52
      Width = 65
      Height = 13
      Caption = '&Record count'
      FocusControl = Edit1
    end
    object CB1: TComboBox
      Left = 8
      Top = 16
      Width = 181
      Height = 21
      HelpContext = 88
      Style = csDropDownList
      Sorted = True
      TabOrder = 0
      OnClick = CB1Click
      OnExit = CB1Exit
    end
    object Edit1: TEdit
      Left = 132
      Top = 48
      Width = 57
      Height = 21
      HelpContext = 95
      TabOrder = 1
      Text = '1'
      OnExit = CB1Exit
    end
  end
end
