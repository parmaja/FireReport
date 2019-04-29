object frOleForm: TfrOleForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'OLE object'
  ClientHeight = 270
  ClientWidth = 426
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
  object Image1: TImage
    Left = 340
    Top = 132
    Width = 16
    Height = 16
    AutoSize = True
    Picture.Data = {
      07544269746D6170F6000000424DF60000000000000076000000280000001000
      0000100000000100040000000000800000000000000000000000100000000000
      000000000000000080000080000000808000800000008000800080800000C0C0
      C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00777777777788877777778777700088777778887782220887790088872222
      2087799908822222208779999002A222227779991112AA222277799111178AA2
      2777799117777222777779177777CCC0887777777774CCCC08777777777CCCCC
      08777777777CCC4C08777777777CC4C40877777777774C444777777777777444
      7777}
    Visible = False
  end
  object Button1: TButton
    Left = 336
    Top = 8
    Width = 85
    Height = 25
    HelpContext = 52
    Caption = '&Insert...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 336
    Top = 36
    Width = 85
    Height = 25
    HelpContext = 119
    Caption = '&Edit...'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 336
    Top = 64
    Width = 85
    Height = 25
    HelpContext = 40
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 2
  end
  object OleContainer1: TOleContainer
    Left = 4
    Top = 8
    Width = 325
    Height = 257
    HelpContext = 125
    AllowInPlace = False
    AutoActivate = aaManual
    AutoVerbMenu = False
    Caption = 'OleContainer1'
    SizeMode = smStretch
    TabOrder = 3
  end
end
