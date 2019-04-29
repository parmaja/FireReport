object frFieldsForm: TfrFieldsForm
  Left = 193
  Top = 109
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Insert field'
  ClientHeight = 323
  ClientWidth = 231
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  DesignSize = (
    231
    323)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 5
    Width = 108
    Height = 13
    Caption = '&Available Datasource'#39's'
    FocusControl = ValCombo
  end
  object ValCombo: TComboBox
    Left = 4
    Top = 23
    Width = 223
    Height = 21
    HelpContext = 10
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = ValComboClick
  end
  object ValList: TListBox
    Left = 4
    Top = 47
    Width = 223
    Height = 240
    HelpContext = 23
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = ValListDblClick
    OnKeyDown = ValListKeyDown
  end
  object Button1: TButton
    Left = 71
    Top = 292
    Width = 75
    Height = 25
    HelpContext = 40
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 149
    Top = 292
    Width = 75
    Height = 25
    HelpContext = 50
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
