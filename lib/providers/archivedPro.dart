import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import './ipProvider.dart';

class ArchivedPro with ChangeNotifier {
  String accessToken;
  int uID;

  ArchivedPro(this.accessToken, this.uID);

  var abx;
  // bool rcvd = false;

  Future<List<Map>> getFullArchived() async {
    String url = '${IpProvider.ip}api/FNDoc/GetWFArchive?userId=$uID&ReqNo=&Subject&DateFrom&DateTo&maxSize=1';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    var res = await json.decode(response.body);
    abx = res['Result']['Data'];

    List<Map> setArcBox = [];
    DateTime today = DateTime.now();
    String dateStr = "${today.day}/${today.month}/${today.year}";
    for (int i = 0; i < abx.length; i++) {
      String beginDate;
      var comparer = abx[i]['WFBeginDate'].split(' ');
      if (comparer[0] == dateStr) {
        beginDate = comparer[1];
      } else {
        beginDate = comparer[0];
      }
      if (LanguageProvider.appLocale == Locale('ar')) {
        setArcBox.add(
          {
            "Sender": abx[i]['Sender'],
            "WFBeginDate": beginDate,
            "SUBJECT": abx[i]['SUBJECT'],
            "StatusID": abx[i]['StatusID'],
            "RequisitionNo": abx[i]['RequisitionNo'],
            //
            "isChecked": false, //declaring by self to enable checkBoxes
            //
            "DETID": abx[i]['DETID'], //primary key
            //
            // "EnableTransfer": abx[i]['EnableTransfer'],
            // "EnableStartNewWF": abx[i]['EnableStartNewWF'],
            // "EnableCompleteTask": abx[i]['EnableCompleteTask'],
            // "EnableAddNotes": abx[i]['EnableAddNotes'],
          },
        );
      } else {
        setArcBox.add(
          {
            "Sender": abx[i]['SenderEn'],
            "WFBeginDate": beginDate,
            "SUBJECT": abx[i]['SUBJECT'],
            "StatusID": abx[i]['StatusID'],
            "RequisitionNo": abx[i]['RequisitionNo'],
            //
            "isChecked": false, //declaring by self to enable checkBoxes
            //
            "DETID": abx[i]['DETID'], //primary key
            //
            // "EnableTransfer": abx[i]['EnableTransfer'],
            // "EnableStartNewWF": abx[i]['EnableStartNewWF'],
            // "EnableCompleteTask": abx[i]['EnableCompleteTask'],
            // "EnableAddNotes": abx[i]['EnableAddNotes'],
          },
        );
      }
    }

    return setArcBox;
  }
}
