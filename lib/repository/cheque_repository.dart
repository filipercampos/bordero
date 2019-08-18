 
import 'package:bordero/repository/repository.dart';

class ChequeRepository extends Repository {
  ChequeRepository()
      : super(
          "cheque",
          {
            "dataEmissao": "INTEGER NOT NULL",
            "dataVencimento": "INTEGER NOT NULL",
            "dataPagamento": "INTEGER",
            "valorCheque": "REAL NOT NULL",
            "taxaJuros": "REAL NOT NULL",
            "valorJuros": "REAL NOT NULL",
            "valorLiquido": "REAL NOT NULL",
            "prazo": "      INTEGER NOT NULL",
            "compensacao": "INTEGER DEFAULT 0",
            "numeroCheque": "TEXT",
            "nominal": "TEXT",
            "clientId": "INTEGER",
            "imagePath": "TEXT",
          },
        );
}
