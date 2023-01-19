import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import 'requestDataProvider.dart';
import 'inboxFilterPro.dart';

class InboxPro with ChangeNotifier {
  String accessToken;
  int uID;

  InboxPro(this.accessToken, this.uID);

  var ibx;
  bool rcvd = false;

  Future<List<Map>> getDashboardInbox() async {
    if (!rcvd) {
      String url = '${RequestDataProvider.ip}api/Dashboard/UserInbox?UserID=$uID';
      var response = await http.get(Uri.parse(url), headers: RequestDataProvider.authHeader);
      var res = await json.decode(response.body);
      ibx = res['Result']['Data'];
      rcvd = true;
    }

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

    return setInbox;
  }

  Future<List<Map>> getFullInbox() async {
    String url = '${RequestDataProvider.ip}api/WFInbox/GetWfinbox';

    var body = {
      'UserID': '$uID',
    };

    if (InFilterProvider.filter) {
      body = {
        'UserID': '$uID',
        'RequisitionNo': InFilterProvider.reqNo,
        'Subject': InFilterProvider.subject,
        'IDateFrom': InFilterProvider.startDate,
        'IDateTo': InFilterProvider.endDate
      };
    }

    var response = await http.post(
      Uri.parse(url),
      headers: RequestDataProvider.authHeader,
      body: body,
    );

    var res = await json.decode(response.body);
    ibx = res['Result']['Data'];

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

      String primarySender = "Sender";
      String secondarySender = "SenderEn";

      if (LanguageProvider.appLocale == Locale('en')) {
        primarySender = "SenderEn";
        secondarySender = "Sender";
      }

      String searchString = ibx[i][primarySender] ?? ibx[i][secondarySender];
      searchString += ' ' + ibx[i]['SUBJECT'];
      searchString += ' ' + (ibx[i]['RequisitionNo'] ?? "");

      setInbox.add(
        {
          "Sender": ibx[i][primarySender] ?? ibx[i][secondarySender],
          "WFBeginDate": beginDate,
          "SUBJECT": ibx[i]['SUBJECT'],
          "StatusID": ibx[i]['StatusID'],
          "RequisitionNo": ibx[i]['RequisitionNo'],
          //
          "isChecked": false, //declaring by self to enable checkBoxes
          //
          "DETID": ibx[i]['DETID'], //primary key
          "ActionID": ibx[i]['ActionID'],
          //
          "EnableTransfer": ibx[i]['EnableTransfer'],
          "EnableStartNewWF": ibx[i]['EnableStartNewWF'],
          "EnableCompleteTask": ibx[i]['EnableCompleteTask'],
          "EnableAddNotes": ibx[i]['EnableAddNotes'],
          //
          "searchString": searchString
        },
      );
    }

    return setInbox;
  }
}
