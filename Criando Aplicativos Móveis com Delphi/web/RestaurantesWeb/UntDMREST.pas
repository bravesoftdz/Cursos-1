unit UntDMREST;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.NetEncoding,
  System.JSON.Types,
  System.Types,
  System.JSON.Readers,

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
  Data.Bind.Components,
  Data.Bind.ObjectScope,

  REST.Response.Adapter,
  REST.Client,
  REST.Types,

  Constantes,
  SmartPoint,

  UntDMDados;

type
  TDMREST = class(TDataModule)
    rstClient: TRESTClient;
    rstRequest: TRESTRequest;
    rstResponse: TRESTResponse;
    rstAdapter: TRESTResponseDataSetAdapter;
    MemREST: TFDMemTable;
  private
    { Private declarations }
    procedure ClearToDefaults;
    function Execute(const AServerMethod, AColecao: string; AElementos: TStrings): Boolean;overload;
    function Execute(const AServerMethod, AColecao: string; AElementos: TStrings; AContent: TJSONArray;
      ARequestMethod: TRESTRequestMethod): Boolean;overload;
    function GetUsuario(const AID: Integer): Boolean;
  public
    { Public declarations }
    function Login(const AUsuario, ASenha: string): Boolean;           //Ok
    function Perfil(const AUsuario: String): Boolean;

    function RegistrarUsuario(const AConteudo: TJSONArray): Integer;                 //Ok INCLUSÃO
    function AtualizarUsuario(const AConteudo: TJSONArray; AID: Integer): Boolean;   //Ok ALTERAÇÃO DO ID_ESTABELECIMETO OU OUTROS

    function RegistrarEstabelecimento(const AConteudo: TJSONArray): Integer;

    function Categorias(const AEstabelecimento: Integer): Boolean;

    function Cardapios(const ACategoria, AEstabelecimento: Integer): Boolean;
    function RegistrarCardapio(const AConteudo: TJSONArray): Boolean;

    function Pedidos(const AIDUsuario: Integer): Boolean; //Resultar os pedidos
    function ItensPedido(const AIDPedido, AIDEstabelecimento: Integer): Boolean;
    function MudarStatusPedido(const AConteudo: TJSONArray;
      AIDUsuario, AID_Pedido_Mobile: Integer): Boolean;
  end;

var
  DMREST: TDMREST;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMREST }

uses
  ServerController;

function TDMREST.AtualizarUsuario(const AConteudo: TJSONArray; AID: Integer): Boolean;
var
  LParam : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    LParam.Value.AddPair('ID', AID.ToString);
    Result := Execute(C_METODOSGERAIS, C_USUARIOS, LParam, AConteudo, rmPUT);
  except on E:Exception do
    begin

    end;
  end;
end;

function TDMREST.Cardapios(const ACategoria,
  AEstabelecimento: Integer): Boolean;
var
  LParams    : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    try
      LParams.Value.AddPair('id_categogia', ACategoria.ToString);
      LParams.Value.AddPair('id_estabelecimento', AEstabelecimento.ToString);

      if Execute(C_SmServicos, C_CARDAPIOS, LParams) then
      begin
        UserSession.DMDados.MemCardapios.Active := False;
        UserSession.DMDados.MemCardapios.Active := True;
        MemREST.First;
        while not (MemREST.Eof) do
        begin
          UserSession.DMDados.MemCardapios.Append;
          UserSession.DMDados.MemCardapios.FieldByName('ID').AsInteger                 := MemREST.FieldByName('ID').AsInteger;
          UserSession.DMDados.MemCardapios.FieldByName('ID_ESTABELECIMENTO').AsInteger := MemREST.FieldByName('ID_ESTABELECIMENTO').AsInteger;
          UserSession.DMDados.MemCardapios.FieldByName('ID_CATEGORIA').AsInteger       := MemREST.FieldByName('ID_CATEGORIA').AsInteger;
          UserSession.DMDados.MemCardapios.FieldByName('NOME').AsString                := MemREST.FieldByName('NOME').AsString;
          UserSession.DMDados.MemCardapios.FieldByName('INGREDIENTES').AsString        := MemREST.FieldByName('INGREDIENTES').AsString;
          UserSession.DMDados.MemCardapios.FieldByName('PRECO').AsFloat                := MemREST.FieldByName('PRECO').AsFloat;

          UserSession.DMDados.MemCardapios.Post;

          MemREST.Next;
        end;

        Result := True;
      end
      else
        Result := False;

      MemREST.Active := False;
    except on E:Exception do
      begin
        Result := False;
      end;
    end;
  finally

  end;
end;

function TDMREST.Categorias(const AEstabelecimento: Integer): Boolean;
var
  LParams    : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    try
      LParams.Value.AddPair('id_estabelecimento', AEstabelecimento.ToString);

      if Execute(C_SmServicos, C_CATEGORIAS, LParams) then
      begin
        UserSession.DMDados.MemCategorias.Active := False;
        UserSession.DMDados.MemCategorias.Active := True;
        MemREST.First;
        while not (MemREST.Eof) do
        begin
          UserSession.DMDados.MemCategorias.Append;
          UserSession.DMDados.MemCategorias.FieldByName('ID').AsInteger       := MemREST.FieldByName('ID').AsInteger;
          UserSession.DMDados.MemCategorias.FieldByName('DESCRICAO').AsString := MemREST.FieldByName('DESCRICAO').AsString;
          UserSession.DMDados.MemCategorias.Post;

          MemREST.Next;
        end;

        Result := True;
      end
      else
        Result := False;

      MemREST.Active := False;
    except on E:Exception do
      begin
        Result := False;
      end;
    end;
  finally

  end;
end;

procedure TDMREST.ClearToDefaults;
begin
  rstRequest.ResetToDefaults;
  rstClient.ResetToDefaults;
  rstResponse.ResetToDefaults;

  //FDMemTable1.EmptyDataSet;
  //FDMemTable1.Active := False;
end;

function TDMREST.Execute(const AServerMethod, AColecao: string;
  AElementos: TStrings): Boolean;
var
  I       : Integer;
  LParams : string;
begin
  Result := False;
  try
    //Reset de componentes
    ClearToDefaults;

    MemREST.Active := False;

    //RESTClient
    rstClient.BaseURL := Format('%s%s', [C_BASEURL, AServerMethod]);

    //RESTRequest
    rstRequest.Method := rmGET;

               {chave}            {valor}
    //SL.AddPair('estabelecimento', '1');
    //SL.AddPair('cardapio', '4');

    if (AElementos <> nil) and (AElementos.Count > 0) then
    begin
      for I := 0 to Pred(AElementos.Count) do
      begin
        rstRequest.Params.AddItem(
          AElementos.Names[I],
          AElementos.ValueFromIndex[I],
          TRESTRequestParameterKind.pkURLSEGMENT
        );
        if LParams.Equals(EmptyStr)
        then LParams := LParams + '{' + AElementos.Names[I] + '}'
        else LParams := LParams + '/{' + AElementos.Names[I] + '}'
      end;
      //cardapios/{estabelecimento}{cardapio}
      rstRequest.Resource := Format('%s/%s', [AColecao, LParams]);
    end
    else
      rstRequest.Resource := AColecao;

    rstRequest.Execute;

    Result := True;
  except on E:Exception do
    begin

    end;
  end;

end;

function TDMREST.Execute(const AServerMethod, AColecao: string;
  AElementos: TStrings; AContent: TJSONArray;
  ARequestMethod: TRESTRequestMethod): Boolean;
var
  I       : Integer;
  LParams : string;
begin
  Result := False;
  try
    //Reset de componentes
    ClearToDefaults;

    MemREST.Active := False;

    //RESTClient
    rstClient.BaseURL := Format('%s%s', [C_BASEURL, AServerMethod]);

    //RESTRequest
    rstRequest.Method := ARequestMethod;

               {chave}            {valor}
    //SL.AddPair('estabelecimento', '1');
    //SL.AddPair('cardapio', '4');

    if (AElementos <> nil) and (AElementos.Count > 0) then
    begin
      for I := 0 to Pred(AElementos.Count) do
      begin
        rstRequest.Params.AddItem(
          AElementos.Names[I],
          AElementos.ValueFromIndex[I],
          TRESTRequestParameterKind.pkURLSEGMENT
        );
        if LParams.Equals(EmptyStr)
        then LParams := LParams + '{' + AElementos.Names[I] + '}'
        else LParams := LParams + '/{' + AElementos.Names[I] + '}'
      end;
      //cardapios/{estabelecimento}{cardapio}
      rstRequest.Resource := Format('%s/%s', [AColecao, LParams]);
    end
    else
      rstRequest.Resource := AColecao;

    rstRequest.Body.Add(AContent.ToString, ContentTypeFromString('application/json'));

    rstRequest.Execute;

    Result := True;
  except on E:Exception do
    begin

    end;
  end;

end;

function TDMREST.GetUsuario(const AID: Integer): Boolean;
var
  LParams    : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    try
      LParams.Value.AddPair('id', AID.ToString);

      if Execute(C_METODOSGERAIS, C_USUARIOS, LParams) then
      begin
        UserSession.ID_Usuario := MemREST.FieldByName('ID').AsInteger;
        Result := True;
      end
      else
        Result := False;

      MemREST.Active := False;
    except on E:Exception do
      begin
        Result := False;
      end;
    end;
  finally

  end;

end;

function TDMREST.ItensPedido(const AIDPedido, AIDEstabelecimento: Integer): Boolean;
var
  LParams    : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    try
      LParams.Value.AddPair('id', AIDPedido.ToString);
      LParams.Value.AddPair('id_estabelecimento', AIDEstabelecimento.ToString);

      if Execute(C_SmServicos, C_ITENS_PEDIDOS, LParams) then
      begin
        UserSession.DMDados.MemItensPedido.Active := False;
        UserSession.DMDados.MemItensPedido.Active := True;
        MemREST.First;
        while not (MemREST.Eof) do
        begin
          UserSession.DMDados.MemItensPedido.Append;
          UserSession.DMDados.MemItensPedido.FieldByName('ID').AsInteger                       := MemREST.FieldByName('ID').AsInteger;
          UserSession.DMDados.MemItensPedido.FieldByName('ID_PEDIDO').AsInteger                := MemREST.FieldByName('ID_PEDIDO').AsInteger;
          UserSession.DMDados.MemItensPedido.FieldByName('QTDE').AsInteger                     := MemREST.FieldByName('QTDE').AsInteger;
          UserSession.DMDados.MemItensPedido.FieldByName('VALOR_UNITARIO').AsFloat             := MemREST.FieldByName('VALOR_UNITARIO').AsFloat;
          UserSession.DMDados.MemItensPedido.FieldByName('ID_CARDAPIO').AsInteger              := MemREST.FieldByName('ID_CARDAPIO').AsInteger;
          UserSession.DMDados.MemItensPedido.FieldByName('ID_PEDIDO_MOBILE').AsInteger         := MemREST.FieldByName('ID_PEDIDO_MOBILE').AsInteger;
          UserSession.DMDados.MemItensPedido.FieldByName('ID_ITEM_PEDIDO_MOBILE').AsInteger    := MemREST.FieldByName('ID_ITEM_PEDIDO_MOBILE').AsInteger;
          UserSession.DMDados.MemItensPedido.FieldByName('ID_USUARIO').AsInteger               := MemREST.FieldByName('ID_USUARIO').AsInteger;
          UserSession.DMDados.MemItensPedido.FieldByName('STATUS').AsString                    := MemREST.FieldByName('STATUS').AsString;

          UserSession.DMDados.MemItensPedido.Post;

          MemREST.Next;
        end;

        Result := True;
      end
      else
        Result := False;

      MemREST.Active := False;
    except on E:Exception do
      begin
        Result := False;
      end;
    end;
  finally

  end;


end;

function TDMREST.Login(const AUsuario, ASenha: string): Boolean;
var
  LParams : TSmartPointer<TStringList>;
begin
  Result := False;

  LParams.Value.AddPair('nome_usuario', AUsuario);
  LParams.Value.AddPair('senha', ASenha);

  if Execute(C_METODOSGERAIS, C_LOGIN, LParams)
  then Result := (rstResponse.StatusCode = 200)
  else Result := False;
end;

function TDMREST.MudarStatusPedido(const AConteudo: TJSONArray;
  AIDUsuario, AID_Pedido_Mobile: Integer): Boolean;
var
  LParam : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    LParam.Value.AddPair('ID_Usuario', AIDUsuario.ToString);
    LParam.Value.AddPair('ID_Pedido_Mobile', AID_Pedido_Mobile.ToString);
    LParam.Value.AddPair('Estabelecimento', 'S');
    Result := Execute(C_SmServicos, C_PEDIDOS, LParam, AConteudo, rmPUT);
  except on E:Exception do
    begin

    end;
  end;
end;

function TDMREST.Pedidos(const AIDUsuario: Integer): Boolean;
var
  LParams    : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    try
      LParams.Value.AddPair('id_usuario', AIDUsuario.ToString);

      if Execute(C_SmServicos, C_PEDIDOS, LParams) then
      begin
        UserSession.DMDados.MemPedidos.Active := False;
        UserSession.DMDados.MemPedidos.Active := True;
        MemREST.First;
        while not (MemREST.Eof) do
        begin
          UserSession.DMDados.MemPedidos.Append;
          UserSession.DMDados.MemPedidos.FieldByName('ID').AsInteger                 := MemREST.FieldByName('ID').AsInteger;
          UserSession.DMDados.MemPedidos.FieldByName('ID_USUARIO').AsInteger         := MemREST.FieldByName('ID_USUARIO').AsInteger;
          UserSession.DMDados.MemPedidos.FieldByName('ID_ESTABELECIMENTO').AsInteger := MemREST.FieldByName('ID_ESTABELECIMENTO').AsInteger;
          UserSession.DMDados.MemPedidos.FieldByName('DATA').AsDateTime              := MemREST.FieldByName('DATA').AsDateTime;
          UserSession.DMDados.MemPedidos.FieldByName('STATUS').AsString              := MemREST.FieldByName('STATUS').AsString;
          UserSession.DMDados.MemPedidos.FieldByName('VALOR_PEDIDO').AsFloat         := MemREST.FieldByName('VALOR_PEDIDO').AsFloat;
          UserSession.DMDados.MemPedidos.FieldByName('ID_PEDIDO_MOBILE').AsInteger   := MemREST.FieldByName('ID_PEDIDO_MOBILE').AsInteger;

          UserSession.DMDados.MemPedidos.Post;

          MemREST.Next;
        end;

        Result := True;
      end
      else
        Result := False;

      MemREST.Active := False;
    except on E:Exception do
      begin
        Result := False;
      end;
    end;
  finally

  end;

end;

function TDMREST.Perfil(const AUsuario: String): Boolean;
var
  FotoStream : TStringStream;
  Foto       : TMemoryStream;
  sReader    : TStringReader;
  jReader    : TJsonTextReader;
  sID        : String;

  LParams    : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    try
      LParams.Value.AddPair('nome_usuario', AUsuario);

      if Execute(C_METODOSGERAIS, C_PERFIL, LParams) then
      begin
        UserSession.DMDados.MemUsuario.Active := False;
        UserSession.DMDados.MemUsuario.Active := True;



        MemREST.First;
        while not (MemREST.Eof) do
        begin
          UserSession.DMDados.MemUsuario.Append;
          UserSession.DMDados.MemUsuario.FieldByName('ID').AsInteger           := MemREST.FieldByName('ID').AsInteger;
          //DM.MemUsuario.FieldByName('ID_ENDERECO').AsInteger  := MemREST.FieldByName('ID_ENDERECO').AsInteger;
          UserSession.DMDados.MemUsuario.FieldByName('NOME_COMPLETO').AsString := MemREST.FieldByName('NOME_COMPLETO').AsString;
          UserSession.DMDados.MemUsuario.FieldByName('NOME_USUARIO').AsString  := MemREST.FieldByName('NOME_USUARIO').AsString;
          UserSession.DMDados.MemUsuario.FieldByName('EMAIL').AsString         := MemREST.FieldByName('EMAIL').AsString;
          UserSession.DMDados.MemUsuario.FieldByName('CPFCNPJ').AsString       := MemREST.FieldByName('CPFCNPJ').AsString;
          UserSession.DMDados.MemUsuario.FieldByName('SENHA').AsString         := MemREST.FieldByName('SENHA').AsString;

          UserSession.ID_Usuario := UserSession.DMDados.MemUsuario.FieldByName('ID').AsInteger;

          sReader := TStringReader.Create(rstResponse.Content);
          jReader := TJsonTextReader.Create(sReader);
          while jReader.Read do
          begin
            if jReader.TokenType = TJsonToken.PropertyName then
            begin
              if (jReader.Path = '[0].id') then
              begin
                jReader.Read;
                sID := jReader.Value.ToString;
              end;

              //Refatorado para o esquema acima.
              //if Pos('ID', UpperCase(jReader.Path)) > 0 then
              //begin
              //  jReader.Read;
              //  sID := jReader.Value.ToString;
              //end;

              if (UpperCase(jReader.Value.ToString) = 'FOTO') and
                  (sID = MemREST.FieldByName('ID').AsInteger.ToString) then
              begin
                try
                  jReader.Read;
                  FotoStream := TStringStream.Create(jReader.Value.ToString);
                  FotoStream.Position := 0;
                  Foto := TMemoryStream.Create;
                  TNetEncoding.Base64.Decode(FotoStream, Foto);
                  UserSession.DMDados.MemUsuariofoto.LoadFromStream(Foto);

                  Break;
                finally
                  FotoStream.DisposeOf;
                  Foto.DisposeOf;
                end;
              end
              else
                continue;
            end;
          end;

          UserSession.DMDados.MemUsuario.Post;
          MemREST.Next;
        end;
        Result := True;
      end
      else
        Result := False;

      MemREST.Active := False;
    except on E:Exception do
      begin
        Result := False;
      end;
    end;
  finally

  end;
end;

function TDMREST.RegistrarCardapio(const AConteudo: TJSONArray): Boolean;
begin
  Result := False;
  try
    Result := Execute(C_SmServicos, C_CARDAPIOS, nil, AConteudo, rmPOST);
  except on E:Exception do
    begin

    end;
  end;
end;

function TDMREST.RegistrarEstabelecimento(
  const AConteudo: TJSONArray): Integer;
var
  bResult  : Boolean;
  iID      : Integer;
  jrResult : TJSONArray;
begin
  try
    bResult := Execute(C_SmServicos, C_ESTABELECIMENTOS, nil, AConteudo, rmPOST)
                  and (rstResponse.StatusCode = 201);

    if bResult then
    begin
      jrResult := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(rstResponse.Content),0) as TJSONArray;
      Result := (jrResult as TJSONArray).Items[0].GetValue<Integer>('ID');
    end
    else
      Result := 0;
  except on E:Exception do
    begin

    end;
  end;
end;

function TDMREST.RegistrarUsuario(const AConteudo: TJSONArray): Integer;
var
  bResult  : Boolean;
  iID      : Integer;
  jrResult : TJSONArray;
begin
  try
    bResult := Execute(C_METODOSGERAIS, C_USUARIOS, nil, AConteudo, rmPOST)
                  and (rstResponse.StatusCode = 201);

    if bResult then
    begin
      jrResult := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(rstResponse.Content),0) as TJSONArray;
      Result := (jrResult as TJSONArray).Items[0].GetValue<Integer>('ID');
    end
    else
      Result := 0;

  except on E:Exception do
    begin

    end;
  end;
end;

end.




