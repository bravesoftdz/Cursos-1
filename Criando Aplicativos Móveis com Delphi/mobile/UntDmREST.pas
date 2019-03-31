unit UntDmREST;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.JSON.Readers,
  System.NetEncoding,
  System.JSON.Types,
  System.Types,

  IPPeerClient,

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
  SmartPoint;

type
  TDmREST = class(TDataModule)
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
  public
    { Public declarations }
    function Estabelecimentos(const AFiltro: string = ''; AValue: Integer = 0): Boolean;
    function Categorias(const AEstabelecimento: Integer): Boolean;
    function Cardapios(const ACategoria, AEstabelecimento: Integer): Boolean;
    function Perfil(const AUsuario: string): Boolean;
    function AtualizarPerfil(const APerfil: TJSONArray; const AID: Integer): Boolean;
    function RegistrarUsuario(const AConteudo: TJSONArray): Boolean;
    function Login(const AUsuario, ASenha: string): Boolean;
    function EnviarPedido(const AConteudo: TJSONArray): Boolean;
    function AtualizarStatusLocal (const AID_Usuario: Integer): Boolean;
    function EnviarAlteracaoPedido(const AConteudo: TJSONArray; AID_Usuario, AID_PEDIDO_MOBILE: Integer): Boolean;
  end;

var
  DmREST: TDmREST;

implementation

uses
  {$IFDEF WEB}
  ServerController,
  {$ENDIF}
  UntDM;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDmREST }

function TDmREST.Execute(const AServerMethod, AColecao: string;
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

procedure TDmRest.ClearToDefaults;
begin
  rstRequest.ResetToDefaults;
  rstClient.ResetToDefaults;
  rstResponse.ResetToDefaults;

  //FDMemTable1.EmptyDataSet;
  //FDMemTable1.Active := False;
end;

function TDmREST.Login(const AUsuario, ASenha: string): Boolean;
var
  LParams : TSmartPointer<TStringList>;
begin
  Result := False;

  LParams.Value.AddPair('nome_usuario', AUsuario);
  LParams.Value.AddPair('senha', ASenha);

  if Execute(C_METODOSGERAIS, C_LOGIN, LParams)
  then Result := (rstResponse.StatusCode = 200)
  else Result := False;
    //ShowMessage('Erro de requisição');
end;

function TDmREST.AtualizarPerfil(const APerfil: TJSONArray;
  const AID: Integer): Boolean;
var
  LParams : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    LParams.Value.AddPair('id', AID.ToString);
    Result := Execute(C_METODOSGERAIS, C_PERFIL, LParams, APerfil, rmPUT);
  except on E:Exception do
    begin

    end;
  end;
end;

function TDmREST.AtualizarStatusLocal(const AID_Usuario: Integer): Boolean;
const
  _UPDATE = 'UPDATE PEDIDOS SET STATUS = :PSTATUS WHERE ID = :PID_PEDIDO_MOBILE AND ID_USUARIO = :PID_USUARIO';
var
  LParams   : TSmartPointer<TStringList>;
  ArraySize : Integer;
  vIndex    : Integer;
begin
  //
  Result := False;
  try
    try
      LParams.Value.AddPair('ID_USUARIO', AID_USUARIO.ToString);

      if Execute(C_SmServicos, C_ATUALIZARSTATUS, LParams) then
      begin
        vIndex := -1;
        MemREST.First;
        ArraySize := MemREST.RecordCount;

        DM.qryAuxiliar.Active           := False;
        DM.qryAuxiliar.SQL.Clear;
        DM.qryAuxiliar.SQL.Text         := _UPDATE;
        DM.qryAuxiliar.Params.ArraySize := ArraySize;

        while not MemREST.Eof do
        begin
          Inc(vIndex);
          DM.qryAuxiliar.ParamByName('PSTATUS').AsStrings[vIndex]            := MemREST.FieldByName('STATUS').AsString;
          DM.qryAuxiliar.ParamByName('PID_PEDIDO_MOBILE').AsIntegers[vIndex] := MemREST.FieldByName('ID_PEDIDO_MOBILE').AsInteger;
          DM.qryAuxiliar.ParamByName('PID_USUARIO').AsIntegers[vIndex]       := MemREST.FieldByName('ID_USUARIO').AsInteger;
          MemREST.Next;
        end;

       DM.qryAuxiliar.Execute(ArraySize, 0);
      end;
    except on E:Exception do
      begin

      end;
    end;
  finally

  end;
end;

function TDmREST.Cardapios(const ACategoria, AEstabelecimento: Integer): Boolean;
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
        DM.MemCardapios.Active := False;
        DM.MemCardapios.Active := True;
        MemREST.First;
        while not (MemREST.Eof) do
        begin
          DM.MemCardapios.Append;
          DM.MemCardapios.FieldByName('ID').AsInteger                 := MemREST.FieldByName('ID').AsInteger;
          DM.MemCardapios.FieldByName('ID_ESTABELECIMENTO').AsInteger := MemREST.FieldByName('ID_ESTABELECIMENTO').AsInteger;
          DM.MemCardapios.FieldByName('ID_CATEGORIA').AsInteger       := MemREST.FieldByName('ID_CATEGORIA').AsInteger;
          DM.MemCardapios.FieldByName('NOME').AsString                := MemREST.FieldByName('NOME').AsString;
          DM.MemCardapios.FieldByName('INGREDIENTES').AsString        := MemREST.FieldByName('INGREDIENTES').AsString;
          DM.MemCardapios.FieldByName('PRECO').AsFloat                := MemREST.FieldByName('PRECO').AsFloat;

          DM.MemCardapios.Post;

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

function TDmREST.Categorias(const AEstabelecimento: Integer): Boolean;
var
  LParams    : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    try
      LParams.Value.AddPair('id_estabelecimento', AEstabelecimento.ToString);

      if Execute(C_SmServicos, C_CATEGORIAS, LParams) then
      begin
        DM.MemCategorias.Active := False;
        DM.MemCategorias.Active := True;
        MemREST.First;
        while not (MemREST.Eof) do
        begin
          DM.MemCategorias.Append;
          DM.MemCategorias.FieldByName('ID').AsInteger       := MemREST.FieldByName('ID').AsInteger;
          DM.MemCategorias.FieldByName('DESCRICAO').AsString := MemREST.FieldByName('DESCRICAO').AsString;
          DM.MemCategorias.Post;

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

function TDmREST.EnviarAlteracaoPedido(const AConteudo: TJSONArray; AID_Usuario,
  AID_PEDIDO_MOBILE: Integer): Boolean;
var
  LParams : TSmartPointer<TStringList>;
begin
  Result := False;
  try
    LParams.Value.AddPair('ID_USUARIO', AID_USUARIO.ToString);
    LParams.Value.AddPair('ID_PEDIDO_MOBILE', AID_PEDIDO_MOBILE.ToString);

    Result :=
           Execute(C_SmServicos, C_PEDIDOS, LParams, AConteudo, rmPUT)
      AND  not (rstResponse.StatusCode = 202);

  except on E:Exception do
    begin
      Result := False;
    end;
  end;

end;

function TDmREST.EnviarPedido(const AConteudo: TJSONArray): Boolean;
begin
  Result := False;
  try
    Result := Execute(C_SmServicos, C_PEDIDOS, nil, AConteudo, rmPOST);
  except on E:Exception do
    begin

    end;
  end;
end;


function TDmREST.Estabelecimentos(const AFiltro: string = ''; AValue: Integer = 0): Boolean;
var
  FotoStream     : TStringStream;
  Foto           : TMemoryStream;
  sReader        : TStringReader;
  jReader        : TJsonTextReader;
  sID            : String;

  LParams        : TSmartPointer<TStringList>;
  DMvREST        : TDataModule;
  dmDados        : TDataModule;
begin
  {$IFDEF WEB}
    DmvREST    := UserSession.DmRest;
    dmDados    := UserSession.DM;
  {$ELSE}
    DMvREST    := DmRest;
    dmDados    := DM;
  {$ENDIF}

  Result := False;
  try
    try
      if not (AFiltro.Equals(EmptyStr)) then
        LParams.Value.AddPair(AFiltro, AValue.ToString);

      if Execute(C_SmServicos, C_ESTABELECIMENTOS, LParams) then
      begin
        TDM(dmDados).MemRestaurantes.Active := False;
        TDM(dmDados).MemRestaurantes.Active := True;
        TDmREST(DMvREST).MemREST.First;

        //TDM(dmDados).MemRestaurantes.CopyDataSet(TDmREST(DMvREST).MemREST);
        //TDmREST(DMvREST).MemREST.Active := False;

        while not (TDmREST(dmvREST).MemREST.Eof) do
        begin
          TDM(dmDados).MemRestaurantes.Append;
          TDM(dmDados).MemRestaurantes.FieldByName('ID').AsInteger           := TDmREST(dmvREST).MemREST.FieldByName('ID').AsInteger;
          TDM(dmDados).MemRestaurantes.FieldByName('FANTASIA').AsString      := TDmREST(dmvREST).MemREST.FieldByName('FANTASIA').AsString;
          TDM(dmDados).MemRestaurantes.FieldByName('RAZAO_SOCIAL').AsString  := TDmREST(dmvREST).MemREST.FieldByName('RAZAO_SOCIAL').AsString;

          sReader := TStringReader.Create(rstResponse.Content);
          jReader := TJsonTextReader.Create(sReader);
          while jReader.Read do
          begin
            if jReader.TokenType = TJsonToken.PropertyName then
            begin
              if Pos('ID', UpperCase(jReader.Path)) > 0 then
              begin
                jReader.Read;
                sID := jReader.Value.ToString;
              end;

              if (UpperCase(jReader.Value.ToString) = 'FOTO_LOGOTIPO') and
                  (sID = TDmREST(dmREST).MemREST.FieldByName('ID').AsInteger.ToString) then
              begin
                try
                  jReader.Read;
                  FotoStream := TStringStream.Create(jReader.Value.ToString);
                  FotoStream.Position := 0;
                  Foto := TMemoryStream.Create;
                  TNetEncoding.Base64.Decode(FotoStream, Foto);
                  TDM(dmDados).MemRestaurantesfoto_logotipo.LoadFromStream(Foto);

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

          TDM(dmDados).MemRestaurantes.Post;
          TDmREST(dmvREST).MemREST.Next;
        end;

        Result := True;
      end
      else
        Result := False;

      TDmREST(DMvREST).MemREST.Active := False;
    except on E:Exception do
      begin
        Result := False;
      end;
    end;
  finally

  end;
end;

function TDmREST.Execute(const AServerMethod, AColecao: string;
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

function TDmREST.Perfil(const AUsuario: string): Boolean;
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
        DM.MemUsuario.Active := False;
        DM.MemUsuario.Active := True;
        MemREST.First;
        while not (MemREST.Eof) do
        begin
          DM.MemUsuario.Append;
          DM.MemUsuario.FieldByName('ID').AsInteger           := MemREST.FieldByName('ID').AsInteger;
          //DM.MemUsuario.FieldByName('ID_ENDERECO').AsInteger  := MemREST.FieldByName('ID_ENDERECO').AsInteger;
          DM.MemUsuario.FieldByName('NOME_COMPLETO').AsString := MemREST.FieldByName('NOME_COMPLETO').AsString;
          DM.MemUsuario.FieldByName('NOME_USUARIO').AsString  := MemREST.FieldByName('NOME_USUARIO').AsString;
          DM.MemUsuario.FieldByName('EMAIL').AsString         := MemREST.FieldByName('EMAIL').AsString;
          DM.MemUsuario.FieldByName('CPFCNPJ').AsString       := MemREST.FieldByName('CPFCNPJ').AsString;
          DM.MemUsuario.FieldByName('SENHA').AsString         := MemREST.FieldByName('SENHA').AsString;

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
                  DM.memUsuariofoto.LoadFromStream(Foto);

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

          DM.MemUsuario.Post;
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

function TDmREST.RegistrarUsuario(const AConteudo: TJSONArray): Boolean;
begin
  Result := False;
  try
    Result := Execute(C_METODOSGERAIS, C_USUARIOS, nil, AConteudo, rmPOST);
  except on E:Exception do
    begin

    end;
  end;
end;

end.

