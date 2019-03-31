unit UntPedidos;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
  System.Bindings.Outputs,

  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Layouts,
  FMX.Effects,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  Fmx.Bind.Editors,
  Fmx.Bind.DBEngExt,
  FMX.Edit,
  FMX.Gestures,
  FMX.DialogService,

  ksTabControl,

  MultiDetailAppearanceU,

  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,

  UntDM,
  UntLib,
  UntLayoutBase,
  UntDMRest,

  TiposComuns,
  Util.Mensageria;

type
  TfPedidos = class(TFrmLayoutBase)
    tbctrlMain: TksTabControl;
    tbitemPedidos: TksTabItem;
    tbitemItens: TksTabItem;
    toolTop: TToolBar;
    Label1: TLabel;
    btnMenu: TButton;
    ShadowEffect1: TShadowEffect;
    ToolBar1: TToolBar;
    Label2: TLabel;
    Button1: TButton;
    ShadowEffect2: TShadowEffect;
    lstviewPedidos: TListView;
    lstviewItens: TListView;
    BindingsList1: TBindingsList;
    rctPopUpItens: TRectangle;
    lytPopUpItens: TLayout;
    btnConfQtdItem: TButton;
    lytBtnsAddRem: TLayout;
    btnMenos: TButton;
    btnMais: TButton;
    edtQtde: TEdit;
    LinkListControlToField1: TLinkListControlToField;
    bindPedidos: TBindSourceDB;
    bindItens: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    gmGestos: TGestureManager;
    procedure FormCreate(Sender: TObject);
    procedure lstviewPedidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Button1Click(Sender: TObject);
    procedure lstviewItensGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lstviewItensDblClick(Sender: TObject);
    procedure btnMaisClick(Sender: TObject);
    procedure btnMenosClick(Sender: TObject);
    procedure btnConfQtdItemClick(Sender: TObject);
    procedure lstviewPedidosGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lstviewPedidosDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure MostrarPopupQtde;
    procedure OcultarPopupQtde(Sender: TObject);
    procedure AdicionarItem(const AQtdeItens : Integer);
    procedure ExcluirItem(const AID_Cardapio: Integer; const QtdeNova: Integer);
    procedure CancelarPedido;
    function  ValidarAlteracao(const APedido: Integer): Boolean;
    procedure ProcessarCancelarPedido(const AResult: TModalResult);
  public
    { Public declarations }
  end;

var
  fPedidos: TfPedidos;

implementation

uses
  Data.DB, System.JSON;

{$R *.fmx}

procedure TfPedidos.CancelarPedido;
const
  _UPDATE =
    'UPDATE PEDIDOS SET              ' +
    '  STATUS = "C"                  ' +
    'WHERE                           ' +
    '      ID         = :PID_PEDIDO  ' +
    '  AND ID_USUARIO = :PID_USUARIO ';
begin
  try
    DM.fdConn.TxOptions.AutoCommit := False;

    if not DM.fdConn.InTransaction then
      DM.fdConn.StartTransaction;

    DM.qryAuxiliar.Active := False;
    DM.qryAuxiliar.SQL.Clear;
    DM.qryAuxiliar.SQL.Text := _UPDATE;
    DM.qryAuxiliar.Params.ArraySize := 1;
    DM.qryAuxiliar.ParamByName('PID_PEDIDO').AsIntegers[0]  := DM.qryPedidosViewID.AsInteger;
    DM.qryAuxiliar.ParamByName('PID_USUARIO').AsIntegers[0] := TLibrary.ID;
    DM.qryAuxiliar.Execute(1, 0);

    //Verificar no servidor se o o Pedido já foi marcado como Preparação ou Motoboy
    //Se pudermos efetuar a transação, commit, caso contrário rollback

    ValidarAlteracao(DM.qryPedidosViewID.AsInteger);

    if DM.fdConn.InTransaction then
      DM.fdConn.Commit;

    DM.fdConn.TxOptions.AutoCommit := True;
  except
    on E: Exception do
    begin
      DM.fdConn.Rollback;
      TMensageria.Mensagem(E.Message, tmiErro);
    end;
  end;
end;

function TfPedidos.ValidarAlteracao(const APedido: Integer): Boolean;
var
  lJSON : TJSONArray;
begin
  try
    //Gera o JSON para envio ao servidor
    lJSON := DM.GerarJSONAlteracoes(TLibrary.ID, APedido);
    if DmREST.EnviarAlteracaoPedido(lJSON, TLibrary.ID, APedido) then
    begin
      TMensageria.Mensagem('Pedido alterado com sucesso!', tmiInformacao);
    end
    else
    begin
      raise Exception.Create('Esse pedido não pôde ser alterado. Contate o estabelecimento!');
    end;
  except on E:Exception do
    begin
      raise;
    end;
  end;
end;

procedure TfPedidos.AdicionarItem(const AQtdeItens : Integer);
const
  _INSERT =
    ' INSERT INTO ITENS_PEDIDO ' +
    '(                         ' +
    '  ID_PEDIDO         ,     ' +
    '  QTDE              ,     ' +
    '  VALOR_UNITARIO    ,     ' +
    '  ID_CARDAPIO       ,     ' +
    '  NOME              ,     ' +
    '  INGREDIENTES      ,     ' +
    '  STATUS            ,     ' +
    '  ID_USUARIO              ' +
    ')                         ' +
    'VALUES                    ' +
    '(                         ' +
    '  :PID_PEDIDO       ,     ' +
    '  :PQTDE            ,     ' +
    '  :PVALOR_UNITARIO  ,     ' +
    '  :PID_CARDAPIO     ,     ' +
    '  :PNOME            ,     ' +
    '  :PINGREDIENTES    ,     ' +
    '  :PSTATUS          ,     ' +
    '  :PID_USUARIO            ' +
    ')                         ';

  _SELECT_TEM =
    'SELECT * FROM ITENS_PEDIDO        ' +
    'WHERE                             ' +
    '      ID_PEDIDO   = :PID_PEDIDO   ' +
    '  AND ID_CARDAPIO = :PID_CARDAPIO ' +
    '  AND ID_USUARIO  = :PID_USUARIO  ' +
    'LIMIT 1                           ';
var
  I         : Integer;
  ArraySize : Integer;
begin
  try
    try
      DM.fdConn.TxOptions.AutoCommit := False;
      if not DM.fdConn.InTransaction then
        DM.fdConn.StartTransaction;

      ArraySize := AQtdeItens;

      //Filtra somente os dados necessários
      DM.qryAuxiliar1.Active   := False;
      DM.qryAuxiliar1.SQL.Clear;
      DM.qryAuxiliar1.SQL.Text := _SELECT_TEM;
      DM.qryAuxiliar1.ParamByName('PID_CARDAPIO').AsInteger := DM.qryItensPedidoViewID_CARDAPIO.AsInteger;
      DM.qryAuxiliar1.ParamByName('PID_PEDIDO').AsInteger   := DM.qryPedidosViewID.AsInteger;
      DM.qryAuxiliar1.ParamByName('PID_USUARIO').AsInteger  := TLibrary.ID;
      DM.qryAuxiliar1.Active   := True;

      DM.qryAuxiliar.Active   := False;
      DM.qryAuxiliar.SQL.Clear;
      DM.qryAuxiliar.SQL.Text := _INSERT;

      for I := 1 to AQtdeItens do
      begin
        DM.qryAuxiliar.ParamByName('PID_PEDIDO').AsIntegers[I-1]    := DM.qryAuxiliar1.FieldByName('ID_PEDIDO').AsInteger;
        DM.qryAuxiliar.ParamByName('PQTDE').AsIntegers[I-1]         := 1;
        DM.qryAuxiliar.ParamByName('PVALOR_UNITARIO').AsFloats[I-1] := DM.qryAuxiliar1.FieldByName('VALOR_UNITARIO').AsFloat;
        DM.qryAuxiliar.ParamByName('PID_CARDAPIO').AsIntegers[I-1]  := DM.qryAuxiliar1.FieldByName('ID_CARDAPIO').AsInteger;
        DM.qryAuxiliar.ParamByName('PNOME').AsStrings[I-1]          := DM.qryAuxiliar1.FieldByName('NOME').AsString;
        DM.qryAuxiliar.ParamByName('PINGREDIENTES').AsStrings[I-1]  := DM.qryAuxiliar1.FieldByName('INGREDIENTES').AsString;
        DM.qryAuxiliar.ParamByName('PSTATUS').AsStrings[I-1]        := 'E';
        DM.qryAuxiliar.ParamByName('PID_USUARIO').AsIntegers[I-1]   := TLibrary.ID;
      end;

      DM.qryAuxiliar.Execute(ArraySize, 0);

      //Verificar no servidor DataSnap se podemos efetuar as alterações
      //Se pudermos fazer a alteração, então alteramos no servidor e
      //Comitamos no mobile

      ValidarAlteracao(DM.qryPedidosViewID.AsInteger);

      if DM.fdConn.InTransaction then
        DM.fdConn.Commit;

      DM.fdConn.TxOptions.AutoCommit := True;
    except on E:Exception do
      begin
        DM.fdConn.Rollback;
        ShowMessage(E.Message);
      end;
    end;
  finally
    DM.qryAuxiliar.Active := False;
    DM.qryAuxiliar1.Active := False;
  end;
end;

procedure TfPedidos.btnConfQtdItemClick(Sender: TObject);
var
  QtdeAlterada : Integer;
  QtdeAtual    : Integer;
begin
  inherited;
  QtdeAlterada := edtQtde.Text.ToInteger();
  QtdeAtual    := DM.qryItensPedidoViewQTDE.AsInteger;

  if QtdeAlterada = QtdeAtual then
  begin
    OcultarPopupQtde(Sender);
    exit;
  end
  else
    TDialogService.MessageDialog(
        'Deseja realmente modificar a quantidade?',
        System.UITypes.TMsgDlgType.mtConfirmation,
        [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo],
        System.UITypes.TMsgDlgBtn.mbYes, 0,

        procedure (const AResult: TModalResult)
        begin
          case AResult of
            mrYes:
              begin
                if QtdeAlterada < QtdeAtual then
                begin
                  //MessageDlg
                  ExcluirItem(DM.qryItensPedidoViewID_CARDAPIO.AsInteger, QtdeAtual - QtdeAlterada);
                  OcultarPopupQtde(Sender);
                end
                else if QtdeAlterada > QtdeAtual then
                begin
                  AdicionarItem(QtdeAlterada - QtdeAtual);
                  OcultarPopupQtde(Sender);
                end;
              end;
          end;
        end
      );
end;

procedure TfPedidos.btnMaisClick(Sender: TObject);
var
  Qtde : Integer;
begin
  inherited;
  try
    Qtde := edtQtde.Text.ToInteger();
    Inc(Qtde);
    edtQtde.Text := Qtde.ToString;
  except on E:Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfPedidos.btnMenosClick(Sender: TObject);
var
  Qtde : Integer;
begin
  inherited;
  try
    Qtde := edtQtde.Text.ToInteger();

    if Qtde <= 0
    then Qtde := 0
    else Dec(Qtde);

    edtQtde.Text := Qtde.ToString;
  except on E:Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfPedidos.Button1Click(Sender: TObject);
begin
  inherited;
  TLibrary.MudarAba(tbctrlMain, tbitemPedidos);
end;

procedure TfPedidos.ExcluirItem(const AID_Cardapio, QtdeNova: Integer);
const
  _SELECT_TEM =
    'SELECT * FROM ITENS_PEDIDO        ' +
    'WHERE                             ' +
    '      ID_PEDIDO   = :PID_PEDIDO   ' +
    '  AND ID_CARDAPIO = :PID_CARDAPIO ' +
    '  AND ID_USUARIO  = :PID_USUARIO  ' +
    'LIMIT :PLIMIT                     ';

  _UPDATE =
    'UPDATE ITENS_PEDIDO SET           ' +
    '  STATUS = "X"                    ' +
    'WHERE                             ' +
    '      ID_CARDAPIO = :PID_CARDAPIO ' +
    '  AND ID_PEDIDO   = :PID_PEDIDO   ' +
    '  AND ID_USUARIO  = :PID_USUARIO  ';

var
  I : Integer;
begin
  try
    try
      DM.fdConn.TxOptions.AutoCommit := False;
      if not DM.fdConn.InTransaction then
        DM.fdConn.StartTransaction;

      if QtdeNova > 0 then
      begin
        //Filtra somente os dados necessários
        DM.qryAuxiliar1.Active   := False;
        DM.qryAuxiliar1.SQL.Clear;
        DM.qryAuxiliar1.SQL.Text := _SELECT_TEM;
        DM.qryAuxiliar1.ParamByName('PID_CARDAPIO').AsInteger := AID_Cardapio;
        DM.qryAuxiliar1.ParamByName('PID_PEDIDO').AsInteger   := DM.qryPedidosViewID.AsInteger;
        DM.qryAuxiliar1.ParamByName('PID_USUARIO').AsInteger  := TLibrary.ID;
        DM.qryAuxiliar1.ParamByName('PLIMIT').AsInteger       := QtdeNova;
        DM.qryAuxiliar1.Active   := True;
        DM.qryAuxiliar1.First;
      end;

      DM.qryAuxiliar.Active := False;
      DM.qryAuxiliar.SQL.Clear;
      DM.qryAuxiliar.SQL.Text := _UPDATE;
      if QtdeNova > 0 then
      begin
        DM.qryAuxiliar.SQL.Add('  AND ID = :PID_ITEM ');
        DM.qryAuxiliar.Params.CreateParam(ftInteger, 'PID_ITEM', ptInput);
      end;

      DM.qryAuxiliar.Params.ArraySize := QtdeNova;
      for I := 1 to QtdeNova do
      begin
        DM.qryAuxiliar.ParamByName('PID_CARDAPIO').AsIntegers[I-1] := AID_Cardapio;
        DM.qryAuxiliar.ParamByName('PID_PEDIDO').AsIntegers[I-1]   := DM.qryPedidosViewID.AsInteger;
        DM.qryAuxiliar.ParamByName('PID_USUARIO').AsIntegers[I-1]  := TLibrary.ID;
        if QtdeNova > 0 then
        begin
          DM.qryAuxiliar.ParamByName('PID_ITEM').AsIntegers[I-1]   := DM.qryAuxiliar1.FieldByName('ID').AsInteger;
          DM.qryAuxiliar1.Next;
        end;
      end;

      DM.qryAuxiliar.Execute(QtdeNova, 0);

      //Verificar no servidor DataSnap se podemos efetuar as alterações
      //Se pudermos fazer a alteração, então alteramos no servidor e
      //Comitamos no mobile

      ValidarAlteracao(DM.qryPedidosViewID.AsInteger);

      if DM.fdConn.InTransaction then
        DM.fdConn.Commit;

      DM.fdConn.TxOptions.AutoCommit := True;
    except on E:Exception do
      begin
        DM.fdConn.Rollback;
        ShowMessage(E.Message);
      end;
    end;
  finally
    DM.qryAuxiliar.Active := False;
    DM.qryAuxiliar1.Active := False;
  end;
end;

procedure TfPedidos.FormCreate(Sender: TObject);
begin
  inherited;
  TBackground.Ocultar;
  OcultarPopupQtde(Sender);
  tbctrlMain.TabPosition := TksTabBarPosition.ksTbpNone;
  tbctrlMain.ActiveTab   := tbitemPedidos;

  DM.AbrirPedidos;
end;

procedure TfPedidos.lstviewItensDblClick(Sender: TObject);
begin
  inherited;
  edtQtde.Text := DM.qryItensPedidoViewQTDE.AsInteger.ToString;
  MostrarPopupQtde;
end;

procedure TfPedidos.lstviewItensGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  inherited;
  if EventInfo.GestureID = igiLongTap then
  begin
    edtQtde.Text := DM.qryItensPedidoViewQTDE.AsInteger.ToString;
    MostrarPopupQtde;
    Handled := False;
  end;
end;

procedure TfPedidos.lstviewPedidosDblClick(Sender: TObject);
begin
  inherited;
  if DM.qryPedidosViewSTATUS.AsString[1] in ['E', 'A', 'G'] then
  begin
    TMensageria.Mensagem('Essa ação cancela o pedido atual. Deseja efetuar o cancelamento?',
      tmiConfirmacao, ProcessarCancelarPedido);
  end
  else
  begin
    TMensageria.Mensagem('Esse pedido não pode ser cancelado!', tmiAviso);
  end;
end;

procedure TfPedidos.ProcessarCancelarPedido(const AResult: TModalResult);
begin
  case AResult of
    mrYES:
      begin
        CancelarPedido;
      end;
  end;
end;

procedure TfPedidos.lstviewPedidosGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  inherited;
  if EventInfo.GestureID = igiLongTap then
  begin
    if DM.qryPedidosViewSTATUS.AsString[1] in ['E', 'A', 'G'] then
    begin
      TDialogService.MessageDialog('Essa ação cancela o pedido atual. Deseja efetuar o cancelamento?',
        System.UITypes.TMsgDlgType.mtInformation,
        [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo],
        System.UITypes.TMsgDlgBtn.mbYes, 0,

        procedure(const AResult: TModalResult)
        begin
          case AResult of
            mrYES:
              begin
                CancelarPedido;
              end;
          end;
        end);
    end
    else
    begin
      ShowMessage('Esse pedido não pode ser cancelado!');
    end;
    Handled := False;
  end;
end;

procedure TfPedidos.lstviewPedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  inherited;
  DM.AbrirItensPedido(DM.qryPedidosViewID.AsInteger);
  TLibrary.MudarAba(tbctrlMain, tbitemItens);
end;

procedure TfPedidos.MostrarPopupQtde;
begin
  TBackground.Mostrar(rctClient, OcultarPopupQtde);
  rctPopUpItens.Position.X := (Self.Width / 2) - (rctPopUpItens.Width / 2);
  rctPopUpItens.Position.Y := 70;
  rctPopUpItens.Visible := True;
  rctPopUpItens.AnimateFloat('OPACITY', 1);
  rctPopUpItens.BringToFront;
end;

procedure TfPedidos.OcultarPopupQtde(Sender: TObject);
begin
  rctPopUpItens.AnimateFloat('OPACITY', 0);
  rctPopUpItens.Visible := False;
  TBackground.Ocultar;
end;

end.
