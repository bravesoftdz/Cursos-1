unit Server.Utils;

interface

uses
  Data.DBXPlatform;

type
  TServerUtils = class
    private

    public
      class procedure FormatJSON(const ACode: Integer; const AContent : string);
  end;

implementation

{ TServerUtils }

class procedure TServerUtils.FormatJSON(const ACode: Integer;
  const AContent: string);
begin
  GetInvocationMetadata().ResponseCode    := ACode;
  GetInvocationMetadata().ResponseContent := AContent;
end;

end.
