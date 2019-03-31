object DMREST: TDMREST
  OldCreateOrder = False
  Height = 384
  Width = 430
  object rstClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 
      'http://localhost:8080/datasnap/rest/TSrvMetodosGerais/GetEstabel' +
      'ecimentos/'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 128
    Top = 128
  end
  object rstRequest: TRESTRequest
    Client = rstClient
    Params = <>
    Response = rstResponse
    SynchronizedEvents = False
    Left = 200
    Top = 56
  end
  object rstResponse: TRESTResponse
    Left = 264
    Top = 128
  end
  object rstAdapter: TRESTResponseDataSetAdapter
    Dataset = MemREST
    FieldDefs = <>
    Response = rstResponse
    Left = 192
    Top = 176
  end
  object MemREST: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 192
    Top = 264
  end
end
