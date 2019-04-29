object frInspForm: TfrInspForm
  Left = 200
  Top = 108
  BorderStyle = bsSizeToolWin
  Caption = 'Object inspector'
  ClientHeight = 122
  ClientWidth = 130
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 2
    Top = 2
    Width = 120
    Height = 115
    BevelOuter = bvNone
    TabOrder = 0
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 120
      Height = 115
      Align = alClient
      OnMouseDown = PaintBox1MouseDown
      OnPaint = PaintBox1Paint
    end
    object SpeedButton1: TSpeedButton
      Left = 12
      Top = 76
      Width = 14
      Height = 14
      Flat = True
      Glyph.Data = {
        96000000424D960000000000000076000000280000000A000000040000000100
        04000000000020000000CE0E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777700
        0000700700700700000070070070070000007777777777000000}
      Margin = 1
      OnClick = SpeedButton1Click
    end
    object ValueEdit: TEdit
      Left = 12
      Top = 56
      Width = 86
      Height = 14
      BorderStyle = bsNone
      TabOrder = 0
      Visible = False
      OnDblClick = ValueEditDblClick
      OnKeyDown = ValueEditKeyDown
      OnKeyPress = ValueEditKeyPress
    end
  end
end
