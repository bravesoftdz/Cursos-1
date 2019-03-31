unit UntFrameBaseLista;

interface

uses
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Objects,
  FMX.Edit,
  FMX.Effects,
  FMX.Gestures,

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants;

type
  TFrameBaseLista = class(TFrame)
    rctBack: TRectangle;
    rctItemLista: TRectangle;
    lytItemLista: TLayout;
    lytLateral: TLayout;
    lblTitulo: TLabel;
    lblSubDetail1: TLabel;
    lblSubDetail2: TLabel;
    lblSubDetail3: TLabel;
    lytLabels: TLayout;
    lytBotoes: TLayout;
    edtQtde: TEdit;
    lblQtde: TLabel;
    pthMenos: TPath;
    pthMais: TPath;
    lytMenos: TLayout;
    lytMais: TLayout;
    speMenos: TSpeedButton;
    speMais: TSpeedButton;
    gmGestos: TGestureManager;
  private
    { Private declarations }
    FIdentify : Integer;
  public
    { Public declarations }
    property Identify : Integer read FIdentify write FIdentify;
  end;

implementation

{$R *.fmx}

end.
