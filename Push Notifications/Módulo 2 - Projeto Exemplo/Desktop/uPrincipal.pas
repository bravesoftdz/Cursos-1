unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,

  System.Net.HttpClient,
  System.JSON;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    memoToken: TMemo;
    memoMensagem: TMemo;
    memoLog: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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

end.
