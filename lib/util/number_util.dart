import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

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
  static String toFormatCurrency(Decimal value){
    return NumberFormat.currency().format(value.toDouble());
  }

  static String toFormatBr(Decimal value){
    var format1 = NumberFormat.currency().format(value.toDouble());
    print(format1);
    final format2 = NumberFormat("#,##0.00", "pt_BR").format(value.toDouble());
    print(format2);
    return format2;
  }
}