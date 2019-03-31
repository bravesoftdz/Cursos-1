object DmREST: TDmREST
  OldCreateOrder = False
  Height = 329
  Width = 356
  object rstClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 
      'http://localhost:8080/datasnap/rest/TSrvMetodosGerais/GetEstabel' +
      'ecimentos/'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 88
    Top = 104
  end
  object rstRequest: TRESTRequest
    Client = rstClient
    Params = <>
    Response = rstResponse
    SynchronizedEvents = False
    Left = 160
    Top = 32
  end
  object rstResponse: TRESTResponse
    Left = 224
    Top = 104
  end
  object rstAdapter: TRESTResponseDataSetAdapter
    Dataset = MemREST
    FieldDefs = <>
    Response = rstResponse
    Left = 152
    Top = 152
  end
  object MemREST: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 152
    Top = 240
  end
end
