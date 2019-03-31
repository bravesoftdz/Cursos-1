unit UntBase;

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
  FMX.Dialogs;

type
  TFrmBase = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ComboBoxEnter(Sender: TObject);
  end;

var
  FrmBase: TFrmBase;

implementation

{$R *.fmx}

procedure TFrmBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := TCloseAction.caFree;
end;

procedure TFrmBase.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
//  if (Key = vkReturn) then
//  begin
//    Key := vkTab;
//    KeyDown(Key, KeyChar, Shift);
//  end;
end;

procedure TFrmBase.ComboBoxEnter(Sender: TObject);
begin
  //TComboBox(Sender).DropDown;
end;

end.
