unit UntCardapios;

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
  FMX.Effects,
  FMX.Edit,

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

  ksTabControl,

  UntLayoutBase,
  UntCategorias,
  UntFrameBaseLista,
  UntLib;

type
  TfCardapios = class(TFrmLayoutBase)
    tbCtrlMain: TksTabControl;
    tbitemLista: TksTabItem;
    toolTop: TToolBar;
    btnVoltar: TButton;
    Label1: TLabel;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    ShadowEffect1: TShadowEffect;
    vrtScrollLista: TVertScrollBox;
    frameExemplo: TFrameBaseLista;
    procedure FormCreate(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure SelecionarItem(Sender: TObject);
  private
    { Private declarations }
    procedure LimparLista(Sender: TObject);
    procedure AddItem(Sender: TObject);
    procedure RemoveItem(Sender: TObject);
    procedure AtualizarCardapios(Sender: TObject);
    procedure GestoLongo(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure DuploClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  fCardapios: TfCardapios;

implementation

uses
  UntDmREST,
  UntDM,
  UntPrincipal,
  UntLibPedido;

{$R *.fmx}

procedure TfCardapios.AddItem(Sender: TObject);
var
  edtQtde : TComponent;
  lQtde   : Integer;
begin
  edtQtde := (TFMXObject(Sender).Owner as TFrameBaseLista).FindComponent('edtQtde');

  if TEdit(edtQtde).Text.Equals(EmptyStr) then
    TEdit(edtQtde).Text := '0';

  lQtde   := TEdit(edtQtde).Text.ToInteger;

  Inc(lQtde);

  TEdit(edtQtde).Text := lQtde.ToString;
end;

procedure TfCardapios.RemoveItem(Sender: TObject);
var
  edtQtde : TComponent;
  lQtde   : Integer;
begin
  edtQtde := (TFMXObject(Sender).Owner as TFrameBaseLista).FindComponent('edtQtde');

  if TEdit(edtQtde).Text.Equals(EmptyStr) then
    TEdit(edtQtde).Text := '0';

  lQtde   := TEdit(edtQtde).Text.ToInteger;

  if (lQtde = 0) then
    exit;

  Dec(lQtde);

  TEdit(edtQtde).Text := lQtde.ToString;
end;

procedure TfCardapios.AtualizarCardapios(Sender: TObject);
const
  sName   = 'frItem%4.4d';
var
  frFrame : TFrameBaseLista;
  I       : Integer;
  sBase   : string;
  iCount  : Integer;
begin
  LimparLista(Sender);
  try
    try
      iCount := 0;

      if not (DmREST.Cardapios(DM.MemCategorias.FieldByName('ID').AsInteger,
        DM.MemRestaurantes.FieldByName('ID').AsInteger)) then
      begin
        ShowMessage('Não há cardápios para essa categoria.');
        TLibrary.AbrirForm(TfCategorias);
      end
      else
      begin
        DM.MemCardapios.First;
        while not DM.MemCardapios.Eof do
        begin
          Inc(iCount);

          frFrame := TFrameBaseLista.Create(Self);
          vrtScrollLista.AddObject(frFrame);
          //Atualização das propriedades do frame
          frFrame.Align     := TAlignLayout.Top;
          frFrame.Name      := Format(sName, [iCount]); //'frItem%4.4d' // frItem0001
          frFrame.Tag       := iCount;
          frFrame.Identify  := iCount;
          //Atualização das propriedades dos Labels
          frFrame.lblTitulo.Text        := DM.MemCardapios.FieldByName('NOME').AsString;
          frFrame.lblSubDetail1.Text    := DM.MemCardapios.FieldByName('INGREDIENTES').AsString;
          frFrame.lblSubDetail2.Text    := DM.MemCardapios.FieldByName('PRECO').AsString;
          frFrame.lblSubDetail3.Visible := False;

          frFrame.speMais.OnClick       := AddItem;
          frFrame.speMenos.OnClick      := RemoveItem;

          for I := 0 to Pred(frFrame.ComponentCount) do
          begin
            if (frFrame.Components[I] is TLabel) then
            begin
              (frFrame.Components[I] as TLabel).HitTest     := True;
              (frFrame.Components[I] as TLabel).OnClick     := SelecionarItem;
              (frFrame.Components[I] as TLabel).OnDblClick  := DuploClick;
              (frFrame.Components[I] as TLabel).OnGesture   := GestoLongo;
            end;
          end;

          frFrame.HitTest := True;
          frFrame.OnClick := SelecionarItem;

          DM.MemCardapios.Next;
        end;
      end;
    except on E:Exception do
      begin

      end;
    end;
  finally

  end;
end;

procedure TfCardapios.btnVoltarClick(Sender: TObject);
begin
  inherited;
  TLibrary.AbrirForm(TfCategorias);
end;

procedure TfCardapios.DuploClick(Sender: TObject);
var
  edtQtde : TComponent;
  lQtde   : Integer;
begin
  edtQtde := (TFMXObject(Sender).Owner as TFrameBaseLista).FindComponent('edtQtde');
  lQtde   := TEdit(edtQtde).Text.ToInteger;
  DM.AdicionarItem(lQtde);
end;

procedure TfCardapios.FormCreate(Sender: TObject);
begin
  inherited;
  btnVoltar.Width        := 80;
  tbCtrlMain.ActiveTab   := tbitemLista;
  tbCtrlMain.TabPosition := TksTabBarPosition.ksTbpNone;
  AtualizarCardapios(Sender);
  TPedidoAtual.IconCart := lytIconCarrinho;
  TPedidoAtual.ToolBar  := toolTop;
  TPedidoAtual.MostrarOcultarCarrinho;
end;

procedure TfCardapios.GestoLongo(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  edtQtde : TComponent;
  lQtde   : Integer;
begin
  if EventInfo.GestureID = igiLongTap then
  begin
    edtQtde := (TFMXObject(Sender).Owner as TFrameBaseLista).FindComponent('edtQtde');
    lQtde   := TEdit(edtQtde).Text.ToInteger;
    DM.AdicionarItem(lQtde);
    Handled := True;
  end;
end;

procedure TfCardapios.LimparLista(Sender: TObject);
var
  I      : Integer;
  lName  : string;
  lFrame : TFrameBaseLista;
begin
  for I := Pred(Self.ComponentCount) downto 0 do
  begin
    if (Self.Components[I] is TFrameBaseLista) then
    begin
      lName  := (Self.Components[I] as TFrameBaseLista).Name;
      lFrame := TFrameBaseLista(TForm(Self).FindComponent(lName));

      lFrame.DisposeOf;
      lFrame := nil;
      //FreeAndNil(lFrame); Não funciona perfeitamente no mobile
    end;
  end;
end;

procedure TfCardapios.SelecionarItem(Sender: TObject);
begin
  {Locate na tabela temporário}
  //DM.MemCardapios.Locate('ID', (TFMXObject(Sender).Owner as TFrameBaseLista).Identify, []);
  //ShowMessage('CLICOU: ' + (TFMXObject(Sender).Owner as TFrameBaseLista).Identify.ToString);
end;


end.
