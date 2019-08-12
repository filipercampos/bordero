import 'package:decimal/decimal.dart';

class NumberUtil{

  /// Converte string para inteiro
  static int toInt(String value){

    if(value.isEmpty || value.contains(",") || value.contains(".")) {
      return 0;
    }
    return int.parse(value);
  }

  // Converte string para double
  static double toDouble(String value){

    if(value.isEmpty ) {
      return 0.0;
    }
    value = value.replaceAll(",", "");
    return double.parse(value);
  }

  // Converte string para Decimal
  static Decimal toDecimal(String value, {int scale=2}){

    if(value.isEmpty ) {
      return Decimal.parse("0");
    }
    value = value.replaceAll(",", "");

    if(scale == 0) {
      return Decimal.parse(value);
    }else{
      return Decimal.parse(Decimal.parse(value).toStringAsFixed(scale));
    }
  }
}