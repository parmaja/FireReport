object frFmtForm: TfrFmtForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Variable formatting'
  ClientHeight = 133
  ClientWidth = 276
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
  object GroupBox2: TGroupBox
    Left = 4
    Top = 5
    Width = 268
    Height = 88
    Caption = 'Variable format'
    TabOrder = 0
    object ComboBox1: TComboBox
      Left = 8
      Top = 20
      Width = 109
      Height = 21
      HelpContext = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = ComboBox1Change
      OnClick = ComboBox1Click
    end
    object ComboBox2: TComboBox
      Left = 128
      Top = 20
      Width = 129
      Height = 21
      HelpContext = 31
      Style = csDropDownList
      TabOrder = 1
      OnClick = ComboBox2Click
    end
    object Panel1: TPanel
      Left = 8
      Top = 52
      Width = 249
      Height = 33
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object Label5: TLabel
        Left = 0
        Top = 8
        Width = 65
        Height = 13
        Caption = '&Decimal digits'
        FocusControl = Edit3
      end
      object Label6: TLabel
        Left = 112
        Top = 8
        Width = 73
        Height = 13
        Caption = 'Fraction &symbol'
        FocusControl = SplEdit
      end
      object SplEdit: TEdit
        Left = 224
        Top = 4
        Width = 25
        Height = 21
        HelpContext = 41
        MaxLength = 1
        TabOrder = 0
        Text = 'SplEdit'
        OnChange = SplEditChange
        OnEnter = SplEditEnter
      end
      object Edit3: TEdit
        Left = 76
        Top = 4
        Width = 25
        Height = 21
        HelpContext = 51
        TabOrder = 1
        Text = '0'
        OnChange = DesEditChange
      end
    end
    object Panel2: TPanel
      Left = 8
      Top = 52
      Width = 249
      Height = 33
      BevelOuter = bvNone
      TabOrder = 3
      object Label1: TLabel
        Left = 60
        Top = 8
        Width = 32
        Height = 13
        Caption = '&Format'
        FocusControl = Edit1
      end
      object Edit1: TEdit
        Left = 120
        Top = 4
        Width = 129
        Height = 21
        HelpContext = 61
        TabOrder = 0
      end
    end
  end
  object Button1: TButton
    Left = 117
    Top = 104
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 197
    Top = 104
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
