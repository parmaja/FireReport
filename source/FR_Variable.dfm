object frVarForm: TfrVarForm
  Left = 220
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Variables'
  ClientHeight = 324
  ClientWidth = 214
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  DesignSize = (
    214
    324)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 5
    Width = 45
    Height = 13
    Caption = '&Category:'
    FocusControl = ValCombo
  end
  object ValList: TListBox
    Left = 4
    Top = 48
    Width = 207
    Height = 238
    HelpContext = 22
    AutoComplete = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
    OnDblClick = ValListDblClick
    OnKeyDown = ValListKeyDown
  end
  object ValCombo: TComboBox
    Left = 4
    Top = 22
    Width = 207
    Height = 21
    HelpContext = 32
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnClick = ValComboClick
  end
  object Button1: TButton
    Left = 57
    Top = 293
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
    Left = 135
    Top = 293
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
