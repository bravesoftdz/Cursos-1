object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 475
  Width = 624
  object MemRestaurantes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 48
    Top = 304
    object MemRestaurantesid: TIntegerField
      FieldName = 'id'
    end
    object MemRestaurantesfantasia: TStringField
      FieldName = 'fantasia'
    end
    object MemRestaurantesrazao_social: TStringField
      FieldName = 'razao_social'
      Size = 200
    end
    object MemRestaurantesfoto_logotipo: TBlobField
      FieldName = 'foto_logotipo'
    end
  end
  object MemCategorias: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 168
    Top = 304
    object MemCategoriasid: TIntegerField
      FieldName = 'id'
    end
    object MemCategoriasdescricao: TStringField
      FieldName = 'descricao'
      Size = 30
    end
  end
  object MemCardapios: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 280
    Top = 304
    object MemCardapiosid: TIntegerField
      FieldName = 'id'
    end
    object MemCardapiosid_estabelecimento: TIntegerField
      FieldName = 'id_estabelecimento'
    end
    object MemCardapiosid_categoria: TIntegerField
      FieldName = 'id_categoria'
    end
    object MemCardapiosnome: TStringField
      FieldName = 'nome'
      Size = 50
    end
    object MemCardapiosingredientes: TStringField
      FieldName = 'ingredientes'
      Size = 200
    end
    object MemCardapiospreco: TFloatField
      FieldName = 'preco'
      EditFormat = 'R$ ######00.00'
    end
  end
  object memUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 528
    Top = 304
    object memUsuarioid: TIntegerField
      FieldName = 'id'
    end
    object memUsuarioid_endereco: TIntegerField
      FieldName = 'id_endereco'
    end
    object memUsuarionome_completo: TStringField
      FieldName = 'nome_completo'
      Size = 100
    end
    object memUsuarionome_usuario: TStringField
      FieldName = 'nome_usuario'
      Size = 45
    end
    object memUsuariocpfcnpj: TStringField
      FieldName = 'cpfcnpj'
      Size = 40
    end
    object memUsuarioemail: TStringField
      FieldName = 'email'
      Size = 50
    end
    object memUsuariosenha: TStringField
      FieldName = 'senha'
    end
    object memUsuariofoto: TBlobField
      FieldName = 'foto'
    end
  end
  object fdConn: TFDConnection
    Params.Strings = (
      
        'Database=D:\Cursos\T001-Criando-aplicativos-moveis-com-Delphi\mo' +
        'bile\database\RestaurantesMoveis.sqlite'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    BeforeConnect = fdConnBeforeConnect
    Left = 56
    Top = 24
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 528
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 528
    Top = 80
  end
  object qryPedido: TFDQuery
    Connection = fdConn
    SQL.Strings = (
      'SELECT * FROM PEDIDOS WHERE 1=2')
    Left = 200
    Top = 96
    object qryPedidoID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryPedidoID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
    end
    object qryPedidoID_ESTABELECIMENTO: TIntegerField
      FieldName = 'ID_ESTABELECIMENTO'
      Origin = 'ID_ESTABELECIMENTO'
    end
    object qryPedidoDATA: TDateTimeField
      FieldName = 'DATA'
      Origin = 'DATA'
    end
    object qryPedidoSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      Size = 1
    end
    object qryPedidoVALOR_PEDIDO: TFloatField
      FieldName = 'VALOR_PEDIDO'
      Origin = 'VALOR_PEDIDO'
    end
    object qryPedidoNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
    end
  end
  object qryItensPedido: TFDQuery
    Connection = fdConn
    SQL.Strings = (
      'SELECT * FROM ITENS_PEDIDO WHERE 1=2')
    Left = 200
    Top = 160
    object qryItensPedidoID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryItensPedidoID_PEDIDO: TIntegerField
      FieldName = 'ID_PEDIDO'
      Origin = 'ID_PEDIDO'
    end
    object qryItensPedidoQTDE: TIntegerField
      FieldName = 'QTDE'
      Origin = 'QTDE'
    end
    object qryItensPedidoVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
      Origin = 'VALOR_UNITARIO'
    end
    object qryItensPedidoID_CARDAPIO: TIntegerField
      FieldName = 'ID_CARDAPIO'
      Origin = 'ID_CARDAPIO'
    end
    object qryItensPedidoNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
    object qryItensPedidoINGREDIENTES: TStringField
      FieldName = 'INGREDIENTES'
      Origin = 'INGREDIENTES'
      Size = 200
    end
    object qryItensPedidoSTATUS: TWideStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      Size = 1
    end
    object qryItensPedidoID_USUARIO: TLargeintField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
    end
  end
  object qryAuxiliar: TFDQuery
    Connection = fdConn
    Left = 528
    Top = 168
  end
  object qryCarrinho: TFDQuery
    Connection = fdConn
    SQL.Strings = (
      'SELECT'
      '  *'
      'FROM'
      '  PEDIDOS PE'
      '  INNER JOIN ITENS_PEDIDO IT'
      '  ON IT.ID_PEDIDO = PE.ID'
      'WHERE'
      '   PE.STATUS = '#39'A'#39)
    Left = 352
    Top = 96
    object qryCarrinhoID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryCarrinhoID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
    end
    object qryCarrinhoID_ESTABELECIMENTO: TIntegerField
      FieldName = 'ID_ESTABELECIMENTO'
      Origin = 'ID_ESTABELECIMENTO'
    end
    object qryCarrinhoDATA: TDateTimeField
      FieldName = 'DATA'
      Origin = 'DATA'
    end
    object qryCarrinhoSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      Size = 1
    end
    object qryCarrinhoVALOR_PEDIDO: TFloatField
      FieldName = 'VALOR_PEDIDO'
      Origin = 'VALOR_PEDIDO'
    end
    object qryCarrinhoID_1: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID_1'
      Origin = 'ID'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarrinhoID_PEDIDO: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID_PEDIDO'
      Origin = 'ID_PEDIDO'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarrinhoQTDE: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'QTDE'
      Origin = 'QTDE'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarrinhoVALOR_UNITARIO: TFloatField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_UNITARIO'
      Origin = 'VALOR_UNITARIO'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarrinhoID_CARDAPIO: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID_CARDAPIO'
      Origin = 'ID_CARDAPIO'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarrinhoNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
    end
    object qryCarrinhoNOME_1: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOME_1'
      Origin = 'NOME'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object qryCarrinhoINGREDIENTES: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'INGREDIENTES'
      Origin = 'INGREDIENTES'
      ProviderFlags = []
      ReadOnly = True
      Size = 200
    end
  end
  object qryItensPedidoView: TFDQuery
    Connection = fdConn
    SQL.Strings = (
      'SELECT'
      '  DISTINCT'
      '    IT.NOME,'
      '    IT.VALOR_UNITARIO,'
      '    IT.ID_CARDAPIO,'
      '    IT.ID_USUARIO,'
      '    PE.ID,'
      '    SUM(IT.QTDE) AS "QTDE::BIGINT"'
      'FROM'
      '  ITENS_PEDIDO IT'
      '  INNER JOIN PEDIDOS PE'
      '  ON IT.ID_PEDIDO = PE.ID'
      'WHERE'
      '      IT.ID_PEDIDO  = :PID_PEDIDO'
      '  AND PE.ID_USUARIO = :PID_USUARIO'
      'GROUP BY'
      '    IT.NOME,'
      '    IT.VALOR_UNITARIO,'
      '    IT.ID_CARDAPIO,'
      '    IT.ID_USUARIO,'
      '    PE.ID')
    Left = 56
    Top = 160
    ParamData = <
      item
        Name = 'PID_PEDIDO'
        DataType = ftString
        ParamType = ptInput
        Value = '16'
      end
      item
        Name = 'PID_USUARIO'
        DataType = ftString
        ParamType = ptInput
        Value = '1'
      end>
    object qryItensPedidoViewNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
    object qryItensPedidoViewVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
      Origin = 'VALOR_UNITARIO'
    end
    object qryItensPedidoViewID_CARDAPIO: TIntegerField
      FieldName = 'ID_CARDAPIO'
      Origin = 'ID_CARDAPIO'
    end
    object qryItensPedidoViewID: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryItensPedidoViewQTDE: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'QTDE'
      Origin = 'QTDE'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryItensPedidoViewID_USUARIO: TLargeintField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
    end
  end
  object qryPedidosView: TFDQuery
    Connection = fdConn
    SQL.Strings = (
      'SELECT * FROM PEDIDOS'
      'WHERE'
      '           STATUS IN ("A", "G", "E", "R", "P", "M")'
      '  AND  ID_USUARIO = :PID_USUARIO')
    Left = 56
    Top = 96
    ParamData = <
      item
        Name = 'PID_USUARIO'
        DataType = ftString
        ParamType = ptInput
        Value = '1'
      end>
    object qryPedidosViewID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryPedidosViewID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
    end
    object qryPedidosViewID_ESTABELECIMENTO: TIntegerField
      FieldName = 'ID_ESTABELECIMENTO'
      Origin = 'ID_ESTABELECIMENTO'
    end
    object qryPedidosViewDATA: TDateTimeField
      FieldName = 'DATA'
      Origin = 'DATA'
    end
    object qryPedidosViewSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      Size = 1
    end
    object qryPedidosViewVALOR_PEDIDO: TFloatField
      FieldName = 'VALOR_PEDIDO'
      Origin = 'VALOR_PEDIDO'
    end
    object qryPedidosViewNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
    end
  end
  object qryAuxiliar1: TFDQuery
    Connection = fdConn
    Left = 528
    Top = 224
  end
end
