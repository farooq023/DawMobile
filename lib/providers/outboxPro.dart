import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import 'requestDataProvider.dart';

class OutboxPro with ChangeNotifier {
  String accessToken;
  int uID;

  OutboxPro(this.accessToken, this.uID);

  var obx;
  bool rcvd = false;

  Future<List<Map>> getFullOutbox() async {
    String url = '${RequestDataProvider.ip}api/WFSent/GetWFSent';
    var response = await http.post(
      Uri.parse(url),
      headers: RequestDataProvider.authHeader,
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
        String searchString = obx[i]['Recipient'] == null ? '' : obx[i]['Recipient'];
        if (obx[i]['SUBJECT'] != null) {
          searchString += ' ' + obx[i]['SUBJECT'];
        }
        if (obx[i]['RequisitionNo'] != null) {
          searchString += ' ' + obx[i]['RequisitionNo'];
        }
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
            //
            "searchString": searchString
          },
        );
      } else {
        String searchString = obx[i]['RecipientEn'] == null ? '' : obx[i]['RecipientEn'];
        if (obx[i]['SUBJECT'] != null) {
          searchString += ' ' + obx[i]['SUBJECT'];
        }
        if (obx[i]['RequisitionNo'] != null) {
          searchString += ' ' + obx[i]['RequisitionNo'];
        }
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
            //
            "searchString": searchString
          },
        );
      }
    }

    return setInbox;
  }
}
