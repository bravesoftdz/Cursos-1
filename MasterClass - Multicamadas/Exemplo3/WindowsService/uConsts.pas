unit uConsts;

interface

uses uRESTDWBase;

Const
 vUsername   = 'testserver';
 vPassword   = 'testserver';
 vPort       = 8070;
 servidor    = '192.168.1.90';
 EncodedData = True;
 SSLPrivateKeyFile = '';
 SSLPrivateKeyPassword = '';
 SSLCertFile           = '';
 database    = 'TDEVROCKS.FDB';
 pasta       = 'C:\Database\Firebird\';
 porta_BD    = 3050;
 usuario_BD  = 'sysdba';
 senha_BD    = 'masterkey';
 LogFile     = 'C:\Temp\RESTDataware\Log.txt';

Var
 RESTServicePooler : TRESTServicePooler;

implementation

Initialization
 RESTServicePooler := TRESTServicePooler.Create(Nil);

Finalization
 RESTServicePooler.Active := False;
 RESTServicePooler.DisposeOf;

end.
