object DMDados: TDMDados
  OldCreateOrder = False
  Height = 492
  Width = 662
  object MemCategorias: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 32
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
    Left = 160
    Top = 32
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
  object MemCadUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 576
    Top = 32
    object MemCadUsuariocpfcnpj: TStringField
      FieldName = 'cpfcnpj'
      Size = 30
    end
    object MemCadUsuarionome_completo: TStringField
      FieldName = 'nome_completo'
      Size = 100
    end
    object MemCadUsuarionome_usuario: TStringField
      FieldName = 'nome_usuario'
      Size = 45
    end
    object MemCadUsuarioemail: TStringField
      FieldName = 'email'
      Size = 50
    end
    object MemCadUsuariosenha: TStringField
      FieldName = 'senha'
      Size = 50
    end
    object MemCadUsuariofoto: TBlobField
      FieldName = 'foto'
    end
    object MemCadUsuarioid_estabelecimento: TIntegerField
      FieldName = 'id_estabelecimento'
    end
  end
  object MemRestaurantes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 264
    Top = 32
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
  object MemPedidos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 144
    object MemPedidosid: TIntegerField
      FieldName = 'id'
    end
    object MemPedidosid_usuario: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_usuario'
      Origin = 'id_usuario'
    end
    object MemPedidosid_estabelecimento: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_estabelecimento'
      Origin = 'id_estabelecimento'
    end
    object MemPedidosdata: TDateTimeField
      AutoGenerateValue = arDefault
      FieldName = 'data'
      Origin = '`data`'
    end
    object MemPedidosstatus: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'status'
      Origin = '`status`'
      Size = 1
    end
    object MemPedidosvalor_pedido: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'valor_pedido'
      Origin = 'valor_pedido'
      Precision = 10
      Size = 2
    end
    object MemPedidosid_pedido_mobile: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_pedido_mobile'
      Origin = 'id_pedido_mobile'
    end
  end
  object MemItensPedido: TFDMemTable
    MasterSource = dtsMasterPedidos
    MasterFields = 'id'
    DetailFields = 'id_pedido'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 256
    object MemItensPedidoid: TIntegerField
      FieldName = 'id'
    end
    object MemItensPedidoid_pedido: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_pedido'
      Origin = 'id_pedido'
    end
    object MemItensPedidoqtde: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'qtde'
      Origin = 'qtde'
    end
    object MemItensPedidovalor_unitario: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'valor_unitario'
      Origin = 'valor_unitario'
      Precision = 10
      Size = 2
    end
    object MemItensPedidoid_cardapio: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_cardapio'
      Origin = 'id_cardapio'
    end
    object MemItensPedidoid_pedido_mobile: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_pedido_mobile'
      Origin = 'id_pedido_mobile'
    end
    object MemItensPedidoid_item_pedido_mobile: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_item_pedido_mobile'
      Origin = 'id_item_pedido_mobile'
    end
    object MemItensPedidoid_usuario: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'id_usuario'
      Origin = 'id_usuario'
    end
    object MemItensPedidostatus: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'status'
      Origin = '`status`'
      Size = 1
    end
  end
  object dtsMasterPedidos: TDataSource
    DataSet = MemPedidos
    Left = 56
    Top = 200
  end
  object MemUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 368
    Top = 32
    object MemUsuarioid: TIntegerField
      FieldName = 'id'
    end
    object MemUsuarioid_endereco: TIntegerField
      FieldName = 'id_endereco'
    end
    object MemUsuarionome_completo: TStringField
      FieldName = 'nome_completo'
      Size = 100
    end
    object MemUsuarionome_usuario: TStringField
      FieldName = 'nome_usuario'
      Size = 45
    end
    object MemUsuariocpfcnpj: TStringField
      FieldName = 'cpfcnpj'
      Size = 40
    end
    object MemUsuarioemail: TStringField
      FieldName = 'email'
      Size = 50
    end
    object MemUsuariosenha: TStringField
      FieldName = 'senha'
    end
    object MemUsuariofoto: TBlobField
      FieldName = 'foto'
    end
  end
end
