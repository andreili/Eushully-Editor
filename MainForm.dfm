object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 511
  ClientWidth = 677
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 241
    Top = 0
    Height = 406
    ExplicitLeft = 8
    ExplicitTop = 208
    ExplicitHeight = 100
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 406
    Width = 677
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 2
    ExplicitTop = 2
    ExplicitWidth = 385
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 406
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 0
    ExplicitHeight = 386
    object Label1: TLabel
      Left = 2
      Top = 2
      Width = 237
      Height = 13
      Align = alTop
      Caption = #1060#1072#1081#1083#1099':'
      ExplicitWidth = 38
    end
    object tv_files: TTreeView
      Left = 2
      Top = 15
      Width = 237
      Height = 389
      Align = alClient
      Indent = 19
      MultiSelect = True
      PopupMenu = PopupMenu1
      ReadOnly = True
      TabOrder = 0
      OnClick = tv_filesClick
      ExplicitHeight = 369
    end
  end
  object Panel3: TPanel
    Left = 244
    Top = 0
    Width = 433
    Height = 406
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 1
    ExplicitHeight = 386
    object vleParams: TValueListEditor
      Left = 2
      Top = 2
      Width = 429
      Height = 135
      Align = alTop
      TabOrder = 0
      TitleCaptions.Strings = (
        #1055#1072#1088#1072#1084#1077#1090#1088
        #1047#1085#1072#1095#1077#1085#1080#1077)
      ColWidths = (
        150
        273)
    end
    object ImgView321: TImgView32
      Left = 2
      Top = 137
      Width = 429
      Height = 267
      Align = alClient
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baCustom
      Scale = 1.000000000000000000
      ScaleMode = smOptimalScaled
      ScrollBars.ShowHandleGrip = True
      ScrollBars.Style = rbsDefault
      ScrollBars.Size = 17
      OverSize = 0
      TabOrder = 1
      ExplicitLeft = 104
      ExplicitTop = 200
      ExplicitWidth = 192
      ExplicitHeight = 192
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 492
    Width = 677
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitTop = 472
  end
  object Panel2: TPanel
    Left = 0
    Top = 409
    Width = 677
    Height = 83
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 3
    ExplicitTop = 389
    object Label2: TLabel
      Left = 2
      Top = 2
      Width = 673
      Height = 13
      Align = alTop
      Caption = #1051#1086#1075':'
      ExplicitWidth = 22
    end
    object m_log: TMemo
      Left = 2
      Top = 15
      Width = 673
      Height = 66
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 96
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object mm_open: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        OnClick = mm_openClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Eushully Game File (SYS4INI.BIN)|SYS4INI.BIN'
    Left = 88
    Top = 144
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 96
    object oo_extract: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100'...'
      OnClick = oo_extractClick
    end
  end
end
