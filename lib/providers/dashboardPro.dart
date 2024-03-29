import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:arabic_numbers/arabic_numbers.dart';

import './languageProvider.dart';
import 'requestDataProvider.dart';

class DashboardPro with ChangeNotifier {
  String accessToken;
  int userID;

  DashboardPro(this.accessToken, this.userID);

  Future<List<String>> getUserStats(BuildContext context) async {
    String url = '${RequestDataProvider.ip}api/Dashboard/UserStatistics?UserID=$userID';
    var response = await http.get(
      Uri.parse(url),
      headers: RequestDataProvider.authHeader,
    );

    var res = await json.decode(response.body);
    List<String> totalMails = [];
    int newM = res['Result']['NewInternalInboxCount'] + res['Result']['NewOutgoingInboxCount'];

    if (LanguageProvider.appLocale == const Locale('ar')) {
      ArabicNumbers arabicNumber = ArabicNumbers();
      totalMails.add(arabicNumber.convert(newM));
      totalMails.add(arabicNumber.convert(res['Result']['ReceivedInboxCount']));
      totalMails.add(arabicNumber.convert(res['Result']['BackInboxCount']));
      totalMails.add(arabicNumber.convert(res['Result']['BackToCreatorInboxCount']));
    } else {
      totalMails.add(newM.toString());
      totalMails.add(res['Result']['ReceivedInboxCount'].toString());
      totalMails.add(res['Result']['BackInboxCount'].toString());
      totalMails.add(res['Result']['BackToCreatorInboxCount'].toString());
    }

    return totalMails;
  }
}
