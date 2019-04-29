object frTemplNewForm: TfrTemplNewForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'New report template'
  ClientHeight = 292
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 44
    Height = 13
    Caption = '&Comment'
    FocusControl = Memo
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 136
    Width = 211
    Height = 117
    Caption = 'Icon'
    TabOrder = 0
    object Panel1: TPanel
      Left = 8
      Top = 20
      Width = 88
      Height = 89
      HelpContext = 83
      BevelOuter = bvLowered
      TabOrder = 0
      object Image: TImage
        Left = 1
        Top = 1
        Width = 86
        Height = 87
        Align = alClient
        Center = True
      end
    end
    object Button1: TButton
      Left = 124
      Top = 20
      Width = 75
      Height = 25
      HelpContext = 64
      Caption = '&File...'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Button2: TButton
    Left = 60
    Top = 264
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button3: TButton
    Left = 140
    Top = 264
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Memo: TMemo
    Left = 4
    Top = 20
    Width = 210
    Height = 109
    HelpContext = 73
    TabOrder = 3
  end
  object OpenDialog: TOpenDialog
    Left = 151
    Top = 195
  end
end
