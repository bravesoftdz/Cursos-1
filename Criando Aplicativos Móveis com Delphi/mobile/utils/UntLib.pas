unit UntLib;

interface

uses
  System.IOUtils,
  System.SysUtils,
  System.RegularExpressions,
  System.UITypes,
  System.Classes,

  FMX.Objects,
  FMX.Edit,
  FMX.Types,
  FMX.Forms,
  FMX.Multiview,
  FMX.StdCtrls,

  ksTabControl,

  IniFiles,
  Constantes;

type
  TBackground = class
    private
      class var
        FBackground    : TRectangle;
        FActionPosHide : TNotifyEvent;
      class procedure Click(Sender: TObject);
    public
      class procedure Mostrar(AParent: TFMXObject; const AActionPosHide: TNotifyEvent = nil);
      class procedure Ocultar;
  end;


  TLibrary = class
  private
    class var
      FOnLine      : Boolean;
      FUsuario     : string;
      FLembrar     : Boolean;
      FID          : Integer;
      FActiveForm  : TForm;
      FMainMenu    : TMultiview;
      FLayoutMain  : TRectangle;
  public
    {Métodos}
    class procedure MudarAba(const AksTabCtrl: TksTabControl; const AksTabItem: TksTabItem);
    class procedure ValidarCampo(const ACampo: TEdit; const ALinha: TLine;
      const ATipoValidacao: TTipoValidacao);
    class procedure LerConfig;
    class procedure SalvarConfig(const AUsuario: String; ALembrar: Boolean);
    class procedure AbrirForm(const AFormClass: TComponentClass; ATarget: TFMXObject = nil);
    {Propriedades}
    class property OnLine     : Boolean     read FOnLine     write FOnLine;
    class property Usuario    : string      read FUsuario    write FUsuario;
    class property Lembrar    : Boolean     read FLembrar    write FLembrar;
    class property ID         : Integer     read FID         write FID;
    class property ActiveForm : TForm       read FActiveForm write FActiveForm;
    class property MainMenu   : TMultiview  read FMainMenu   write FMainMenu;
    class property LayoutMain : TRectangle  read FLayoutMain write FLayoutMain;
  end;

implementation

{ TLibrary }

class procedure TLibrary.AbrirForm(const AFormClass: TComponentClass;
  ATarget: TFMXObject);
var
  oLayoutBase : TComponent;
  oBotaoMenu  : TComponent;
  I           : Integer;
begin
  if ATarget = nil then
    ATarget := LayoutMain;

  //Em desenvolvimento
  if(Assigned(FActiveForm))then
  begin
    if (FActiveForm.ClassType = AFormClass) then
    begin
      FMainMenu.HideMaster;
      Exit
    end
    else
    begin
      FActiveForm.Close;
      //FActiveForm.DisposeOf;
      //FActiveForm := nil;
    end;
  end;

  Application.CreateForm(AFormClass, FActiveForm);

  oLayoutBase := FActiveForm.FindComponent('rctClient');
  oBotaoMenu  := FActiveForm.FindComponent('btnMenu');
  if(Assigned(oLayoutBase))then
  begin
    TRectangle(ATarget).AddObject(TRectangle(OLayoutBase));
    if Assigned(oBotaoMenu) then
      FMainMenu.MasterButton := TButton(oBotaoMenu);
    FMainMenu.HideMaster;
  end;
end;

class procedure TLibrary.LerConfig;
var
  IniFile  : TIniFile;
begin
  try
    try
      IniFile  := TIniFile.Create(System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'Config.ini'));
      FUsuario := IniFile.ReadString('Credenciais', 'Usuario', FUsuario);
      FLembrar := IniFile.ReadBool('Credenciais', 'Lembrar', FLembrar);
    except on E:Exception do
      begin
        //
      end;
    end;
  finally
    IniFile.DisposeOf;
  end;
end;

class procedure TLibrary.MudarAba(const AksTabCtrl: TksTabControl;
  const AksTabItem: TksTabItem);
begin
  AksTabCtrl.FadeToTab(AksTabItem, 0);
end;


class procedure TLibrary.SalvarConfig(const AUsuario: String; ALembrar: Boolean);
var
  IniFile : TIniFile;
begin
  try
    try
      IniFile := TIniFile.Create(System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'Config.ini'));
      IniFile.WriteString('Credenciais', 'Usuario', AUsuario);
      IniFile.WriteBool('Credenciais', 'Lembrar', ALembrar);
    except on E:Exception do
      begin
        //
      end;
    end;
  finally
    IniFile.DisposeOf;
  end;
end;

class procedure TLibrary.ValidarCampo(const ACampo: TEdit; const ALinha: TLine;
  const ATipoValidacao: TTipoValidacao);
begin
  case ATipoValidacao of
    tvCPF   :
      begin
        if TEdit(ACampo).Text.Equals(EmptyStr) then
          TLine(ALinha).Stroke.Color := TAlphaColors.White
        else if TRegEx.IsMatch(TEdit(ACampo).Text, C_EXP_CPF) then
          TLine(ALinha).Stroke.Color := TAlphaColors.Springgreen
        else
          TLine(ALinha).Stroke.Color := TAlphaColors.Red;
      end;
    tvEmail :
      begin
        if TEdit(ACampo).Text.Equals(EmptyStr) then
          TLine(ALinha).Stroke.Color := TAlphaColors.White
        else if TRegEx.IsMatch(TEdit(ACampo).Text, C_EXP_EMAIL) then
          TLine(ALinha).Stroke.Color := TAlphaColors.Springgreen
        else
          TLine(ALinha).Stroke.Color := TAlphaColors.Red;
      end;
  end;
end;

{ TBackground }

class procedure TBackground.Click(Sender: TObject);
begin
  if Assigned(FActionPosHide) then
    FActionPosHide(Sender);

  Ocultar;
end;

class procedure TBackground.Mostrar(AParent: TFMXObject;
  const AActionPosHide: TNotifyEvent);
begin
  FBackground            := TRectangle.Create(nil);
  FBackground.Parent     := AParent;
  FBackground.Fill.Color := TAlphaColorRec.Black;
  FBackground.Opacity    := 0.0;
  FBackground.Visible    := True;
  FBackground.Align      := TAlignLayout.Contents;

  if Assigned(AActionPosHide) then
    FActionPosHide := AActionPosHide;

  FBackground.OnClick := Click;

  FBackground.BringToFront;
  FBackground.AnimateFloat('OPACITY', 0.4);
end;

class procedure TBackground.Ocultar;
begin
  if Assigned(FBackground) then
  begin
    FBackground.AnimateFloat('OPACITY', 0.0);
    FBackground.Visible    := False;

    FBackground.DisposeOf;
    FBackground := nil;
  end;
end;

end.
