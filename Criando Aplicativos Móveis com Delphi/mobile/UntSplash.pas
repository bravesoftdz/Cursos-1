unit UntSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Devices,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Effects, FMX.Objects;

type
  TfSplash = class(TForm)
    rctBackground: TRectangle;
    BlurEffect1: TBlurEffect;
    rctOfuscaImagem: TRectangle;
    lytBottom: TLayout;
    lytVersao: TLayout;
    lytIndicador: TLayout;
    aniAguarde: TAniIndicator;
    lblVersao: TLabel;
    StartUpTimer: TTimer;
    imgLogo: TImage;
    Layout1: TLayout;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure imgLogoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure StartUpTimerTimer(Sender: TObject);
  private
    { Private declarations }
    FInitialized : Boolean;
    procedure LoadMainForm;
  public
    { Public declarations }
  end;

var
  fSplash: TfSplash;

implementation

uses
  UntPrincipal,
  TiposComuns,
  Util.Mensageria;

{$R *.fmx}

{ TfSplash }

procedure TfSplash.FormCreate(Sender: TObject);
begin
  lblVersao.Text       := 'v.1.0.1';
  StartUpTimer.Enabled := False;
  aniAguarde.Enabled   := True;

  {$IFDEF DEBUG}
    StartUpTimer.Interval := 100;
  {$ELSE}
    StartUpTimer.Interval := 3000;
  {$ENDIF}
end;

procedure TfSplash.imgLogoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  StartupTimer.Enabled := not FInitialized;
end;

procedure TfSplash.LoadMainForm;
type
  TFormClass = class of TForm;
var
  FRM      : TForm;
  FrmClass : TFormClass;
begin
  FrmClass := nil;

  case TDeviceInfo.ThisDevice.DeviceClass of
    TDeviceInfo.TDeviceClass.Desktop : FrmClass := TfPrincipal;
    TDeviceInfo.TDeviceClass.Phone   : FrmClass := TfPrincipal;
    TDeviceInfo.TDeviceClass.Tablet  : FrmClass := TfPrincipal;
  end;

  if FrmClass <> nil then
  begin
    FRM := FrmClass.Create(Application);
    FRM.Show;
    Application.MainForm := FRM;
  end
  else
  begin
    TMensageria.Mensagem('Esse dispositivo não é compatível!', tmiInformacao);
  end;

  Close;
end;

procedure TfSplash.StartUpTimerTimer(Sender: TObject);
begin
  StartupTimer.Enabled := False;
  if not FInitialized then
  begin
    FInitialized       := True;
    aniAguarde.Enabled := False;
    LoadMainForm;
  end;
end;

end.
