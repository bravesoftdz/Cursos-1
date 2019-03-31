unit UntInfoUsuario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UntLayoutBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions,

  System.JSON,
  System.JSON.Readers,
  System.StrUtils,
  System.NetEncoding, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ksTabControl,

  UntLib, FMX.Edit, FMX.ListBox,
  ULGTDataSetHelper,

  Funcoes;

type
  TFrmInfoUsuario = class(TFrmLayoutBase)
    lytGeral: TLayout;
    lytTopo: TLayout;
    lytFotoDados: TLayout;
    lytFoto: TLayout;
    lytDados: TLayout;
    cirFundo: TCircle;
    cirFoto: TCircle;
    lblNomeUsuario: TLabel;
    lblNomeCompleto: TLabel;
    lblCPF: TLabel;
    lblEmail: TLabel;
    imgEscolherFoto: TImage;
    rctEscolherFoto: TRectangle;
    btnCamera: TButton;
    btnGaleria: TButton;
    rctBackground: TRectangle;
    actAcoes: TActionList;
    actGaleria: TTakePhotoFromLibraryAction;
    actCamera: TTakePhotoFromCameraAction;
    btnCancelar: TButton;
    tbCtrl: TksTabControl;
    tbitemMain: TksTabItem;
    toolSupView: TToolBar;
    Label1: TLabel;
    btnMenu: TButton;
    btnEditar: TButton;
    tbitemEdicao: TksTabItem;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    ToolBar1: TToolBar;
    Label2: TLabel;
    btnBack: TButton;
    btnSalvar: TButton;
    lsboxEdicao: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    edtNomeCompleto: TEdit;
    edtEmail: TEdit;
    edtCPF: TEdit;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkPropertyToFieldText4: TLinkPropertyToField;
    LinkControlToField3: TLinkControlToField;
    LinkPropertyToFieldFillBitmapBitmap: TLinkPropertyToField;
    procedure Button3Click(Sender: TObject);
    procedure actGaleriaDidFinishTaking(Image: TBitmap);
    procedure actCameraDidFinishTaking(Image: TBitmap);
    procedure imgEscolherFotoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure rctBackgroundClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure cirFotoClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure MostrarPopup;
    procedure EsconderPopup;
    procedure AtualizarFoto(Image: TBitmap);
    procedure GravarPerfil;
  public
    { Public declarations }
  end;

var
  FrmInfoUsuario: TFrmInfoUsuario;

implementation

uses
  UntDM,
  UntDmREST;


{$R *.fmx}

procedure TFrmInfoUsuario.actCameraDidFinishTaking(Image: TBitmap);
begin
  inherited;
  AtualizarFoto(Image);
end;

procedure TFrmInfoUsuario.actGaleriaDidFinishTaking(Image: TBitmap);
begin
  inherited;
  AtualizarFoto(Image);
end;

procedure TFrmInfoUsuario.btnBackClick(Sender: TObject);
begin
  inherited;
  if DM.memUsuario.State in dsEditModes then
    DM.memUsuario.Cancel;
  TLibrary.MudarAba(tbCtrl, tbitemMain);
end;

procedure TFrmInfoUsuario.btnCancelarClick(Sender: TObject);
begin
  inherited;
  EsconderPopup;
end;

procedure TFrmInfoUsuario.btnEditarClick(Sender: TObject);
begin
  inherited;
  TLibrary.MudarAba(tbCtrl, tbitemEdicao);

end;

procedure TFrmInfoUsuario.btnSalvarClick(Sender: TObject);
begin
  inherited;
  GravarPerfil;
end;

procedure TFrmInfoUsuario.Button3Click(Sender: TObject);
begin
  inherited;
(*
  with TOpenDialog.Create(Self) do
  begin
    if execute then
    begin
      memUsuario.Active := True;
      memUsuario.Append;
      Image1.Bitmap.LoadFromFile(Filename);
      memUsuariofoto.Assign(Image1.Bitmap);
      memUsuario.Post;
    end;
  end;
*)
end;

procedure TFrmInfoUsuario.cirFotoClick(Sender: TObject);
begin
  inherited;
  {$IFDEF MSWINDOWS}
    with TOpenDialog.Create(Self) do
    begin
      if Execute then
      begin
        //cirFoto.Fill.Bitmap.Bitmap.LoadFromFile(Filename);
        if DM.memUsuario.State in [dsBrowse] then
          DM.memUsuario.Edit;

        DM.memUsuariofoto.LoadFromFile(Filename);
      end;
    end;
  {$ENDIF}
end;

procedure TFrmInfoUsuario.EsconderPopup;
begin
  rctEscolherFoto.AnimateFloat('opacity', 0);
  rctBackground.AnimateFloatWait('opacity', 0);

  rctBackground.Visible   := False;
  rctEscolherFoto.Visible := False
end;

procedure TFrmInfoUsuario.AtualizarFoto(Image: TBitmap);
begin
  //cirFoto.Fill.Bitmap.Bitmap.Assign(Image);

  if DM.memUsuario.State in [dsBrowse] then
    DM.memUsuario.Edit;

  DM.memUsuariofoto.Assign(Image);
  EsconderPopup;
end;

procedure TFrmInfoUsuario.GravarPerfil;
var
  jrContent  : TJSONArray;
begin
  //1. Validar os campos vazios
  //2. Validar o CPF offline
  //3. Validar os dados online
  if edtNomeCompleto.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Nome Completo é de preenchimento obrigatório.');
    edtNomeCompleto.SetFocus;
  end;
  if edtEmail.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Email é de preenchimento obrigatório.');
    edtEmail.SetFocus;
  end;
  if edtCPF.Text.Equals(EmptyStr) then
  begin
    ShowMessage('CPF é de preenchimento obrigatório.');
    edtCPF.SetFocus;
  end;
  if ValidaCPF(edtCPF.Text) then
  begin
    jrContent := DM.memUsuario.DataSetToJSON;
    DmREST.AtualizarPerfil(jrContent, TLibrary.ID);
  end
  else
  begin
    ShowMessage('CPF digitado inválido.');
    edtCPF.SetFocus;
  end;
end;

procedure TFrmInfoUsuario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if DM.memUsuario.State in dsEditModes then
  begin
    DM.memUsuario.Post;
    GravarPerfil;
  end;
end;

procedure TFrmInfoUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  EsconderPopup;
  tbCtrl.ActiveTab   := tbitemMain;
  tbCtrl.TabPosition := TksTabBarPosition.ksTbpNone;
  DmREST.Perfil(TLibrary.Usuario);
  //if not (DM.memUsuariofoto.IsNull) then
  //begin
    //cirFoto.Fill.Bitmap.Bitmap.Assign(DM.memUsuariofoto);
  //end;
  DM.memUsuario.Edit;
  {$IFDEF MSWINDOWS}
    btnSalvar.Width := 80;
    btnBack.Width   := 80;
  {$ENDIF}
end;

procedure TFrmInfoUsuario.imgEscolherFotoClick(Sender: TObject);
begin
  inherited;
  MostrarPopup;
end;

procedure TFrmInfoUsuario.MostrarPopup;
begin
  rctBackground.Opacity := 0;
  rctBackground.Align   := TAlignLayout.Contents;
  rctBackground.BringToFront;
  rctBackground.Visible := True;
  rctBackground.AnimateFloat('opacity', 0.5);

  rctEscolherFoto.Opacity := 0;
  rctEscolherFoto.Align   := TAlignLayout.Center;
  rctEscolherFoto.BringToFront;
  rctEscolherFoto.Visible := True;
  rctEscolherFoto.AnimateFloatWait('opacity', 1);
end;

procedure TFrmInfoUsuario.rctBackgroundClick(Sender: TObject);
begin
  inherited;
  EsconderPopup;
end;

end.
