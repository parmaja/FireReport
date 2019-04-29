object frGroupEditorForm: TfrGroupEditorForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Group'
  ClientHeight = 89
  ClientWidth = 285
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 125
    Top = 60
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 205
    Top = 60
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
    Width = 277
    Height = 47
    Caption = '&Condition'
    TabOrder = 2
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 260
      Height = 21
      HelpContext = 96
      TabOrder = 0
      Text = 'Edit1'
    end
    object Panel1: TPanel
      Left = 249
      Top = 18
      Width = 17
      Height = 17
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 1
      object frSpeedButton1: TSpeedButton
        Left = 0
        Top = 0
        Width = 17
        Height = 17
        Hint = 'Insert DB field'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Glyph.Data = {
          96000000424D960000000000000076000000280000000A000000040000000100
          04000000000020000000CE0E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777700
          0000700700700700000070070070070000007777777777000000}
        ParentFont = False
        OnClick = frSpeedButton1Click
      end
    end
  end
end
