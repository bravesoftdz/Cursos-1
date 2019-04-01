unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,

  System.Net.HttpClient,
  System.JSON, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    memoToken: TMemo;
    memoMensagem: TMemo;
    memoLog: TMemo;
    Button1: TButton;
    IdTCPClient1: TIdTCPClient;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IdSSLIOHandlerSocketOpenSSL1GetPassword(var Password: string);
    procedure FormCreate(Sender: TObject);
  private
    function HexToAscii(const AStrHexa: AnsiString): AnsiString;
    function GetMessage(const ADeviceToken, APayLoad: AnsiString): AnsiString;
    { Private declarations }
  public
    { Public declarations }
    Badge: integer;
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
var
  vHttpClient     : THttpClient;
  v_JSON          : TJSONObject;
  v_JsonData      : TJSONObject;
  v_RegisterIDs   : TJSONArray;
  v_Data          : TStringStream;
  v_Response      : TStringStream;

  Token           : String;
  CodigoProjeto   : String;
  API             : String;
  Link            : String;

  RegisterIDs     : TJSONArray;
begin
  //
  Token         := memoToken.Lines.Text;
  CodigoProjeto := '271332362079';
  API           := 'AIzaSyDgjOcWTVmmL9_JhVoXfo5Axngosqi-UoQ';
  Link          := 'https://android.googleapis.com/gcm/send';

  try
    RegisterIDs := TJSONArray.Create;
    RegisterIDs.Add(Token);

    v_JsonData  := TJSONObject.Create;
    v_JsonData.AddPair('id', CodigoProjeto);                //obrigatório
    v_JsonData.AddPair('message', memoMensagem.Lines.Text); //obrigatório
    v_JsonData.AddPair('campo_extra', '123456');

    v_JSON      := TJSONObject.Create;
    v_JSON.AddPair('registration_ids', RegisterIDs);
    v_JSON.AddPair('data', v_JsonData);

    vHttpClient := THTTPClient.Create;
    vHttpClient.ContentType := 'application/json';
    vHttpClient.CustomHeaders['Authorization'] := 'key=' + API;

    memoLog.Lines.Clear;
    memoLog.Lines.Add(v_JSON.ToString);

    v_Data := TStringStream.Create(v_JSON.ToString);
    v_Data.Position := 0;

    v_Response := TStringStream.Create;

    //Envio do Push
    vHttpClient.Post(Link, v_Data, v_Response);
    v_Response.Position := 0;

    memoLog.Lines.Add(v_Response.DataString);
  finally

  end;

end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if not IdTCPClient1.Connected then
  begin
    IdTCPClient1.Connect;
    memoLog.Lines.Add('Conectado');
  end;

end;

function TForm2.HexToAscii(const AStrHexa : AnsiString): AnsiString;
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

procedure TForm2.IdSSLIOHandlerSocketOpenSSL1GetPassword(var Password: string);
begin
  Password := '0S6a3235';
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  sToken    : string;
  sMsg      : AnsiString;
  StreamMsg : TStringStream;

  function GetPayLoad(const AAlert: AnsiString; const ABadge: Integer;
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

begin
  sToken := memoToken.Lines.Text;
  sMsg   := memoMensagem.Lines.Text;

  if not IdTCPClient1.Connected then
  begin
    IdTCPClient1.Connect;
    memoLog.Lines.Add('Conectado');
  end;

  sMsg := GetMessage(sToken, GetPayLoad(PAnsiChar(UTF8Encode(sMsg)), 1, 'default'));
  StreamMsg := TStringStream.Create(sMsg);

  IdTCPClient1.IOHandler.Write(StreamMsg);

  memoLog.Lines.Add('Enviado');

  if IdTCPClient1.Connected then
  begin
    IdTCPClient1.Disconnect;
    memoLog.Lines.Add('Desconectado')
  end;
end;

function TForm2.GetMessage(const ADeviceToken : AnsiString; const APayLoad : AnsiString): AnsiString;
begin
  Result := AnsiChar(0) + AnsiChar(0) + AnsiChar(32); // Cabecera del Mensaje
  Result := Result + HexToAscii(ADeviceToken) + AnsiChar(0) + AnsiChar(Length(APayLoad)) + APayLoad;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  if IdTCPClient1.Connected then
  begin
    IdTCPClient1.Disconnect;
    memoLog.Lines.Add('Desconectado')
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Badge := 1;
end;

end.
