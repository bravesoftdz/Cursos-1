unit Unit2;

interface

uses
  System.SysUtils,
  System.Classes,

  uDWAbout,

  uRESTDWServerEvents,
  uDWDataModule,
  UDWJSONObject;

type
  TDataModule2 = class(TServerMethodDataModule)
    DWServerEvents1: TDWServerEvents;
    procedure DWServerEvents1EventstdevrocksReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule2.DWServerEvents1EventstdevrocksReplyEvent(
  var Params: TDWParams; var Result: string);
begin
  Params.ItemsString['result'].Value := 'Olá mundo!';
end;

end.
