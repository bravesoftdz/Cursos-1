unit UserSessionUnit;

{
  This is a DataModule where you can add components or declare fields that are specific to
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

uses
  IWUserSessionBase,
  SysUtils,
  Classes,

  UntDmREST,
  UntDMDados;

type
  TIWUserSession = class(TIWUserSessionBase)
    procedure IWUserSessionBaseCreate(Sender: TObject);
  private
    { Private declarations }
    FID_Usuario         : Integer;
    FID_Estabelecimento : Integer;
  public
    { Public declarations }
    DMDados : TDMDados;
    DMRest: TDMREST;

    property ID_Usuario        : Integer read FID_Usuario         write FID_Usuario;
    property ID_Estabelecimento: Integer read FID_Estabelecimento write FID_Estabelecimento;
  end;

implementation


{$R *.dfm}

procedure TIWUserSession.IWUserSessionBaseCreate(Sender: TObject);
begin
  DMRest  := TDmRest.Create(Self);
  DMDados := TDmDados.Create(Self);
end;

end.
