object ServerMethodDM: TServerMethodDM
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esANSI
  OnWelcomeMessage = ServerMethodDataModuleWelcomeMessage
  OnMassiveProcess = ServerMethodDataModuleMassiveProcess
  Left = 531
  Top = 220
  Height = 302
  Width = 390
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverZeos1
    Compression = True
    Encoding = esANSI
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 52
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
            Encoded = False
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
      end>
    ContextName = 'SE1'
    Left = 80
    Top = 103
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
    Left = 109
    Top = 103
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
    Left = 137
    Top = 103
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = False
    BeforeConnect = ZConnection1BeforeConnect
    Port = 3050
    Protocol = 'firebird-2.5'
    Left = 56
    Top = 16
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 120
    Top = 16
  end
  object RESTDWDriverZeos1: TRESTDWDriverZeos
    CommitRecords = 100
    Connection = ZConnection1
    Left = 56
    Top = 64
  end
end
