class ChequeClient {
  int id;
  int clientId;
  String clientName;
  double valorCheque;
  double taxaJuros;
  double valorJuros;
  double valorLiquido;
  int prazo;

  ChequeClient.fromMap(Map<String, dynamic> json) {
    id = json["id"];
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
    return 'ChequeGroupByClient{id: $id, clientId: $clientId, clientName: $clientName, valorCheque: $valorCheque, taxaJuros: $taxaJuros, valorJuros: $valorJuros, valorLiquido: $valorLiquido, prazo: $prazo}';
  }
}
