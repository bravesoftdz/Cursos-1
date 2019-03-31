object SmServicos: TSmServicos
  OldCreateOrder = True
  Height = 199
  Width = 195
  object qryExportar: TFDQuery
    Left = 80
    Top = 32
  end
  object qryAuxiliar: TFDQuery
    SQL.Strings = (
      'select * from curso.ITENS_PEDIDO')
    Left = 80
    Top = 96
  end
end
