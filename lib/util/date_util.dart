import 'package:intl/intl.dart';

class DateUtil {

  static DateTime toDate(String dateString) {
    if(dateString.isEmpty || dateString== null){
      return null;
    }
    return DateFormat("dd/MM/yyyy").parse(dateString);
  }

  /// Formata a data em formato dd/MM/yyyy
  static String toFormat(DateTime date) {
    var formatter = DateFormat('dd/MM/yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  /// Formata a data em formato yyyy-MM-dd
  static String toFormatSql(DateTime date) {
    var formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date);
    return formatted;
  }

  /// Recupera o intervalo existente entre duas datas
  static int getDiffDays(DateTime dateInit, DateTime dateEnd) {
    final difference = dateEnd.difference(dateInit).inDays;
    return difference;
  }

  /// Adiciona os dias na data informada
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// Verfica se a data é sábado
  static isSaturday(DateTime data) {
    return data.weekday == DateTime.saturday;
  }

  /// Verifica se a data é domingo
  static isSunday(DateTime data) {
    return data.weekday == DateTime.sunday;
  }

  /// Verifica se a data é um dia útil
  static isUsefulDay(DateTime data) {
    return data.weekday != DateTime.saturday && data.weekday != DateTime.sunday;
  }

  /// Recupera a data atual no primeiro dia do mês
  static firstDateFromMonth() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// Recupera a data atual no último dia do mês
  static lastDateFromMonth() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
