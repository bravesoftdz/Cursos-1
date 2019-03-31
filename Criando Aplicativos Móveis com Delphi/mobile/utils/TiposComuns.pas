unit TiposComuns;

interface

type
  TTipoMensagemIcone  = (tmiInformacao, tmiConfirmacao, tmiAviso, tmiErro, tmiNenhum);
  TTipoMensagemBotao  = (tmbOk, tmbYesNo);

  TProcedureWithObject = reference to procedure(const aSender: TObject);

implementation

end.
