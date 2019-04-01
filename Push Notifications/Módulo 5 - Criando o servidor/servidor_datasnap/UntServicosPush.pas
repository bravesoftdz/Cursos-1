unit UntServicosPush;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Json,
  System.Net.HTTPClient,

  Data.DB,

  Datasnap.DSServer,
  Datasnap.DSAuth,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,

  Constantes,
  SmartPoint,
  Server.Connection,
  Server.Utils,
  Utils.DataSet.JSON.Helper;

type
{$METHODINFO ON}
  TSmServicosPush = class(TDataModule)
    IdTCPClient1: TIdTCPClient;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    QryAuxiliar: TFDQuery;
  private
    { Private declarations }
    {Métodos do iOS}
    function GetPayLoad(const AAlert: AnsiString; const ABadge: Integer;
      const ASound: AnsiString): String;
    function  GetMessage(const ADeviceToken : AnsiString; const APayLoad : AnsiString): AnsiString;
    function  HexToAscii(const AStrHexa: AnsiString): AnsiString;

    {Métodos do Android}


    {Métodos Genéricos}
    procedure EnviarPushAndroid(AMensagem, AExtras, AToken: string);
    procedure EnviarPushiOS(AMensagem, AExtras, AToken: string);
  public
    { Public declarations }
    function TesteServer: TJSONArray;
    function EnviarPush(AMensagem, AExtras: TJSONArray): TJSONArray;
    function RegistrarUsuario(const ANome, AEmail, AToken, ATipoDispositivo: string): TJSONArray;
  end;
{$METHODINFO OFF}

implementation


{$R *.dfm}


{ TSmServicosPush }

function TSmServicosPush.EnviarPush(AMensagem, AExtras: TJSONArray): TJSONArray;
begin
//  1. Conectar-se ao banco de dados
//  2. Listar os registros referentes aos dispositivos
//  3. Chamar o método EnviarPushAndoid/iOS
//
//  if DataSet.FieldByName('TIPO_DISPOSITIVO') = 'IOS' then
//    EnviarPushiOS...
//  else
//    EnviarPushAndroid...
end;

procedure TSmServicosPush.EnviarPushAndroid(AMensagem, AExtras, AToken: string);
var
  vHttpClient     : THttpClient;
  v_JSON          : TJSONObject;
  v_JsonData      : TJSONObject;
  v_RegisterIDs   : TJSONArray;
  v_Data          : TStringStream;
  v_Response      : TStringStream;

  RegisterIDs     : TJSONArray;
begin
  //Envio de push exclusivo para ANDROID
  try
    RegisterIDs := TJSONArray.Create;
    RegisterIDs.Add(AToken);

    v_JsonData  := TJSONObject.Create;
    v_JsonData.AddPair('id', C_CodigoProjeto); //obrigatório
    v_JsonData.AddPair('message', AMensagem);  //obrigatório

    v_JsonData.AddPair('campo_extra', '123456');

    v_JSON      := TJSONObject.Create;
    v_JSON.AddPair('registration_ids', RegisterIDs);
    v_JSON.AddPair('priority', 'high'); //Para o novo formato e recebimento com ele fechado
    v_JSON.AddPair('data', v_JsonData);

    vHttpClient := THTTPClient.Create;
    vHttpClient.ContentType := 'application/json';
    vHttpClient.CustomHeaders['Authorization'] := 'key=' + C_API;

    //memoLog.Lines.Add('---------------------------');
    //memoLog.Lines.Add(v_JSON.ToString);

    //v_Data := TStringStream.Create(v_JSON.ToString);
    v_Data := TStringStream.Create(v_JSON.ToString, TEncoding.UTF8);
    v_Data.Position := 0;

    v_Response := TStringStream.Create;

    //Envio do Push
    vHttpClient.Post(C_LinkAndroid, v_Data, v_Response);
    v_Response.Position := 0;

    //memoLog.Lines.Add(v_Response.DataString);
  finally

  end;

end;

procedure TSmServicosPush.EnviarPushiOS(AMensagem, AExtras, AToken: string);
var
  LMsg      : AnsiString;
  StreamMsg : TStringStream;
begin
  if not IdTCPClient1.Connected then
  begin
    IdTCPClient1.Connect;
    //memoLog.Lines.Add('Conectado');
  end;

  LMsg := GetMessage(AToken, GetPayLoad(PAnsiChar(UTF8Encode(AMensagem)), 1, 'default'));
  StreamMsg := TStringStream.Create(LMsg);

  IdTCPClient1.IOHandler.Write(StreamMsg);

  //memoLog.Lines.Add('Enviado');

  if IdTCPClient1.Connected then
  begin
    IdTCPClient1.Disconnect;
    //memoLog.Lines.Add('Desconectado')
  end;
end;

function TSmServicosPush.GetPayLoad(const AAlert: AnsiString; const ABadge: Integer;
  const ASound: AnsiString): String;
var
  AJsonAps      : TJSONObject;
  AJsonPayLoad  : TJSONObject;
begin
  AJsonAps := TJSONObject.Create;

  AJsonAps.AddPair('alert', AAlert);
  AJsonAps.AddPair('badge', TJSONNumber.Create(ABadge));
  AJsonAps.AddPair('sound', ASound);

  AJsonAps.AddPair('mensagem', AAlert);
  //AJsonAps.AddPair('extras', 'aaa');

  AJsonPayLoad := TJSONObject.Create;
  AJsonPayLoad.AddPair('aps', AJsonAps);

  Result := AJsonPayLoad.ToString();
end;

function TSmServicosPush.GetMessage(const ADeviceToken, APayLoad: AnsiString): AnsiString;
begin
  Result := AnsiChar(0) + AnsiChar(0) + AnsiChar(32);
  Result := Result + HexToAscii(ADeviceToken) + AnsiChar(0) + AnsiChar(Length(APayLoad)) + APayLoad;
end;

function TSmServicosPush.HexToAscii(const AStrHexa : AnsiString): AnsiString;
var
  strLen : Integer;
  I: Integer;
begin
  strLen := Length(AStrHexa) div 2;
  Result := '';
  for I := 0 to strLen -1 do
  begin
    Result := Result + AnsiChar(Byte(StrToInt('$'+Copy(AStrHexa, (I*2)+1, 2))));
  end;
end;

function TSmServicosPush.RegistrarUsuario(const ANome, AEmail, AToken,
  ATipoDispositivo: string): TJSONArray;
begin
  //
end;


function TSmServicosPush.TesteServer: TJSONArray;
var
  LConnection : TSmartPointer<TConnectionData>;
  LQuery      : TFDQuery;
begin
  try
    LQuery := TFDQuery.Create(nil);

    LQuery.Connection := LConnection.Value.Connection;

    LQuery.Active := False;
    LQuery.SQL.Clear;
    LQuery.SQL.Text := 'SELECT * FROM ENVIOS';
    LQuery.Active := True;


    if not LQuery.IsEmpty
    then Result := LQuery.DataSetToJSON()
    else Result := TJSONArray.Create('Mensagem', 'Nenhum ENVIO encontrado!');

    TServerUtils.FormatJSON(201, Result.ToString);
  finally
    LQuery.Free;
  end;
end;

end.

