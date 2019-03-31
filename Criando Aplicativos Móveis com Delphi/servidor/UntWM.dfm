object WM: TWM
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Name = 'ReverseStringAction'
      PathInfo = '/ReverseString'
      Producer = ReverseString
    end
    item
      Name = 'ServerFunctionInvokerAction'
      PathInfo = '/ServerFunctionInvoker'
      Producer = ServerFunctionInvoker
    end
    item
      Default = True
      Name = 'DefaultAction'
      PathInfo = '/'
      OnAction = WebModuleDefaultAction
    end>
  BeforeDispatch = WebModuleBeforeDispatch
  Height = 496
  Width = 739
  object DSServer1: TDSServer
    Left = 72
    Top = 16
  end
  object DSHTTPWebDispatcher1: TDSHTTPWebDispatcher
    Server = DSServer1
    Filters = <>
    AuthenticationManager = DSAuthenticationManager1
    WebDispatch.PathInfo = 'datasnap*'
    Left = 72
    Top = 72
  end
  object DSAuthenticationManager1: TDSAuthenticationManager
    OnUserAuthenticate = DSAuthenticationManager1UserAuthenticate
    OnUserAuthorize = DSAuthenticationManager1UserAuthorize
    Roles = <>
    Left = 360
    Top = 424
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 496
    Top = 32
  end
  object ServerFunctionInvoker: TPageProducer
    HTMLFile = 'templates/serverfunctioninvoker.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 72
    Top = 272
  end
  object ReverseString: TPageProducer
    HTMLFile = 'templates/reversestring.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 208
    Top = 272
  end
  object WebFileDispatcher1: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end
      item
        MimeType = 'text/html'
        Extensions = 'htm;html'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpg;jpeg;jpe'
      end
      item
        MimeType = 'image/gif'
        Extensions = 'gif'
      end>
    BeforeDispatch = WebFileDispatcher1BeforeDispatch
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    VirtualPath = '/'
    Left = 72
    Top = 128
  end
  object DSProxyGenerator1: TDSProxyGenerator
    ExcludeClasses = 'DSMetadata'
    MetaDataProvider = DSServerMetaDataProvider1
    Writer = 'Java Script REST'
    Left = 72
    Top = 424
  end
  object DSServerMetaDataProvider1: TDSServerMetaDataProvider
    Server = DSServer1
    Left = 208
    Top = 424
  end
  object DSServerClassEstabelecimentos: TDSServerClass
    OnGetClass = DSServerClassEstabelecimentosGetClass
    Server = DSServer1
    Left = 624
    Top = 32
  end
end
