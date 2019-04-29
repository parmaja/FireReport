object frGEditorForm: TfrGEditorForm
  Left = 200
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Picture'
  ClientHeight = 255
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 4
    Top = 8
    Width = 246
    Height = 241
    Shape = bsFrame
  end
  object Image1: TImage
    Left = 8
    Top = 12
    Width = 237
    Height = 233
    Stretch = True
  end
  object CB1: TCheckBox
    Left = 256
    Top = 232
    Width = 73
    Height = 17
    HelpContext = 82
    Caption = '&Stretch'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = CB1Click
  end
  object Button1: TButton
    Left = 256
    Top = 96
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 256
    Top = 124
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Button3: TButton
    Left = 256
    Top = 8
    Width = 75
    Height = 25
    HelpContext = 63
    Caption = '&Load...'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object Button4: TButton
    Left = 256
    Top = 36
    Width = 75
    Height = 25
    HelpContext = 71
    Caption = '&Clear'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 254
    Top = 63
    Width = 75
    Height = 25
    Caption = '&Memo'
    TabOrder = 5
    OnClick = Button5Click
  end
  object OpenDlg: TOpenDialog
    DefaultExt = 'bmp'
    Options = [ofHideReadOnly]
    Left = 52
    Top = 40
  end
end
