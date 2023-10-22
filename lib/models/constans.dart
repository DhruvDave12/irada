enum MODAL_STATES { CONFIRMATION, LOADING, PROCESS }

class OpenAIResponse {
  String? name;
  String? operation;
  String? chain;
  double? amount;
  String? currency;

  OpenAIResponse(
      {required this.name,
      required this.amount,
      required this.chain,
      required this.operation,
      required this.currency});
}
