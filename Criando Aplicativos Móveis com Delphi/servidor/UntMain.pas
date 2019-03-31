unit UntMain;

interface

uses
  Winapi.Messages,
  WinApi.Windows,
  Winapi.ShellApi,

  System.SysUtils,
  System.Variants,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.AppEvnts,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin,

  IdHTTPWebBrokerBridge,

  Web.HTTPApp,

  Data.DB,

  Datasnap.DSSession,

  IniFiles,
  UntDMGeral;

type
  TfMain = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    EditPort: TEdit;
    ButtonStart: TButton;
    ButtonStop: TButton;
    ButtonOpenBrowser: TButton;
    DBGrid1: TDBGrid;
    memMensagens: TMemo;
    btnLimparLog: TButton;
    edtIP: TLabeledEdit;
    edtDatabase: TLabeledEdit;
    edtUsuario: TLabeledEdit;
    edtSenha: TLabeledEdit;
    edtLib: TLabeledEdit;
    spePortaDatabase: TSpinEdit;
    Label2: TLabel;
    btnVer: TButton;
    btnTestar: TButton;
    btnSalvar: TButton;
    btnSelecionar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnTestarClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnVerClick(Sender: TObject);
    procedure btnLimparLogClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure LerConfig;
    procedure SalvarConfig;
    procedure InserirLog(const AMsg: String);
    procedure StartServer;
    procedure AtualizarCredenciais;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TfMain.AtualizarCredenciais;
begin
  try
    try
      Screen.Cursor := crHourGlass;

      {DataModule Geral}
      DMGeral.fdConn.Connected := False;
      DMGeral.fdConn.Params.Values['Database']   := edtDatabase.Text;
      DMGeral.fdConn.Params.Values['Server']     := edtIP.Text;
      DMGeral.fdConn.Params.Values['Port']       := spePortaDatabase.Value.ToString;
      DMGeral.fdConn.Params.Values['User_Name']  := edtUsuario.Text;
      DMGeral.fdConn.Params.Values['Password']   := edtSenha.Text;
      DMGeral.fdDriverMySQL.VendorLib            := edtLib.Text;
      DMGeral.fdConn.Connected := True;

      InserirLog('API(s) serviços conectada(s) com sucesso!');
    except on E:Exception do
      begin
        InserirLog('Ocorreu um problema de conexão: ' + E.Message);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfMain.btnLimparLogClick(Sender: TObject);
begin
  memMensagens.Lines.Clear;
end;

procedure TfMain.btnSalvarClick(Sender: TObject);
begin
  SalvarConfig;
end;

procedure TfMain.btnSelecionarClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  begin
    DefaultExt := 'dll';
    Filter     := 'Todos os arquivos (*.*)|*.*|Dll do Banco de Dados (*.dll) | *.dll';
    if execute then
      edtLib.Text := FileName;
  end;
end;

procedure TfMain.btnTestarClick(Sender: TObject);
begin
  AtualizarCredenciais;
end;

procedure TfMain.btnVerClick(Sender: TObject);
begin
  if edtSenha.PasswordChar = '*' then
  begin
    btnVer.Caption        := 'Ocultar';
    edtSenha.PasswordChar := #0;
  end
  else
  begin
    edtSenha.PasswordChar := Char('*');
    btnVer.Caption        := 'Ver';
  end;
end;

procedure TfMain.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfMain.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfMain.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  memMensagens.Lines.Clear;
  LerConfig;
  AtualizarCredenciais;
  StartServer;
end;

procedure TfMain.InserirLog(const AMsg: String);
begin
  memMensagens.Lines.Add(Format('%s : %s', [FormatDateTime('YYYY-MM-DD hh:mm', Now), AMsg]));
end;

procedure TfMain.LerConfig;
var
  IniFile : TIniFile;
begin
  //
  try
    try
      IniFile                :=  TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');

      edtIP.Text             := IniFile.ReadString('DATABASE', 'DatabasePath', EmptyStr);
      spePortaDatabase.Value := IniFile.ReadInteger('DATABASE', 'DatabasePort', 0);
      edtDatabase.Text       := IniFile.ReadString('DATABASE', 'DatabaseName', EmptyStr);
      edtUsuario.Text        := IniFile.ReadString('DATABASE', 'DatabaseUser', EmptyStr);
      edtSenha.Text          := IniFile.ReadString('DATABASE', 'DatabasePass', EmptyStr);

      edtLib.Text            := IniFile.ReadString('DATABASE', 'DatabaseLib', EmptyStr);
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

procedure TfMain.SalvarConfig;
var
  IniFile : TIniFile;
begin
  //
  try
    try
      IniFile                :=  TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');

      IniFile.WriteString('DATABASE', 'DatabasePath', edtIP.Text);
      IniFile.WriteInteger('DATABASE', 'DatabasePort', spePortaDatabase.Value);
      IniFile.WriteString('DATABASE', 'DatabaseName', edtDatabase.Text);
      IniFile.WriteString('DATABASE', 'DatabaseUser', edtUsuario.Text);
      IniFile.WriteString('DATABASE', 'DatabasePass', edtSenha.Text);

      IniFile.WriteString('DATABASE', 'DatabaseLib', edtLib.Text);
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

procedure TfMain.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.

end;
