program ServidorPushDS;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  UntMain in 'UntMain.pas' {fMain},
  UntServicosPush in 'UntServicosPush.pas' {SmServicosPush: TDataModule},
  UntWM in 'UntWM.pas' {WM: TWebModule},
  Constantes in '..\comum\Constantes.pas',
  Server.Config in 'infra\Server.Config.pas',
  Server.Connection in 'infra\Server.Connection.pas',
  Server.Utils in 'infra\Server.Utils.pas',
  SmartPoint in 'utils\SmartPoint.pas',
  Utils.DataSet.JSON.Helper in 'utils\Utils.DataSet.JSON.Helper.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
