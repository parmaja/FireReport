object frBandEditorForm: TfrBandEditorForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Band data source'
  ClientHeight = 126
  ClientWidth = 225
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
    Left = 66
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
    Left = 146
    Top = 96
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GB1: TGroupBox
    Left = 4
    Top = 4
    Width = 217
    Height = 81
    Caption = '&Data source'
    TabOrder = 2
    object Label2: TLabel
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
      Width = 201
      Height = 21
      HelpContext = 88
      Style = csDropDownList
      Sorted = True
      TabOrder = 0
      OnClick = CB1Click
    end
    object Edit1: TEdit
      Left = 136
      Top = 48
      Width = 72
      Height = 21
      HelpContext = 95
      TabOrder = 1
      Text = '1'
    end
  end
end
