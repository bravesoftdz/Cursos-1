unit UntPrincipal;

interface

uses
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ListBox,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Edit,

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Bluetooth,
  System.Bluetooth.Components;

//UUID para impressoras Bluetooth
const
  UUID = '{00001101-0000-1000-8000-00805F9B34FB}';

type
  TfrmPrincipal = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    ListBox1: TListBox;
    lsboxImpressora: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    cbxDevices: TComboBox;
    btnImprimir: TButton;
    BT: TBluetooth;
    Layout2: TLayout;
    procedure FormShow(Sender: TObject);
    procedure cbxDevicesChange(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    { Private declarations }
    procedure ListarDispositivosPareadosNoCombo;
    function  ObterDevicePeloNome(ANomeDevice: string) : TBluetoothDevice;
    function  ConectarImpressora(ANomeDevice: string): Boolean;
  public
    { Public declarations }
    FSocket : TBluetoothSocket;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  ssESCPOSPrintBitmap;

{$R *.fmx}

{ TfrmPrincipal }

{ TfrmPrincipal }

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
begin
  //ESC/POS
  if (FSocket <> nil) and (FSocket.Connected) then
  begin
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(64)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(97) + chr(1)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(33) + chr(8)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(33) + chr(16)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(33) + chr(32)));

    FSocket.SendData(TEncoding.UTF8.GetBytes('TDevRocks Software' + chr(13)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(100) + chr(1)));
    FSocket.SendData(TEncoding.UTF8.GetBytes('Datecs DPP 250' + chr(13)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(100) + chr(1)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(33) + chr(0)));

    FSocket.SendData(TEncoding.UTF8.GetBytes('Imprimindo direto para Bluetooth '));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(100) + chr(1)));
    FSocket.SendData(TEncoding.UTF8.GetBytes('Imprimindo direto para Bluetooth '));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(100) + chr(1)));

    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(97) + chr(0)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(100) + chr(5)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(29) + chr(107) + chr(2) + '8983847583721' + chr(0)));
    FSocket.SendData(TEncoding.UTF8.GetBytes(chr(27) + chr(100) + chr(5)));
  end;
end;

procedure TfrmPrincipal.cbxDevicesChange(Sender: TObject);
begin
  if (cbxDevices.Selected <> nil) and (cbxDevices.Selected.Text <> EmptyStr) then
  begin
    if ConectarImpressora(cbxDevices.Selected.Text)
    then lsboxImpressora.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark
    else lsboxImpressora.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
  end;
end;

function TfrmPrincipal.ConectarImpressora(ANomeDevice: string): Boolean;
var
  lDevice : TBluetoothDevice;
begin
  Result := False;
  lDevice := ObterDevicePeloNome(ANomeDevice);
  if lDevice <> nil then
  begin
    FSocket := lDevice.CreateClientSocket(StringToGUID(UUID), False);
    if FSocket <> nil then
    begin
      FSocket.Connect; //Conectando-se a impressora
      Result := FSocket.Connected;
    end;
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  ListarDispositivosPareadosNoCombo;
end;

procedure TfrmPrincipal.ListarDispositivosPareadosNoCombo;
var
  lDevice : TBluetoothDevice;
begin
  cbxDevices.Clear;
  for lDevice in BT.PairedDevices do
    cbxDevices.Items.Add(lDevice.DeviceName);
end;

function TfrmPrincipal.ObterDevicePeloNome(
  ANomeDevice: string): TBluetoothDevice;
var
  lDevice : TBluetoothDevice;
begin
  Result := nil;
  for lDevice in BT.PairedDevices do
    if lDevice.DeviceName.Equals(ANomeDevice) then
      Result := lDevice;
end;

end.
