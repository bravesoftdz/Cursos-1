object ServerMethodDM: TServerMethodDM
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  OnWelcomeMessage = ServerMethodDataModuleWelcomeMessage
  OnMassiveProcess = ServerMethodDataModuleMassiveProcess
  Height = 450
  Width = 704
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 64
    Top = 87
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    OnPrepareConnection = RESTDWDriverFD1PrepareConnection
    Connection = Server_FDConnection
    Left = 64
    Top = 163
  end
  object Server_FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=D:\Meus Dados\Projetos\SUGV\Componentes\XyberPower\REST' +
        '_Controls\DEMO\EMPLOYEE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'Port=3050'
      'CharacterSet='
      'DriverID=FB')
    FetchOptions.AssignedValues = [evCursorKind]
    FetchOptions.CursorKind = ckDefault
    UpdateOptions.AssignedValues = [uvCountUpdatedRecords]
    ConnectedStoredUsage = []
    LoginPrompt = False
    Transaction = FDTransaction1
    OnError = Server_FDConnectionError
    BeforeConnect = Server_FDConnectionBeforeConnect
    Left = 64
    Top = 239
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 509
    Top = 147
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 305
    Top = 179
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 349
    Top = 39
  end
  object FDTransaction1: TFDTransaction
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = Server_FDConnection
    Left = 305
    Top = 103
  end
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovDateTime
            ParamName = 'result'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'inputdata'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'resultstring'
            Encoded = False
          end>
        JsonMode = jmDataware
        Name = 'servertime'
        OnReplyEvent = DWServerEvents1EventsservertimeReplyEvent
      end
      item
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
        Name = 'loaddatasetevent'
        OnReplyEvent = DWServerEvents1EventsloaddataseteventReplyEvent
      end
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'getemployee'
        OnReplyEvent = DWServerEvents1EventsgetemployeeReplyEvent
      end
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'segundoparam'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'getemployeeDW'
        OnReplyEvent = DWServerEvents1EventsgetemployeeDWReplyEvent
      end
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovInteger
            ParamName = 'mynumber'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovInteger
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'eventint'
        OnReplyEvent = DWServerEvents1EventseventintReplyEvent
      end
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovDateTime
            ParamName = 'mydatetime'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovDateTime
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'eventdatetime'
        OnReplyEvent = DWServerEvents1EventseventdatetimeReplyEvent
      end
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'helloworld'
        OnReplyEvent = DWServerEvents1EventshelloworldReplyEvent
      end
      item
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'Estados'
        OnReplyEvent = DWServerEvents1EventsEstadosReplyEvent
      end>
    ContextName = 'SE1'
    Left = 64
    Top = 23
  end
  object FDQuery1: TFDQuery
    Connection = Server_FDConnection
    SQL.Strings = (
      '')
    Left = 64
    Top = 311
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 517
    Top = 75
  end
  object DWServerEvents2: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'helloworld'
        OnReplyEvent = DWServerEvents2Eventshelloworld2ReplyEvent
      end>
    ContextName = 'SE2'
    Left = 309
    Top = 247
  end
  object DWServerContext1: TDWServerContext
    IgnoreInvalidParams = False
    ContextList = <
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'entrada'
            Encoded = True
          end>
        ContentType = 'text/html'
        ContextName = 'init'
        ContextRoutes = [crAll]
        OnReplyRequest = DWServerContext1ContextListinitReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'index'
        ContextRoutes = [crAll]
        OnReplyRequest = DWServerContext1ContextListindexReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'openfile'
        ContextRoutes = [crAll]
        OnReplyRequestStream = DWServerContext1ContextListopenfileReplyRequestStream
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'php'
        ContextRoutes = [crAll]
        OnReplyRequest = DWServerContext1ContextListphpReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'angular'
        ContextRoutes = [crAll]
        OnReplyRequest = DWServerContext1ContextListangularReplyRequest
      end>
    BaseContext = 'www'
    Left = 521
    Top = 247
  end
  object qryEstados: TFDQuery
    Connection = Server_FDConnection
    Left = 312
    Top = 360
  end
end
