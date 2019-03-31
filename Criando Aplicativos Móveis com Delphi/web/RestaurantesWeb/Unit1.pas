unit Unit1;

interface

uses
  Classes,
  SysUtils,

  IWAppForm,
  IWApplication,
  IWColor,
  IWTypes,
  IWCompButton,
  IWVCLBaseControl,
  IWBaseControl,
  IWBaseHTMLControl,
  IWControl,
  IWCompEdit,
  IWDBStdCtrls,
  IWCompGrids,
  IWDBGrids,
  IWCompExtCtrls,
  IWDBExtCtrls,

  Data.DB,
  Vcl.Controls, IWCompLabel, IWCompListbox;

type
  TIWForm1 = class(TIWAppForm)
    IWDBEdit1: TIWDBEdit;
    dtsCategorias: TDataSource;
    IWButton1: TIWButton;
    IWDBGrid1: TIWDBGrid;
    edtEstabelecimento: TIWEdit;
    IWLabel1: TIWLabel;
    edtUsuario: TIWEdit;
    edtSenha: TIWEdit;
    IWButton2: TIWButton;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWButton3: TIWButton;
    IWDBEdit2: TIWDBEdit;
    IWDBGrid2: TIWDBGrid;
    dtsCardapios: TDataSource;
    IWDBEdit3: TIWDBEdit;
    IWDBEdit4: TIWDBEdit;
    IWDBEdit5: TIWDBEdit;
    IWDBEdit6: TIWDBEdit;
    IWDBEdit7: TIWDBEdit;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    IWLabel6: TIWLabel;
    IWLabel7: TIWLabel;
    IWLabel8: TIWLabel;
    IWButton4: TIWButton;
    IWButton5: TIWButton;
    IWButton6: TIWButton;
    edtConfSenha: TIWEdit;
    IWLabel9: TIWLabel;
    IWLabel10: TIWLabel;
    IWLabel11: TIWLabel;
    IWLabel12: TIWLabel;
    IWLabel13: TIWLabel;
    IWLabel14: TIWLabel;
    edtdbCNPJ: TIWDBEdit;
    edtdbRazao: TIWDBEdit;
    edtdbUsuario: TIWDBEdit;
    edtdbEmail: TIWDBEdit;
    edtdbSenha: TIWDBEdit;
    dtsUsuario: TDataSource;
    IWButton7: TIWButton;
    IWLabel15: TIWLabel;
    IWLabel16: TIWLabel;
    IWButton8: TIWButton;
    IWButton9: TIWButton;
    IWDBEdit8: TIWDBEdit;
    IWDBEdit9: TIWDBEdit;
    dtsRestaurantes: TDataSource;
    IWLabel17: TIWLabel;
    lblIDUsuarioRegistrado: TIWLabel;
    IWDBGrid3: TIWDBGrid;
    IWDBGrid4: TIWDBGrid;
    edtPedido: TIWEdit;
    dtsPedidos: TDataSource;
    dtsItensPedido: TDataSource;
    IWButton10: TIWButton;
    IWButton11: TIWButton;
    edtID_Estabelecimento: TIWEdit;
    IWLabel18: TIWLabel;
    IWLabel19: TIWLabel;
    cbxStatus: TIWComboBox;
    IWLabel20: TIWLabel;
    IWButton12: TIWButton;
    IWDBEdit10: TIWDBEdit;
    IWLabel21: TIWLabel;
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton2Click(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWButton7Click(Sender: TObject);
    procedure IWButton8Click(Sender: TObject);
    procedure IWButton9Click(Sender: TObject);
    procedure IWButton10Click(Sender: TObject);
    procedure IWButton11Click(Sender: TObject);
    procedure IWButton12Click(Sender: TObject);
  public
  end;

implementation

uses
  ServerController, UntDMDados;

{$R *.dfm}


procedure TIWForm1.IWButton10Click(Sender: TObject);
begin
  UserSession.DMRest.Pedidos(UserSession.ID_Usuario);
end;

procedure TIWForm1.IWButton11Click(Sender: TObject);
begin
  UserSession.DMRest.ItensPedido(
    StrToInt(edtPedido.Text),
    StrToInt(edtID_Estabelecimento.Text)
  );
end;

procedure TIWForm1.IWButton12Click(Sender: TObject);
begin
  UserSession.DMDados.MemPedidos.Edit;
  UserSession.DMDados.MemPedidosstatus.AsString :=
    cbxStatus.Items[cbxStatus.ItemIndex][1];
  UserSession.DMDados.MemPedidos.Post;
  if UserSession.DMDados.AtualizarStatusPedido(UserSession.ID_Usuario,
                                               UserSession.DMDados.MemPedidosid_pedido_mobile.AsInteger) then
    WebApplication.ShowMessage('Status alterado com sucesso!')
  else
    WebApplication.ShowMessage('Não foi possível alterar o status!');
end;

procedure TIWForm1.IWButton1Click(Sender: TObject);
begin
  UserSession.DmREST.Categorias(StrToInt(edtEstabelecimento.Text));
  //UserSession.DM.MemRestaurantes.Active := True;
end;

procedure TIWForm1.IWButton2Click(Sender: TObject);
begin
  if UserSession.DMRest.Login(edtUsuario.Text, edtSenha.Text) then
  begin
    UserSession.DMRest.Perfil(edtUsuario.Text);
    WebApplication.ShowMessage('Login efetuado com sucesso!')
  end
  else
    WebApplication.ShowMessage('Usuário ou Senha inálidos!');

end;

procedure TIWForm1.IWButton3Click(Sender: TObject);
begin
  UserSession.DmREST.Cardapios(
    UserSession.DMDados.MemCategoriasid.AsInteger,
    StrToInt(edtEstabelecimento.Text)
  );
end;

procedure TIWForm1.IWButton4Click(Sender: TObject);
begin
  UserSession.DMDados.MemCardapios.Append;
  UserSession.DMDados.MemCardapiosid_estabelecimento.AsInteger := StrToInt(edtEstabelecimento.Text);
  UserSession.DMDados.MemCardapiosid_categoria.AsInteger       :=
    UserSession.DMDados.MemCategoriasid.AsInteger;
end;

procedure TIWForm1.IWButton5Click(Sender: TObject);
begin
  UserSession.DMDados.MemCardapios.Post;
  UserSession.DMDados.GravarCardapio;
  if UserSession.DmREST.Cardapios(
    UserSession.DMDados.MemCategoriasid.AsInteger,
    StrToInt(edtEstabelecimento.Text)
  ) then
    WebApplication.ShowMessage('Cardápio inserido com sucesso!')
  else
    WebApplication.ShowMessage('Erro ao cadastrar o cardápio.');
end;

procedure TIWForm1.IWButton6Click(Sender: TObject);
begin
  if not UserSession.DMDados.MemCadUsuario.Active then
    UserSession.DMDados.MemCadUsuario.Active := True;

  UserSession.DMDados.MemCadUsuario.Append;
  UserSession.DMDados.MemCadUsuarioid_estabelecimento.AsInteger := -1;
end;

procedure TIWForm1.IWButton7Click(Sender: TObject);
begin
  if (edtConfSenha.Text = edtdbSenha.Text) then
  begin
    UserSession.ID_Usuario      := UserSession.DMDados.GravarUsuario;
    lblIDUsuarioRegistrado.Text := UserSession.ID_Usuario.ToString;
    WebApplication.ShowMessage('Usuario gravado com sucesso!');
  end
  else
    WebApplication.ShowMessage('Confirmação e Senha são diferentes!');
end;

procedure TIWForm1.IWButton8Click(Sender: TObject);
begin
  if not UserSession.DMDados.MemRestaurantes.Active then
    UserSession.DMDados.MemRestaurantes.Active := True;

  UserSession.DMDados.MemRestaurantes.Append;
end;

procedure TIWForm1.IWButton9Click(Sender: TObject);
begin
  UserSession.ID_Estabelecimento := UserSession.DMDados.GravarEstabelecimento;
  if UserSession.ID_Estabelecimento > 0 then //Confirmou o cadastro
  begin
    UserSession.DMDados.MemCadUsuario.Edit;
    UserSession.DMDados.MemCadUsuarioid_estabelecimento.AsInteger := UserSession.ID_Estabelecimento;
    UserSession.DMDados.AtualizarUsuario(UserSession.ID_Usuario);
    WebApplication.ShowMessage('Restaurante gravado com sucesso!');
  end
  else
    WebApplication.ShowMessage('Erro ao cadastrar o restaurante. Verifique!');
end;

initialization
  TIWForm1.SetAsMainForm;

end.
