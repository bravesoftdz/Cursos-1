unit Restaurantes.Servidor.Connection;

interface

uses
  FireDAC.Comp.Client,
  UntDMGeral;

type
  TConexaoDados = class
    private
      class var FConnection : TFDConnection;
      class function GetConnection : TFDConnection; static;
    public
      class property Connection : TFDConnection read GetConnection write FConnection;
  end;

implementation

class function TConexaoDados.GetConnection : TFDConnection;
begin
  if not (Assigned(DMGeral)) then
    DMGeral := TDMGeral.Create(nil);

  Result := DMGeral.fdConn;
end;

end.
