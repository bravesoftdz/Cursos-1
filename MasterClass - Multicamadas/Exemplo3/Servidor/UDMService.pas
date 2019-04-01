unit UDMService;

interface

uses
  System.SysUtils, System.Classes, UDWJSONObject,

  uDWDataModule, uDWAbout, uRESTDWServerEvents, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, uRESTDWPoolerDB,
  uRestDWDriverFD, Data.DB, FireDAC.Comp.Client;

type
  TDmService = class(TServerMethodDataModule)
    DWServerEvents1: TDWServerEvents;
    poolDBFirebird: TRESTDWPoolerDB;
    fcConn: TFDConnection;
    driverFD: TRESTDWDriverFD;
    procedure DWServerEvents1Eventsevento1ReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmService: TDmService;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmService.DWServerEvents1Eventsevento1ReplyEvent(
  var Params: TDWParams; var Result: string);
begin
  Params.ItemsString['result'].AsString := 'Olá mundo!';
end;

end.
