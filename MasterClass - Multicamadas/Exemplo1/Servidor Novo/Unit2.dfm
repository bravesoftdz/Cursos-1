object DataModule2: TDataModule2
  OldCreateOrder = False
  Encoding = esASCII
  Height = 347
  Width = 577
  object TServerEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'tdevrocks'
        OnReplyEvent = TServerEventsEventstdevrocksReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'getUsuarios'
        OnReplyEvent = TServerEventsEventsgetUsuariosReplyEvent
      end>
    Left = 72
    Top = 40
  end
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverZeos1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 296
    Top = 40
  end
  object RESTDWDriverZeos1: TRESTDWDriverZeos
    CommitRecords = 100
    Connection = ZConnection1
    Left = 296
    Top = 96
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    Properties.Strings = (
      'controls_cp=CP_UTF16')
    HostName = '192.168.1.90'
    Port = 3306
    Database = 'curso'
    User = 'curso'
    Password = 's32]4]381a'
    Protocol = 'mysqld-5'
    LibraryLocation = 'C:\Windows\System32\libmysql.dll'
    Left = 296
    Top = 160
  end
  object zqryUsuarios: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 296
    Top = 224
  end
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
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
        OnReplyEvent = DWServerEvents1EventsgettableReplyEvent
      end>
    ContextName = 'adriano'
    Left = 128
    Top = 184
  end
end
