unit UntDMDados;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.IOUtils,
  System.UITypes,
  System.JSON.Writers,
  System.JSON.Types,
  System.NetEncoding,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  Data.DB,



  ULGTDataSetHelper;

type
  TDMDados = class(TDataModule)
    MemCategorias: TFDMemTable;
    MemCategoriasid: TIntegerField;
    MemCategoriasdescricao: TStringField;
    MemCardapios: TFDMemTable;
    MemCardapiosid: TIntegerField;
    MemCardapiosid_estabelecimento: TIntegerField;
    MemCardapiosid_categoria: TIntegerField;
    MemCardapiosnome: TStringField;
    MemCardapiosingredientes: TStringField;
    MemCardapiospreco: TFloatField;
    MemCadUsuario: TFDMemTable;
    MemCadUsuariocpfcnpj: TStringField;
    MemCadUsuarionome_completo: TStringField;
    MemCadUsuarionome_usuario: TStringField;
    MemCadUsuarioemail: TStringField;
    MemCadUsuariosenha: TStringField;
    MemCadUsuariofoto: TBlobField;
    MemRestaurantes: TFDMemTable;
    MemRestaurantesid: TIntegerField;
    MemRestaurantesfantasia: TStringField;
    MemRestaurantesrazao_social: TStringField;
    MemRestaurantesfoto_logotipo: TBlobField;
    MemCadUsuarioid_estabelecimento: TIntegerField;
    MemPedidos: TFDMemTable;
    MemItensPedido: TFDMemTable;
    MemPedidosid_usuario: TIntegerField;
    MemPedidosid_estabelecimento: TIntegerField;
    MemPedidosdata: TDateTimeField;
    MemPedidosstatus: TStringField;
    MemPedidosvalor_pedido: TBCDField;
    MemPedidosid_pedido_mobile: TIntegerField;
    MemItensPedidoid_pedido: TIntegerField;
    MemItensPedidoqtde: TIntegerField;
    MemItensPedidovalor_unitario: TBCDField;
    MemItensPedidoid_cardapio: TIntegerField;
    MemItensPedidoid_pedido_mobile: TIntegerField;
    MemItensPedidoid_item_pedido_mobile: TIntegerField;
    MemItensPedidoid_usuario: TIntegerField;
    MemItensPedidostatus: TStringField;
    dtsMasterPedidos: TDataSource;
    MemUsuario: TFDMemTable;
    MemUsuarioid: TIntegerField;
    MemUsuarioid_endereco: TIntegerField;
    MemUsuarionome_completo: TStringField;
    MemUsuarionome_usuario: TStringField;
    MemUsuariocpfcnpj: TStringField;
    MemUsuarioemail: TStringField;
    MemUsuariosenha: TStringField;
    MemUsuariofoto: TBlobField;
    MemPedidosid: TIntegerField;
    MemItensPedidoid: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GravarCardapio;
    function  GravarUsuario: Integer;
    procedure AtualizarUsuario(const AID: Integer);
    function  GravarEstabelecimento: Integer;
    function  AtualizarStatusPedido(const AIDUsuario, AID_Pedido_Mobile: Integer): Boolean;
  end;

var
  DMDados: TDMDados;

implementation

uses
  ServerController;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMDados }

function TDMDados.AtualizarStatusPedido(const AIDUsuario,
  AID_Pedido_Mobile: Integer): Boolean;
var
  StrAux  : TStringWriter;
  TxtJSON : TJSONTextWriter;
  ljObj   : TJSONObject;
  jrJSON : TJSONArray;
begin
  if MemPedidos.State in [dsEdit, dsInsert] then
    MemPedidos.Post;

  jrJSON := TJSONArray.Create;

  StrAux  := TStringWriter.Create;
  TxtJSON := TJsonTextWriter.Create(StrAux);
  TxtJSON.Formatting := TJsonFormatting.Indented;

  //Cabeçalho do Pedido
  TxtJSON.WriteStartObject; //Objeto Global
  TxtJSON.WritePropertyName('pedido');
  TxtJSON.WriteStartArray;  //Array Pedido

  TxtJSON.WriteStartObject;
  TxtJSON.WritePropertyName('id_pedido_mobile');
  TxtJSON.WriteValue(MemPedidos.FieldByName('ID').AsInteger);

  TxtJSON.WritePropertyName('id_usuario');
  TxtJSON.WriteValue(MemPedidos.FieldByName('ID_USUARIO').AsInteger);

  TxtJSON.WritePropertyName('id_estabelecimento');
  TxtJSON.WriteValue(MemPedidos.FieldByName('ID_ESTABELECIMENTO').AsInteger);

  TxtJSON.WritePropertyName('data');
  TxtJSON.WriteValue(FormatDateTime('DD/MM/YYYY', MemPedidos.FieldByName('DATA').AsDateTime));

  TxtJSON.WritePropertyName('valor_pedido');
  TxtJSON.WriteValue(MemPedidos.FieldByName('VALOR_PEDIDO').AsFloat);

  TxtJSON.WritePropertyName('status_pedido');
  TxtJSON.WriteValue(MemPedidos.FieldByName('STATUS').AsString);

  TxtJSON.WriteEndObject; //Objeto Pedido

  TxtJSON.WriteEndArray;  //Array Pedido / Itens
  TxtJSON.WriteEndObject; //Objeto Global

  ljObj   := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(StrAux.ToString), 0) as TJSONObject;

  jrJSON.AddElement(ljObj);

  Result := UserSession.DMRest.MudarStatusPedido(jrJSON, AIDUsuario, AID_Pedido_Mobile);

(*
  var
  jrJSON : TJSONArray;
begin
  if MemPedidos.State in [dsEdit, dsInsert] then
    MemPedidos.Post;

  jrJSON := TJSONArray.Create;
  jrJSON := MemPedidos.DataSetToJSON(True);
  Result := UserSession.DMRest.MudarStatusPedido(jrJSON, AIDUsuario, AID_Pedido_Mobile);
*)
end;

procedure TDMDados.AtualizarUsuario(const AID: Integer);
var
  jrJSON : TJSONArray;
begin
  if MemCadUsuario.State in [dsEdit, dsInsert] then
    MemCadUsuario.Post;

  jrJSON := TJSONArray.Create;
  jrJSON := MemCadUsuario.DataSetToJSON(True);
  UserSession.DMRest.AtualizarUsuario(jrJSON, AID);
end;

procedure TDMDados.GravarCardapio;
var
  jrJSON : TJSONArray;
begin
  if MemCardapios.State in [dsEdit, dsInsert] then
    MemCardapios.Post;

  jrJSON := TJSONArray.Create;
  jrJSON := MemCardapios.DataSetToJSON(True);
  UserSession.DMRest.RegistrarCardapio(jrJSON);
end;

function TDMDados.GravarEstabelecimento : Integer;
var
  jrJSON : TJSONArray;
begin
  if MemRestaurantes.State in [dsEdit, dsInsert] then
    MemRestaurantes.Post;

  jrJSON := TJSONArray.Create;
  jrJSON := MemRestaurantes.DataSetToJSON(True);
  Result := UserSession.DMRest.RegistrarEstabelecimento(jrJSON);
end;

function TDMDados.GravarUsuario: Integer;
var
  jrJSON : TJSONArray;
begin
  if MemCadUsuario.State in [dsEdit, dsInsert] then
    MemCadUsuario.Post;

  jrJSON := TJSONArray.Create;
  jrJSON := MemCadUsuario.DataSetToJSON(True);
  Result := UserSession.DMRest.RegistrarUsuario(jrJSON);
end;

end.
