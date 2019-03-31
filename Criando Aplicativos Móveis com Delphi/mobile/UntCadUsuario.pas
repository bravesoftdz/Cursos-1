unit UntCadUsuario;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.RegularExpressions,
  System.JSON,
  System.JSON.Readers,
  System.JSON.Types,

  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Layouts,
  FMX.Edit,

  REST.Json,

  UntLayoutBase,
  ksTabControl,
  Constantes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  ULGTDataSetHelper, FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.Ani;

type
  TfCadUsuario = class(TFrmLayoutBase)
    lblLogo: TLabel;
    tbCtrlMain: TksTabControl;
    tbStep1: TksTabItem;
    tbStep2: TksTabItem;
    tbStep3: TksTabItem;
    edtCPF: TEdit;
    rctStep2: TRectangle;
    lytStep1: TLayout;
    lytCPF: TLayout;
    lytBotoes: TLayout;
    lytCancelar: TLayout;
    lytStep2: TLayout;
    lblStep2: TLabel;
    rctCancelar: TRectangle;
    lblCancelar: TLabel;
    rctBackStep1: TRectangle;
    lnCPF: TLine;
    Layout1: TLayout;
    Layout2: TLayout;
    lytBotoesStep2: TLayout;
    Layout4: TLayout;
    Rectangle3: TRectangle;
    Label1: TLabel;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    Label2: TLabel;
    edtNome: TEdit;
    lnNome: TLine;
    edtEmail: TEdit;
    lnEmail: TLine;
    Layout6: TLayout;
    Layout7: TLayout;
    edtApelido: TEdit;
    lnApelido: TLine;
    edtSenha: TEdit;
    lnSenha: TLine;
    lytBotoesStep3: TLayout;
    Layout9: TLayout;
    Rectangle6: TRectangle;
    Label3: TLabel;
    Layout10: TLayout;
    Rectangle7: TRectangle;
    Label4: TLabel;
    edtConfirmaSenha: TEdit;
    lnConfirmacaoSenha: TLine;
    tbStep5: TksTabItem;
    Layout11: TLayout;
    Layout12: TLayout;
    lytBotaoStep4: TLayout;
    Rectangle8: TRectangle;
    Label5: TLabel;
    rctTop: TRectangle;
    rctBackStep2: TRectangle;
    rctBackStep3: TRectangle;
    rctBackStep4: TRectangle;
    lblCodigo: TLabel;
    memCadTempUsuario: TFDMemTable;
    memCadTempUsuariocpfcnpj: TStringField;
    memCadTempUsuarioemail: TStringField;
    memCadTempUsuariosenha: TStringField;
    memCadTempUsuariofoto: TBlobField;
    memCadTempUsuarionome_completo: TStringField;
    memCadTempUsuarionome_usuario: TStringField;
    tbStep4: TksTabItem;
    Rectangle1: TRectangle;
    cirFotoPerfil: TCircle;
    Layout8: TLayout;
    actAcoes: TActionList;
    actCamera: TTakePhotoFromCameraAction;
    actGaleria: TTakePhotoFromLibraryAction;
    lytPopUp: TLayout;
    rctPopUp: TRectangle;
    lblPopUP: TLabel;
    btnCamera: TButton;
    btnGaleria: TButton;
    btnCancelar: TButton;
    rctBack: TRectangle;
    Layout3: TLayout;
    Layout13: TLayout;
    Rectangle2: TRectangle;
    Label6: TLabel;
    Layout14: TLayout;
    Rectangle5: TRectangle;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure rctStep2Click(Sender: TObject);
    procedure Rectangle3Click(Sender: TObject);
    procedure Rectangle4Click(Sender: TObject);
    procedure Rectangle6Click(Sender: TObject);
    procedure Rectangle7Click(Sender: TObject);
    procedure rctCancelarClick(Sender: TObject);
    procedure edtCPFChangeTracking(Sender: TObject);
    procedure edtEmailChangeTracking(Sender: TObject);
    procedure rctBackClick(Sender: TObject);
    procedure cirFotoPerfilClick(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure actCameraDidFinishTaking(Image: TBitmap);
    procedure actGaleriaDidFinishTaking(Image: TBitmap);
  private
    { Private declarations }
    procedure MostrarBackground;
    procedure OcultarBackground;
    procedure MostrarPopup;
    procedure OcultarPopup;
    procedure EscolherFoto(Image: TBitmap);
  public
    { Public declarations }
  end;

var
  fCadUsuario: TfCadUsuario;

implementation

uses
  UntLib,
  UntPrincipal,
  Funcoes, UntDmREST;

{$R *.fmx}

procedure TfCadUsuario.edtEmailChangeTracking(Sender: TObject);
begin
  inherited;
  TLibrary.ValidarCampo(edtEmail, lnEmail, tvEmail);
end;

procedure TfCadUsuario.actCameraDidFinishTaking(Image: TBitmap);
begin
  inherited;
  EscolherFoto(Image);
end;

procedure TfCadUsuario.EscolherFoto(Image: TBitmap);
begin
  cirFotoPerfil.Fill.Bitmap.Bitmap.Assign(Image);
  OcultarBackground;
  OcultarPopup;
end;
procedure TfCadUsuario.actGaleriaDidFinishTaking(Image: TBitmap);
begin
  inherited;
  EscolherFoto(Image);
end;

procedure TfCadUsuario.btnCancelarClick(Sender: TObject);
begin
  inherited;
  OcultarBackground;
  OcultarPopup;
end;

procedure TfCadUsuario.cirFotoPerfilClick(Sender: TObject);
begin
  inherited;
  {$IFDEF MSWINDOWS}
    with TOpenDialog.Create(Self) do
    begin
      if Execute then
        cirFotoPerfil.Fill.Bitmap.Bitmap.LoadFromFile(Filename);
    end;
  {$ELSE}
    MostrarPopup;
  {$ENDIF}
end;

procedure TfCadUsuario.edtCPFChangeTracking(Sender: TObject);
begin
  inherited;
  TLibrary.ValidarCampo(edtCPF, lnCPF, tvCPF);
end;

procedure TfCadUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  tbCtrlMain.TabPosition := TksTabBarPosition.ksTbpNone;
  tbCtrlMain.ActiveTab   := tbStep1;
  OcultarBackground;
  OcultarPopup;
end;

procedure TfCadUsuario.MostrarBackground;
begin
  rctBack.Visible := True;
  rctBack.Align   := TAlignLayout.Contents;
  rctBack.BringToFront;
  rctBack.AnimateFloat('OPACITY', 0.5);
end;

procedure TfCadUsuario.MostrarPopup;
begin
  MostrarBackground;
  lytPopUp.Visible := True;
  lytPopUp.Width   := Self.Width - 20;
  lytPopUp.Position.X := (Self.Width / 2) - (lytPopUp.Width / 2);
  lytPopUp.Position.Y := lblLogo.Height + 20;
  lytPopUp.BringToFront;
  lytPopUp.AnimateFloat('OPACITY', 1);
end;

procedure TfCadUsuario.OcultarBackground;
begin
  rctBack.AnimateFloat('OPACITY', 0);
  rctBack.Visible := False;
  rctBack.Align   := TAlignLayout.None;
end;

procedure TfCadUsuario.OcultarPopup;
begin
  lytPopUp.AnimateFloat('OPACITY', 0);
  lytPopUp.Visible := False;
  OcultarBackground;
end;

procedure TfCadUsuario.rctBackClick(Sender: TObject);
begin
  inherited;
  OcultarBackground;
  OcultarPopup;
end;

procedure TfCadUsuario.rctCancelarClick(Sender: TObject);
begin
  inherited;
  TLibrary.ActiveForm := nil;
  TLibrary.MudarAba(fPrincipal.tbCtrlMain, fPrincipal.tbitemLogin);
  Close;
end;

procedure TfCadUsuario.rctStep2Click(Sender: TObject);
begin
  inherited;
  if edtCPF.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Campo CPF é de uso obrigatório.');
    edtCPF.SetFocus;
  end
  else
  begin
    if not (ValidaCPF(edtCPF.Text)) then
    begin
      ShowMessage('CPF inválido.');
      edtCPF.SetFocus;
    end
    else
      TLibrary.MudarAba(tbCtrlMain, tbStep2);
  end;
end;

procedure TfCadUsuario.Rectangle2Click(Sender: TObject);
begin
  inherited;
  TLibrary.MudarAba(tbCtrlMain, tbStep3);
end;

procedure TfCadUsuario.Rectangle3Click(Sender: TObject);
begin
  inherited;
  TLibrary.MudarAba(tbCtrlMain, tbStep1);
end;

procedure TfCadUsuario.Rectangle4Click(Sender: TObject);
begin
  inherited;
  if edtNome.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Campo Nome Completo é de preenchimento obrigatório.');
    edtNome.SetFocus;
    exit;
  end;

  if edtEmail.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Campo Email é de preenchimento obrigatório.');
    edtEmail.SetFocus;
    exit;
  end;

  TLibrary.MudarAba(tbCtrlMain, tbStep3);
end;

procedure TfCadUsuario.Rectangle5Click(Sender: TObject);
var
  jrContent : TJSONArray;
begin
  inherited;
  //Validar usuário no servidor
  try
    memCadTempUsuario.Active := not memCadTempUsuario.Active;
    memCadTempUsuario.Append;
    memCadTempUsuario.FieldByName('cpfcnpj').AsString       := edtCPF.Text;
    memCadTempUsuario.FieldByName('nome_completo').AsString := edtNome.Text;
    memCadTempUsuario.FieldByName('email').AsString         := edtEmail.Text;
    memCadTempUsuario.FieldByName('nome_usuario').AsString  := edtApelido.Text;
    memCadTempUsuario.FieldByName('senha').AsString         := edtSenha.Text;

    if not (cirFotoPerfil.Fill.Bitmap.Bitmap.IsEmpty)  then
      memCadTempUsuariofoto.Assign(cirFotoPerfil.Fill.Bitmap.Bitmap);

    memCadTempUsuario.Post;

    jrContent := memCadTempUsuario.DataSetToJSON;
    DmREST.RegistrarUsuario(jrContent);

    TLibrary.MudarAba(tbCtrlMain, tbStep5);
  finally
    if Assigned(jrContent) then
      jrContent.DisposeOf;
  end;
end;

procedure TfCadUsuario.Rectangle6Click(Sender: TObject);
begin
  inherited;
  TLibrary.MudarAba(tbCtrlMain, tbStep2);
end;

procedure TfCadUsuario.Rectangle7Click(Sender: TObject);
var
  jrContent         : TJSONArray;
begin
  inherited;
  if edtApelido.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Campo Usuário é de preenchimento obrigatório.');
    edtApelido.SetFocus;
    exit;
  end;

  if edtSenha.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Campo Senha é de preenchimento obrigatório.');
    edtSenha.SetFocus;
    exit;
  end;

  if edtConfirmaSenha.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Campo Confirmação de Senha é de preenchimento obrigatório.');
    edtConfirmaSenha.SetFocus;
    exit;
  end;

  if not (edtSenha.Text.Equals(edtConfirmaSenha.Text)) then
  begin
    ShowMessage('Os campos Senha e Confirmação de Senha precisam ser iguais.');
    edtConfirmaSenha.SetFocus;
    exit;
  end;

  TLibrary.MudarAba(tbCtrlMain, tbStep4);
end;

end.
