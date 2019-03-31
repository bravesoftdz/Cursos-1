unit UntPrincipal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,
  System.Json,

  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ImgList,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.MultiView,
  FMX.Edit,
  FMX.Effects,

  UntBase,
  ksTabControl,

  UntCadUsuario,
  Constantes,
  UntAguarde,
  Data.Bind.EngExt,
  Fmx.Bind.DBEngExt,
  System.Rtti,
  System.Bindings.Outputs,
  Fmx.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.DBScope,
  UntLibPedido,
  UntCarrinho,

  TiposComuns,
  Util.Mensageria;

type
  TfPrincipal = class(TFrmBase)
    tbCtrlMain: TksTabControl;
    tbitemLogin: TksTabItem;
    tbitemMain: TksTabItem;
    mtvMenu: TMultiView;
    imgMenu: TImageList;
    rctSair: TRectangle;
    lblMnuSair: TLabel;
    rctPerfil: TRectangle;
    lblNomePerfil: TLabel;
    lblEmail: TLabel;
    lytPerfil: TLayout;
    lytBase: TLayout;
    rctClient: TRectangle;
    lytBoxUserPass: TLayout;
    edtApelido: TEdit;
    Line3: TLine;
    edtSenha: TEdit;
    Line4: TLine;
    rctBackground: TRectangle;
    lytLogin: TLayout;
    rctLogin: TRectangle;
    lblLogin: TLabel;
    imgClearApelido: TImage;
    imgMostrarSenha: TImage;
    lytEdtApelido: TLayout;
    lytIntenoApelido: TLayout;
    lytEdtSenha: TLayout;
    lytInternoSenha: TLayout;
    lytCadastrar: TLayout;
    rctCadastrar: TRectangle;
    lblCadastrar: TLabel;
    lytNovoCadastro: TLayout;
    lytNaoCadastro: TLabel;
    lytCadFace: TLayout;
    rctCadFace: TRectangle;
    lblCadFace: TLabel;
    swtLembrar: TSwitch;
    lytLembrar: TLayout;
    lblLembrar: TLabel;
    cirFoto: TCircle;
    lytFoto: TLayout;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldFillBitmapBitmap: TLinkPropertyToField;
    speLogin: TSpeedButton;
    BlurEffect1: TBlurEffect;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    rctOfuscaImagem: TRectangle;
    speNovoCad: TSpeedButton;
    speFacebook: TSpeedButton;
    rctMenu: TRectangle;
    rctBackTopo: TRectangle;
    rctMnuPerfil: TRectangle;
    lytMnuIconPerfil: TLayout;
    lytMnuPerfil: TLayout;
    lblMnuPerfil: TLabel;
    rctMnuRestaurantes: TRectangle;
    lytMnuIconRestaurantes: TLayout;
    lytMnuRestaurantes: TLayout;
    lblMnuRestaurantes: TLabel;
    pthRestaurantes: TPath;
    pthPerfil: TPath;
    lytMnuIconSair: TLayout;
    pthSair: TPath;
    rctPedidos: TRectangle;
    lytBackBtnPedidos: TLayout;
    pthPedidos: TPath;
    lytMnuPedidos: TLayout;
    lblMnuPedidos: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure rctSairClick(Sender: TObject);
    procedure glySairTap(Sender: TObject; const Point: TPointF);
    procedure rctLoginClick(Sender: TObject);
    procedure rctCadastrarClick(Sender: TObject);
    procedure rctCadFaceClick(Sender: TObject);
    procedure rctMnuPerfilClick(Sender: TObject);
    procedure rctMnuRestaurantesClick(Sender: TObject);
    procedure rctPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

uses
  UntInfoUsuario,
  UntLib,
  UntEstabelecimentos,
  UntDmREST,
  UntDM,
  UntPedidos;

{$R *.fmx}

{ TFrmPrincipal }

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  inherited;
  tbCtrlMain.TabPosition    := TksTabBarPosition.ksTbpNone;
  tbCtrlMain.ActiveTab      := tbitemLogin;

  TLibrary.ActiveForm       := nil;
  TLibrary.MainMenu         := mtvMenu;
  TLibrary.LayoutMain       := rctClient;
  TLibrary.MainMenu.HideMaster;

  TPedidoAtual.FormCarrinho := TfCarrinho;

  TLibrary.LerConfig;
  if TLibrary.Lembrar then
  begin
    edtApelido.Text      := TLibrary.Usuario;
    swtLembrar.IsChecked := TLibrary.Lembrar;
  end;

  {$IFDEF DEBUG}
    edtApelido.Text := 'adriano';
    edtSenha.Text   := '1';
    //rctLoginClick(Sender);
  {$ENDIF}
end;

procedure TfPrincipal.glySairTap(Sender: TObject; const Point: TPointF);
begin
  inherited;
  rctSairClick(Sender);
end;

procedure TfPrincipal.rctCadastrarClick(Sender: TObject);
begin
  inherited;
  TLibrary.AbrirForm(TfCadUsuario);
  TLibrary.MudarAba(tbCtrlMain, tbitemMain);
end;

procedure TfPrincipal.rctCadFaceClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TfPrincipal.rctLoginClick(Sender: TObject);
var
  lResultado : String;
begin
  inherited;
  if DmREST.Login(edtApelido.Text, edtSenha.Text) then
  begin
    TLibrary.OnLine  := True;
    TLibrary.Usuario := edtApelido.Text;
    TLibrary.Lembrar := swtLembrar.IsChecked;

    TLibrary.SalvarConfig(edtApelido.Text, swtLembrar.IsChecked);
    TLibrary.AbrirForm(TfEstabelecimentos);
    TLibrary.MudarAba(tbCtrlMain, tbitemMain);
    DmREST.Perfil(TLibrary.Usuario);

    TLibrary.ID := DM.memUsuario.FieldByName('ID').AsInteger;

    DMRest.AtualizarStatusLocal(TLibrary.ID);

    rctMnuRestaurantesClick(Sender);
  end
  else
  begin
    TMensageria.Mensagem('Usuário ou Senha inválidos. Verifique!', tmiErro);
  end;
end;

procedure TfPrincipal.rctMnuPerfilClick(Sender: TObject);
begin
  inherited;
  TLibrary.AbrirForm(TFrmInfoUsuario);
  TLibrary.MudarAba(tbCtrlMain, tbitemMain);
end;

procedure TfPrincipal.rctMnuRestaurantesClick(Sender: TObject);
begin
  inherited;
  TLibrary.AbrirForm(TfEstabelecimentos);
  TLibrary.MudarAba(tbCtrlMain, tbitemMain);
end;

procedure TfPrincipal.rctPedidosClick(Sender: TObject);
begin
  inherited;
  TLibrary.AbrirForm(TfPedidos);
  TLibrary.MudarAba(tbCtrlMain, tbitemMain);
end;

procedure TfPrincipal.rctSairClick(Sender: TObject);
begin
  inherited;
  ShowMessage('Logoff efetuado');
  mtvMenu.HideMaster;
  TLibrary.MudarAba(tbCtrlMain, tbitemLogin);
end;

end.
