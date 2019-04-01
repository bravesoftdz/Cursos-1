unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, REST.Backend.PushTypes,
  System.JSON, REST.Backend.EMSPushDevice, System.PushNotification,
  REST.Backend.EMSProvider, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Backend.BindSource, REST.Backend.PushDevice;

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
    procedure PushEvents1DeviceTokenReceived(Sender: TObject);
    procedure PushEvents1PushReceived(Sender: TObject; const AData: TPushData);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

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
    end;
  finally
    Notificacao.DisposeOf;
    Notificacao := nil;
  end;
end;

procedure TForm1.PushEvents1DeviceTokenReceived(Sender: TObject);
begin
  memoDeviceToken.Lines.Clear;
  memoDeviceToken.Lines.Add(PushEvents1.DeviceToken);

  memoDeviceID.Lines.Clear;
  memoDeviceID.Lines.Add(PushEvents1.DeviceID);
end;

procedure TForm1.PushEvents1PushReceived(Sender: TObject;
  const AData: TPushData);

var
  I : Integer;
begin
  memoMensagem.Lines.Clear;
  memoMensagem.Lines.Add(AData.Message);
  memoMensagem.Lines.Add('-------------');
  memoMensagem.Lines.Add(EmptyStr);

  for I := 0 to Pred(AData.Extras.Count) do
    memoMensagem.Lines.Add(AData.Extras[I].Key + ' - ' + AData.Extras[I].Value);

end;

end.
