import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './languageProvider.dart';
import './ipProvider.dart';
import './inboxFilterPro.dart';
// import 'dart:io';

class Auth with ChangeNotifier {
  // String accessToken = '';
  // String userName = '';

  // int userID = 0;
  // String name = '';
  // String jobTitle = '';

  // *********

  String accessToken = 'hejC6dXee0o4eh3BiLhWu31iJrIStcWFIb5o0BeP3_qSFVaS72B1HyuIjLRFHoF-BP8gpoUWvzMILrKBpDOR2QxNLERWs81Ie2V8EYjJxkcXXvQCGUIO2YEIcKAhmN0C5fgs_5W-r0ZiT2cnLAyRIchaY9eNR0NPLldz8AfQp5juy0x-fXY_RwxOnr7LhCBAEXfuAPJeMoKT_Zn9nHXJFXeq4_ycuwUsPEIzS_7CJ1N0CJgYuMm_bUymPOeDVpzNBYS9dqAbdil2Vqcwfk4bgg';
  String userName = 'dawqa_3';
  int userID = 4;
  String name = 'الامين المساعد للمالية والادارية';
  String jobTitle = 'English';

  bool get isAuth {
    return accessToken == '';
  }

  Future<String> login(String un, String pass) async {
    try {
      // const url = 'http://10.0.190.191:51/token';

      var url = '${IpProvider.ip}token';
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
            '${IpProvider.ip}api/Common/GetUserInfo?userName=$userName&LogLogin=true&ActionUserID=';
        response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        // print('request sent');

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
    var url = '${IpProvider.ip}api/Common/Logout';
    // var response = await http.get(
    //   Uri.parse(url),
    //   headers: {
    //     'Authorization': 'Bearer $accessToken',
    //   },
    // );
    http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('logged out');
  }
}
