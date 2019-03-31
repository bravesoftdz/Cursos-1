unit UntCarrinho;

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
  FMX.ScrollBox,
  FMX.Memo,

  ksTabControl,

  MultiDetailAppearanceU,

  UntLayoutBase,

  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,

  UntDMRest;

type
  TfCarrinho = class(TFrmLayoutBase)
    tbctrlMain: TksTabControl;
    tbitemListagem: TksTabItem;
    tbitemEnvio: TksTabItem;
    toolTop: TToolBar;
    Label1: TLabel;
    btnMenu: TButton;
    ShadowEffect1: TShadowEffect;
    lytPedidoCab: TLayout;
    lstviewItens: TListView;
    lblNomeEstabelecimento: TLabel;
    lblData: TLabel;
    lblValorPedido: TLabel;
    lytDiv: TLayout;
    rctDiv: TRectangle;
    lblItens: TLabel;
    lytEnvio: TLayout;
    rctEnvio: TRectangle;
    lblEnvio: TLabel;
    speEnvio: TSpeedButton;
    ShadowEffect2: TShadowEffect;
    ToolBar1: TToolBar;
    lblTituloFechamento: TLabel;
    btnVoltar: TButton;
    ShadowEffect3: TShadowEffect;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure speEnvioClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCarrinho: TfCarrinho;

implementation

uses
  UntPrincipal,
  UntLib,
  UntDM, System.JSON,
  UntLibPedido;

{$R *.fmx}

procedure TfCarrinho.btnVoltarClick(Sender: TObject);
begin
  inherited;
  TLibrary.MudarAba(tbctrlMain, tbitemListagem);
end;

procedure TfCarrinho.FormCreate(Sender: TObject);
begin
  inherited;
  tbctrlMain.TabPosition := TksTabBarPosition.ksTbpNone;
  tbctrlMain.ActiveTab   := tbitemListagem;

  DM.qryCarrinho.Active := False;
  DM.qryCarrinho.Active := True;
end;

procedure TfCarrinho.speEnvioClick(Sender: TObject);
var
  lJSON : TJSONArray;
begin
  inherited;
  //ShowMessage(DM.GerarJSONPedidoLocal);
//  Memo1.Lines.Clear;
//  Memo1.Lines.Add(DM.GerarJSONPedidoLocal);

  lJSON := DM.GerarJSONPedidoLocal;
  if DmREST.EnviarPedido(lJSON) then
  begin
    DM.qryCarrinho.Edit;
    DM.qryCarrinhoSTATUS.AsString := 'E';
    DM.qryCarrinho.Post;
    ShowMessage('Pedido enviado com sucesso!');
  end;

  //TLibrary.MudarAba(tbctrlMain, tbitemEnvio);
end;

end.
