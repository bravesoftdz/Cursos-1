object DmService: TDmService
  OldCreateOrder = False
  Encoding = esASCII
  Height = 321
  Width = 525
  object DWServerEvents1: TDWServerEvents
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
        Name = 'evento1'
        OnReplyEvent = DWServerEvents1Eventsevento1ReplyEvent
      end>
    Left = 120
    Top = 32
  end
  object poolDBFirebird: TRESTDWPoolerDB
    RESTDriver = driverFD
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 280
    Top = 32
  end
  object fcConn: TFDConnection
    Params.Strings = (
      'Database=C:\Databases\Firebird\TDevRocks.fdb'
      'User_Name=sysdba'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=localhost'
      'Port=3050'
      'DriverID=FB')
    Left = 280
    Top = 144
  end
  object driverFD: TRESTDWDriverFD
    CommitRecords = 100
    Connection = fcConn
    Left = 280
    Top = 88
  end
end
