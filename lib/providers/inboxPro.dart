import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import './ipProvider.dart';
import 'inboxFilterPro.dart';

class InboxPro with ChangeNotifier {
  String accessToken;
  int uID;
  // bool filter;

  InboxPro(this.accessToken, this.uID);
  // InboxPro(this.accessToken, this.uID, this.filter);

  var ibx;
  bool rcvd = false;

  Future<List<Map>> getDashboardInbox() async {
    if (!rcvd) {
      String url = '${IpProvider.ip}api/Dashboard/UserInbox?UserID=$uID';
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

    return setInbox;
  }

  Future<List<Map>> getFullInbox() async {
    String url = '${IpProvider.ip}api/WFInbox/GetWfinbox';
    var response;

    if (InFilterProvider.filter) {
      response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'UserID': '$uID',
          'RequisitionNo': InFilterProvider.reqNo,
          'Subject': InFilterProvider.subject,
          'IDateFrom': InFilterProvider.startDate,
          'IDateTo': InFilterProvider.endDate
        },
      );
    } else {
      response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'UserID': '$uID',         //      '$uID'
        },
      );
    }

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
      if (LanguageProvider.appLocale == const Locale('ar')) {
        String searchString = ibx[i]['Sender'] == null ? '' : ibx[i]['Sender'];
        if (ibx[i]['SUBJECT'] != null) {
          searchString += ' ' + ibx[i]['SUBJECT'];
        }
        if (ibx[i]['RequisitionNo'] != null) {
          searchString += ' ' + ibx[i]['RequisitionNo'];
        }
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
            //
            "searchString": searchString
          },
        );
      } else {
        String searchString =
            ibx[i]['SenderEn'] == null ? '' : ibx[i]['SenderEn'];
        if (ibx[i]['SUBJECT'] != null) {
          searchString += ' ' + ibx[i]['SUBJECT'];
        }
        if (ibx[i]['RequisitionNo'] != null) {
          searchString += ' ' + ibx[i]['RequisitionNo'];
        }

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
            //
            "searchString": searchString
          },
        );
      }
    }

    return setInbox;
  }
}
