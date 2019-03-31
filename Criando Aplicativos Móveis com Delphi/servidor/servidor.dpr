program servidor;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  UntMain in 'UntMain.pas' {fMain},
  UntWM in 'UntWM.pas' {WM: TWebModule},
  Restaurantes.Constantes in 'infra\Restaurantes.Constantes.pas',
  Restaurantes.Utils in 'infra\Restaurantes.Utils.pas',
  UntSrvMetodosGerais in 'UntSrvMetodosGerais.pas' {SrvMetodosGerais: TDataModule},
  UntSmServicos in 'UntSmServicos.pas' {SmServicos: TDataModule},
  ULGTDataSetHelper in '..\comum\ULGTDataSetHelper.pas',
  UntDMGeral in 'UntDMGeral.pas' {DMGeral: TDataModule},
  Restaurantes.Servidor.Connection in 'infra\Restaurantes.Servidor.Connection.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TDMGeral, DMGeral);
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
