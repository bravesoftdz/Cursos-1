unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDWAbout, uRESTDWBase, Vcl.StdCtrls,

  Unit2;

type
  TForm1 = class(TForm)
    RESTServicePooler1: TRESTServicePooler;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  RESTServicePooler1.ServerMethodClass := TDataModule2;
  RESTServicePooler1.Active := not RESTServicePooler1.Active;
  if RESTServicePooler1.Active then
  begin
    Label1.Caption := 'Servidor Ativo';
    Button1.Caption := 'Desativar';
  end
  else
  begin
    Label1.Caption := 'Servidor inativo';
    Button1.Caption := 'Ativar';
  end;
end;

end.
