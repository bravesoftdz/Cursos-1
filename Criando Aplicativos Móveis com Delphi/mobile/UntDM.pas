unit UntDM;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.UITypes,
  System.JSON.Writers,
  System.JSON.Types,
  System.NetEncoding,
  System.JSON,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,

  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.DApt,


  Data.Bind.Components,
  Data.Bind.ObjectScope,
  Data.DB,


  IPPeerClient,
  REST.Client,

  FireDAC.Comp.Client,

  FMX.Dialogs,
  FMX.DialogService,

  UntLib;

type
  TDM = class(TDataModule)
    MemRestaurantes: TFDMemTable;
    MemRestaurantesid: TIntegerField;
    MemRestaurantesfantasia: TStringField;
    MemRestaurantesrazao_social: TStringField;
    MemCategorias: TFDMemTable;
    MemCategoriasid: TIntegerField;
    MemCategoriasdescricao: TStringField;
    MemCardapios: TFDMemTable;
    MemCardapiosid_estabelecimento: TIntegerField;
    MemCardapiosid_categoria: TIntegerField;
    MemCardapiosnome: TStringField;
    MemCardapiosingredientes: TStringField;
    MemCardapiospreco: TFloatField;
    MemRestaurantesfoto_logotipo: TBlobField;
    memUsuario: TFDMemTable;
    memUsuarioid: TIntegerField;
    memUsuarioid_endereco: TIntegerField;
    memUsuarionome_completo: TStringField;
    memUsuarionome_usuario: TStringField;
    memUsuarioemail: TStringField;
    memUsuariosenha: TStringField;
    memUsuariofoto: TBlobField;
    memUsuariocpfcnpj: TStringField;
    fdConn: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qryPedido: TFDQuery;
    qryItensPedido: TFDQuery;
    qryPedidoID: TFDAutoIncField;
    qryPedidoID_USUARIO: TIntegerField;
    qryPedidoID_ESTABELECIMENTO: TIntegerField;
    qryPedidoDATA: TDateTimeField;
    qryPedidoSTATUS: TStringField;
    qryPedidoVALOR_PEDIDO: TFloatField;
    qryItensPedidoID: TFDAutoIncField;
    qryItensPedidoID_PEDIDO: TIntegerField;
    qryItensPedidoQTDE: TIntegerField;
    qryItensPedidoVALOR_UNITARIO: TFloatField;
    qryItensPedidoID_CARDAPIO: TIntegerField;
    qryAuxiliar: TFDQuery;
    MemCardapiosid: TIntegerField;
    qryCarrinho: TFDQuery;
    qryCarrinhoID: TFDAutoIncField;
    qryCarrinhoID_USUARIO: TIntegerField;
    qryCarrinhoID_ESTABELECIMENTO: TIntegerField;
    qryCarrinhoDATA: TDateTimeField;
    qryCarrinhoSTATUS: TStringField;
    qryCarrinhoVALOR_PEDIDO: TFloatField;
    qryCarrinhoID_1: TIntegerField;
    qryCarrinhoID_PEDIDO: TIntegerField;
    qryCarrinhoQTDE: TIntegerField;
    qryCarrinhoVALOR_UNITARIO: TFloatField;
    qryCarrinhoID_CARDAPIO: TIntegerField;
    qryPedidoNOME: TStringField;
    qryItensPedidoNOME: TStringField;
    qryItensPedidoINGREDIENTES: TStringField;
    qryCarrinhoNOME: TStringField;
    qryCarrinhoNOME_1: TStringField;
    qryCarrinhoINGREDIENTES: TStringField;
    qryItensPedidoView: TFDQuery;
    qryItensPedidoViewNOME: TStringField;
    qryItensPedidoViewVALOR_UNITARIO: TFloatField;
    qryItensPedidoViewID_CARDAPIO: TIntegerField;
    qryItensPedidoViewID: TIntegerField;
    qryPedidosView: TFDQuery;
    qryPedidosViewID: TFDAutoIncField;
    qryPedidosViewID_USUARIO: TIntegerField;
    qryPedidosViewID_ESTABELECIMENTO: TIntegerField;
    qryPedidosViewDATA: TDateTimeField;
    qryPedidosViewSTATUS: TStringField;
    qryPedidosViewVALOR_PEDIDO: TFloatField;
    qryPedidosViewNOME: TStringField;
    qryItensPedidoViewQTDE: TLargeintField;
    qryItensPedidoSTATUS: TWideStringField;
    qryItensPedidoID_USUARIO: TLargeintField;
    qryItensPedidoViewID_USUARIO: TLargeintField;
    qryAuxiliar1: TFDQuery;
    procedure fdConnBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure qryCarrinhoNOME_ITEMGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  private
    { Private declarations }
    function  MaxID(const ATabela, ACampo: String): Integer;
    function  ItemDoMesmoEstabelecimento(AID_Estabelecimento: Integer): Boolean;
    function  CancelarPedido(AID_Pedido: Integer): Boolean;
    procedure AtualizarPedidoAtual;
    procedure NovoPedido;
    procedure AddItem_Pedido(const AID_Pedido: Integer; AQtde: Integer);
    procedure AtualizarValorTotal(const AID_Pedido: Integer);
  public
    { Public declarations }
    procedure AdicionarItem(const AQtde: Integer);
    procedure PedidoAberto;
    function  GerarJSONPedidoLocal: TJSONArray;
    function  GerarJSONAlteracoes(const AID_Usuario, AID_Pedido: Integer): TJSONArray;
    procedure AbrirPedidos;
    procedure AbrirItensPedido(const AID_PEDIDO: Integer);
  end;

var
  DM: TDM;

implementation

uses
  UntLibPedido;

procedure TDM.NovoPedido;
begin
  //Adicionar um novo Pedido
  //Adicionar os itens do pedido
  if not qryPedido.Active then
    qryPedido.Active := True;

  if not qryItensPedido.Active then
    qryItensPedido.Active := True;

  qryPedido.Filter   := EmptyStr;
  qryPedido.Filtered := False;

  qryPedido.Append;
  qryPedidoID_USUARIO.AsInteger         := TLibrary.ID;
  qryPedidoID_ESTABELECIMENTO.AsInteger := MemRestaurantesid.AsInteger;
  qryPedidoDATA.AsDateTime              := Now;
  qryPedidoSTATUS.AsString              := 'A';
  qryPedidoVALOR_PEDIDO.AsFloat         := 0.0;
  qryPedidoNOME.AsString                := MemRestaurantesfantasia.AsString;
  qryPedido.Post;

  TPedidoAtual.Status    := TStatusPedido.spAberto;
  TPedidoAtual.NumPedido := MaxID('PEDIDOS', 'ID');
end;

procedure TDM.PedidoAberto;
const
  _SQL =
    'SELECT                          ' +
    '  *                             ' +
    'FROM                            ' +
    '  PEDIDOS PE                    ' +
    '  INNER JOIN ITENS_PEDIDO IT    ' +
    '  ON IT.ID_PEDIDO = PE.ID       ' +
    'WHERE                           ' +
    '   PE.STATUS = ''A''            ';
begin
  qryCarrinho.Active := False;
  qryCarrinho.SQL.Clear;
  qryCarrinho.SQL.Add(_SQL);
  qryCarrinho.Active := True;
end;



procedure TDM.qryCarrinhoNOME_ITEMGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
end;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.AbrirPedidos;
const
  SELECT_PEDIDOS =
    'SELECT * FROM PEDIDOS                          ' +
    'WHERE                                          ' +
    '       STATUS IN ("A", "G", "E", "R", "P", "M")' +
    '  AND  ID_USUARIO = :PID_USUARIO               ';
begin
  qryPedidosView.Active := False;
  qryPedidosView.SQL.Clear;
  qryPedidosView.SQL.Text := SELECT_PEDIDOS;
  qryPedidosView.ParamByName('PID_USUARIO').AsInteger := TLibrary.ID;
  qryPedidosView.Active := True;
end;

procedure TDM.AbrirItensPedido(const AID_PEDIDO: Integer);
const
  SELECT_ITENS =
    'SELECT                                ' +
    '  DISTINCT                            ' +
    '    IT.NOME,                          ' +
    '    IT.VALOR_UNITARIO,                ' +
    '    IT.ID_CARDAPIO,                   ' +
    '    IT.ID_USUARIO,                    ' +
    '    PE.ID,                            ' +
    '    SUM(IT.QTDE) AS "QTDE::BIGINT"    ' +
    'FROM                                  ' +
    '  ITENS_PEDIDO IT                     ' +
    '  INNER JOIN PEDIDOS PE               ' +
    '  ON IT.ID_PEDIDO = PE.ID             ' +
    'WHERE                                 ' +
    '      IT.ID_PEDIDO  = :PID_PEDIDO     ' +
    '  AND PE.ID_USUARIO = :PID_USUARIO    ' +
    '  AND IT.STATUS     <> "X"            ' +
    'GROUP BY                              ' +
    '    IT.NOME,                          ' +
    '    IT.VALOR_UNITARIO,                ' +
    '    IT.ID_CARDAPIO,                   ' +
    '    IT.ID_USUARIO,                    ' +
    '    PE.ID                             ';
begin
  qryItensPedidoView.Active := False;
  qryItensPedidoView.SQL.Clear;
  qryItensPedidoView.SQL.Text := SELECT_ITENS;
  qryItensPedidoView.ParamByName('PID_PEDIDO').AsInteger  := AID_PEDIDO;
  qryItensPedidoView.ParamByName('PID_USUARIO').AsInteger := TLibrary.ID;
  qryItensPedidoView.Active := True;
end;

procedure TDM.AddItem_Pedido(const AID_Pedido: Integer; AQtde: Integer);
var
  I : Integer;
begin
  qryItensPedido.Filter   := EmptyStr;
  qryItensPedido.Filtered := False;

  if not qryItensPedido.Active then
    qryItensPedido.Active := True;

  for I := 1 to AQtde do
  begin
    qryItensPedido.Append;
    qryItensPedidoID_PEDIDO.AsInteger    := AID_Pedido;
    qryItensPedidoQTDE.AsInteger         := 1;
    qryItensPedidoVALOR_UNITARIO.AsFloat := MemCardapiospreco.AsFloat;
    qryItensPedidoID_CARDAPIO.AsInteger  := MemCardapiosid.AsInteger;
    qryItensPedidoNOME.AsString          := MemCardapiosnome.AsString;
    qryItensPedidoINGREDIENTES.AsString  := MemCardapiosingredientes.AsString;
    qryItensPedido.Post;
  end;
end;
procedure TDM.AtualizarValorTotal(const AID_Pedido: Integer);
const
  _SELECT =
    'SELECT SUM(VALOR_UNITARIO) AS TOTAL  ' +
    'FROM ITENS_PEDIDO                    ' +
    'WHERE ID_PEDIDO = :PID_PEDIDO        ' +
    'GROUP BY ID_PEDIDO                   ';
  _SQLAbertura = 'SELECT * FROM PEDIDOS WHERE ID = :PID';
begin
  qryAuxiliar.Active := False;
  qryAuxiliar.SQL.Clear;
  qryAuxiliar.SQL.Text := _SELECT;
  qryAuxiliar.ParamByName('PID_PEDIDO').AsInteger := AID_Pedido;
  qryAuxiliar.Active := True;

  if not qryPedido.Active then
  begin
    qryPedido.SQL.Text := _SQLAbertura;
    qryPedido.ParamByName('PID').AsInteger := AID_Pedido;
    qryPedido.Active := True;
  end;

  qryPedido.Locate('ID', AID_Pedido, []);

  qryPedido.Edit;
  qryPedido.FieldByName('VALOR_PEDIDO').AsFloat :=
    qryAuxiliar.FieldByName('TOTAL').AsFloat;
  qryPedido.Post;
end;

procedure TDM.AdicionarItem(const AQtde: Integer);
begin
  if TPedidoAtual.ExistePedidoAberto then
  begin
    if ItemDoMesmoEstabelecimento(MemRestaurantesID.AsInteger) then
    begin
      //Adicionar Item
      AddItem_Pedido(TPedidoAtual.NumPedido, AQtde);
      AtualizarValorTotal(TPedidoAtual.NumPedido);
      ShowMessage('Adicionou ao pedido!');
    end
    else
    begin
      TDialogService.MessageDialog(
        'Este item pertence a outro estabelecimento. ' +
        'Para adicionar este item, cancele o pedido atual.' + #13#10 +
        'Deseja cancelar este pedido?',
        System.UITypes.TMsgDlgType.mtConfirmation,
        [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo],
        System.UITypes.TMsgDlgBtn.mbNo,
        0,
        //Procedure Anônima
        procedure (const AResult : TModalResult)
        var
          iPedido : Integer;
        begin
          case AResult of
            mrYes :
              begin
                iPedido := TPedidoAtual.NumPedido;
                CancelarPedido(iPedido);
                NovoPedido;
                AddItem_Pedido(iPedido, AQtde);
                //Atualizar o valor do pedido
                AtualizarValorTotal(iPedido);
                ShowMessage('Adicionou ao pedido!');
              end;
            mrNo :
              begin
                //
                Exit;
              end;
          end;
        end
        );
    end;
  end
  else
  begin
    NovoPedido;
    AddItem_Pedido(TPedidoAtual.NumPedido, AQtde);
    //Atualizar o valor do pedido
    AtualizarValorTotal(TPedidoAtual.NumPedido);
    ShowMessage('Adicionou ao pedido!');
  end;
end;

function TDM.CancelarPedido(AID_Pedido: Integer): Boolean;
const
  _DEL_ITENS  = 'DELETE FROM ITENS_PEDIDO WHERE ID_PEDIDO = :PID_PEDIDO';
  _DEL_PEDIDO = 'DELETE FROM PEDIDOS WHERE ID = :PID';
var
  iIDPedido : Integer;
begin
  Result := False;
  try
    //Abrir transação

    //Excluir itens
    qryAuxiliar.Active := False;
    qryAuxiliar.SQL.Clear;
    qryAuxiliar.SQL.Text := _DEL_ITENS;
    qryAuxiliar.ParamByName('PID_PEDIDO').AsInteger := AID_Pedido;
    qryAuxiliar.ExecSQL;

    //Excluir Pedido
    qryAuxiliar.Active := False;
    qryAuxiliar.SQL.Clear;
    qryAuxiliar.SQL.Text := _DEL_PEDIDO;
    qryAuxiliar.ParamByName('PID').AsInteger := AID_Pedido;
    qryAuxiliar.ExecSQL;

    Result := True;
    //Commit
  except on E:Exception do
    begin
      //Rollback
    end;
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  AtualizarPedidoAtual;
end;

procedure TDM.fdConnBeforeConnect(Sender: TObject);
begin
  fdConn.Params.Values['OpenMode'] := 'ReadWrite';
  {$IFDEF MSWINDOWS}
    fdConn.Params.Values['Database'] := '$(CURSO_MOBILE)';
  {$ELSE}
    fdConn.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'RestaurantesMoveis.sqlite');
  {$ENDIF}
end;


function TDM.GerarJSONAlteracoes(const AID_Usuario, AID_Pedido: Integer): TJSONArray;
const
  _SELECT =
    'SELECT                             ' +
    '  PE.ID,                           ' +
    '  PE.ID_USUARIO,                   ' +
    '  PE.ID_ESTABELECIMENTO,           ' +
    '  PE.DATA,                         ' +
    '  PE.STATUS AS STATUS_PEDIDO,      ' +
    '  PE.VALOR_PEDIDO,                 ' +
    '  IT.ID AS ID_ITEM_MOBILE,         ' +
    '  IT.QTDE,                         ' +
    '  IT.VALOR_UNITARIO,               ' +
    '  IT.ID_CARDAPIO,                  ' +
    '  IT.NOME,                         ' +
    '  IT.INGREDIENTES,                 ' +
    '  IT.STATUS AS STATUS_ITEM         ' +
    'FROM                               ' +
    '  PEDIDOS PE                       ' +
    '  INNER JOIN ITENS_PEDIDO IT       ' +
    '  ON IT.ID_PEDIDO = PE.ID          ' +
    'WHERE                              ' +
    '      PE.ID_USUARIO = :PID_USUARIO ' +
    '  AND PE.ID         = :PID_PEDIDO  ';

var
  StrAux  : TStringWriter;
  TxtJSON : TJSONTextWriter;
  ljObj   : TJSONObject;
  I       : Integer;
begin
  Result := TJSONArray.Create;

  StrAux  := TStringWriter.Create;
  TxtJSON := TJsonTextWriter.Create(StrAux);
  TxtJSON.Formatting := TJsonFormatting.Indented;

  qryAuxiliar.Active := False;
  qryAuxiliar.SQL.Clear;
  qryAuxiliar.SQL.Text := _SELECT;
  qryAuxiliar.ParamByName('PID_USUARIO').AsInteger := AID_Usuario;
  qryAuxiliar.ParamByName('PID_PEDIDO').AsInteger  := AID_Pedido;
  qryAuxiliar.Active := True;

  qryAuxiliar.First;

  //Cabeçalho do Pedido
  TxtJSON.WriteStartObject; //Objeto Global
  TxtJSON.WritePropertyName('pedido');
  TxtJSON.WriteStartArray;//Array Pedido

  TxtJSON.WriteStartObject;
  TxtJSON.WritePropertyName('id_pedido_mobile');
  TxtJSON.WriteValue(qryAuxiliar.FieldByName('ID').AsInteger);

  TxtJSON.WritePropertyName('id_usuario');
  TxtJSON.WriteValue(qryAuxiliar.FieldByName('ID_USUARIO').AsInteger);

  TxtJSON.WritePropertyName('id_estabelecimento');
  TxtJSON.WriteValue(qryAuxiliar.FieldByName('ID_ESTABELECIMENTO').AsInteger);

  TxtJSON.WritePropertyName('data');
  TxtJSON.WriteValue(FormatDateTime('DD/MM/YYYY', qryAuxiliar.FieldByName('DATA').AsDateTime));

  TxtJSON.WritePropertyName('valor_pedido');
  TxtJSON.WriteValue(qryAuxiliar.FieldByName('VALOR_PEDIDO').AsFloat);

  TxtJSON.WritePropertyName('status_pedido');
  TxtJSON.WriteValue(qryAuxiliar.FieldByName('STATUS_PEDIDO').AsString);

  //Itens
  TxtJSON.WritePropertyName('itens');
  TxtJSON.WriteStartArray; //Array Itens

  while not qryAuxiliar.Eof do
  begin
    TxtJSON.WriteStartObject; //Objeto Item

    TxtJSON.WritePropertyName('qtde');
    TxtJSON.WriteValue(qryAuxiliar.FieldByName('qtde').AsInteger);

    TxtJSON.WritePropertyName('valor_unitario');
    TxtJSON.WriteValue(qryAuxiliar.FieldByName('valor_unitario').AsFloat);

    TxtJSON.WritePropertyName('id_cardapio');
    TxtJSON.WriteValue(qryAuxiliar.FieldByName('ID_CARDAPIO').AsInteger);

    TxtJSON.WritePropertyName('status_item');
    TxtJSON.WriteValue(qryAuxiliar.FieldByName('status_item').AsString);

    TxtJSON.WritePropertyName('id_item_pedido_mobile');
    TxtJSON.WriteValue(qryAuxiliar.FieldByName('id_item_mobile').AsInteger);

    qryAuxiliar.Next;
    TxtJSON.WriteEndObject; //Objeto item
  end;

  TxtJSON.WriteEndArray;  //Array Itens


  TxtJSON.WriteEndObject; //Objeto Pedido

  TxtJSON.WriteEndArray;  //Array Pedido / Itens
  TxtJSON.WriteEndObject; //Objeto Global

  ljObj   := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(StrAux.ToString), 0) as TJSONObject;

  Result.AddElement(ljObj);
end;

function TDM.GerarJSONPedidoLocal: TJSONArray;
var
  StrAux  : TStringWriter;
  TxtJSON : TJSONTextWriter;
  ljObj   : TJSONObject;
  I       : Integer;
begin
  Result := TJSONArray.Create;

  StrAux  := TStringWriter.Create;
  TxtJSON := TJsonTextWriter.Create(StrAux);
  TxtJSON.Formatting := TJsonFormatting.Indented;

  qryCarrinho.First;

  //Cabeçalho do Pedido
  TxtJSON.WriteStartObject; //Objeto Global
  TxtJSON.WritePropertyName('pedido');
  TxtJSON.WriteStartArray;//Array Pedido

  TxtJSON.WriteStartObject;
  TxtJSON.WritePropertyName('id_pedido_mobile');
  TxtJSON.WriteValue(qryCarrinhoID.AsInteger);

  TxtJSON.WritePropertyName('id_usuario');
  TxtJSON.WriteValue(qryCarrinhoID_USUARIO.AsInteger);

  TxtJSON.WritePropertyName('id_estabelecimento');
  TxtJSON.WriteValue(qryCarrinhoID_ESTABELECIMENTO.AsInteger);

  TxtJSON.WritePropertyName('data');
  TxtJSON.WriteValue(FormatDateTime('DD/MM/YYYY', qryCarrinhoDATA.AsDateTime));

  TxtJSON.WritePropertyName('valor_pedido');
  TxtJSON.WriteValue(qryCarrinhoVALOR_PEDIDO.AsFloat);

  //Itens
  TxtJSON.WritePropertyName('itens');
  TxtJSON.WriteStartArray; //Array Itens

  while not qryCarrinho.Eof do
  begin
    TxtJSON.WriteStartObject; //Objeto Item

    TxtJSON.WritePropertyName('qtde');
    TxtJSON.WriteValue(qryCarrinhoQTDE.AsInteger);

    TxtJSON.WritePropertyName('valor_unitario');
    TxtJSON.WriteValue(qryCarrinhoVALOR_UNITARIO.AsFloat);

    TxtJSON.WritePropertyName('id_cardapio');
    TxtJSON.WriteValue(qryCarrinhoID_CARDAPIO.AsInteger);

    qryCarrinho.Next;
    TxtJSON.WriteEndObject; //Objeto item
  end;

  TxtJSON.WriteEndArray;  //Array Itens

  TxtJSON.WriteEndObject; //Objeto Pedido

  TxtJSON.WriteEndArray;  //Array Pedido / Itens
  TxtJSON.WriteEndObject; //Objeto Global

  ljObj   := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(StrAux.ToString), 0) as TJSONObject;

  Result.AddElement(ljObj);
end;

procedure TDM.AtualizarPedidoAtual;
const
  _SELECT = 'SELECT ID, STATUS FROM PEDIDOS WHERE STATUS = ''A''';
begin
  qryAuxiliar.Active := False;
  qryAuxiliar.SQL.Clear;
  qryAuxiliar.SQL.Text := _SELECT;
  qryAuxiliar.Active := True;

  if not qryAuxiliar.IsEmpty then
  begin
    TPedidoAtual.NumPedido := qryAuxiliar.FieldByName('ID').AsInteger;
    TPedidoAtual.Status    := TStatusPedido.spAberto;
  end
  else
  begin
    TPedidoAtual.Status    := TStatusPedido.spNenhum;
  end;
end;

function TDM.ItemDoMesmoEstabelecimento(AID_Estabelecimento: Integer): Boolean;
const
  _SELECT = 'SELECT * FROM PEDIDOS WHERE STATUS = ''A'' AND ID_ESTABELECIMENTO = :PID_ESTABELECIMENTO';
begin
  qryAuxiliar.Active := False;
  qryAuxiliar.SQL.Clear;
  qryAuxiliar.SQL.Text := _SELECT;
  qryAuxiliar.ParamByName('PID_ESTABELECIMENTO').AsInteger := AID_Estabelecimento;
  qryAuxiliar.Active := True;

  Result := not (qryAuxiliar.IsEmpty);
end;

function TDM.MaxID(const ATabela, ACampo: String): Integer;
const
  _SELECT = 'SELECT MAX(%s) AS MAXIMO FROM %s';
begin
  qryAuxiliar.Active := False;
  qryAuxiliar.SQL.Clear;
  qryAuxiliar.SQL.Text := Format(_SELECT, [ACampo, ATabela]);
  qryAuxiliar.Active := True;

  Result := qryAuxiliar.FieldByName('MAXIMO').AsInteger;
end;

end.


