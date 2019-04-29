object frMemoEditorForm: TfrMemoEditorForm
  Left = 189
  Top = 201
  HelpContext = 11
  BorderIcons = [biSystemMenu, biMaximize, biHelp]
  Caption = 'Text editor'
  ClientHeight = 238
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    E00000000E0000000E00000EEE00000000E0EEEEE000F00000EEEEE00000FF00
    00EE000000000FF0000EEEEEE000000F0000E00EEEE00000F00E0E0000EE0FFF
    FFF000E0000E00FFFFFFEEEEEEEE000000FEEEEEEEE00000000F0000000000FF
    0000F000000000FFF000F000000000FFFFFFFFFFF00000000FFFFFFFFF00F7FB
    0000FBE30000FD0700007C1F00003CFF00009E070000EF610000F6BC000081DE
    0000C0000000FC010000FEFF0000CF7F0000C77F0000C0070000F8030000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    422
    238)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 6
    Width = 29
    Height = 13
    Caption = '&Memo'
    FocusControl = MemoEdit
  end
  object MemoEdit: TMemo
    Left = 5
    Top = 28
    Width = 413
    Height = 162
    HelpContext = 30
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    WordWrap = False
    OnEnter = MemoEditEnter
    OnKeyDown = MemoEditKeyDown
  end
  object Button1: TButton
    Left = 262
    Top = 210
    Width = 75
    Height = 25
    HelpContext = 40
    Anchors = [akLeft, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 342
    Top = 210
    Width = 75
    Height = 25
    HelpContext = 50
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Button3: TButton
    Left = 2
    Top = 210
    Width = 75
    Height = 25
    HelpContext = 60
    Anchors = [akLeft, akBottom]
    Caption = '&Variable'
    TabOrder = 3
    OnClick = Button3Click
  end
  object FieldsBtn: TButton
    Left = 82
    Top = 210
    Width = 75
    Height = 25
    HelpContext = 70
    Anchors = [akLeft, akBottom]
    Caption = '&Fields'
    TabOrder = 4
    OnClick = FieldsBtnClick
  end
  object Button5: TButton
    Left = 162
    Top = 210
    Width = 75
    Height = 25
    HelpContext = 110
    Anchors = [akLeft, akBottom]
    Caption = '&Format'
    TabOrder = 5
    OnClick = Button5Click
  end
  object CB3: TCheckBox
    Left = 10
    Top = 191
    Width = 109
    Height = 17
    HelpContext = 100
    Anchors = [akLeft, akBottom]
    Caption = '&Word wrap'
    TabOrder = 6
    OnClick = CB3Click
  end
end
