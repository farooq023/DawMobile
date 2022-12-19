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

  String accessToken = 'JxakekiplNv7udo21SX1edluWGwDwevVN6z6OPBTCxeOqg5uRhTconJv3EQ_vsAWmFbrTZnKcSlj6bDJI16rMA4LlEeJ-JkCPHx4U8CMkeo1f2_pDRpATpp8U0wBh5sWGGbLtgG0uB0xegtklpuhaUF18t-XKp58_D32e4JAxZ4YPovdvaUahv3Cb_DPaaWvBc5k-cq3snT1rGs9dNTevB7K4GgjamkjN0lZC47uF7-2V9-0k3IBpeC1A-3Cf5NlW9VaQCA3qay7HbfwbREpsA';
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
