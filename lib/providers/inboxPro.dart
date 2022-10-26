import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';

class InboxPro with ChangeNotifier {
  String accessToken;
  int uID;

  InboxPro(this.accessToken, this.uID);

  var ibx;
  bool rcvd = false;

  Future<List<Map>> getDashboardInbox() async {
    if (!rcvd) {
      String url = 'http://10.0.190.191:51/api/Dashboard/UserInbox?UserID=$uID';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      var res = await json.decode(response.body);

      // List<Map> ibx = res['Result']['Data'];
      ibx = res['Result']['Data'];
      rcvd = true;
    }

    // print('******* allocated received list *******');

    List<Map> setInbox = [];

    for (int i = 0; i < ibx.length; i++) {
      setInbox.add(
        {
          "Sender": ibx[i]['Sender'],
          "WFBeginDate": ibx[i]['WFBeginDate'],
          "SUBJECT": ibx[i]['SUBJECT'],
          "wfTypeDesc": ibx[i]['wfTypeDesc'],
        },
      );
    }

    // print('******sending all the setInbox.******');

    // dashboardInbox.add(newM);
    // dashboardInbox.add(res['Result']['ibxCount']);
    // dashboardInbox.add(res['Result']['BackInboxCount']);
    // dashboardInbox.add(res['Result']['BackToCreatorInboxCount']);

    return setInbox;
  }

  Future<List<Map>> getFullInbox() async {
    String url = 'http://10.0.190.191:51/api/WFInbox/GetWfinbox';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'UserID': '$uID',
      },
    );

    var res = await json.decode(response.body);
    var ibx = res['Result']['Data'];

    List<Map> setInbox = [];
    DateTime today = DateTime.now();
    String dateStr = "${today.day}/${today.month}/${today.year}";
    for (int i = 0; i < ibx.length; i++) {
      String beginDate;
      var comparer = ibx[i]['WFBeginDate'].split(' ');
      if (comparer[0] == dateStr) {
        beginDate = comparer[1];
      } else {
        beginDate = comparer[0];
      }
      if (LanguageProvider.appLocale == Locale('ar')) {
        setInbox.add(
          {
            "Sender": ibx[i]['Sender'],
            "WFBeginDate": beginDate,
            "SUBJECT": ibx[i]['SUBJECT'],
            "StatusID": ibx[i]['StatusID'],
            "RequisitionNo": ibx[i]['RequisitionNo'],
            //
            "isChecked": false, //declaring by self to enable checkBoxes
            //
            "DETID": ibx[i]['DETID'], //primary key
            //
            "EnableTransfer": ibx[i]['EnableTransfer'],
            "EnableStartNewWF": ibx[i]['EnableStartNewWF'],
            "EnableCompleteTask": ibx[i]['EnableCompleteTask'],
            "EnableAddNotes": ibx[i]['EnableAddNotes'],
          },
        );
      } else {
        setInbox.add(
          {
            "Sender": ibx[i]['SenderEn'],
            "WFBeginDate": beginDate,
            "SUBJECT": ibx[i]['SUBJECT'],
            "StatusID": ibx[i]['StatusID'],
            "RequisitionNo": ibx[i]['RequisitionNo'],
            //
            "isChecked": false, //declaring by self to enable checkBoxes
            //
            "DETID": ibx[i]['DETID'], //primary key
            //
            "EnableTransfer": ibx[i]['EnableTransfer'],
            "EnableStartNewWF": ibx[i]['EnableStartNewWF'],
            "EnableCompleteTask": ibx[i]['EnableCompleteTask'],
            "EnableAddNotes": ibx[i]['EnableAddNotes'],
          },
        );
      }
    }

    return setInbox;
  }
}
