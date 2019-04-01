unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDWAbout, uRESTDWBase, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    RESTServicePooler1: TRESTServicePooler;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uDMService;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if RESTServicePooler1.Active then
  begin
    Label1.Caption := 'Offline';
    Button1.Caption := 'Ativar';
    RESTServicePooler1.Active := False;
  end
  else
  begin
    Label1.Caption := 'Online';
    Button1.Caption := 'Desativar';
    RESTServicePooler1.Active := True;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RESTServicePooler1.ServerMethodClass := TDMService;
end;

end.
