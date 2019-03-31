program RestaurantesWeb;

uses
  IWRtlFix,
  IWJclStackTrace,
  IWJclDebug,
  Forms,
  IWStart,
  Unit1 in 'Unit1.pas' {IWForm1: TIWAppForm},
  ServerController in 'ServerController.pas' {IWServerController: TIWServerControllerBase},
  UserSessionUnit in 'UserSessionUnit.pas' {IWUserSession: TIWUserSessionBase},
  Constantes in '..\..\mobile\utils\Constantes.pas',
  SmartPoint in '..\..\mobile\utils\SmartPoint.pas',
  UntDMREST in 'UntDMREST.pas' {DMREST: TDataModule},
  UntDMDados in 'UntDMDados.pas' {DMDados: TDataModule},
  ULGTDataSetHelper in '..\..\comum\ULGTDataSetHelper.pas';

{$R *.res}

begin
  TIWStart.Execute(True);
end.
