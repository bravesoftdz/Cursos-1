unit UMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Layouts,
  FMX.StdCtrls,

  FMXDelphiZXIngQRCode,

  Math, FMX.ScrollBox, FMX.Memo, FMX.TabControl,

  Winsoft.FireMonkey.Obr, System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions;

type
  TForm1 = class(TForm)
    edtText1: TEdit;
    cmbEnconding: TComboBox;
    edtQuietZone: TEdit;
    imgQRCode: TImage;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ToolBar1: TToolBar;
    Button1: TButton;
    edtText2: TEdit;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ToolBar2: TToolBar;
    Button2: TButton;
    Memo1: TMemo;
    Image1: TImage;
    FObr1: TFObr;
    ActionList1: TActionList;
    tkcactionLeitura: TTakePhotoFromCameraAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtText1Change(Sender: TObject);
    procedure cmbEncondingChange(Sender: TObject);
    procedure edtQuietZoneChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tkcactionLeituraDidCancelTaking;
    procedure tkcactionLeituraDidFinishTaking(Image: TBitmap);
  private
    { Private declarations }
    QRCodeBitmap : TBitmap;
    strDados     : TStringList;
  public
    { Public declarations }
    procedure Update;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  //Atualiza a StringList
  strDados.Clear;
  strDados.Add('  ' + edtText1.Text);
  strDados.Add(edtText2.Text);
  strDados.Add('(+55) (11) 9-8288-6464');
  strDados.Add('tdevrocks@tdevrocks.com.br');
  Update;
end;

procedure TForm1.cmbEncondingChange(Sender: TObject);
begin
  Update;
end;

procedure TForm1.edtQuietZoneChange(Sender: TObject);
begin
  Update;
end;

procedure TForm1.edtText1Change(Sender: TObject);
begin
  Update;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  strDados := TStringList.Create;
  strDados.Add(edtText1.Text);
  strDados.Add(edtText2.Text);
  QRCodeBitmap := TBitmap.Create;
  Update;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  QRCodeBitmap.Free;
  strDados.Free;
end;

procedure TForm1.tkcactionLeituraDidCancelTaking;
begin
  Memo1.Lines.Clear;
end;

procedure TForm1.tkcactionLeituraDidFinishTaking(Image: TBitmap);
var
  I: Integer;
  Barcode : TObrSymbol;
begin
  //
  Memo1.Lines.Clear;

  Image1.Bitmap.Assign(Image);

  FObr1.Active := True;
  FObr1.Picture.Assign(Image1.Bitmap);
  FObr1.Scan;

  if FObr1.BarcodeCount = 0 then
    Memo1.Lines.Add('QRCode inválido ou não lido')
  else
    for I := 0 to Pred(FObr1.BarcodeCount) do
    begin
      Barcode := FObr1.Barcode[I];
      Memo1.Lines.Append(
        Barcode.SymbologyName + Barcode.SymbologyAddonName + ' ' +
        Barcode.OrientationName + ' ' + Barcode.DataUtf8
      );
    end;
 end;

procedure TForm1.Update;
const
  downsizeQuality : Integer = 2; // bigger value, better quality, slower rendering
var
  QRCode          : TDelphiZXingQRCode;
  Row, Column     : Integer;
  pixelColor      : TAlphaColor;
  vBitMapData     : TBitmapData;
  pixelCount      : Integer;
  y               : Integer;
  x               : Integer;
  columnPixel     : Integer;
  rowPixel        : Integer;

  function GetPixelCount(AWidth, AHeight: Single): Integer;
  begin
    if QRCode.Rows > 0 then
      Result := Trunc(Min(AWidth, AHeight)) div QRCode.Rows
    else
      Result := 0;
  end;
begin
  QRCode := TDelphiZXingQRCode.Create;
  try
    //Personalizar os dados que vão para o QRCode
    QRCode.Data      := strDados.Text;
    //////////////////////////////////////////////

    QRCode.Encoding  := TQRCodeEncoding(cmbEnconding.ItemIndex);
    QRCode.QuietZone := StrToIntDef(edtQuietZone.Text, 4);
    pixelCount       := GetPixelCount(imgQRCode.Width, imgQRCode.Height);

    case imgQRCode.WrapMode of
      TImageWrapMode.iwOriginal,TImageWrapMode.iwTile,TImageWrapMode.iwCenter:
      begin
        if pixelCount > 0 then
          imgQRCode.Bitmap.SetSize(QRCode.Columns * pixelCount,
            QRCode.Rows * pixelCount);
      end;

      TImageWrapMode.iwFit:
      begin
        if pixelCount > 0 then
        begin
          imgQRCode.Bitmap.SetSize(QRCode.Columns * pixelCount * downsizeQuality,
            QRCode.Rows * pixelCount * downsizeQuality);
          pixelCount := pixelCount * downsizeQuality;
        end;
      end;

      TImageWrapMode.iwStretch:
        raise Exception.Create('Not a good idea to stretch the QR Code');
    end;
    if imgQRCode.Bitmap.Canvas.BeginScene then
    begin
      try
        imgQRCode.Bitmap.Canvas.Clear(TAlphaColors.White);
        if pixelCount > 0 then
        begin
          if imgQRCode.Bitmap.Map(TMapAccess.maWrite, vBitMapData)  then
          begin
            try
              for Row := 0 to QRCode.Rows - 1 do
              begin
                for Column := 0 to QRCode.Columns - 1 do
                begin
                  if (QRCode.IsBlack[Row, Column]) then
                    pixelColor := TAlphaColors.Black
                  else
                    pixelColor := TAlphaColors.White;
                  columnPixel := Column * pixelCount;
                  rowPixel := Row * pixelCount;
                  for x := 0 to pixelCount - 1 do
                    for y := 0 to pixelCount - 1 do
                      vBitMapData.SetPixel(columnPixel + x,
                        rowPixel + y, pixelColor);
                end;
              end;
            finally
              imgQRCode.Bitmap.Unmap(vBitMapData);
            end;
          end;
        end;
      finally
        imgQRCode.Bitmap.Canvas.EndScene;
      end;
    end;
  finally
    QRCode.Free;
  end;
end;
end.
