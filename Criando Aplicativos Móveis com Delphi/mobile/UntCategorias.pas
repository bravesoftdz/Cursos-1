unit UntCategorias;

interface

uses
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Layouts,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  FMX.Bind.DBEngExt,
  FMX.Effects,
  FMX.Bind.Editors,

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
  System.Bindings.Outputs,

  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,

  UntLayoutBase,

  ksTabControl,
  UntLib;

type
  TfCategorias = class(TFrmLayoutBase)
    tbCtrlMain: TksTabControl;
    tbitemLista: TksTabItem;
    toolTop: TToolBar;
    btnVoltar: TButton;
    Label1: TLabel;
    lsviewLista: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    ShadowEffect1: TShadowEffect;
    procedure FormCreate(Sender: TObject);
    procedure lsviewListaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnVoltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCategorias: TfCategorias;

implementation

uses
  UntDM,
  UntDMRest,
  UntCardapios,
  UntEstabelecimentos,
  UntPrincipal,
  UntLibPedido;

{$R *.fmx}

procedure TfCategorias.btnVoltarClick(Sender: TObject);
begin
  inherited;
  TLibrary.AbrirForm(TfEstabelecimentos);
end;

procedure TfCategorias.FormCreate(Sender: TObject);
begin
  inherited;
  btnVoltar.Width         := 80;
  tbCtrlMain.ActiveTab    := tbitemLista;
  tbCtrlMain.TabPosition  := TksTabBarPosition.ksTbpNone;
  if not (DmREST.Categorias(DM.MemRestaurantes.FieldByName('ID').AsInteger)) then
  begin
    ShowMessage('Nãó há categorias disponíveis para esse estabelecimento.');
    TLibrary.AbrirForm(TfEstabelecimentos);
    exit;
  end;
  TPedidoAtual.IconCart := lytIconCarrinho;
  TPedidoAtual.ToolBar  := toolTop;
  TPedidoAtual.MostrarOcultarCarrinho;
end;

procedure TfCategorias.lsviewListaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  inherited;
  TLibrary.AbrirForm(TfCardapios);
end;

end.
