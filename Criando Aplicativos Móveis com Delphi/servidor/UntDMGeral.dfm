object DMGeral: TDMGeral
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 315
  Width = 287
  object fdConn: TFDConnection
    Params.Strings = (
      'Database=curso'
      'User_Name=curso'
      'Password=s32]4]381a'
      'Server=tdevrocks.ddns.com.br'
      'Port=53306'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 128
    Top = 24
  end
  object fdDriverMySQL: TFDPhysMySQLDriverLink
    Left = 128
    Top = 88
  end
  object fdStorageJSON: TFDStanStorageJSONLink
    Left = 128
    Top = 152
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 128
    Top = 208
  end
end
