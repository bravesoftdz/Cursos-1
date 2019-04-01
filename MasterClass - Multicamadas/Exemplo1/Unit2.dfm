object DataModule2: TDataModule2
  OldCreateOrder = False
  Encoding = esASCII
  Height = 386
  Width = 584
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
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
        OnReplyEvent = DWServerEvents1EventstdevrocksReplyEvent
      end>
    Left = 64
    Top = 40
  end
end
