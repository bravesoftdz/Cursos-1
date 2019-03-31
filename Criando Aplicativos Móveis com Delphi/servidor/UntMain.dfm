object fMain: TfMain
  Left = 271
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Servidor DataSnap Curso Aplicativos M'#243'veis'
  ClientHeight = 709
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1002
    Height = 297
    Align = alTop
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 11
      Top = 4
      Width = 537
      Height = 285
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = ' Banco de Dados '
      TabOrder = 0
      object Label2: TLabel
        Left = 408
        Top = 21
        Width = 88
        Height = 13
        Caption = 'Porta Database'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtIP: TLabeledEdit
        Left = 9
        Top = 40
        Width = 394
        Height = 21
        EditLabel.Width = 188
        EditLabel.Height = 13
        EditLabel.Caption = 'IP/Endere'#231'o do servidor (Server)'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        TabOrder = 0
      end
      object edtDatabase: TLabeledEdit
        Left = 9
        Top = 85
        Width = 394
        Height = 21
        EditLabel.Width = 156
        EditLabel.Height = 13
        EditLabel.Caption = 'Banco de Dados (Database)'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        TabOrder = 2
      end
      object edtUsuario: TLabeledEdit
        Left = 9
        Top = 129
        Width = 121
        Height = 21
        EditLabel.Width = 121
        EditLabel.Height = 13
        EditLabel.Caption = 'Usu'#225'rio (User_Name)'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object edtSenha: TLabeledEdit
        Left = 136
        Top = 129
        Width = 121
        Height = 21
        EditLabel.Width = 102
        EditLabel.Height = 13
        EditLabel.Caption = 'Senha (Password)'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        PasswordChar = '*'
        TabOrder = 4
      end
      object edtLib: TLabeledEdit
        Left = 8
        Top = 250
        Width = 394
        Height = 21
        EditLabel.Width = 126
        EditLabel.Height = 13
        EditLabel.Caption = 'Lib MySQL (VendorLib)'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        TabOrder = 5
      end
      object spePortaDatabase: TSpinEdit
        Left = 408
        Top = 40
        Width = 121
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object btnVer: TButton
        Left = 263
        Top = 127
        Width = 75
        Height = 25
        Caption = 'Ver'
        TabOrder = 6
        OnClick = btnVerClick
      end
      object btnTestar: TButton
        Left = 408
        Top = 184
        Width = 121
        Height = 25
        Caption = 'Testar Conex'#227'o'
        TabOrder = 7
        OnClick = btnTestarClick
      end
      object btnSalvar: TButton
        Left = 408
        Top = 215
        Width = 121
        Height = 25
        Caption = 'Salvar'
        TabOrder = 8
        OnClick = btnSalvarClick
      end
      object btnSelecionar: TButton
        Left = 408
        Top = 248
        Width = 121
        Height = 25
        Caption = 'Selecionar'
        TabOrder = 9
        OnClick = btnSelecionarClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 551
      Top = 8
      Width = 441
      Height = 281
      Caption = ' Servidor '
      TabOrder = 1
      object Label1: TLabel
        Left = 10
        Top = 20
        Width = 31
        Height = 13
        Caption = 'Porta'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EditPort: TEdit
        Left = 10
        Top = 39
        Width = 121
        Height = 21
        TabOrder = 0
        Text = '8080'
      end
      object ButtonStart: TButton
        Left = 319
        Top = 16
        Width = 107
        Height = 25
        Caption = 'Iniciar'
        TabOrder = 1
        OnClick = ButtonStartClick
      end
      object ButtonStop: TButton
        Left = 319
        Top = 47
        Width = 107
        Height = 25
        Caption = 'Parar'
        TabOrder = 2
        OnClick = ButtonStopClick
      end
      object ButtonOpenBrowser: TButton
        Left = 319
        Top = 78
        Width = 107
        Height = 25
        Caption = 'Browser'
        TabOrder = 3
        OnClick = ButtonOpenBrowserClick
      end
      object btnLimparLog: TButton
        Left = 320
        Top = 109
        Width = 105
        Height = 25
        Caption = 'Limpar Log'
        TabOrder = 4
        OnClick = btnLimparLogClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 297
    Width = 1002
    Height = 160
    Align = alTop
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 1000
      Height = 158
      Align = alClient
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 457
    Width = 1002
    Height = 252
    Align = alClient
    TabOrder = 2
    object memMensagens: TMemo
      Left = 1
      Top = 1
      Width = 1000
      Height = 250
      Align = alClient
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clLime
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'memMensagens')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WantTabs = True
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 496
    Top = 24
  end
end
