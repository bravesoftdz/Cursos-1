unit uDmService;

interface

uses
  SysUtils, Classes, IBConnection, sqldb, SysTypes, uDWDatamodule,
  uDWJSONObject, Dialogs, ServerUtils, uDWConsts, uDWConstsData,
  RestDWServerFormU, uRESTDWPoolerDB, uRESTDWServerEvents, uRESTDWServerContext,
  uRestDWLazDriver, uDWJSONTools;


type

  { TServerMethodDM }

  TServerMethodDM = class(TServerMethodDataModule)
    DWServerContext1: TDWServerContext;
    DWServerEvents1: TDWServerEvents;
    RESTDWDriverFD1: TRESTDWLazDriver;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    Server_FDConnection: TIBConnection;
    FDQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure DWServerContext1ContextListangularReplyRequest(
      const Params: TDWParams; Var ContentType, Result: String);
    procedure DWServerContext1ContextListindexReplyRequest(
      const Params: TDWParams; Var ContentType, Result: String);
    procedure DWServerContext1ContextListinitReplyRequest(
      const Params: TDWParams; Var ContentType, Result: String);
    procedure DWServerContext1ContextListopenfileReplyRequestStream(
      const Params: TDWParams; Var ContentType: String;
      Var Result: TMemoryStream);
    procedure DWServerContext1ContextListphpReplyRequest(
      const Params: TDWParams; Var ContentType, Result: String);
    procedure DWServerEvents1EventsgetemployeeReplyEvent(Var Params: TDWParams;
      Var Result: String);
    procedure DWServerEvents1EventsservertimeReplyEvent(Var Params: TDWParams;
      Var Result: String);
    procedure ServerMethodDataModuleReplyEvent(SendType: TSendEvent;
      Context: string; var Params: TDWParams; var Result: string);
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure Server_FDConnectionBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerMethodDM: TServerMethodDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.lfm}

procedure TServerMethodDM.ServerMethodDataModuleCreate(Sender: TObject);
begin
 RESTDWPoolerDB1.Active := RestDWForm.cbPoolerState.Checked;
end;

procedure TServerMethodDM.ServerMethodDataModuleReplyEvent(SendType: TSendEvent;
  Context: string; var Params: TDWParams; var Result: string);
Begin
 Case SendType Of
  sePOST   : Result := '{(''STATUS'',   ''NOK''), (''MENSAGEM'', ''Método não encontrado'')}';
 End;
End;

procedure TServerMethodDM.DWServerEvents1EventsgetemployeeReplyEvent(
  Var Params: TDWParams; Var Result: String);
Var
 JSONValue: TJSONValue;
begin
 JSONValue          := TJSONValue.Create;
 Try
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from employee');
  Try
   FDQuery1.Open;
   JSONValue.Encoding := Encoding;
   JSONValue.Encoded  := False;
   JSONValue.DatabaseCharSet := RESTDWDriverFD1.DatabaseCharSet;
   JSONValue.LoadFromDataset('employee', FDQuery1, False,  Params.JsonMode, '');
   Result := JSONValue.ToJSON;
  Except
  End;
 Finally
  JSONValue.Free;
 End;
end;

procedure TServerMethodDM.DWServerContext1ContextListinitReplyRequest(
  const Params: TDWParams; Var ContentType, Result: String);
begin
 Result := '<!DOCTYPE html> ' +
           '<html>' +
           '  <head>' +
           '    <meta charset="utf-8">' +
           '    <title>My test page</title>' +
           '    <link href=''http://fonts.googleapis.com/css?family=Open+Sans'' rel=''stylesheet'' type=''text/css''>' +
           '  </head>' +
           '  <body>' +
           '    <h1>REST Dataware (Lazarus) is cool</h1>' +
           '    <img src="http://www.resteasyobjects.com.br/myimages/LogoDW.png" alt="The REST Dataware logo: Powerfull Web Service.">' +
           '  ' +
           '  ' +
           '    <p>working together to keep the Internet alive and accessible, help us to help you. Be free.</p>' +
           ' ' +
           '    <p><a href="http://www.restdw.com.br/">REST Dataware site</a> to learn and help us.</p>' +
           '  </body>' +
           '</html>';
end;

procedure TServerMethodDM.DWServerContext1ContextListopenfileReplyRequestStream(
  const Params: TDWParams; Var ContentType: String; Var Result: TMemoryStream);
Var
 vNotFound   : Boolean;
 vFileName   : String;
 vStringStream : TStringStream;
begin
 vNotFound := True;
 Result    := TMemoryStream.Create;
 If Params.ItemsString['filename'] <> Nil Then
  Begin
   vFileName := '.\www\' + DecodeStrings(Params.ItemsString['filename'].AsString,
                                         RESTDWDriverFD1.DatabaseCharSet);
   vNotFound := Not FileExists(vFileName);
   If Not vNotFound Then
    Begin
     Try
      Result.LoadFromFile(vFileName);
      ContentType := GetMIMEType(vFileName);
     Finally
     End;
    End;
  End;
 If vNotFound Then
  Begin
   vStringStream := TStringStream.Create('<!DOCTYPE html> ' +
                                         '<html>' +
                                         '  <head>' +
                                         '    <meta charset="utf-8">' +
                                         '    <title>My test page</title>' +
                                         '    <link href=''http://fonts.googleapis.com/css?family=Open+Sans'' rel=''stylesheet'' type=''text/css''>' +
                                         '  </head>' +
                                         '  <body>' +
                                         '    <h1>REST Dataware</h1>' +
                                         '    <img src="http://www.resteasyobjects.com.br/myimages/LogoDW.png" alt="The REST Dataware logo: Powerfull Web Service.">' +
                                         '  ' +
                                         '  ' +
                                         Format('    <p>File "%s" not Found.</p>', [vFileName]) +
                                         '  </body>' +
                                         '</html>');
   Try
    vStringStream.Position := 0;
    Result.CopyFrom(vStringStream, vStringStream.Size);
   Finally
    vStringStream.Free;
   End;
  End;
end;

procedure TServerMethodDM.DWServerContext1ContextListphpReplyRequest(
  const Params: TDWParams; Var ContentType, Result: String);
var
 s : TStringlist;
begin
 s := TStringlist.Create;
 Try
  s.LoadFromFile('.\www\index_php.html');
  Result := s.Text;
 Finally
  s.Free;
 End;
end;

procedure TServerMethodDM.DWServerContext1ContextListindexReplyRequest(
  const Params: TDWParams; Var ContentType, Result: String);
var
 s : TStringlist;
begin
 s := TStringlist.Create;
 Try
  s.LoadFromFile('.\www\index.html');
  Result := s.Text;
 Finally
  s.Free;
 End;
end;

procedure TServerMethodDM.DWServerContext1ContextListangularReplyRequest(
  const Params: TDWParams; Var ContentType, Result: String);
var
 s : TStringlist;
begin
 s := TStringlist.Create;
 Try
  s.LoadFromFile('.\www\dw_angular.html');
  Result := s.Text;
 Finally
  s.Free;
 End;
end;

procedure TServerMethodDM.DWServerEvents1EventsservertimeReplyEvent(
  Var Params: TDWParams; Var Result: String);
begin
 If Params.ItemsString['inputdata'].AsString <> '' Then //servertime
  Params.ItemsString['result'].AsDateTime := Now
 Else
  Params.ItemsString['result'].AsDateTime := Now - 1;
 Params.ItemsString['resultstring'].AsString := 'testservice';
end;

procedure TServerMethodDM.Server_FDConnectionBeforeConnect(Sender: TObject);
Var
 porta_BD,
 servidor,
 database,
 pasta,
 usuario_BD,
 senha_BD      : String;
Begin
 servidor      := RestDWForm.DatabaseIP;
 database      := RestDWForm.edBD.Text;
 pasta         := IncludeTrailingPathDelimiter(RestDWForm.edPasta.Text);
 porta_BD      := RestDWForm.edPortaBD.Text;
 usuario_BD    := RestDWForm.edUserNameBD.Text;
 senha_BD      := RestDWForm.edPasswordBD.Text;
 RestDWForm.DatabaseName := pasta + database;
 TIBConnection(Sender).HostName     := Servidor;
 TIBConnection(Sender).DatabaseName := RestDWForm.DatabaseName;
 TIBConnection(Sender).UserName     := usuario_BD;
 TIBConnection(Sender).Password     := senha_BD;
end;

end.
