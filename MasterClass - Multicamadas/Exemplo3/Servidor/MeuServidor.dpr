program MeuServidor;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UDMService in 'UDMService.pas' {DmService: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDmService, DmService);
  Application.Run;
end.
