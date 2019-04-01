object SmServicosPush: TSmServicosPush
  OldCreateOrder = False
  Height = 465
  Width = 634
  object IdTCPClient1: TIdTCPClient
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    ConnectTimeout = 0
    Host = 'gateway.sandbox.push.apple.com'
    IPVersion = Id_IPv4
    Port = 2195
    ReadTimeout = -1
    Left = 480
    Top = 24
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    Destination = 'gateway.sandbox.push.apple.com:2195'
    Host = 'gateway.sandbox.push.apple.com'
    MaxLineAction = maException
    Port = 2195
    DefaultPort = 0
    SSLOptions.CertFile = 'certificados.pem'
    SSLOptions.KeyFile = 'certificados.pem'
    SSLOptions.Method = sslvSSLv23
    SSLOptions.SSLVersions = [sslvSSLv2, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2]
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 480
    Top = 96
  end
  object QryAuxiliar: TFDQuery
    Left = 112
    Top = 32
  end
end
