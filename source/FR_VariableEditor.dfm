object frEvForm: TfrEvForm
  Left = 201
  Top = 109
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Variables editor'
  ClientHeight = 331
  ClientWidth = 326
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
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 38
    Height = 13
    Caption = '&Variable'
    FocusControl = VarCombo
  end
  object Label2: TLabel
    Left = 166
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Va&lue'
    FocusControl = ValCombo
  end
  object Label3: TLabel
    Left = 4
    Top = 244
    Width = 51
    Height = 13
    Caption = '&Expression'
    FocusControl = Edit1
  end
  object SB1: TSpeedButton
    Left = 92
    Top = 300
    Width = 25
    Height = 25
    Hint = 'Copy variables'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000CE0E0000C40E00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333FFFFFFFFF333333444444
      4443333333888888888F3333334FFFFFFF433333338F3FFFFF8F3333334F0000
      0F433FFFFF8F8888838F0000004FFFFFFF438888888F3FFFFF8F0FFFFF4F0000
      0F438F3FFF8F8888838F0F00004FFFFFFF438F88888F3FF3FF8F0FFFFF4F00F4
      44438F3FFF8F883888830F00004FFFF4F4338F88888F3338F8330FFFFF4FFFF4
      43338F3FF38FFFF883330F00F044444433338F883888888833330FFFF0F03333
      33338F3338F8333333330FFFF003333333338FFFF88333333333000000333333
      3333888888333333333333333333333333333333333333333333}
    NumGlyphs = 2
    OnClick = SB1Click
  end
  object SB2: TSpeedButton
    Left = 117
    Top = 300
    Width = 25
    Height = 25
    Hint = 'Paste variables'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000CE0E0000C40E00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333333FFFFFFFFF333333444444444433FFFF88888888883000004FFFFF
      FFF43888888F3FFFFFF80838384F444444F48F33338F888888380383834FFFFF
      FFF48F33338F3FFF3FF80838384F444F44448F33338F888388880383834FFFFF
      4F438F33338F33338F830838384FFFFF44338F33338FFFFF88F3038383444444
      40338F333388888888F308383838383830338F33FFFFFFFF38F3038000000008
      80338F388888888F38F308803333330830338F383FF33F8338F303830B00B083
      803383FF88FF88FFF833300000BB000003333888888888888333333330000333
      3333333338888333333333333333333333333333333333333333}
    NumGlyphs = 2
    OnClick = SB2Click
  end
  object Bevel1: TBevel
    Left = 4
    Top = 288
    Width = 317
    Height = 2
    Shape = bsTopLine
  end
  object VarCombo: TComboBox
    Left = 4
    Top = 24
    Width = 155
    Height = 21
    HelpContext = 69
    Style = csDropDownList
    TabOrder = 0
    OnClick = VarComboClick
  end
  object VarList: TListBox
    Left = 4
    Top = 48
    Width = 155
    Height = 189
    HelpContext = 78
    ItemHeight = 13
    TabOrder = 1
    OnClick = VarListClick
  end
  object ValCombo: TComboBox
    Left = 166
    Top = 24
    Width = 155
    Height = 21
    HelpContext = 87
    Style = csDropDownList
    TabOrder = 2
    OnClick = ValComboClick
  end
  object ValList: TListBox
    Left = 166
    Top = 48
    Width = 155
    Height = 189
    HelpContext = 93
    ItemHeight = 13
    TabOrder = 3
    OnClick = ValListClick
    OnExit = Edit1Exit
  end
  object Button1: TButton
    Left = 166
    Top = 300
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 4
    Top = 260
    Width = 317
    Height = 21
    HelpContext = 104
    TabOrder = 5
    OnExit = Edit1Exit
  end
  object Button2: TButton
    Left = 246
    Top = 300
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object Button3: TButton
    Left = 4
    Top = 300
    Width = 85
    Height = 25
    HelpContext = 114
    Caption = 'Va&riables...'
    TabOrder = 7
    OnClick = Button3Click
  end
end
