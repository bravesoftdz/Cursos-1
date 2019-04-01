unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDWAbout, uRESTDWPoolerDB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uDWConstsData, Vcl.StdCtrls, uDWDataset, Vcl.Mask, Vcl.DBCtrls, Data.DB,
  uRESTDWBase, uRESTDWServerEvents;

type
  TForm3 = class(TForm)
    Button1: TButton;
    RESTDWDataBase1: TRESTDWDataBase;
    RESTDWClientSQL1: TRESTDWClientSQL;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button2: TButton;
    DBEdit1: TDBEdit;
    RESTDWClientSQL1id: TIntegerField;
    RESTDWClientSQL1id_endereco: TIntegerField;
    RESTDWClientSQL1nome_completo: TWideStringField;
    RESTDWClientSQL1nome_usuario: TWideStringField;
    RESTDWClientSQL1email: TWideStringField;
    RESTDWClientSQL1cpfcnpj: TWideStringField;
    RESTDWClientSQL1senha: TWideStringField;
    RESTDWClientSQL1foto: TBlobField;
    RESTDWClientSQL1id_estabelecimento: TIntegerField;
    RESTDWClientSQL1tipo: TWideStringField;
    Button3: TButton;
    Button4: TButton;
    DWClientEvents1: TDWClientEvents;
    RESTClientPooler1: TRESTClientPooler;
    Button5: TButton;
    DWMemtable1: TDWMemtable;
    DBGrid2: TDBGrid;
    DataSource2: TDataSource;
    Label1: TLabel;
    RESTDWClientSQL2: TRESTDWClientSQL;
    DataSource3: TDataSource;
    DBGrid3: TDBGrid;
    DBEdit2: TDBEdit;
    RESTDWClientSQL2id: TIntegerField;
    RESTDWClientSQL2fantasia: TWideStringField;
    RESTDWClientSQL2razao_social: TWideStringField;
    RESTDWClientSQL2foto_logotipo: TBlobField;
    RESTDWClientSQL2id_endereco: TIntegerField;
    Button6: TButton;
    Button7: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure RESTDWClientSQL1BeforeOpen(DataSet: TDataSet);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  UDWJsonObject, UDWConsts;


{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  DataSource1.DataSet     := RESTDWClientSQL1;
  RESTDWClientSQL1.Active := True;

  DataSource3.DataSet     := RESTDWClientSQL2;
  RESTDWClientSQL2.Active := True;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  RESTDWClientSQL1.Edit;
end;

procedure TForm3.Button3Click(Sender: TObject);
var
  vError: string;
begin
  if RESTDWClientSQL1.State in [dsEdit, dsInsert] then
    RESTDWClientSQL1.Post;

  if not RESTDWClientSQL1.ApplyUpdates(vError) then
    ShowMessage('Erro ao aplicar os dados: ' + vError);
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
  RESTDWClientSQL1.Active := False;
  RESTDWClientSQL2.Active := False;
end;

procedure TForm3.Button5Click(Sender: TObject);
var
dwParams: TDWParams ;
jsonvalue: TjsonValue;
vError: String;
begin
  DWClientEvents1.CreateDWParams('gettable',dwparams);
  DWClientEvents1.SendEvent('gettable',dwparams,vError);

    try
     jsonvalue:= TJSONValue.Create ;
     jsonvalue.WriteToDataset(dtFull, dwParams.itemsString['result'].AsString,DWMemtable1);
     DataSource2.DataSet := DWMemtable1;
    finally
     jsonvalue.Free;
    end;
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  RESTDWClientSQL2.Edit;
end;

procedure TForm3.Button7Click(Sender: TObject);
var
  sErro : string;
begin
  if RESTDWClientSQL2.State in [dsEdit, dsInsert] then
    RESTDWClientSQL2.Post;

  if RESTDWClientSQL2.ApplyUpdates(sErro)
  then ShowMessage('Gravado com sucesso')
  else ShowMessage('Erro ao gravar: ' + sErro);
end;

procedure TForm3.RESTDWClientSQL1BeforeOpen(DataSet: TDataSet);
begin
//RESTDWClientSQL1.FieldDefs.Clear;
//RESTDWClientSQL1.Fields.Clear;
end;

end.
