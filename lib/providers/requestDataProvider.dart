import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './auth.dart';
import 'package:path/path.dart';

// class RequestDataProvider {
class RequestDataProvider with ChangeNotifier {
  static const ip = 'http://10.0.190.191:51/';

  static Map<String, String> langHeader = {
    "user-language": "ar",
  };

  static Map<String, String> authHeader = {
    'Authorization': 'Bearer ${Auth.accessToken}',
  };

  static Map<String, String> contentHeader = {
    'Authorization': 'Bearer ${Auth.accessToken}',
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
