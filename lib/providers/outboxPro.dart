import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import './ipProvider.dart';

class OutboxPro with ChangeNotifier {
  String accessToken;
  int uID;

  OutboxPro(this.accessToken, this.uID);

  var obx;
  bool rcvd = false;

  // Future<List<Map>> getDashboardInbox() async {
  //   if (!rcvd) {
  //     String url = '${IpProvider.ip}api/Dashboard/UserInbox?UserID=$uID';
  //     var response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );

  //     var res = await json.decode(response.body);

  //     // List<Map> obx = res['Result']['Data'];
  //     obx = res['Result']['Data'];
  //     rcvd = true;
  //   }

  //   // print('******* allocated received list *******');

  //   List<Map> setInbox = [];

  //   for (int i = 0; i < obx.length; i++) {
  //     setInbox.add(
  //       {
  //         "Sender": obx[i]['Sender'],
  //         "WFBeginDate": obx[i]['WFBeginDate'],
  //         "SUBJECT": obx[i]['SUBJECT'],
  //         "wfTypeDesc": obx[i]['wfTypeDesc'],
  //       },
  //     );
  //   }

  //   return setInbox;
  // }

  Future<List<Map>> getFullOutbox() async {
    String url = '${IpProvider.ip}api/WFSent/GetWFSent';
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
    obx = res['Result']['Data'];

    List<Map> setInbox = [];
    DateTime today = DateTime.now();
    String dateStr = "${today.day}/${today.month}/${today.year}";
    for (int i = 0; i < obx.length; i++) {
      String beginDate;
      var comparer = obx[i]['WFBeginDate'].split(' ');
      if (comparer[0] == dateStr) {
        beginDate = comparer[1];
      } else {
        beginDate = comparer[0];
      }
      if (LanguageProvider.appLocale == const Locale('ar')) {
        setInbox.add(
          {
            "Recipient": obx[i]['Recipient'],
            "WFBeginDate": beginDate,
            "SUBJECT": obx[i]['SUBJECT'],
            "StatusID": obx[i]['StatusID'],
            "RequisitionNo": obx[i]['RequisitionNo'],
            //
            "isChecked": false, //declaring by self to enable checkBoxes
            //
            "DETID": obx[i]['DETID'], //primary key
            //
            "EnableUrgent": obx[i]['EnableUrgent'],
            "EnableReTransfer": obx[i]['EnableReTransfer'],
            "EnableCancel": obx[i]['EnableCancel'],
            "EnableWithdraw": obx[i]['EnableWithdraw'],
          },
        );
      } else {
        setInbox.add(
          {
            "Recipient": obx[i]['RecipientEn'],
            "WFBeginDate": beginDate,
            "SUBJECT": obx[i]['SUBJECT'],
            "StatusID": obx[i]['StatusID'],
            "RequisitionNo": obx[i]['RequisitionNo'],
            //
            "isChecked": false, //declaring by self to enable checkBoxes
            //
            "DETID": obx[i]['DETID'], //primary key
            //
            "EnableUrgent": obx[i]['EnableUrgent'],
            "EnableReTransfer": obx[i]['EnableReTransfer'],
            "EnableCancel": obx[i]['EnableCancel'],
            "EnableWithdraw": obx[i]['EnableWithdraw'],
          },
        );
      }
    }

    return setInbox;
  }
}
