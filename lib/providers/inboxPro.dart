import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InboxPro with ChangeNotifier {
  String accessToken;
  int uID;

  // String uName;

  // String name = '';
  // String jobTitle = '';

  InboxPro(this.accessToken, this.uID);

  // List<Map> savedInbox = [];

  Future<List<Map>> getDashboardInbox() async {
    String url = 'http://10.0.190.191:51/api/Dashboard/UserInbox?UserID=$uID';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    var res = await json.decode(response.body);

    // List<Map> receivedInbox = res['Result']['Data'];
    var receivedInbox = res['Result']['Data'];

    // print('******* allocated received list *******');
    print(receivedInbox);

    List<Map> setInbox = [];

    for (int i = 0; i < receivedInbox.length; i++) {
      setInbox.add(
        {
          "Sender": receivedInbox[i]['Sender'],
          "WFBeginDate": receivedInbox[i]['WFBeginDate'],
          "SUBJECT": receivedInbox[i]['SUBJECT'],
          "wfTypeDesc": receivedInbox[i]['wfTypeDesc'],
        },
      );
    }

    // print('******sending all the setInbox.******');

    // dashboardInbox.add(newM);
    // dashboardInbox.add(res['Result']['ReceivedInboxCount']);
    // dashboardInbox.add(res['Result']['BackInboxCount']);
    // dashboardInbox.add(res['Result']['BackToCreatorInboxCount']);

    return setInbox;
  }

  Future<List<Map>> getFullInbox() async {
    print(' **** API called **** ');
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
    var receivedInbox = res['Result']['Data'];

    // return receivedInbox;

    List<Map> setInbox = [];
    DateTime today = DateTime.now();
    String dateStr = "${today.day}/${today.month}/${today.year}";
    for (int i = 0; i < receivedInbox.length; i++) {
      String beginDate;
      var comparer = receivedInbox[i]['WFBeginDate'].split(' ');
      if (comparer[0] == dateStr) {
        beginDate = comparer[1];
      } else {
        beginDate = comparer[0];
      }
      setInbox.add(
        {
          "Sender": receivedInbox[i]['Sender'],
          "WFBeginDate": beginDate,
          "SUBJECT": receivedInbox[i]['SUBJECT'],
          "StatusID": receivedInbox[i]['StatusID'],
          "RequisitionNo": receivedInbox[i]['RequisitionNo'],
          //
          "isChecked": false, //declaring by self to enable checkBoxes
          //
          "DETID": receivedInbox[i]['DETID'], //primary key
          //
          "EnableTransfer": receivedInbox[i]['EnableTransfer'],
          "EnableStartNewWF": receivedInbox[i]['EnableStartNewWF'],
          "EnableCompleteTask": receivedInbox[i]['EnableCompleteTask'],
          "EnableAddNotes": receivedInbox[i]['EnableAddNotes'],
        },
      );
    }

    // savedInbox = setInbox;

    return setInbox;
  }
}
