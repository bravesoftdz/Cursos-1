unit uMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.JSON,
  System.PushNotification,
  System.Threading,
//  System.UTF8Decode,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls.Presentation,

  REST.Backend.PushTypes,
  REST.Backend.EMSPushDevice,
  REST.Backend.EMSProvider,
  REST.Backend.BindSource,
  REST.Backend.PushDevice,

  Data.Bind.Components,
  Data.Bind.ObjectScope;

const
  C_APPID = '271332362079';

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    memoDeviceToken: TMemo;
    memoDeviceID: TMemo;
    memoMensagem: TMemo;
    Button1: TButton;
    PushEvents1: TPushEvents;
    EMSProvider1: TEMSProvider;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    PushService       : TPushService;
    ServiceConnection : TPushServiceConnection;
    procedure DoServiceConnectionChange(Sender: TObject; PushChanges: TPushService.TChanges);
    procedure DoReceiveNotificationEvent(Sender: TObject; const ServiceNotification: TPushServiceNotification);
    procedure LerNotificacoes;
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.DoReceiveNotificationEvent(Sender: TObject; const ServiceNotification: TPushServiceNotification);
var
  sMsg      : String;
  I         : Integer;
begin
  //sMsg := ServiceNotification.DataObject.GetValue('message').Value;
  try
    for I := 0 to Pred(ServiceNotification.DataObject.Count) do
    begin
      //iOS
      if ServiceNotification.DataKey.Equals('aps') then
      begin
        if ServiceNotification.DataObject.Pairs[I].JsonString.Value.Equals('alert') then
          sMsg := ServiceNotification.DataObject.Pairs[I].JsonValue.Value;
      end;

      //Android
      if ServiceNotification.DataKey.Equals('gcm') then
      begin
        if ServiceNotification.DataObject.Pairs[I].JsonString.Value.Equals('message') then
          sMsg := ServiceNotification.DataObject.Pairs[I].JsonValue.Value;
      end;
    end;

    memoMensagem.Lines.Clear;
    memoMensagem.Lines.Add(sMsg);
  except on E:Exception do
    begin
      //ShowMessage(E.Message);
    end;
  end;
end;

procedure TForm1.DoServiceConnectionChange(Sender: TObject; PushChanges: TPushService.TChanges);
var
  sToken    : string;
  sDeviceID : string;
begin
  if TPushService.TChange.DeviceToken in PushChanges then
  begin
    sToken    := PushService.DeviceTokenValue[TPushService.TDeviceTokenNames.DeviceToken];
    sDeviceID := PushService.DeviceTokenValue[TPushService.TDeviceIDNames.DeviceID];
  end;

  memoDeviceToken.Lines.Clear;
  memoDeviceToken.Lines.Add(sToken);

  memoDeviceID.Lines.Clear;
  memoDeviceID.Lines.Add(sDeviceID);
  //ToGo: RegitrarDevice(sToken);
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  Notificacao : TPushData;
  I           : Integer;
begin
  try
    Notificacao := Self.PushEvents1.StartupNotification;
    if Assigned(Notificacao) then
    begin
      if not PushEvents1.StartupNotification.GCM.Message.Equals(EmptyStr) then
      begin
        for I := 0 to Pred(Notificacao.Extras.Count) do
          memoMensagem.Lines.Add(Notificacao.Extras[I].Key + ' - ' + Notificacao.Extras[I].Value);
      end;

      if (PushEvents1.StartupNotification.APS.Alert <> '') then
      begin
        for I := 0 to Pred(Notificacao.Extras.Count) do
          memoMensagem.Lines.Add(Notificacao.Extras[I].Key + ' - ' + Notificacao.Extras[I].Value);
      end;

    end;
  finally
    Notificacao.DisposeOf;
    Notificacao := nil;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  EMSProvider1.AndroidPush.GCMAppID := C_APPID;
  {$IFDEF IOS}
    PushService := TPushServiceManager.Instance.GetServiceByName(
      TPushService.TServiceNames.APS);
  {$ELSE}
    PushService := TPushServiceManager.Instance.GetServiceByName(
      TPushService.TServiceNames.GCM);
    PushService.AppProps[TPushService.TAppPropNames.GCMAppID] := C_APPID;
  {$ENDIF}

  ServiceConnection                       := TPushServiceConnection.Create(PushService);
  ServiceConnection.Active                := True;
  ServiceConnection.OnChange              := DoServiceConnectionChange;
  ServiceConnection.OnReceiveNotification := DoReceiveNotificationEvent;

  TTask.run(
    procedure
    begin
      ServiceConnection.Active := True;
    end
  );

  //Carregar os dados DeviceToken e o DeviceID
end;

procedure TForm1.LerNotificacoes;
var
  Notificacao : TPushData;
  I           : Integer;
begin
  Notificacao := Self.PushEvents1.StartupNotification;
  try
    if Assigned(Notificacao) then
    begin
      if not (PushEvents1.StartupNotification.GCM.Message.Equals(EmptyStr)) then
      begin
        for I := 0 to Pred(Notificacao.Extras.Count) do
          memoMensagem.Lines.Add(Notificacao.Extras[I].Key + ' - ' + Notificacao.Extras[I].Value);
      end;

      if not (PushEvents1.StartupNotification.APS.Alert.Equals(EmptyStr)) then
      begin
        for I := 0 to Pred(Notificacao.Extras.Count) do
          memoMensagem.Lines.Add(Notificacao.Extras[I].Key + ' - ' + Notificacao.Extras[I].Value);
      end;
    end;
  finally
    Notificacao.DisposeOf;
  end;

end;

end.
