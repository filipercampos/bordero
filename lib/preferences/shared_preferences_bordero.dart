import 'package:bordero/enums/cheque_view_type.dart';
import 'package:bordero/util/enum_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceBordero {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _kSortingOrderPrefs = "sortOrder";
  final String _kViewChequesPrefs = "viewScreen";

  /// ------------------------------------------------------------
  /// Method that returns the user decision to allow notifications
  /// ------------------------------------------------------------
  Future<ChequeViewType> getViewCheques() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return EnumUtil.getEnumFromString(
            ChequeViewType.values, prefs.getString(_kViewChequesPrefs)) ??
        ChequeViewType.CHEQUES;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision to allow notifications
  /// ----------------------------------------------------------
  Future<bool> setViewCheques(ChequeViewType value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kViewChequesPrefs, value.toString());
  }

  /// ------------------------------------------------------------
  /// Method that returns the user decision on sorting order
  /// ------------------------------------------------------------
  Future<String> getSortingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_kSortingOrderPrefs) ?? 'name';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision on sorting order
  /// ----------------------------------------------------------
  Future<bool> setSortingOrder(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kSortingOrderPrefs, value);
  }
}
