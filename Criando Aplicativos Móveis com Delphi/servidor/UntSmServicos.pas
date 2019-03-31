unit UntSmServicos;

interface

uses
  System.Classes,
  System.JSON,
  System.JSON.Readers,
  System.JSON.Types,
  System.NetEncoding,

  Web.HTTPApp,
  Datasnap.DSHTTPWebBroker,

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
  FireDAC.Stan.StorageJSON,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  Data.DB,
  Data.DBXPlatform,
  UntSrvMetodosGerais,
  ULGTDataSetHelper,

  Restaurantes.Utils,
  //Classe de conexão
  Restaurantes.Servidor.Connection;

type
{$MethodInfo ON}
  TSmServicos = class(TDataModule)
    qryExportar: TFDQuery;
    qryAuxiliar: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    {Estabelecimentos}
    function Estabelecimentos(const AID: string): TJSONArray;                           //Get     - SELECT
    function AcceptEstabelecimentos(const AID : string): TJSONArray;                    //Put     - UPDATE TABELA
    function UpdateEstabelecimentos : TJSONArray;                                       //Post    - INSERT INTO
    function CancelEstabelecimentos (const AID : string): TJSONArray;                   //Delete  - DELETE
    {Categorias}
    function Categorias(const AEstabelecimento: string): TJSONArray;                    //Get
    function AcceptCategorias(const AID: Integer): TJSONArray;                          //Put
    function UpdateCategorias: TJSONArray;                                              //Post
    function CancelCategorias(const AID: string): TJSONArray;                           //Delete
    {Cardapios}
    function Cardapios(const ACategoria, AEstabelecimento: string): TJSONArray;         //Get
    function AcceptCardapios(const AID: string) : TJSONArray;                           //Put
    function UpdateCardapios: TJSONArray;                                               //Post
    function CancelCardapios(const AID: string): TJSONArray;                            //Delete
    {Pedidos}
    function Pedidos(const AUsuario: Integer;  APedidoMobile: Integer = 0): TJSONArray; //Get     - SELECT
    function AcceptPedidos(const AID_Usuario, AID_Pedido_Mobile: Integer;
  AEstabelecimento: String = 'N'): TJSONArray;  //Put     - UPDATE TABELA
    function UpdatePedidos: TJSONArray;                                                 //Post    - INSERT INTO
    function AtualizarStatus(const AUsuario: Integer): TJSONArray;

    function ItensPedido(const AIDPedido, AIDEstabelecimento: Integer): TJSONArray;
  end;
{$MethodInfo OFF}

var
  SmServicos: TSmServicos;

implementation

uses
  System.SysUtils;


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TsmEstabelecimentos }

function TSmServicos.AcceptCategorias(const AID: Integer): TJSONArray;
begin

end;

function TSmServicos.AcceptCardapios(const AID: string): TJSONArray;
begin

end;

function TSmServicos.AcceptEstabelecimentos (const AId : string): TJSONArray;
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
  if (lModulo.Request.Content.IsEmpty) or (aID.IsEmpty) then
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
        lLinha.Append('UPDATE CURSO.ESTABELECIMENTOS SET ');
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
            if LowerCase(lFields[j]) = 'foto_logotipo' then
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

function TSmServicos.AcceptPedidos(const AID_Usuario, AID_Pedido_Mobile: Integer;
  AEstabelecimento: String = 'N'): TJSONArray;
const
  SQL_PEDIDO =
    'SELECT ID, STATUS FROM CURSO.PEDIDOS           ' +
    'WHERE                                          ' +
    '      ID_USUARIO          = :PID_USUARIO       ' +
    '  AND ID_PEDIDO_MOBILE    = :PID_PEDIDO_MOBILE ';

  UPD_PEDIDO =
    'UPDATE CURSO.PEDIDOS                                ' +
    'SET                                                 ' +
    '   ID_USUARIO             = :PID_USUARIO          , ' +
    '   ID_ESTABELECIMENTO     = :PID_ESTABELECIMENTO  , ' +
    '   DATA                   = :PDATA                , ' +
    '   STATUS                 = :PSTATUS              , ' +
    '   VALOR_PEDIDO           = :PVALOR_PEDIDO        , ' +
    '   ID_PEDIDO_MOBILE       = :PID_PEDIDO_MOBILE      ' +
    'WHERE                                               ' +
    '      ID_USUARIO          = :PID_USUARIO            ' +
    '  AND ID_PEDIDO_MOBILE    = :PID_PEDIDO_MOBILE      ';

  SQL_ITEM_PEDIDO =
    'SELECT ID FROM CURSO.ITENS_PEDIDO                      ' +
    'WHERE                                                  ' +
    '       ID_PEDIDO_MOBILE      = :PID_PEDIDO_MOBILE      ' +
    '   AND ID_USUARIO            = :PID_USUARIO            ' +
    '   AND ID_ITEM_PEDIDO_MOBILE = :PID_ITEM_PEDIDO_MOBILE ';

  UPD_ITENS_PEDIDO =
    'UPDATE CURSO.ITENS_PEDIDO                                  ' +
    'SET                                                        ' +
    '   STATUS                    = :PSTATUS                    ' +
    'WHERE                                                      ' +
    '       ID_PEDIDO_MOBILE      = :PID_PEDIDO_MOBILE          ' +
    '   AND ID_USUARIO            = :PID_USUARIO                ' +
    '   AND ID_ITEM_PEDIDO_MOBILE = :PID_ITEM_PEDIDO_MOBILE     ';

  INS_ITENS_PEDIDO =
    'INSERT INTO CURSO.ITENS_PEDIDO     ' +
    '(                                  ' +
    '   ID_PEDIDO               ,       ' +
    '   QTDE                    ,       ' +
    '   VALOR_UNITARIO          ,       ' +
    '   ID_CARDAPIO             ,       ' +
    '   ID_PEDIDO_MOBILE        ,       ' +
    '   STATUS                  ,       ' +
    '   ID_ITEM_PEDIDO_MOBILE   ,       ' +
    '   ID_USUARIO                      ' +
    ')                                  ' +
    'VALUES                             ' +
    '(                                  ' +
    '   :PID_PEDIDO             ,       ' +
    '   :PQTDE                  ,       ' +
    '   :PVALOR_UNITARIO        ,       ' +
    '   :PID_CARDAPIO           ,       ' +
    '   :PID_PEDIDO_MOBILE      ,       ' +
    '   :PSTATUS                ,       ' +
    '   :PID_ITEM_PEDIDO_MOBILE ,       ' +
    '   :PID_USUARIO                    ' +
    ');                                 ';

var
  lModulo                 : TWebModule;
  lJARequisicao           : TJSONArray;
  LValores                : TJSONValue;
  jPedido                 : TJSONValue;
  jItens                  : TJSONValue;
  lJOBJ                   : TJSONObject;

  //Pedidos
  iID_Pedido_Servidor     : Integer;
  iId_Estabelecimento     : Integer;
  dData                   : TDateTime;
  fValor_Pedido           : Double;
  sStatus                 : String;

  //Itens pedido
  iQtde                   : Integer;
  fValor_Unitario         : Double;
  iId_Cardapio            : Integer;
  iID_Item_Pedido_Mobile  : Integer;
  sStatus_Item            : string;

  //Auxiliares
  I                       : Integer;
  J                       : Integer;
  arrItens                : Integer;
begin
  lModulo := GetDataSnapWebModule;
  if lModulo.Request.Content.IsEmpty then
  begin
    GetInvocationMetaData().ResponseCode := 204;
    Abort;
  end;

  lJARequisicao := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

  try
    try
      qryAuxiliar.Connection := TConexaoDados.Connection;
      qryExportar.Connection := TConexaoDados.Connection;

      TConexaoDados.Connection.TxOptions.AutoCommit := False;
      if not TConexaoDados.Connection.InTransaction then
        TConexaoDados.Connection.StartTransaction;

      for LVAlores in lJARequisicao do
      begin
        jPedido := LValores.GetValue<TJSONArray>('pedido');
        for I := 0 to Pred((jPedido as TJSONArray).Count) do
        begin
          iId_Estabelecimento := (jPedido as TJSONArray).Items[I].GetValue<integer>('id_estabelecimento');
          dData               := StrToDateTime((jPedido as TJSONArray).Items[I].GetValue<string>('data'));
          fValor_Pedido       := (jPedido as TJSONArray).Items[I].GetValue<double>('valor_pedido');
          sStatus             := (jPedido as TJSONArray).Items[I].GetValue<string>('status_pedido');

          //Resgatar o ID do Pedido Atual - Alterado
          qryAuxiliar.Active           := False;
          qryAuxiliar.SQL.Clear;
          qryAuxiliar.SQL.Text         := SQL_PEDIDO;
          qryAuxiliar.ParamByName('PID_USUARIO').AsIntegers[0]         := AID_Usuario;
          qryAuxiliar.ParamByName('PID_PEDIDO_MOBILE').AsIntegers[0]   := AID_Pedido_Mobile;
          qryAuxiliar.Active := True;

          iID_Pedido_Servidor          := qryAuxiliar.FieldByName('ID').AsInteger;

          if (qryAuxiliar.FieldByName('STATUS').AsString[1] in ['P', 'M', 'F', 'C', 'X']) and not (AEstabelecimento.Equals('S')) then
          begin
            lJOBJ := TJSONObject.Create;
            lJOBJ.AddPair('Mensagem', 'O pedido não pôde ser alterado. Consulte o estabelecimento!');

            Result := TJSONArray.Create;
            Result.AddElement(lJOBJ);

            GetInvocationMetaData().ResponseCode := 202;

            TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToJSON());

            TConexaoDados.Connection.Rollback;
            exit;
          end;


          //A = ABERTO (NÃO ENVIADO DO CLIENTE PARA O SERVIDOR)
          //G = AGUARDANDO (AGUARDANDO QUALQUER STATUS)
          //E = ENVIADO (CLIENTE PARA SERVIDOR)
          //R = RECEBIDO (RECEBIDO NO RESTAURANTE)
          //P = PREPARO (PREPARANDO NO RESTAURANTE)
          //M = MOTOBOY (ENVIADO DO RESTAURANTE PARA O CLIENTE)
          //F = FECHADO (ENTREGUE - O MOTOBOY RETORNOU E DEU BAIXA NO RESTAURANTE)
          //C = CANCELADO (PELO CLIENTE OU RESTAURANTE)
          //X = EXCLUÍDO (ITEM DE PEDIDO EXCLUÍDO)

          qryAuxiliar.Active           := False;

          //Atualização de Pedidos
          qryExportar.Active           := False;
          qryExportar.SQL.Clear;
          qryExportar.SQL.Text         := UPD_PEDIDO;
          qryExportar.Params.ArraySize := 1;

          qryExportar.ParamByName('PID_USUARIO').AsIntegers[0]         := AID_Usuario;
          qryExportar.ParamByName('PID_ESTABELECIMENTO').AsIntegers[0] := iId_Estabelecimento;
          qryExportar.ParamByName('PDATA').AsDateTimes[0]              := dData;
          qryExportar.ParamByName('PSTATUS').AsStrings[0]              := sStatus;
          qryExportar.ParamByName('PVALOR_PEDIDO').AsFloats[0]         := (FormatFloat('###,###,##0.00', fValor_Pedido)).ToDouble();
          qryExportar.ParamByName('PID_PEDIDO_MOBILE').AsIntegers[0]   := AID_Pedido_Mobile;

          qryExportar.Execute(1, 0);

          //Atualiação dos Itens do Pedido
          (jPedido as TJSONArray).Items[I].TryGetValue('itens', jItens);


          //jItens   := (jPedido as TJSONArray).Items[I].GetValue<TJSONArray>('itens');
          if Assigned(jItens) then
          begin
            arrItens := (jItens as TJSONArray).Count;

            for J := 0 to Pred((jItens as TJSONArray).Count) do
            begin
              iQtde                   := (jItens as TJSONArray).Items[J].GetValue<integer>('qtde');
              fValor_Unitario         := (FormatFloat('###,###,##0.00', (jItens as TJSONArray).Items[J].GetValue<double>('valor_unitario'))).ToDouble();
              iId_Cardapio            := (jItens as TJSONArray).Items[J].GetValue<integer>('id_cardapio');
              sStatus_Item            := (jItens as TJSONArray).Items[J].GetValue<string>('status_item');
              iID_Item_Pedido_Mobile  := (jItens as TJSONArray).Items[J].GetValue<integer>('id_item_pedido_mobile');

              //Localiza o item na base. Se existir, altera, senão insere
              qryAuxiliar.Active           := False;
              qryAuxiliar.SQL.Clear;
              qryAuxiliar.SQL.Text         := SQL_ITEM_PEDIDO;
              qryAuxiliar.ParamByName('PID_PEDIDO_MOBILE').AsIntegers[0]      := AID_Pedido_Mobile;
              qryAuxiliar.ParamByName('PID_USUARIO').AsIntegers[0]            := AID_Usuario;
              qryAuxiliar.ParamByName('PID_ITEM_PEDIDO_MOBILE').AsIntegers[0] := iID_Item_Pedido_Mobile;
              qryAuxiliar.Active := True;

              if not qryAuxiliar.IsEmpty then //Se o item FOR encontrado, ou seja, existir....faz o update no banco
              begin
                //Update no Item
                qryExportar.Active := False;
                qryExportar.SQL.Clear;
                qryExportar.SQL.Text         := UPD_ITENS_PEDIDO;
                qryExportar.Params.ArraySize := 1;

                qryExportar.ParamByName('PSTATUS').AsStrings[0]                 := sStatus_Item;

                qryExportar.ParamByName('PID_PEDIDO_MOBILE').AsIntegers[0]      := AID_Pedido_Mobile;
                qryExportar.ParamByName('PID_USUARIO').AsIntegers[0]            := AID_Usuario;
                qryExportar.ParamByName('PID_ITEM_PEDIDO_MOBILE').AsIntegers[0] := iID_Item_Pedido_Mobile;

                qryExportar.Execute(1, 0);
              end
              else                            //Se o item NÃO for encontrado, ou seja, NÃO existir...adiciona o novo registro
              begin
                //Insert do Item
                qryExportar.Active := False;
                qryExportar.SQL.Clear;
                qryExportar.SQL.Text         := INS_ITENS_PEDIDO;
                qryExportar.Params.ArraySize := 1;

                qryExportar.ParamByName('PID_PEDIDO').AsIntegers[0]             := iID_Pedido_Servidor;
                qryExportar.ParamByName('PID_PEDIDO_MOBILE').AsIntegers[0]      := AID_Pedido_Mobile;
                qryExportar.ParamByName('PID_ITEM_PEDIDO_MOBILE').AsIntegers[0] := iID_Item_Pedido_Mobile;
                qryExportar.ParamByName('PSTATUS').AsStrings[0]                 := sStatus_Item;
                qryExportar.ParamByName('PQTDE').AsIntegers[0]                  := iQtde;
                qryExportar.ParamByName('PVALOR_UNITARIO').AsFloats[0]          := fValor_Unitario;
                qryExportar.ParamByName('PID_CARDAPIO').AsIntegers[0]           := iId_Cardapio;
                qryExportar.ParamByName('PID_USUARIO').AsIntegers[0]            := AID_Usuario;

                qryExportar.Execute(1, 0);
              end;
            end;
          end;

        end;
      end;

      if TConexaoDados.Connection.InTransaction then
        TConexaoDados.Connection.CommitRetaining;

      TConexaoDados.Connection.TxOptions.AutoCommit := True;

      lJOBJ := TJSONObject.Create;
      lJOBJ.AddPair('Mensagem', 'Pedido alterado com sucesso!');

      Result := TJSONArray.Create;
      Result.AddElement(lJOBJ);

      GetInvocationMetaData().ResponseCode := 201;

      TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToJSON());

    except on E:Exception do
      begin
        TConexaoDados.Connection.Rollback;
        raise;
      end;
    end;
  finally

  end;


end;

function TSmServicos.AtualizarStatus(const AUsuario: Integer): TJSONArray;
const
  _SQL =
    'SELECT * FROM CURSO.PEDIDOS WHERE               ' +
    '       STATUS IN ("A", "G", "E", "R", "P", "M") ' +
    '  AND  ID_USUARIO = :PUSUARIO                   ';
begin
  qryExportar.Connection := TConexaoDados.Connection;

  qryExportar.Active := False;
  qryExportar.SQL.Clear;
  qryExportar.SQL.Add(_SQL);
  qryExportar.ParamByName('PUSUARIO').AsInteger := AUsuario;

  qryExportar.Active := True;

  if qryExportar.IsEmpty
  then Result := TJSONArray.Create('Mensagem', 'Nenhum pedido encontrado.')
  else Result := qryExportar.DataSetToJSON;

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
end;

function TSmServicos.CancelCardapios(const AID: string): TJSONArray;
begin
//
end;

function TSmServicos.CancelCategorias(const AID: string): TJSONArray;
begin
//
end;

function TSmServicos.CancelEstabelecimentos(const AId : string): TJSONArray;
const
  _SQL = 'DELETE FROM ESTABELECIMENTOS WHERE ID = :PID';
var
  lJob  : TJSONObject;
  lRows : integer;
begin
  //Result := 'DELETE - Delphi';
  qryExportar.Connection := TConexaoDados.Connection;
  Result := TJSONArray.Create;
  lJob   := TJSONObject.Create;
  lRows  := 0;

  if not AID.IsEmpty then
  begin
    qryExportar.SQL.Clear;
    qryExportar.SQL.Append(_SQL);
    qryExportar.Params.CreateParam(ftInteger, 'pID', ptInput);
    qryExportar.ParamByName('pID').AsInteger := AId.ToInteger();
    lRows := qryExportar.ExecSQL(_SQL);
  end
  else
    GetInvocationMetadata().ResponseCode := 204;

  lJob.AddPair('Linhas afetadas', TJSONNumber.Create(lRows));
  Result.AddElement(lJob);

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToJSON);
end;

function TSmServicos.Cardapios(const ACategoria, AEstabelecimento: string): TJSONArray;
const
  _SQL =
    'SELECT                                     ' +
    '  ID                 ,                     ' +
    '  ID_ESTABELECIMENTO ,                     ' +
    '  ID_CATEGORIA       ,                     ' +
    '  NOME               ,                     ' +
    '  INGREDIENTES       ,                     ' +
    '  PRECO                                    ' +
    'FROM CURSO.CARDAPIOS                       ' +
    'WHERE                                      ' +
    '  ID_CATEGORIA       = :ID_CATEGORIA AND   ' +
    '  ID_ESTABELECIMENTO = :ID_ESTABELECIMENTO ';
begin
  qryExportar.Connection := TConexaoDados.Connection;
  qryExportar.Active := False;
  qryExportar.SQL.Clear;
  qryExportar.SQL.Text := _SQL;
  qryExportar.ParamByName('ID_CATEGORIA').AsInteger       := ACategoria.ToInteger();
  qryExportar.ParamByName('ID_ESTABELECIMENTO').AsInteger := AEstabelecimento.ToInteger();
  qryExportar.Active := True;

  if qryExportar.IsEmpty
  then Result := TJSONArray.Create('Mensagem', 'Nenhum cardápio encontrado.')
  else Result := qryExportar.DataSetToJSON;

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
end;

function TSmServicos.Categorias(const AEstabelecimento: string): TJSONArray;
const
  _SQL =
    'SELECT                                        ' +
    '  CI.ID,                                      ' +
    '  CI.DESCRICAO                                ' +
    'FROM                                          ' +
    '  CURSO.CATEGORIA_ITEM CI                     ' +
    '  INNER JOIN CURSO.CARDAPIOS CA               ' +
    '  ON CA.ID_CATEGORIA = CI.ID                  ' +
    'WHERE                                         ' +
    '  CA.ID_ESTABELECIMENTO = :ID_ESTABELECIMENTO ' +
    'GROUP BY                                      ' +
    '  CI.DESCRICAO                                ';
begin
  qryExportar.Connection := TConexaoDados.Connection;
  qryExportar.Active := False;
  qryExportar.SQL.Clear;
  qryExportar.SQL.Text := _SQL;
  qryExportar.ParamByName('ID_ESTABELECIMENTO').AsInteger := AEstabelecimento.ToInteger();
  qryExportar.Active := True;

  if qryExportar.IsEmpty
  then Result := TJSONArray.Create('Mensagem', 'Nenhuma categoria encontrada.')
  else Result := qryExportar.DataSetToJSON;

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
end;

function TSmServicos.Estabelecimentos(const AId : string): TJSONArray;
const
  _SQL = 'SELECT * FROM CURSO.ESTABELECIMENTOS';
begin
  //Result := 'GET - Delphi'
  qryExportar.Connection := TConexaoDados.Connection;
  qryExportar.Close;
  if AId.IsEmpty then
    qryExportar.Open(_SQL)
  else
  begin
    qryExportar.SQL.Clear;
    qryExportar.SQL.Add(_SQL);
    qryExportar.SQL.Add(' WHERE ID = :PID');
    qryExportar.Params.CreateParam(ftInteger, 'PID', ptInput);
    qryExportar.ParamByName('PID').AsInteger := aId.ToInteger();
    qryExportar.Open();
  end;

  if qryExportar.IsEmpty
  then Result := TJSONArray.Create('Mensagem', 'Nenhum estabelecimento encontrado.')
  else Result := qryExportar.DataSetToJSON;

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
end;

function TSmServicos.ItensPedido(const AIDPedido, AIDEstabelecimento: Integer): TJSONArray;
const
  _SQL =
    'SELECT * FROM                                       ' +
    '  CURSO.ITENS_PEDIDO IT                             ' +
    '  INNER JOIN CURSO.PEDIDOS PE                       ' +
    '  ON IT.ID_PEDIDO = PE.ID                           ' +
    'WHERE                                               ' +
    '      PE.ID = :PID                                  ' +
    '  AND PE.ID_ESTABELECIMENTO = :PID_ESTABELECIMENTO  ';
begin
  //Result := 'GET - Delphi'
  qryExportar.Connection := TConexaoDados.Connection;

  qryExportar.Active := False;
  qryExportar.SQL.Clear;
  qryExportar.SQL.Add(_SQL);
  qryExportar.ParamByName('PID').AsInteger                 := AIDPedido;
  qryExportar.ParamByName('PID_ESTABELECIMENTO').AsInteger := AIDEstabelecimento;

  qryExportar.Active := True;

  if qryExportar.IsEmpty
  then Result := TJSONArray.Create('Mensagem', 'Nenhum item de pedido encontrado.')
  else Result := qryExportar.DataSetToJSON;

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
end;

function TSmServicos.Pedidos(const AUsuario: Integer; APedidoMobile: Integer = 0): TJSONArray;
const
  _SQL =
    'SELECT * FROM CURSO.PEDIDOS';
begin
  //Result := 'GET - Delphi'
  qryExportar.Connection := TConexaoDados.Connection;
  qryExportar.Active := False;
  qryExportar.SQL.Clear;
  qryExportar.SQL.Add(_SQL);
  qryExportar.SQL.Add(' WHERE ID_USUARIO = :PUSUARIO');
  qryExportar.Params.CreateParam(ftInteger, 'PUSUARIO', ptInput);
  qryExportar.ParamByName('PUSUARIO').AsInteger := AUsuario;

  if not (APedidoMobile = 0) then
  begin
    qryExportar.SQL.Add(' AND ');
    qryExportar.SQL.Add(' ID_PEDIDO_MOBILE = :PPEDIDO_MOBILE');
    qryExportar.Params.CreateParam(ftInteger, 'PPEDIDO_MOBILE', ptInput);
    qryExportar.ParamByName('PPEDIDO_MOBILE').AsInteger := APedidoMobile;
  end;

  qryExportar.Active := True;

  if qryExportar.IsEmpty
  then Result := TJSONArray.Create('Mensagem', 'Nenhum pedido encontrado.')
  else Result := qryExportar.DataSetToJSON;

  TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToString);
end;

function TSmServicos.UpdateCardapios: TJSONArray;
var
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
  //Result := 'POST Delphi';
  lModulo := GetDataSnapWebModule;
  if lModulo.Request.Content.IsEmpty then
  begin
    GetInvocationMetadata().ResponseCode := 204;
    Abort;
  end;

  lJARequisicao := TJSONObject.ParseJSONValue(
    TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

  Result    := TJSONArray.Create;

  lJObj     := TJSONObject.Create;
  lInsert   := TStringList.Create;
  lFields   := TStringList.Create;
  lValues   := TStringList.Create;

  lLinha    := TStringBuilder.Create;
  lImagem64 := TStringList.Create;

  try
    qryExportar.Connection := TConexaoDados.Connection;
    for I := 0 to Pred(lJARequisicao.Count) do
    begin
      lSR := TStringReader.Create(lJARequisicao.Items[I].ToJSON);
      lJR := TJsonTextReader.Create(lSR);
      lLinha.Clear;
      lFields.Clear;
      lValues.Clear;
      lLinha.Append('INSERT INTO CURSO.CARDAPIOS(');
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
                lValues.Append(QuotedStr(FormatDateTime('dd.mm.yyyy',StrToDate(lJR.Value.ToString))))
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
          if LowerCase(lFields[j]) = 'foto_logotipo' then
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
        //lInStream := TStringStream.Create(lImagem64[i]);
        //lInStream.Position := 0;
        //lOutStream := TMemoryStream.Create;
        //TNetEncoding.Base64.Decode(lInStream, lOutStream);
        //lOutStream.Position := 0;

        qryExportar.SQL.Clear;
        qryExportar.SQL.Append(lInsert[I]);
        //qryExportar.Params.CreateParam(ftBlob, 'PIMAGEM', ptInput);
        //qryExportar.ParamByName('PIMAGEM').LoadFromStream(lOutStream, ftBlob);

        qryExportar.ExecSQL;
        lJObj.AddPair('ID', TConexaoDados.Connection.GetLastAutoGenValue('cardapios'));
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

function TSmServicos.UpdateCategorias: TJSONArray;
begin

end;

function TSmServicos.UpdateEstabelecimentos: TJSONArray;
var
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
  //Result := 'POST Delphi';
  lModulo := GetDataSnapWebModule;
  if lModulo.Request.Content.IsEmpty then
  begin
    GetInvocationMetadata().ResponseCode := 204;
    Abort;
  end;

  lJARequisicao := TJSONObject.ParseJSONValue(
    TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

  Result    := TJSONArray.Create;

  lJObj     := TJSONObject.Create;
  lInsert   := TStringList.Create;
  lFields   := TStringList.Create;
  lValues   := TStringList.Create;

  lLinha    := TStringBuilder.Create;
  lImagem64 := TStringList.Create;

  try
    qryExportar.Connection := TConexaoDados.Connection;
    for I := 0 to Pred(lJARequisicao.Count) do
    begin
      lSR := TStringReader.Create(lJARequisicao.Items[I].ToJSON);
      lJR := TJsonTextReader.Create(lSR);
      lLinha.Clear;
      lFields.Clear;
      lValues.Clear;
      lLinha.Append('INSERT INTO CURSO.ESTABELECIMENTOS(');
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
                lValues.Append(QuotedStr(FormatDateTime('dd.mm.yyyy',StrToDate(lJR.Value.ToString))))
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
          (*
          if LowerCase(lFields[j]) = 'foto_logotipo' then
          begin
            lImagem64.Add(lValues[j]);
            lValues[j] := ':PIMAGEM';
          end;
          *)

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
//        lInStream := TStringStream.Create(lImagem64[i]);
//        lInStream.Position := 0;
//        lOutStream := TMemoryStream.Create;
//        TNetEncoding.Base64.Decode(lInStream, lOutStream);
//        lOutStream.Position := 0;

        qryExportar.SQL.Clear;
        qryExportar.SQL.Append(lInsert[I]);
//        qryExportar.Params.CreateParam(ftBlob, 'PIMAGEM', ptInput);
//        qryExportar.ParamByName('PIMAGEM').LoadFromStream(lOutStream, ftBlob);

        qryExportar.ExecSQL;
        lJObj.AddPair('ID', TConexaoDados.Connection.GetLastAutoGenValue('estabelecimentos'));
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

function TSmServicos.UpdatePedidos: TJSONArray;
const
  INS_PEDIDO =
    'INSERT INTO CURSO.PEDIDOS   ' +
    '(                           ' +
    '   ID_USUARIO             , ' +
    '   ID_ESTABELECIMENTO     , ' +
    '   DATA                   , ' +
    '   STATUS                 , ' +
    '   VALOR_PEDIDO           , ' +
    '   ID_PEDIDO_MOBILE         ' +
    ')                           ' +
    'VALUES                      ' +
    '(                           ' +
    '   :ID_USUARIO            , ' +
    '   :ID_ESTABELECIMENTO    , ' +
    '   :DATA                  , ' +
    '   :STATUS                , ' +
    '   :VALOR_PEDIDO          , ' +
    '   :ID_PEDIDO_MOBILE        ' +
    ');                        ';

  INS_ITENS_PEDIDO =
    'INSERT INTO CURSO.ITENS_PEDIDO  ' +
    '(                               ' +
    '   ID_PEDIDO            ,       ' +
    '   QTDE                 ,       ' +
    '   VALOR_UNITARIO       ,       ' +
    '   ID_CARDAPIO          ,       ' +
    '   ID_PEDIDO_MOBILE             ' +
    ')                               ' +
    'VALUES                          ' +
    '(                               ' +
    '   :ID_PEDIDO           ,       ' +
    '   :QTDE                ,       ' +
    '   :VALOR_UNITARIO      ,       ' +
    '   :ID_CARDAPIO         ,       ' +
    '   :ID_PEDIDO_MOBILE            ' +
    ');                              ';

var
  lModulo               : TWebModule;
  lJARequisicao         : TJSONArray;
  LValores              : TJSONValue;
  jPedido               : TJSONValue;
  jItens                : TJSONValue;
  lJOBJ                 : TJSONObject;

  //Pedidos
  iId_Pedido_Mobile     : Integer;
  iId_Usuario           : Integer;
  iId_Estabelecimento   : Integer;
  dData                 : TDateTime;
  fValor_Pedido         : Double;

  //Itens pedido
  iQtde                 : Integer;
  fValor_Unitario       : Double;
  iId_Cardapio          : Integer;

  //Auxiliares
  I                     : Integer;
  J                     : Integer;
  arrItens              : Integer;
  iID_PedidoGerado      : Integer;
begin
  lModulo := GetDataSnapWebModule;
  if lModulo.Request.Content.IsEmpty then
  begin
    GetInvocationMetaData().ResponseCode := 204;
    Abort;
  end;

  lJARequisicao := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

  try
    qryExportar.Connection := TConexaoDados.Connection;

    TConexaoDados.Connection.TxOptions.AutoCommit := False;
    if not TConexaoDados.Connection.InTransaction  then
      TConexaoDados.Connection.StartTransaction;

    for LVAlores in lJARequisicao do
    begin
      jPedido := LValores.GetValue<TJSONArray>('pedido');
      for I := 0 to Pred((jPedido as TJSONArray).Count) do
      begin
        iId_Pedido_Mobile   := (jPedido as TJSONArray).Items[I].GetValue<integer>('id_pedido_mobile');
        iId_Usuario         := (jPedido as TJSONArray).Items[I].GetValue<integer>('id_usuario');
        iId_Estabelecimento := (jPedido as TJSONArray).Items[I].GetValue<integer>('id_estabelecimento');
        dData               := StrToDateTime((jPedido as TJSONArray).Items[I].GetValue<string>('data'));
        fValor_Pedido       := (jPedido as TJSONArray).Items[I].GetValue<double>('valor_pedido');

        //Update de Pedidos
        qryExportar.Active := False;
        qryExportar.SQL.Clear;
        qryExportar.SQL.Text := INS_PEDIDO;

        qryExportar.ParamByName('ID_USUARIO').AsInteger         := iId_Usuario;
        qryExportar.ParamByName('ID_ESTABELECIMENTO').AsInteger := iId_Estabelecimento;
        qryExportar.ParamByName('DATA').AsDateTime              := dData;
        qryExportar.ParamByName('STATUS').AsString              := 'E';
        qryExportar.ParamByName('VALOR_PEDIDO').AsFloat         := (FormatFloat('###,###,##0.00', fValor_Pedido)).ToDouble();
        qryExportar.ParamByName('ID_PEDIDO_MOBILE').AsInteger   := iId_Pedido_Mobile;

        qryExportar.ExecSQL;

        iID_PedidoGerado := TConexaoDados.Connection.GetLastAutoGenValue('ID');

        //Inclusão dos itens do pedido
        jItens   := (jPedido as TJSONArray).Items[I].GetValue<TJSONArray>('itens');
        arrItens := (jItens as TJSONArray).Count;

        qryExportar.Active := False;
        qryExportar.SQL.Clear;
        qryExportar.SQL.Text         := INS_ITENS_PEDIDO;
        qryExportar.Params.ArraySize := arrItens;

        for J := 0 to Pred((jItens as TJSONArray).Count) do
        begin
          iQtde           := (jItens as TJSONArray).Items[J].GetValue<integer>('qtde');
          fValor_Unitario := (FormatFloat('###,###,##0.00', (jItens as TJSONArray).Items[J].GetValue<double>('valor_unitario'))).ToDouble();
          iId_Cardapio    := (jItens as TJSONArray).Items[J].GetValue<integer>('id_cardapio');

          qryExportar.ParamByName('ID_PEDIDO').AsIntegers[J]        := iID_PedidoGerado;
          qryExportar.ParamByName('QTDE').AsIntegers[J]             := iQtde;
          qryExportar.ParamByName('VALOR_UNITARIO').AsFloats[J]     := fValor_Unitario;
          qryExportar.ParamByName('ID_CARDAPIO').AsIntegers[J]      := iId_Cardapio;
          qryExportar.ParamByName('ID_PEDIDO_MOBILE').AsIntegers[J] := iId_Pedido_Mobile;
        end;

        qryExportar.Execute(arrItens, 0);
      end;
    end;

    if TConexaoDados.Connection.InTransaction then
      TConexaoDados.Connection.CommitRetaining;

    TConexaoDados.Connection.TxOptions.AutoCommit := True;

    lJOBJ := TJSONObject.Create;
    lJOBJ.AddPair('Mensagem', 'Pedido enviado com sucesso!');

    Result := TJSONArray.Create;
    Result.AddElement(lJOBJ);

    GetInvocationMetaData().ResponseCode := 201;

    TUtils.FormatarJSON(GetInvocationMetadata().ResponseCode, Result.ToJSON());
  except on E:Exception do
    begin
      TConexaoDados.Connection.Rollback;
      raise;
    end;
  end;
end;

end.



