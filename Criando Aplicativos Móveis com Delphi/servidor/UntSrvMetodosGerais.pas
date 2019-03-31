unit UntSrvMetodosGerais;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  System.JSON,
  System.JSON.Types,
  System.JSON.Writers,
  System.StrUtils,
  System.NetEncoding,

  Datasnap.DSServer,
  Datasnap.DSAuth,

  Data.DB,
  Data.DBXPlatform,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Stan.StorageJSON,
  FireDAC.Stan.StorageBin,
  Restaurantes.Constantes,
  Restaurantes.Utils,

  Web.HTTPApp,
  Datasnap.DSHTTPWebBroker,
  ULGTDataSetHelper,

  //Classe de conexão
  Restaurantes.Servidor.Connection;

type
{$METHODINFO ON}
  TSrvMetodosGerais = class(TDataModule)
    qryAuxiliar: TFDQuery;
    qryAuxiliar2: TFDQuery;
    qryExportar: TFDQuery;
  private
    { Private declarations }
    function MaxTable(ATabela, ACampo: String): Integer;
    function GerarValidacao(AMaximo: Integer): string;
  public
    { Public declarations }
    {Métodos de Usuário}
    function RegistrarUsuario(const ARegistro: TJSONObject): string;
    function Login(const AUsuario, ASenha: string): TJSONArray;
    {Perfil}
    function Usuarios(const AID: Integer): TJSONArray;
    function AcceptUsuarios(const AID: Integer): TJSONArray;
    function UpdateUsuarios(): TJSONArray;
    function Perfil(const AUsuario: string): TJSONArray;
    function AcceptPerfil(const AID: string): TJSONArray;
  end;
{$METHODINFO OFF}

implementation

uses
  System.JSON.Readers;


{$R *.dfm}

function TSrvMetodosGerais.AcceptPerfil(const AID: string): TJSONArray;
const
  _SELECT =
    'SELECT * FROM CURSO.USUARIOS        ' +
    'WHERE                               ' +
    '  (CPFCNPJ = :CPF   AND ID <> :ID) OR ' +
    '  (EMAIL   = :EMAIL AND ID <> :ID)    ';
var
  iID         : Integer;
  sCPF        : string;
  sNome       : string;
  sEmail      : string;
  sFoto       : string;

  FotoStream  : TStringStream;
  Foto        : TMemoryStream;

  lResultado  : TJSONObject;

  LValores    : TJSONValue;

  lModulo       : TWebmodule;
  lJARequisicao : TJSONArray;
  lJObj         : TJSONObject;
  lSR           : TStringReader;
  lJR           : TJsonTextReader;
  lFields       : TStringList;
  lValues       : TStringList;
  lUpdate       : TStringList;
  lLinha        : TStringBuilder;
  I             : Integer;
  J             : Integer;
  lRows         : integer;
  lInStream     : TStringStream;
  lOutStream    : TMemoryStream;
  lImagem64     : TStringList;
begin
  try
    try
      lModulo := GetDataSnapWebModule;
      if (lModulo.Request.Content.IsEmpty) or (aID.IsEmpty) then
      begin
        GetInvocationMetadata().ResponseCode := 204;
        Abort
      end;

      lJARequisicao := TJSONObject.ParseJSONValue(
          TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

      for LValores in lJARequisicao do
      begin
        iID    := LValores.GetValue<string>('id').ToInteger();
        sCPF   := LValores.GetValue<string>('cpfcnpj');
        sEmail := LValores.GetValue<string>('email');
      end;

      //Verificar se o usuário e o cpf já existem no banco
      qryAuxiliar.Connection := TConexaoDados.Connection;
      qryAuxiliar.Active   := False;
      qryAuxiliar.SQL.Clear;
      qryAuxiliar.SQL.Text := _SELECT;
      qryAuxiliar.ParamByName('ID').AsInteger   := iID;
      qryAuxiliar.ParamByName('CPF').AsString   := sCPF;
      qryAuxiliar.ParamByName('EMAIL').AsString := sEmail;
      qryAuxiliar.Active   := True;

      if not (qryAuxiliar.IsEmpty) then
      begin
        if (qryAuxiliar.Locate('CPF', sCPF, [])) and
           (qryAuxiliar.FieldByName('ID').AsInteger <> iID) then
          Result := TJSONArray.Create('Mensagem', '"CPF" já cadatrado em nosso banco de dados!')
        else if (qryAuxiliar.Locate('EMAIL', sEMAIL, [])) and
                (qryAuxiliar.FieldByName('ID').AsInteger <> iID) then
        Result := TJSONArray.Create('Mensagem', '"EMAIL" já cadatrado em nosso banco de dados!');
      end
      else
      begin
        Result    := TJSONArray.Create;

        lJObj     := TJSONObject.Create;
        lUpdate   := TStringList.Create;
        lFields   := TStringList.Create;
        lValues   := TStringList.Create;
        lLinha    := TStringBuilder.Create;
        lImagem64 := TStringList.Create;
        lRows     := 0;

        try
          for I := 0 to lJARequisicao.Count -1 do
            begin
              lSR := TStringReader.Create(lJARequisicao.Items[i].ToJSON);
              lJR := TJsonTextReader.Create(lSR);
              lLinha.Clear;
              lFields.Clear;
              lValues.Clear;
              lLinha.Append('UPDATE CURSO.USUARIOS SET ');
              while lJR.Read do
              begin
                if lJR.TokenType = TJsonToken.PropertyName then
                begin
                  if not lJR.Value.ToString.IsEmpty then
                  begin
                    if lFields.IndexOf(lJR.Value.ToString) = -1 then
                      lFields.Append(lJR.Value.ToString);

                    lJR.Read;
                    if lJR.TokenType in [TJsonToken.String, TJsonToken.Date] then //System.JSON.Types;
                    begin
                      if lJR.TokenType = TJsonToken.Date then
                        lValues.Append(QuotedStr(FormatDateTime('dd.mm.yyyy',
                                                StrToDate(lJR.Value.ToString))))
                      else if UpperCase(lJR.Value.ToString) <> 'NULL' then
                        lValues.Append(QuotedStr(lJR.Value.ToString))
                      else
                        lValues.Append(lJR.Value.ToString);
                    end
                    else
                      lValues.Append(lJR.Value.ToString.Replace(',','.'));
                  end;
                end;
              end;

              for J := 0 to lFields.Count -1 do
              begin
                if not lFields[j].IsEmpty then
                begin
                  if LowerCase(lFields[j]) = 'foto' then
                  begin
                    lImagem64.Add(lValues[j]);
                    lValues[j] := ':PIMAGEM';
                  end;

                  if j <> lFields.Count -1 then
                    lLinha.Append(lFields[j] + ' = ' + lValues[j] + ', ')
                  else
                    lLinha.Append(lFields[j] + ' = ' + lValues[j]);
                end;
              end;
              lLinha.Append(' WHERE ID = :PID');
              lUpdate.Append(lLinha.ToString+';');
            end;

            TConexaoDados.Connection.TxOptions.AutoCommit := False;
            if not TConexaoDados.Connection.InTransaction then
              TConexaoDados.Connection.StartTransaction;

            try
              for I := 0 to Pred(lUpdate.Count) do
              begin
                lInStream          := TStringStream.Create(lImagem64[i]);
                lInStream.Position := 0;
                lOutStream         := TMemoryStream.Create;

                TNetEncoding.Base64.Decode(lInStream, lOutStream);
                lOutStream.Position := 0;
                qryExportar.SQL.Clear;
                qryExportar.SQL.Append(lUpdate[I]);
                qryExportar.Params.CreateParam(ftInteger, 'PID', ptInput);
                qryExportar.ParamByName('PID').AsInteger := aId.ToInteger();
                qryExportar.Params.CREATEPARAM(ftBlob, 'PIMAGEM', ptInput);
                qryExportar.ParamByName('pImagem').LoadFromStream(lOutStream, ftBlob);
                //qryExportar.SQL.SaveToFile('accept.txt');
                lRows := qryExportar.ExecSQL(lUpdate[I]);
                lJObj.AddPair('Linhas afetadas', TJSONNumber.Create(lRows));
                lInStream.Free;
                lOutStream.Free;
              end;

              if TConexaoDados.Connection.InTransaction then
                TConexaoDados.Connection.CommitRetaining;

              TConexaoDados.Connection.TxOptions.AutoCommit := True;
              Result.AddElement(lJObj);

              if lRows > 0
              then GetInvocationMetadata().ResponseCode := 200
              else GetInvocationMetadata().ResponseCode := 204;

              TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToJSON);
            except on E: Exception do
              begin
                TConexaoDados.Connection.Rollback;
                raise
              end;
            end;
        finally
          lUpdate.Free;
          lFields.Free;
          lValues.Free;
          lLinha.Free;
          lJR.Free;
          lSR.Free;
        end;
      end;
    except on E:Exception do
      begin
        //
      end;
    end;
  finally
    //
  end;
end;

function TSrvMetodosGerais.Login(const AUsuario, ASenha: string): TJSONArray;
const
  _SQL = 'SELECT NOME_USUARIO, SENHA FROM CURSO.USUARIOS WHERE NOME_USUARIO = %s AND SENHA = %s';
begin
  try
    try
      qryAuxiliar.Connection := TConexaoDados.Connection;
      qryAuxiliar.Active := False;
      qryAuxiliar.SQL.Text := Format(_SQL, [QuotedStr(AUsuario), QuotedStr(ASenha)]);
      qryAuxiliar.Active := True;

      if not (qryAuxiliar.IsEmpty) then
      begin
        Result := TJSONArray.Create('Mensagem', 'Usuário conectado com sucesso!');
        TUtils.FormatarJSON(200, Result.ToString);
      end
      else
      begin
        Result := TJSONArray.Create('Mensagem', 'Usuário ou Senha inválidos!');
        TUtils.FormatarJSON(203, Result.ToString);
      end;

    except on E:Exception do
      begin
        Result := TJSONArray.Create('Mensagem', E.Message);
        TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
      end;
    end;
  finally

  end;
end;

function TSrvMetodosGerais.AcceptUsuarios(const AID: Integer): TJSONArray;
var
  lModulo       : TWebmodule;
  lJARequisicao : TJSONArray;
  lJObj         : TJSONObject;
  lSR           : TStringReader;
  lJR           : TJsonTextReader;
  lFields       : TStringList;
  lValues       : TStringList;
  lUpdate       : TStringList;
  lLinha        : TStringBuilder;
  I             : Integer;
  J             : Integer;
  lRows         : integer;
  lInStream     : TStringStream;
  lOutStream    : TMemoryStream;
  lImagem64     : TStringList;
begin
  //Result := 'PUT - Delphi';
  lModulo := GetDataSnapWebModule;
  if (lModulo.Request.Content.IsEmpty) or (AID <= 0) then
  begin
    GetInvocationMetadata().ResponseCode := 204;
    Abort
  end;

  lJARequisicao := TJSONObject.ParseJSONValue(
      TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

  Result    := TJSONArray.Create;

  lJObj     := TJSONObject.Create;
  lUpdate   := TStringList.Create;
  lFields   := TStringList.Create;
  lValues   := TStringList.Create;
  lLinha    := TStringBuilder.Create;
  lImagem64 := TStringList.Create;
  lRows     := 0;

  try
    qryExportar.Connection := TConexaoDados.Connection;

    for I := 0 to lJARequisicao.Count -1 do
      begin
        lSR := TStringReader.Create(lJARequisicao.Items[i].ToJSON);
        lJR := TJsonTextReader.Create(lSR);
        lLinha.Clear;
        lFields.Clear;
        lValues.Clear;
        lLinha.Append('UPDATE CURSO.USUARIOS SET ');
        while lJR.Read do
        begin
          if lJR.TokenType = TJsonToken.PropertyName then
          begin
            if not lJR.Value.ToString.IsEmpty then
            begin
              if lFields.IndexOf(lJR.Value.ToString) = -1 then
                lFields.Append(lJR.Value.ToString);

              lJR.Read;
              if lJR.TokenType in [TJsonToken.String, TJsonToken.Date] then //System.JSON.Types;
              begin
                if lJR.TokenType = TJsonToken.Date then
                  lValues.Append(QuotedStr(FormatDateTime('dd.mm.yyyy',
                                          StrToDate(lJR.Value.ToString))))
                else if UpperCase(lJR.Value.ToString) <> 'NULL' then
                  lValues.Append(QuotedStr(lJR.Value.ToString))
                else
                  lValues.Append(lJR.Value.ToString);
              end
              else
                lValues.Append(lJR.Value.ToString.Replace(',','.'));
            end;
          end;
        end;

        for J := 0 to lFields.Count -1 do
        begin
          if not lFields[j].IsEmpty then
          begin
            (*
            if LowerCase(lFields[j]) = 'foto_logotipo' then
            begin
              lImagem64.Add(lValues[j]);
              lValues[j] := ':PIMAGEM';
            end;
            *)

            if j <> lFields.Count -1 then
              lLinha.Append(lFields[j] + ' = ' + lValues[j] + ', ')
            else
              lLinha.Append(lFields[j] + ' = ' + lValues[j]);
          end;
        end;
        lLinha.Append(' WHERE ID = :PID');
        lUpdate.Append(lLinha.ToString+';');
      end;

      TConexaoDados.Connection.TxOptions.AutoCommit := False;
      if not TConexaoDados.Connection.InTransaction then
        TConexaoDados.Connection.StartTransaction;

      try
        for I := 0 to Pred(lUpdate.Count) do
        begin
          //lInStream          := TStringStream.Create(lImagem64[i]);
          //lInStream.Position := 0;
          //lOutStream         := TMemoryStream.Create;

          //TNetEncoding.Base64.Decode(lInStream, lOutStream);
          //lOutStream.Position := 0;

          qryExportar.SQL.Clear;
          qryExportar.SQL.Append(lUpdate[I]);

          qryExportar.Params.CreateParam(ftInteger, 'PID', ptInput);
          qryExportar.ParamByName('PID').AsInteger := AID;

          //qryExportar.Params.CREATEPARAM(ftBlob, 'PIMAGEM', ptInput);
          //qryExportar.ParamByName('pImagem').LoadFromStream(lOutStream, ftBlob);

          lRows := qryExportar.ExecSQL(lUpdate[I]);
          lJObj.AddPair('Linhas afetadas', TJSONNumber.Create(lRows));
          lInStream.Free;
          lOutStream.Free;
        end;

        if TConexaoDados.Connection.InTransaction then
          TConexaoDados.Connection.CommitRetaining;

        TConexaoDados.Connection.TxOptions.AutoCommit := True;
        Result.AddElement(lJObj);

        if lRows > 0
        then GetInvocationMetadata().ResponseCode := 200
        else GetInvocationMetadata().ResponseCode := 204;

        TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToJSON);
      except on E: Exception do
        begin
          TConexaoDados.Connection.Rollback;
          raise
        end;
      end;
  finally
    lUpdate.Free;
    lFields.Free;
    lValues.Free;
    lLinha.Free;
    lJR.Free;
    lSR.Free;
  end;

end;

function TSrvMetodosGerais.GerarValidacao(AMaximo: Integer): string;
const
  Letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  I      : Integer;
  tmpL   : Integer;
  CHR    : Char;
  Codigo : String;
begin
  //Gera 6 letras aleatórias
  repeat
    Randomize;
    tmpL := Random(26);
    //Rejeita caracter Nulo #0
    if tmpL = 0 then
      continue;
    //Rejeita letra igual
    if Pos(Letras[tmpL], Codigo) > 0 then
      continue;
    CHR    := Letras[tmpL];
    Codigo := Codigo + CHR;
  until Length(Codigo) = AMaximo;

  Result := Codigo;
end;

function TSrvMetodosGerais.Perfil(const AUsuario: string): TJSONArray;
const
  _SQL = 'SELECT * FROM CURSO.USUARIOS WHERE UPPER(NOME_USUARIO) = UPPER(:NOME_USUARIO)';
begin
  qryExportar.Connection := TConexaoDados.Connection;
  qryExportar.Active := False;
  qryExportar.SQL.Clear;
  qryExportar.SQL.Add(_SQL);
  qryExportar.ParamByName('NOME_USUARIO').AsString := UpperCase(AUsuario);
  qryExportar.Active := True;

  if qryExportar.IsEmpty
  then Result := TJSONArray.Create('Mensagem', 'Nenhum perfil encontrado.')
  else Result := qryExportar.DataSetToJSON;

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
end;

function TSrvMetodosGerais.MaxTable(ATabela, ACampo: String): Integer;
const
  _SELECT = 'SELECT MAX(%s) AS MAXIMO FROM %s';
begin
  try
    qryAuxiliar2.Connection := TConexaoDados.Connection;

    qryAuxiliar2.Active    := False;
    qryAuxiliar2.SQL.Text  := Format(_SELECT, [ACampo, ATabela]);
    qryAuxiliar2.Active    := True;

    if not (qryAuxiliar2.IsEmpty)
    then Result := qryAuxiliar2.FieldByName('MAXIMO').AsInteger + 1
    else Result := 1;
  except on E:Exception do
    begin
      //
    end;
  end;
end;

function TSrvMetodosGerais.RegistrarUsuario(const ARegistro: TJSONObject): string;
const
  _SELECT = 'SELECT CPF, NOME_USUARIO FROM CURSO.USUARIOS WHERE CPF = %s OR NOME_USUARIO = %s';

  _INSERT =
    'INSERT INTO CURSO.USUARIOS ' +
    '(                          ' +
    '   ID                    , ' +
    '   NOME_COMPLETO         , ' +
    '   NOME_USUARIO          , ' +
    '   EMAIL                 , ' +
    '   CPF                   , ' +
    '   SENHA                   ' +
    ')                          ' +
    'VALUES                     ' +
    '(                          ' +
    '   :ID                   , ' +
    '   :NOME_COMPLETO        , ' +
    '   :NOME_USUARIO         , ' +
    '   :EMAIL                , ' +
    '   :CPF                  , ' +
    '   :SENHA                  ' +
    ');                         ';
var
  sCPF        : string;
  sNome       : string;
  sEmail      : string;
  sUsuario    : string;
  sSenha      : string;

  lResultado  : TJSONObject;
begin
  Result := EmptyStr;
  try
    qryAuxiliar.Connection := TConexaoDados.Connection;
    try
      sCPF     := (ARegistro as TJSONObject).Values['cpf'].Value;
      sNome    := (ARegistro as TJSONObject).Values['nome'].Value;
      sEmail   := (ARegistro as TJSONObject).Values['email'].Value;
      sUsuario := (ARegistro as TJSONObject).Values['usuario'].Value;
      sSenha   := (ARegistro as TJSONObject).Values['senha'].Value;

      //Verificar se o usuário e o cpf já existem no banco
      qryAuxiliar.Active   := False;
      qryAuxiliar.SQL.Text := Format(_SELECT, [QuotedStr(sCPF), QuotedStr(sUsuario)]);
      qryAuxiliar.Active   := True;

      if not (qryAuxiliar.IsEmpty) then
      begin
        if qryAuxiliar.FieldByName('CPF').AsString.Equals(sCPF) then
        begin
          {$REGION 'Exemplo de Uso'}
          //Exemplo de uso
          {
             "resultado":"aviso",
             "erro message":"Usuário já existe"
          }

          {
             "resultado":"erro",
             "codigo_erro":"500",
             "erro message":"Não foi possível registrar seu usuário. Access Violation"
          }

          {
             "resultado":"sucesso",
             "codigo":"ABD123"
          }
          {$ENDREGION}
          lResultado  := TJSONObject.Create;
          lResultado.AddPair('resultado', 'aviso');
          lResultado.AddPair('codigo_mensagem', '200');
          lResultado.AddPair('mensagem', '"CPF" já cadatrado em nosso banco de dados!');

          Result := lResultado.ToString;

          TUtils.FormatarJSON(Info200, Result);
        end
        else if qryAuxiliar.FieldByName('nome_usuario').AsString.Equals(sUsuario) then
        begin
          lResultado  := TJSONObject.Create;
          lResultado.AddPair('resultado', 'aviso');
          lResultado.AddPair('codigo_mensagem', '200');
          lResultado.AddPair('mensagem', '"Nome de usuário" já cadatrado em nosso banco de dados!');

          Result := lResultado.ToString;

          TUtils.FormatarJSON(Info200, Result);
        end
      end
      else
      begin
        //Registrar o usuário no banco de dados
        try
          qryAuxiliar.Active                                       := False;

          qryAuxiliar.SQL.Text                                     := _INSERT;
          qryAuxiliar.Params.ParamByName('ID').AsInteger           := MaxTable('CURSO.USUARIOS', 'ID');
          qryAuxiliar.Params.ParamByName('NOME_COMPLETO').AsString := sNome;
          qryAuxiliar.Params.ParamByName('NOME_USUARIO').AsString  := sUsuario;
          qryAuxiliar.Params.ParamByName('EMAIL').AsString         := sEmail;
          qryAuxiliar.Params.ParamByName('CPF').AsString           := sCPF;
          qryAuxiliar.Params.ParamByName('SENHA').AsString         := sSenha;

          qryAuxiliar.ExecSQL;

          lResultado  := TJSONObject.Create;
          lResultado.AddPair('resultado', 'sucesso');
          lResultado.AddPair('codigo_mensagem', '200');
          lResultado.AddPair('mensagem', 'Usuário cadastrado com sucesso!');
          lResultado.AddPair('codigo_validacao', GerarValidacao(6));

          Result := lResultado.ToString;

          GetInvocationMetadata().ResponseCode    := 200;
          GetInvocationMetadata().ResponseContent := Result;
        except on E:Exception do
          begin
            lResultado  := TJSONObject.Create;
            lResultado.AddPair('resultado', 'sucesso');
            lResultado.AddPair('codigo_mensagem', '200');
            lResultado.AddPair('mensagem', E.Message);
            lResultado.AddPair('codigo_validacao', GerarValidacao(6));

            Result := lResultado.ToString;

            GetInvocationMetadata().ResponseCode    := 200;
            GetInvocationMetadata().ResponseContent := Result;
          end;
        end;
      end;
    except on E:Exception do
      begin
        //
      end;
    end;
  finally
    //
  end;
end;

function TSrvMetodosGerais.UpdateUsuarios: TJSONArray;
const
  _SELECT =
    'SELECT * FROM CURSO.USUARIOS        ' +
    'WHERE                               ' +
    '  (CPFCNPJ = :CPF  )    OR          ' +
    '  (EMAIL   = :EMAIL)                ';
var
  sCPF        : string;
  sNome       : string;
  sEmail      : string;
  sFoto       : string;

  LValores      : TJSONValue;
  lModulo       : TWebmodule;
  lJARequisicao : TJSONArray;

  lJObj         : TJSONObject;
  lSR           : TStringReader;
  lJR           : TJsonTextReader;
  lFields       : TStringList;
  lValues       : TStringList;
  lInsert       : TStringList;
  lLinha        : TStringBuilder;
  I             : Integer;
  J             : Integer;
  lInStream     : TStringStream;
  lOutStream    : TMemoryStream;
  lImagem64     : TStringList;
begin
  lModulo := GetDataSnapWebModule;
  if (lModulo.Request.Content.IsEmpty) then
  begin
    GetInvocationMetadata().ResponseCode := 204;
    Abort
  end;

  lJARequisicao := TJSONObject.ParseJSONValue(
      TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

  for LValores in lJARequisicao do
  begin
    sCPF   := LValores.GetValue<string>('cpfcnpj');
    sEmail := LValores.GetValue<string>('email');
  end;

  //Verificar se o usuário e o cpf já existem no banco
  qryAuxiliar.Connection := TConexaoDados.Connection;

  qryAuxiliar.Active   := False;
  qryAuxiliar.SQL.Clear;
  qryAuxiliar.SQL.Text := _SELECT;
  qryAuxiliar.ParamByName('CPF').AsString   := sCPF;
  qryAuxiliar.ParamByName('EMAIL').AsString := sEmail;
  qryAuxiliar.Active   := True;

  if not (qryAuxiliar.IsEmpty) then
  begin
    if (qryAuxiliar.Locate('CPFCNPJ', sCPF, [])) then
      Result := TJSONArray.Create('Mensagem', '"CPF" já cadatrado em nosso banco de dados!')
    else if (qryAuxiliar.Locate('EMAIL', sEMAIL, [])) then
    Result := TJSONArray.Create('Mensagem', '"EMAIL" já cadatrado em nosso banco de dados!');
  end
  else
  begin
    Result    := TJSONArray.Create;

    lJObj     := TJSONObject.Create;
    lInsert   := TStringList.Create;
    lFields   := TStringList.Create;
    lValues   := TStringList.Create;

    lLinha    := TStringBuilder.Create;
    lImagem64 := TStringList.Create;

    try
      for I := 0 to Pred(lJARequisicao.Count) do
      begin
        lSR := TStringReader.Create(lJARequisicao.Items[I].ToJSON);
        lJR := TJsonTextReader.Create(lSR);
        lLinha.Clear;
        lFields.Clear;
        lValues.Clear;
        lLinha.Append('INSERT INTO CURSO.USUARIOS(');
        //Preenche os Campos
        while lJR.Read do
        begin
          if lJR.TokenType = TJsonToken.PropertyName then
          begin
            if not lJR.Value.ToString.IsEmpty then
            begin
              if lFields.IndexOf(lJR.Value.ToString) = -1 then
                lFields.Append(lJR.Value.ToString);

              lJR.Read;
              if lJR.TokenType in [TJsonToken.String, TJsonToken.Date] then //System.JSON.Types;
              begin
                if lJR.TokenType = TJsonToken.Date then
                  lValues.Append(QuotedStr(FormatDateTime('dd.mm.yyyy',
                                          StrToDate(lJR.Value.ToString))))
                else if UpperCase(lJR.Value.ToString) <> 'NULL' then
                  lValues.Append(QuotedStr(lJR.Value.ToString))
                else
                  lValues.Append(lJR.Value.ToString);
              end
              else
                lValues.Append(lJR.Value.ToString.Replace(',','.'));
            end;
          end;
        end;

        for J := 0 to Pred(lFields.Count) do
        begin
          if not lFields[j].IsEmpty then
          begin
            if j <> lFields.Count -1 then
              lLinha.Append(lFields[j] + ', ')
            else
              lLinha.Append(lFields[j]);
          end;
        end;

        lLinha.Append(') VALUES (');

        //Preenche os valores
        for J := 0 to lValues.Count -1 do
        begin
          if not lValues[j].IsEmpty then
          begin
            if LowerCase(lFields[j]) = 'foto' then
            begin
              lImagem64.Add(lValues[j]);
              lValues[j] := ':PIMAGEM';
            end;


            if j <> lValues.Count -1 then
              lLinha.Append(lValues[j] + ', ')
            else
              lLinha.Append(lValues[j]);
          end;
        end;

        lInsert.Append(lLinha.ToString + ');');
      end;

      //Inicia a transação
      TConexaoDados.Connection.TxOptions.AutoCommit := False;
      if not TConexaoDados.Connection.InTransaction then
        TConexaoDados.Connection.StartTransaction;

      try
        for I := 0 to Pred(lInsert.Count) do
        begin
          lInStream := TStringStream.Create(lImagem64[i]);
          lInStream.Position := 0;
          lOutStream := TMemoryStream.Create;
          TNetEncoding.Base64.Decode(lInStream, lOutStream);
          lOutStream.Position := 0;
          qryExportar.SQL.Clear;
          qryExportar.SQL.Append(lInsert[I]);
          qryExportar.Params.CreateParam(ftBlob, 'PIMAGEM', ptInput);
          qryExportar.ParamByName('PIMAGEM').LoadFromStream(lOutStream, ftBlob);
          qryExportar.ExecSQL;
          lJObj.AddPair('ID', TConexaoDados.Connection.GetLastAutoGenValue('usuarios'));
          lInStream.Free;
          lOutStream.Free;
        end;

        if TConexaoDados.Connection.InTransaction then
          TConexaoDados.Connection.CommitRetaining;

        TConexaoDados.Connection.TxOptions.AutoCommit := True;
        Result.AddElement(lJObj);
        GetInvocationMetadata().ResponseCode := 201;

        TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToJSON);
      except on E: Exception do
        begin
          TConexaoDados.Connection.Rollback;
          raise;
        end;
      end;
    finally
      lInsert.Free;
      lFields.Free;
      lValues.Free;
      lLinha.Free;
      lJR.Free;
      lSR.Free;
    end;
  end;
end;

function TSrvMetodosGerais.Usuarios(const AID: Integer): TJSONArray;
begin
  //
end;

end.

