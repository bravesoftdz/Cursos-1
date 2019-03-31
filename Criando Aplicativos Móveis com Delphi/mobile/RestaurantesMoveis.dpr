program RestaurantesMoveis;

uses
  System.StartUpCopy,
  FMX.Forms,
  UntBase in 'UntBase.pas' {FrmBase},
  UntLayoutBase in 'UntLayoutBase.pas' {FrmLayoutBase},
  UntInfoUsuario in 'UntInfoUsuario.pas' {FrmInfoUsuario},
  UntPrincipal in 'UntPrincipal.pas' {fPrincipal},
  UntLib in 'utils\UntLib.pas',
  UntCadUsuario in 'UntCadUsuario.pas' {fCadUsuario},
  Constantes in 'utils\Constantes.pas',
  Funcoes in 'utils\Funcoes.pas',
  UntDM in 'UntDM.pas' {DM: TDataModule},
  UntDmREST in 'UntDmREST.pas' {DmREST: TDataModule},
  UntEstabelecimentos in 'UntEstabelecimentos.pas' {fEstabelecimentos},
  UntCategorias in 'UntCategorias.pas' {fCategorias},
  UntCardapios in 'UntCardapios.pas' {fCardapios},
  UntAguarde in 'classes\UntAguarde.pas',
  SmartPoint in 'utils\SmartPoint.pas',
  ULGTDataSetHelper in '..\comum\ULGTDataSetHelper.pas',
  UntFrameBaseLista in 'UntFrameBaseLista.pas' {FrameBaseLista: TFrame},
  UntLibPedido in 'UntLibPedido.pas',
  UntCarrinho in 'UntCarrinho.pas' {fCarrinho},
  UntPedidos in 'UntPedidos.pas' {fPedidos},
  Util.Mensageria in 'utils\Util.Mensageria.pas',
  TiposComuns in 'utils\TiposComuns.pas',
  UntSplash in 'UntSplash.pas' {fSplash};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TDmREST, DmREST);
  Application.CreateForm(TfSplash, fSplash);
  Application.Run;
end.
