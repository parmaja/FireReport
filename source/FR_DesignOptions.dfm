object frDesOptionsForm: TfrDesOptionsForm
  Left = 194
  Top = 109
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 323
  ClientWidth = 357
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
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 349
    Height = 281
    ActivePage = Tab1
    TabOrder = 0
    object Tab1: TTabSheet
      Caption = 'Designer'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 4
        Top = 4
        Width = 177
        Height = 65
        Caption = 'Grid'
        TabOrder = 0
        object CB1: TCheckBox
          Left = 8
          Top = 20
          Width = 157
          Height = 17
          HelpContext = 66
          Caption = '&Show grid'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CB2: TCheckBox
          Left = 8
          Top = 40
          Width = 157
          Height = 17
          HelpContext = 75
          Caption = 'Align to &grid'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object GroupBox2: TGroupBox
        Left = 188
        Top = 4
        Width = 149
        Height = 65
        Caption = 'Object moving'
        TabOrder = 1
        object RB4: TRadioButton
          Left = 8
          Top = 20
          Width = 133
          Height = 17
          HelpContext = 84
          Caption = 'S&hape'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RB5: TRadioButton
          Left = 8
          Top = 40
          Width = 133
          Height = 17
          HelpContext = 94
          Caption = '&Contents'
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 188
        Top = 74
        Width = 149
        Height = 85
        Caption = 'Report units'
        TabOrder = 2
        object RB6: TRadioButton
          Left = 8
          Top = 20
          Width = 133
          Height = 17
          HelpContext = 102
          Caption = '&Pixels'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RB7: TRadioButton
          Left = 8
          Top = 40
          Width = 133
          Height = 17
          HelpContext = 112
          Caption = '&MM'
          TabOrder = 1
        end
        object RB8: TRadioButton
          Left = 8
          Top = 60
          Width = 133
          Height = 17
          HelpContext = 121
          Caption = '&Inches'
          TabOrder = 2
        end
      end
      object GroupBox4: TGroupBox
        Left = 4
        Top = 74
        Width = 177
        Height = 85
        Caption = 'Grid size'
        TabOrder = 3
        object RB1: TRadioButton
          Left = 8
          Top = 20
          Width = 145
          Height = 17
          HelpContext = 131
          Caption = '&4 pixels'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RB2: TRadioButton
          Left = 8
          Top = 40
          Width = 145
          Height = 17
          HelpContext = 141
          Caption = '&8 pixels'
          TabOrder = 1
        end
        object RB3: TRadioButton
          Left = 8
          Top = 60
          Width = 145
          Height = 17
          HelpContext = 151
          Caption = '&18 pixels (5mm)'
          TabOrder = 2
        end
      end
      object GroupBox5: TGroupBox
        Left = 4
        Top = 164
        Width = 333
        Height = 85
        Caption = 'Other'
        TabOrder = 4
        object CB3: TCheckBox
          Left = 8
          Top = 18
          Width = 133
          Height = 17
          HelpContext = 161
          Caption = 'Colored &buttons'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CB4: TCheckBox
          Left = 8
          Top = 38
          Width = 221
          Height = 17
          HelpContext = 171
          Caption = '&Editing after insert'
          TabOrder = 1
        end
        object CB5: TCheckBox
          Left = 8
          Top = 60
          Width = 225
          Height = 17
          Caption = 'Show band &titles'
          TabOrder = 2
        end
      end
    end
  end
  object Button1: TButton
    Left = 198
    Top = 292
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 278
    Top = 292
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
