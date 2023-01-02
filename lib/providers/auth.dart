import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './languageProvider.dart';
import 'requestDataProvider.dart';
import './inboxFilterPro.dart';
// import 'dart:io';

class Auth with ChangeNotifier {
  // static String accessToken = '';
  // String userName = '';

  // int userID = 0;
  // String name = '';
  // String jobTitle = '';

  // *********

  static String accessToken =
      'mUgmiebLEWYO_JO22iAUa9KM1RBidlYgaTBKBV6CMitygNKWKulkTEazXuVkg6YFcWJae5disV0brawoeITdctDbCw-a3U4ilx8AGlW2ZlTKN_AXxJb1MKMWxSKW0isZUZtNN9jCdK4ek9cdCThHkswRYBecttrNb0lTcmhH5BwRNLtbF9LbdsYvOiIvmsLCWaVm53vWG1mmi3ePFeCBQdk61p8rFesCVAWjcK4N2Ko3JDPMBEir_5C-_8Z-OgHbnktD9uJ1LJf1DcXnhr2OEg';
  String userName = 'dawqa_1';
  int userID = 2;
  String name = 'الامين العام';
  String jobTitle = 'المدير العام';

  bool get isAuth {
    return accessToken == '';
  }

  String get authToken {
    return accessToken;
  }

  Future<String> login(String un, String pass) async {
    try {
      var url = '${RequestDataProvider.ip}token';
      var response = await http.post(
        Uri.parse(url),
        headers: RequestDataProvider.langHeader,
        body: {
          'grant_type': 'password',
          'username': un,
          'password': pass,
        },
      );

      var res = json.decode(response.body);
      if (res.containsKey('access_token')) {
        accessToken = res['access_token'];
        userName = un;

        //Now Fetching UserInfo i.e. (UserID, Employee Name & Job Title)

        String url = '${RequestDataProvider.ip}api/Common/GetUserInfo?userName=$userName&LogLogin=true&ActionUserID=';
        response = await http.get(
          Uri.parse(url),
          headers: RequestDataProvider.authHeader,
        );

        res = await json.decode(response.body);
        userID = res['Result']['UserId'];

        if (LanguageProvider.appLocale == const Locale('ar')) {
          name = res['Result']['UserFullName'];
          jobTitle = res['Result']['JobTitle'];
        } else {
          name = res['Result']['UserFullNameEn'];
          jobTitle = res['Result']['JobTitleEn'];
        }
        notifyListeners();
        return 'success';
      } else {
        return 'failure';
      }
    } catch (e) {
      return 'error';
    }
  }

  void logout() {
    accessToken = '';
    userName = '';
    userID = 0;
    name = '';
    jobTitle = '';

    InFilterProvider.setFilterToFalse();

    notifyListeners();
    var url = '${RequestDataProvider.ip}api/Common/Logout';
    http.get(
      Uri.parse(url),
      headers: RequestDataProvider.authHeader,
    );
    print('logged out');
  }
}
