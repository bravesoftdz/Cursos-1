object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 396
  ClientWidth = 789
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 5
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 63
    Top = 5
    Width = 33
    Height = 13
    Caption = 'Estado'
  end
  object Label3: TLabel
    Left = 342
    Top = 5
    Width = 22
    Height = 13
    Caption = 'Sigla'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 51
    Width = 773
    Height = 310
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 367
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 1
  end
  object DBEdit1: TDBEdit
    Left = 8
    Top = 24
    Width = 49
    Height = 21
    DataField = 'ID'
    DataSource = DataSource1
    TabOrder = 2
  end
  object DBEdit2: TDBEdit
    Left = 63
    Top = 24
    Width = 273
    Height = 21
    DataField = 'NOME'
    DataSource = DataSource1
    TabOrder = 3
  end
  object DBEdit3: TDBEdit
    Left = 342
    Top = 24
    Width = 51
    Height = 21
    DataField = 'SIGLA'
    DataSource = DataSource1
    TabOrder = 4
  end
  object Button1: TButton
    Left = 416
    Top = 20
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 5
    OnClick = Button1Click
  end
  object DataSource1: TDataSource
    DataSet = RESTDWClientSQL1
    Left = 352
    Top = 248
  end
  object RESTDWDataBase1: TRESTDWDataBase
    Active = False
    Compression = True
    Login = 'testserver'
    Password = 'testserver'
    Proxy = False
    ProxyOptions.Port = 8888
    PoolerService = '127.0.0.1'
    PoolerPort = 8070
    PoolerName = 'TServerMethodDM.RESTDWPoolerDB1'
    StateConnection.AutoCheck = False
    StateConnection.InTime = 1000
    RequestTimeOut = 10000
    EncodeStrings = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    ParamCreate = True
    ClientConnectionDefs.Active = False
    Left = 352
    Top = 136
  end
  object RESTDWClientSQL1: TRESTDWClientSQL
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'SIGLA'
        DataType = ftString
        Size = 2
      end>
    MasterCascadeDelete = True
    Datapacks = -1
    DataCache = True
    Params = <>
    DataBase = RESTDWDataBase1
    SQL.Strings = (
      'select * from estado')
    CacheUpdateRecords = True
    AutoCommitData = False
    AutoRefreshAfterCommit = False
    ActionCursor = crSQLWait
    Left = 352
    Top = 192
  end
end
