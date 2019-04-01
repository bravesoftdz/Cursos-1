object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 401
  ClientWidth = 1100
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
    Top = 154
    Width = 75
    Height = 13
    Caption = 'Nome Completo'
  end
  object Label2: TLabel
    Left = 364
    Top = 154
    Width = 60
    Height = 13
    Caption = 'Raz'#227'o Social'
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 200
    Width = 350
    Height = 192
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button2: TButton
    Left = 232
    Top = 138
    Width = 126
    Height = 25
    Caption = 'Editar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object DBEdit1: TDBEdit
    Left = 8
    Top = 173
    Width = 218
    Height = 21
    DataField = 'nome_completo'
    DataSource = DataSource1
    TabOrder = 3
  end
  object Button3: TButton
    Left = 232
    Top = 169
    Width = 126
    Height = 25
    Caption = 'Salar e Aplicar'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 19
    Top = 411
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 6
    OnClick = Button5Click
  end
  object DBGrid2: TDBGrid
    Left = 8
    Top = 442
    Width = 625
    Height = 137
    DataSource = DataSource2
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBGrid3: TDBGrid
    Left = 364
    Top = 200
    Width = 728
    Height = 193
    DataSource = DataSource3
    TabOrder = 8
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'fantasia'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'razao_social'
        Width = 295
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'foto_logotipo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'id_endereco'
        Visible = True
      end>
  end
  object DBEdit2: TDBEdit
    Left = 364
    Top = 173
    Width = 285
    Height = 21
    DataField = 'razao_social'
    DataSource = DataSource3
    TabOrder = 9
  end
  object Button6: TButton
    Left = 655
    Top = 169
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 10
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 736
    Top = 169
    Width = 356
    Height = 25
    Caption = 'Salvar e Aplicar'
    TabOrder = 11
    OnClick = Button7Click
  end
  object RESTDWDataBase1: TRESTDWDataBase
    Active = True
    Compression = True
    MyIP = '127.0.0.1'
    Login = 'testserver'
    Password = 'testserver'
    Proxy = False
    ProxyOptions.Port = 8888
    PoolerService = '127.0.0.1'
    PoolerPort = 8082
    PoolerName = 'TDataModule2.RESTDWPoolerDB1'
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
    Left = 64
    Top = 256
  end
  object RESTDWClientSQL1: TRESTDWClientSQL
    BeforeOpen = RESTDWClientSQL1BeforeOpen
    FieldDefs = <
      item
        Name = 'id'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'id_endereco'
        DataType = ftInteger
      end
      item
        Name = 'nome_completo'
        DataType = ftWideString
        Size = 100
      end
      item
        Name = 'nome_usuario'
        DataType = ftWideString
        Size = 45
      end
      item
        Name = 'email'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'cpfcnpj'
        DataType = ftWideString
        Size = 30
      end
      item
        Name = 'senha'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'foto'
        DataType = ftBlob
      end
      item
        Name = 'id_estabelecimento'
        DataType = ftInteger
      end
      item
        Name = 'tipo'
        DataType = ftWideString
        Size = 15
      end>
    IndexDefs = <>
    MasterFields = ''
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    MasterCascadeDelete = True
    Datapacks = -1
    DataCache = False
    Params = <>
    DataBase = RESTDWDataBase1
    SQL.Strings = (
      'SELECT * FROM CURSO.USUARIOS')
    UpdateTableName = 'curso.usuarios'
    CacheUpdateRecords = True
    AutoCommitData = False
    AutoRefreshAfterCommit = False
    ActionCursor = crSQLWait
    Left = 176
    Top = 256
    object RESTDWClientSQL1id: TIntegerField
      FieldName = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object RESTDWClientSQL1id_endereco: TIntegerField
      FieldName = 'id_endereco'
    end
    object RESTDWClientSQL1nome_completo: TWideStringField
      FieldName = 'nome_completo'
      Size = 100
    end
    object RESTDWClientSQL1nome_usuario: TWideStringField
      FieldName = 'nome_usuario'
      Size = 45
    end
    object RESTDWClientSQL1email: TWideStringField
      FieldName = 'email'
      Size = 50
    end
    object RESTDWClientSQL1cpfcnpj: TWideStringField
      FieldName = 'cpfcnpj'
      Size = 30
    end
    object RESTDWClientSQL1senha: TWideStringField
      FieldName = 'senha'
      Size = 50
    end
    object RESTDWClientSQL1foto: TBlobField
      FieldName = 'foto'
    end
    object RESTDWClientSQL1id_estabelecimento: TIntegerField
      FieldName = 'id_estabelecimento'
    end
    object RESTDWClientSQL1tipo: TWideStringField
      FieldName = 'tipo'
      Size = 15
    end
  end
  object DataSource1: TDataSource
    DataSet = RESTDWClientSQL1
    Left = 272
    Top = 256
  end
  object DWClientEvents1: TDWClientEvents
    ServerEventName = 'TDataModule2.DWServerEvents1'
    RESTClientPooler = RESTClientPooler1
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'sql'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'gettable'
      end>
    Left = 8
    Top = 448
  end
  object RESTClientPooler1: TRESTClientPooler
    DataCompression = True
    Encoding = esUtf8
    hEncodeStrings = True
    Host = 'localhost'
    UserName = 'testserver'
    Password = 'testserver'
    ProxyOptions.BasicAuthentication = False
    ProxyOptions.ProxyPort = 0
    RequestTimeOut = 10000
    ThreadRequest = False
    AllowCookies = False
    HandleRedirects = False
    Left = 16
    Top = 464
  end
  object DWMemtable1: TDWMemtable
    FieldDefs = <>
    Left = 24
    Top = 464
  end
  object DataSource2: TDataSource
    Left = 24
    Top = 480
  end
  object RESTDWClientSQL2: TRESTDWClientSQL
    FieldDefs = <>
    IndexDefs = <>
    MasterFields = ''
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    MasterCascadeDelete = True
    Datapacks = -1
    DataCache = False
    Params = <>
    DataBase = RESTDWDataBase1
    SQL.Strings = (
      'SELECT * FROM CURSO.ESTABELECIMENTOS')
    UpdateTableName = 'CURSO.ESTABELECIMENTOS'
    CacheUpdateRecords = True
    AutoCommitData = False
    AutoRefreshAfterCommit = False
    ActionCursor = crSQLWait
    Left = 680
    Top = 232
    object RESTDWClientSQL2id: TIntegerField
      FieldName = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object RESTDWClientSQL2fantasia: TWideStringField
      FieldName = 'fantasia'
    end
    object RESTDWClientSQL2razao_social: TWideStringField
      FieldName = 'razao_social'
      Size = 200
    end
    object RESTDWClientSQL2foto_logotipo: TBlobField
      FieldName = 'foto_logotipo'
    end
    object RESTDWClientSQL2id_endereco: TIntegerField
      FieldName = 'id_endereco'
    end
  end
  object DataSource3: TDataSource
    AutoEdit = False
    DataSet = RESTDWClientSQL2
    Left = 680
    Top = 280
  end
end
