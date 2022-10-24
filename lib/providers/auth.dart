import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './languageProvider.dart';

class Auth with ChangeNotifier {
  String accessToken = '';
  String userName = '';

  int userID = 0;
  String name = '';
  String jobTitle = '';

  ///********* */

  // String accessToken = 'jVhzB7lOtMYSC74yLSBUmWP9cino1yiq_JFHjRUh6U50KcwqAhlN75q3qg7EI5e0eQL-P54Xgp9eJzrcYUds5hlSgV6rx7w_lLDtOcCuN1xIbQGU91yg0qAYFUrF8xAxRTOTLfl0BxblLS5YvhrndZlXVVerr4O-8YZh_JIHir5IJDrk-pcgLcU0_r_uEnSFsNZt9aNvt4k138Z9yVyBhECPkG66u9pvIFq7snLtDTusMrHYiG_zGhGSmGgtzyCuGmTFVajPggWN88O2UMAHdw';
  // String userName = 'dawqa_3';
  // int userID = 4;
  // String name = 'الامين المساعد للمالية والادارية';
  // String jobTitle = 'الامين المساعد للمالية والادارية';

  bool get isAuth {
    return accessToken == '';
  }

  Future<String> login(String un, String pass) async {
    try{
      const url = 'http://10.0.190.191:51/token';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "user-language": "ar",
        // "Content-Type": "application/json; charset=UTF-8",
      },
      // encoding: Encoding.getByName('utf-8'),
      body: {
        'grant_type': 'password',
        'username': un,
        'password': pass,
      },
    );

    var res = json.decode(response.body);

    if (res.containsKey('access_token')) {
      // print(res['access_token']);
      accessToken = res['access_token'];
      userName = un;

      //Now Fetching UserInfo i.e. (UserID, Employee Name & Job Title)

      String url =
          'http://10.0.190.191:51/api/Common/GetUserInfo?userName=$userName&LogLogin=true&ActionUserID=';
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // print('request sent');

      res = await json.decode(response.body);

      userID = res['Result']['UserId'];

      if (LanguageProvider.appLocale == Locale('ar')) {
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
    }
    catch(e) {
      print('errr caught');
      return 'error';
    }
  }

  Future<void> logout() async {
    
    accessToken = '';
    userName = '';
    userID = 0;

    notifyListeners();
    const url = 'http://10.0.190.191:51/api/Common/Logout';
    // var response = await http.get(
    //   Uri.parse(url),
    //   headers: {
    //     'Authorization': 'Bearer $accessToken',
    //   },
    // );
    await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('logged out');
  }
}
