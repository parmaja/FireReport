object frInsertFieldsForm: TfrInsertFieldsForm
  Left = 194
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Insert fields'
  ClientHeight = 222
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 6
    Width = 104
    Height = 13
    Caption = '&Available datasources'
    FocusControl = DatasetCB
  end
  object FieldsL: TListBox
    Left = 4
    Top = 46
    Width = 145
    Height = 171
    HelpContext = 106
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
  end
  object DatasetCB: TComboBox
    Left = 4
    Top = 22
    Width = 145
    Height = 21
    HelpContext = 97
    Style = csDropDownList
    Sorted = True
    TabOrder = 1
    OnChange = DatasetCBChange
  end
  object GroupBox1: TGroupBox
    Left = 156
    Top = 15
    Width = 173
    Height = 65
    Caption = 'Placement'
    TabOrder = 2
    object HorzRB: TRadioButton
      Left = 8
      Top = 20
      Width = 153
      Height = 17
      HelpContext = 115
      Caption = '&Horizontal'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object VertRB: TRadioButton
      Left = 8
      Top = 40
      Width = 153
      Height = 17
      HelpContext = 122
      Caption = '&Vertical'
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 172
    Top = 192
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 252
    Top = 192
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object GroupBox2: TGroupBox
    Left = 156
    Top = 85
    Width = 173
    Height = 60
    TabOrder = 5
    object HeaderCB: TCheckBox
      Left = 8
      Top = 14
      Width = 157
      Height = 17
      HelpContext = 132
      Caption = '&Include headers'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object BandCB: TCheckBox
      Left = 8
      Top = 36
      Width = 157
      Height = 17
      Caption = 'Include &bands'
      TabOrder = 1
    end
  end
end
