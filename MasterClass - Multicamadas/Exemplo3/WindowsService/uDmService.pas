UNIT uDmService;

INTERFACE

USES
  SysUtils,
  Classes,
  SysTypes,
  UDWDatamodule,
  System.JSON,
  UDWJSONObject,
  Dialogs,
  ServerUtils,
  UDWConsts,
  FireDAC.Dapt,
  UDWConstsData,
  FireDAC.Phys.FBDef,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Phys.IBBase,
  FireDAC.Stan.StorageJSON,
  URESTDWPoolerDB,
  URestDWDriverFD,
  uConsts,
  //FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.ODBCBase,
  //FireDAC.Phys.MSSQL,
  Vcl.SvcMgr, uDWAbout, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet;

TYPE
  TServerMethodDM = CLASS(TServerMethodDataModule)
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    Server_FDConnection: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDTransaction1: TFDTransaction;
    FDQuery1: TFDQuery;
    PROCEDURE Server_FDConnectionBeforeConnect(Sender: TObject);
    procedure ServerMethodDataModuleReplyEvent(SendType: TSendEvent;
      Context: string; var Params: TDWParams; var Result: string;
      AccessTag: string);
  PRIVATE
    { Private declarations }
    FUNCTION ConsultaBanco(VAR Params: TDWParams): STRING; OVERLOAD;
  PUBLIC
    { Public declarations }
  END;

VAR
  ServerMethodDM: TServerMethodDM;

IMPLEMENTATION

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

FUNCTION TServerMethodDM.ConsultaBanco(VAR Params: TDWParams): STRING;
VAR
  VSQL: STRING;
  JSONValue: TJSONValue;
  FdQuery: TFDQuery;
BEGIN
  IF Params.ItemsString['SQL'] <> NIL THEN
  BEGIN
    JSONValue          := UDWJSONObject.TJSONValue.Create;
    JSONValue.Encoding := Encoding;
    IF Params.ItemsString['SQL'].Value <> '' THEN
    BEGIN
      IF Params.ItemsString['TESTPARAM'] <> NIL THEN
        Params.ItemsString['TESTPARAM'].SetValue('OK, OK');
      VSQL := Params.ItemsString['SQL'].Value;
{$IFDEF FPC}
{$ELSE}
      FdQuery := TFDQuery.Create(NIL);
      TRY
        FdQuery.Connection := Server_FDConnection;
        FdQuery.SQL.Add(VSQL);
        JSONValue.LoadFromDataset('sql', FdQuery, EncodedData);
        Result := JSONValue.ToJSON;
      FINALLY
        JSONValue.Free;
        FdQuery.Free;
      END;
{$ENDIF}
    END;
  END;
END;

procedure TServerMethodDM.ServerMethodDataModuleReplyEvent(SendType: TSendEvent;
  Context: string; var Params: TDWParams; var Result: string;
  AccessTag: string);
VAR
  JSONObject: TJSONObject;
BEGIN
  JSONObject := TJSONObject.Create;
  CASE SendType OF
    SePOST:
      BEGIN
        IF UpperCase(Context) = UpperCase('EMPLOYEE') THEN
          Result := ConsultaBanco(Params)
        ELSE
        BEGIN
          JSONObject.AddPair(TJSONPair.Create('STATUS', 'NOK'));
          JSONObject.AddPair(TJSONPair.Create('MENSAGEM', 'M�todo n�o encontrado'));
          Result := JSONObject.ToJSON;
        END;
      END;
  END;
  JSONObject.Free;
END;

PROCEDURE TServerMethodDM.Server_FDConnectionBeforeConnect(Sender: TObject);
VAR
  Servidor_BD: STRING;
  Pasta_BD: STRING;
BEGIN
 Servidor_BD := servidor;
 Pasta_BD := IncludeTrailingPathDelimiter(pasta);
 Pasta_BD := Pasta_BD + Database;
 TFDConnection(Sender).Params.Clear;
 TFDConnection(Sender).Params.Add('DriverID=FB');
 TFDConnection(Sender).Params.Add('Server=' + Servidor_BD);
 TFDConnection(Sender).Params.Add('Port=' + IntToStr(porta_BD));
 TFDConnection(Sender).Params.Add('Database=' + Pasta_BD);
 TFDConnection(Sender).Params.Add('User_Name=' + Usuario_BD);
 TFDConnection(Sender).Params.Add('Password=' + Senha_BD);
 TFDConnection(Sender).Params.Add('Protocol=TCPIP');
 TFDConnection(Sender).DriverName  := 'FB';
 TFDConnection(Sender).LoginPrompt := FALSE;
 TFDConnection(Sender).UpdateOptions.CountUpdatedRecords := False;
END;

END.
