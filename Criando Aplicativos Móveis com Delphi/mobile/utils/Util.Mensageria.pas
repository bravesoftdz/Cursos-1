unit Util.Mensageria;

interface

uses
  System.UITYpes,

  FMX.DialogService,
  FMX.Dialogs,

  TiposComuns;

type
  TMensageria = class
    private

    public
      class procedure Mensagem(const ATexto: String; const ATipo: TTipoMensagemIcone;
        ACallBack: TInputCloseDialogProc = nil);overload;

      class procedure Mensagem(const ATexto: String; const ATipo: TMsgDlgType;
        const ACloseDialogProc: TInputCloseDialogProc);overload;
  end;


implementation

{ TMensageria }

class procedure TMensageria.Mensagem(const ATexto: String;
  const ATipo: TMsgDlgType; const ACloseDialogProc: TInputCloseDialogProc);
begin
  TDialogService.MessageDialog(ATexto, ATipo, [System.UITypes.TMsgDlgBtn.mbOk],
    System.UITypes.TMsgDlgBtn.mbOk, 0, ACloseDialogProc);
end;

class procedure TMensageria.Mensagem(const ATexto: String;
  const ATipo: TTipoMensagemIcone; ACallBack: TInputCloseDialogProc);
var
  vTpMsgIconDelphi     : TMsgDlgType;
  vTpMsgBtnDelphi      : System.UITypes.TMsgDlgButtons;
  lTpMsgBtnFocusDelphi : System.UITypes.TMsgDlgBtn;
begin
  vTpMsgBtnDelphi      := [System.UITypes.TMsgDlgBtn.mbOk];
  lTpMsgBtnFocusDelphi := System.UITypes.TMsgDlgBtn.mbOk;

  case ATipo of
    tmiInformacao  : vTpMsgIconDelphi := System.UITypes.TMsgDlgType.mtInformation;
    tmiConfirmacao :
      begin
        vTpMsgIconDelphi     := System.UITypes.TMsgDlgType.mtConfirmation;
        vTpMsgBtnDelphi      := FMX.Dialogs.mbYesNo;
        lTpMsgBtnFocusDelphi := System.UITypes.TMsgDlgBtn.mbNo;
      end;
    tmiAviso   : vTpMsgIconDelphi := System.UITypes.TMsgDlgType.mtWarning;
    tmiErro    : vTpMsgIconDelphi := System.UITypes.TMsgDlgType.mtError;
    tmiNenhum  : vTpMsgIconDelphi := System.UITypes.TMsgDlgType.mtCustom;
  end;

  TDialogService.MessageDialog(ATexto, vTpMsgIconDelphi, vTpMsgBtnDelphi, lTpMsgBtnFocusDelphi, 0, ACallBack);
end;

end.
