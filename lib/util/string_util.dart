import 'dart:convert';

import 'package:crypto/crypto.dart';

class StringUtil {

  static hashSha1(String value){
    var bytes = utf8.encode(value); // data being hashed

    return sha1.convert(bytes).toString();
  }
}