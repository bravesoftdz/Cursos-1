unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDWAbout, uRESTDWBase, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    RESTServicePooler1: TRESTServicePooler;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  RESTServicePooler1.ServerMethodClass := TDataModule2;
  RESTServicePooler1.Active := not RESTServicePooler1.Active;
  if RESTServicePooler1.Active then
  begin
    Button1.Caption := 'Desativar';
    Label1.Caption := 'Servidor Ativo';
  end
  else
  begin
    Button1.Caption := 'Ativar';
    Label1.Caption := 'Servidor Inativo';
  end;

end;

end.
