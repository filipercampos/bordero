import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class NumberUtil {
  /// Converte string para inteiro
  static int toInt(String value) {
    if (value.isEmpty || value.contains(",") || value.contains(".")) {
      return 0;
    }
    return int.parse(value);
  }

  // Converte string para double
  static double toDouble(String value, {int scale = 0}) {
    value = _validateDecimal(value);
    if (scale > 0) {
      return double.parse(double.parse(value).toStringAsFixed(2));
    }

    return double.parse(value);
  }

  // Converte string para Decimal
  static double toDoubleDecimal(String value, {int scale = 2}) {
    return toDecimal(value, scale: scale).toDouble();
  }

  // Converte string para Decimal
  static Decimal toDecimal(String value, {int scale = 2}) {
    value = _validateDecimal(value);

    if (scale == 0) {
      return Decimal.parse(value);
    } else {
      return Decimal.parse(Decimal.parse(value).toStringAsFixed(scale));
    }
  }

  // Converte double para Decimal
  static Decimal toDecimalFromDouble(double value, {int scale = 2}) {
    if (value == null) {
      return Decimal.zero;
    }

    if (scale == 0) {
      return Decimal.parse(value.toString());
    } else {
      return Decimal.parse(
          Decimal.parse(value.toString()).toStringAsFixed(scale));
    }
  }

  static String toFormatCurrency(double value) {
    return NumberFormat.currency().format(value);
  }

  static String toFormatBr(double value) {
    return NumberFormat("#,##0.00", "pt_BR").format(value);
  }

  static String toDoubleFormatBr(double value) {
    return NumberFormat("#,##0.00", "pt_BR").format(value);
  }

  static String _validateDecimal(String value) {
    if (value == null || value.isEmpty) {
      return "0";
    }
    if (value.contains(",")) {
      value = value.replaceAll(".", "");
      value = value.replaceAll(",", ".");
    }
    return value;
  }
}
