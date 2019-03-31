unit UntLibPedido;

interface

uses
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Types,
  FMX.Objects,
  FMX.Dialogs,
  FMX.Forms,

  System.Classes,

  UntLib;

type
  TStatusPedido = (spNenhum, spAberto, spFechado, spAguardando, spEnviado);

  TPedidoAtual = class
    private
      class var
        FIconCart     : TLayout;
        FToolBar      : TToolBar;
        FStatusPedido : TStatusPedido;
        FNumPedido    : Integer;
        FFormCarrinho : TComponentClass;
      class procedure ClickCart(Sender: TObject);
    public
      class procedure MostrarOcultarCarrinho;
      class function  ExistePedidoAberto: Boolean;
      class property  IconCart     : TLayout         read FIconCart     write FIconCart;
      class property  ToolBar      : TToolBar        read FToolBar      write FToolBar;
      //Informações sobre PedidoAtual
      class property  Status       : TStatusPedido   read FStatusPedido write FStatusPedido;
      class property  NumPedido    : Integer         read FNumPedido    write FNumPedido;
      class property  FormCarrinho : TComponentClass read FFormCarrinho write FFormCarrinho;
  end;

implementation

{ TPedidoAtual }

class procedure TPedidoAtual.ClickCart(Sender: TObject);
begin
  TLibrary.AbrirForm(FFormCarrinho);
end;

class function TPedidoAtual.ExistePedidoAberto: Boolean;
begin
  Result := FNumPedido > 0;
end;

class procedure TPedidoAtual.MostrarOcultarCarrinho;
var
  I : Integer;
begin
  if (TToolBar(ToolBar).FindComponent(IconCart.Name) = nil) then
    ToolBar.AddObject(TFMXObject(IconCart));

  IconCart.Align := TAlignLayout.Right;
  IconCart.BringToFront;
  IconCart.HitTest := True;
  IconCart.OnClick := ClickCart;
  IconCart.Visible := (Status = spAberto);

  if IconCart.Visible then
  begin
    for I := 0 to Pred(IconCart.ControlsCount) do
    begin
      if ((IconCart.Controls[I]) is TPath) then
      begin
        ((IconCart.Controls[I]) as TPath).OnClick := ClickCart;
        ((IconCart.Controls[I]) as TPath).HitTest := True;
      end;

      if ((IconCart.Controls[I]) is TSpeedButton) then
        ((IconCart.Controls[I]) as TSpeedButton).OnClick := ClickCart;
    end;
  end;
end;

end.
