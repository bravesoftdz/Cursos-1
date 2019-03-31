unit UntDMGeral;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.StorageJSON, Data.DB,
  FireDAC.Comp.Client,

  IniFiles, FireDAC.Comp.UI;

type
  TDMGeral = class(TDataModule)
    fdConn: TFDConnection;
    fdDriverMySQL: TFDPhysMySQLDriverLink;
    fdStorageJSON: TFDStanStorageJSONLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FIP       : String;
    FPorta    : Integer;
    FDatabase : String;
    FUsuario  : String;
    FSenha    : String;
    FLib      : String;
    procedure LerConfig;
  public
    { Public declarations }
    property IP        : String  read FIP       write FIP;
    property Porta     : Integer read FPorta    write FPorta;
    property Database  : String  read FDatabase write FDatabase;
    property Usuario   : String  read FUsuario  write FUsuario;
    property Senha     : String  read FSenha    write FSenha;
    property Lib       : String  read FLib      write FLib;
  end;

var
  DMGeral: TDMGeral;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMGeral }

procedure TDMGeral.DataModuleCreate(Sender: TObject);
begin
  LerConfig;
end;

procedure TDMGeral.LerConfig;
var
  IniFile : TIniFile;
begin
  //
  try
    try
      IniFile                :=  TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');

      IP       := IniFile.ReadString('DATABASE', 'DatabasePath', EmptyStr);
      Porta    := IniFile.ReadInteger('DATABASE', 'DatabasePort', 0);
      Database := IniFile.ReadString('DATABASE', 'DatabaseName', EmptyStr);
      Usuario  := IniFile.ReadString('DATABASE', 'DatabaseUser', EmptyStr);
      Senha    := IniFile.ReadString('DATABASE', 'DatabasePass', EmptyStr);
      Lib      := IniFile.ReadString('DATABASE', 'DatabaseLib', EmptyStr);

      fdConn.Connected := False;
      fdConn.Params.Values['Database']   := Database;
      fdConn.Params.Values['Server']     := IP;
      fdConn.Params.Values['Port']       := Porta.ToString;
      fdConn.Params.Values['User_Name']  := Usuario;
      fdConn.Params.Values['Password']   := Senha;
      fdDriverMySQL.VendorLib            := Lib;
    except on E:Exception do
      begin

      end;
    end;
  finally
    //FreeAndNil(IniFile);
    IniFile.Free;
    IniFile := nil;
  end;
end;


end.
