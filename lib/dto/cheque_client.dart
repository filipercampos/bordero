class ChequeClient {
  int clientId;
  String clientName;
  double valorCheque;
  double taxaJuros;
  double valorJuros;
  double valorLiquido;
  int prazo;

  ChequeClient.fromMap(Map<String, dynamic> json) {
    clientId = json["clientId"];
    clientName = json["name"];
    valorCheque = json["valorCheque"];
    taxaJuros = json["taxaJuros"];
    valorJuros = json["valorJuros"];
    valorLiquido = json["valorLiquido"];
    prazo = json["prazo"];
    clientId = json["clientId"];
  }

  @override
  String toString() {
    return 'ChequeGroupByClient{clientId: $clientId, clientName: $clientName, valorCheque: $valorCheque, taxaJuros: $taxaJuros, valorJuros: $valorJuros, valorLiquido: $valorLiquido, prazo: $prazo}';
  }
}
