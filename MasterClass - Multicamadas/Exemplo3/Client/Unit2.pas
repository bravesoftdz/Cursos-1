unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.StdCtrls,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDWConstsData, uRESTDWPoolerDB,
  uDWAbout, FMX.Edit;

type
  TForm2 = class(TForm)
    RESTDWDataBase1: TRESTDWDataBase;
    RESTDWClientSQL1: TRESTDWClientSQL;
    RESTDWClientSQL1ID: TIntegerField;
    RESTDWClientSQL1NOME: TStringField;
    RESTDWClientSQL1SIGLA: TStringField;
    StringGrid1: TStringGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
begin
  RESTDWClientSQL1.Open;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  RESTDWClientSQL1.Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  RESTDWClientSQL1.Append;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  RESTDWClientSQL1.Edit;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  RESTDWClientSQL1.Post;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  RESTDWClientSQL1.Delete;
end;

procedure TForm2.Button7Click(Sender: TObject);
var
  vErro : string;
begin
  if RESTDWClientSQL1.ApplyUpdates(vErro) then
    ShowMessage('Gravado com sucesso')
  else
    ShowMessage('Erro: ' + vErro);
end;

end.
