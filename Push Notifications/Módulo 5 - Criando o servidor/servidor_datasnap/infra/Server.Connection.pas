unit Server.Connection;

interface

uses
  System.SysUtils,
  System.Classes,

  FireDAC.Comp.Client,     //FDConnection
  FireDAC.Phys.FB,         //DriverPhys do FireBird
  FireDAC.Stan.Def,        //StanStorage

  SmartPoint;

type
  TDriverFB = class(TFDPhysFBDriverLink)
    private
      constructor Create(Owner: TComponent);override;
      destructor Destroy;override;
    public
      property VendorLib;
  end;

  TConnectionData = class
    protected
      FDriverFB: TDriverFB;
      function GetDriverFB: TDriverFB;
    private
      FConnection : TFDConnection;
      procedure SetParams;
    public
      constructor Create;
      destructor Free;
      property Connection : TFDConnection read FConnection write FConnection;
  end;

implementation

Uses
  Server.Config;

{ TConnectionData }

constructor TConnectionData.Create;
begin
  if not Assigned(FConnection) then
    FConnection := TFDConnection.Create(nil);

  SetParams;
end;

destructor TConnectionData.Free;
begin
  if Assigned(FDriverFB) then
    FDriverFB.Free;

  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FConnection.Free;
  end;
end;

function TConnectionData.GetDriverFB: TDriverFB;
begin
  if not Assigned(FDriverFB) then
    FDriverFB := TDriverFB.Create(nil);

  Result := FDriverFB;
end;

procedure TConnectionData.SetParams;
begin
  TServerConfig.FileName                 := ExtractFilePath(ParamStr(0)) + 'Config.ini';
  FConnection.DriverName                 := TServerConfig.DriverName;
  FConnection.Params.Values['Database']  := TServerConfig.Database;
  FConnection.Params.Values['User_Name'] := TServerConfig.UserName;
  FConnection.Params.Values['Password']  := TServerConfig.Password;
  FConnection.Params.Values['Server']    := TServerConfig.Server;
  FConnection.Params.Values['Port']      := IntToStr(TServerConfig.Port);
end;

{ TDriverMySQL }

constructor TDriverFB.Create(Owner: TComponent);
begin
  inherited;
end;

destructor TDriverFB.Destroy;
begin
  inherited;
end;

end.
