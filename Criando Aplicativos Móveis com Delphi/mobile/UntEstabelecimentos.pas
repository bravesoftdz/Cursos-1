unit UntEstabelecimentos;

interface

uses
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  FMX.Controls.Presentation,
  FMX.Bind.Editors,
  FMX.Bind.DBEngExt,

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
  System.Bindings.Outputs,
  System.IOUtils,

  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,

  ksTabControl,

  UntLayoutBase,
  UntDM,
  UntDmREST,

  MultiDetailAppearanceU,
  FMX.Effects,

  UntAguarde;

type
  TfEstabelecimentos = class(TFrmLayoutBase)
    tbCtrlMain: TksTabControl;
    ksTabItem0: TksTabItem;
    toolTop: TToolBar;
    btnMenu: TButton;
    Label1: TLabel;
    lstViewEstabelecimentos: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    ShadowEffect1: TShadowEffect;
    procedure FormCreate(Sender: TObject);
    procedure lstViewEstabelecimentosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEstabelecimentos: TfEstabelecimentos;

implementation

uses
  UntCategorias,
  UntPrincipal,
  UntLib,
  UntLibPedido;

{$R *.fmx}

procedure TfEstabelecimentos.FormCreate(Sender: TObject);
begin
  inherited;
  lytIconCarrinho.Visible := False;
  tbCtrlMain.TabPosition := TksTabBarPosition.ksTbpNone;

  TAguarde.Show('Carregando restaurantes...');
  DmREST.Estabelecimentos;
  TAguarde.Hide;

  lstViewEstabelecimentos.ScrollTo(0);

  TPedidoAtual.IconCart := lytIconCarrinho;
  TPedidoAtual.ToolBar  := toolTop;
  TPedidoAtual.MostrarOcultarCarrinho;
end;

procedure TfEstabelecimentos.lstViewEstabelecimentosItemClick(
  const Sender: TObject; const AItem: TListViewItem);
begin
  inherited;
  TLibrary.AbrirForm(TfCategorias);
end;



end.
