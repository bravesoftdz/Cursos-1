unit Unit2;

interface

uses
  System.SysUtils,
  System.Classes,

  Data.DB,

  uDWAbout,
  uRESTDWServerEvents,
  uDWDataModule,
  UDWJSONObject,
  uRESTDWPoolerDB,
  ZAbstractConnection,
  ZConnection,
  uRESTDWDriverZEOS,

  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset;

type
  TDataModule2 = class(TServerMethodDataModule)
    TServerEvents: TDWServerEvents;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverZeos1: TRESTDWDriverZeos;
    ZConnection1: TZConnection;
    zqryUsuarios: TZQuery;
    DWServerEvents1: TDWServerEvents;
    procedure TServerEventsEventstdevrocksReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure TServerEventsEventsgetUsuariosReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWServerEvents1EventsgettableReplyEvent(var Params: TDWParams;
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

procedure TDataModule2.DWServerEvents1EventsgettableReplyEvent(
  var Params: TDWParams; var Result: string);
Var
 JSONValue: TJSONValue;
begin

 JSONValue          := TJSONValue.Create;
 Try
  zqryUsuarios.Close;
  zqryUsuarios.SQL.Clear;
  zqryUsuarios.SQL.Add('select * from curso.usuarios');
  Try
   zqryUsuarios.Open;
   JSONValue.JsonMode := Params.JsonMode;
   JSONValue.Encoding := Encoding;
//   If Params.JsonMode in [jmPureJSON, jmMongoDB] Then
//    Begin
//     JSONValue.LoadFromDataset('', FDQuery1, False,  Params.JsonMode, 'dd/mm/yyyy', '.');
//     Result := JSONValue.ToJson;
//    End
//   Else
//    Begin
     JSONValue.LoadFromDataset('curso.usuarios', zqryUsuarios, False,  Params.JsonMode);
     Params.ItemsString['result'].AsString := JSONValue.ToJSON;
//    End;
  Except
   On E : Exception Do
    Begin
     Result := Format('{"Error":"%s"}', [E.Message]);
    End;
  End;
 Finally
  JSONValue.Free;
 End;
end;

procedure TDataModule2.TServerEventsEventsgetUsuariosReplyEvent(
  var Params: TDWParams; var Result: string);
Var
 JSONValue: TJSONValue;
begin
(*
 JSONValue          := TJSONValue.Create;
 Try
  ZQuery1.Close;
  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Add('select * from curso.usuarios');
  Try
   ZQuery1.Open;
   JSONValue.JsonMode := Params.JsonMode;
   JSONValue.Encoding := Encoding;
//   If Params.JsonMode in [jmPureJSON, jmMongoDB] Then
//    Begin
//     JSONValue.LoadFromDataset('', FDQuery1, False,  Params.JsonMode, 'dd/mm/yyyy', '.');
//     Result := JSONValue.ToJson;
//    End
//   Else
//    Begin
     JSONValue.LoadFromDataset('usuarios', ZQuery1, False,  Params.JsonMode);
     Params.ItemsString['result'].AsObject       := JSONValue.ToJSON;
//    End;
  Except
   On E : Exception Do
    Begin
     Result := Format('{"Error":"%s"}', [E.Message]);
    End;
  End;
 Finally
  JSONValue.Free;
 End;
*)
end;

procedure TDataModule2.TServerEventsEventstdevrocksReplyEvent(
  var Params: TDWParams; var Result: string);
begin
  Params.ItemsString['result'].AsString := 'Olá RESTDataware';
end;

end.
