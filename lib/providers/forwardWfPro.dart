import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import 'requestDataProvider.dart';

class ForwardWfPro with ChangeNotifier {
  String accessToken;
  int uID;

  ForwardWfPro(this.accessToken, this.uID);

  Future<List<Map>> getWfData(List<double> detIds) async {
    String url = '${RequestDataProvider.ip}api/WFLaunch/Load';

    var response = await http.post(
      Uri.parse(url),
      headers: RequestDataProvider.contentHeader,
      body: jsonEncode({
        "WFAction": "1",
        "DetailIDs": detIds,
        "UserID": '$uID',
      }),
    );

    var res = await json.decode(response.body);
    List rcvdWFsData = res["Result"]["DataItems"];

    String primPriority = "Priority";
    String secPriority = "PriorityEn";

    if (LanguageProvider.isEng) {
      primPriority = "PriorityEn";
      secPriority = "Priority";
    }

    List<Map> wfsData = [];

    for (int i = 0; i < rcvdWFsData.length; i++) {
      wfsData.add({
        "subject": rcvdWFsData[i]["WFData"]["SUBJECT"],
        "reqNo": rcvdWFsData[i]["WFData"]["RequisitionNo"],
        "wfDeadline": rcvdWFsData[i]["WFData"]["WFDeadLine"],
        "priorityID": rcvdWFsData[i]["WFData"]["PriorityID"],
        "priority": rcvdWFsData[i]["WFData"][primPriority] ?? rcvdWFsData[i]["WFData"][secPriority],
        "attachs": rcvdWFsData[i]["Attachs"],
      });
    }

    return wfsData;
  }

  // Future<bool> forwardWorkflow(Map<String, dynamic> wfData) async {
  //   String url = '${RequestDataProvider.ip}api/WFLaunch/Launch';

  //   List<Map<String, dynamic>> launchDataItemss = [
  //     {
  //       "Subject": wfData["Subject"],
  //       "PriorityID": '${wfData["PrioID"]}',
  //       "WfEndDate": wfData["WfEndD"],
  //       "Attachs": [
  //         {"Files": wfData["filessss"]}
  //       ],
  //       "RecentlySignedDocVSIDs": [""],
  //     }
  //   ];

  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: RequestDataProvider.authHeader,
  //     body: jsonEncode(<String, dynamic>{
  //       "WFAction": '${wfData["actID"]}',
  //       "LaunchDataItems": launchDataItemss,
  //       "LaunchToUsers": wfData["LaunchToUsers"],
  //       "UserID": '$uID'
  //     }),
  //   );

  //   var res = await json.decode(response.body);
  //   return res["Success"];
  // }

  Future<bool> forwardWorkflow(Map<String, dynamic> wfData) async {
    print("forwarding");
    String url = '${RequestDataProvider.ip}api/WFLaunch/Launch';

    // List attachments = wfData["attachments"];

    List<Map<String, dynamic>> launchDataItemss = [
      {
        "DetID": wfData["DetID"],
        "Subject": wfData["Subject"],
        "ReqNo": wfData["ReqNo"],
        "PriorityID": '${wfData["PrioID"]}',
        "WfEndDate": wfData["WfEndD"],
        "IsReplyRequired": true,
        "IsSplitWF": true,
        // "AddActionSheet": true,
        "Attachs": wfData["attachments"],
        "RecentlySignedDocVSIDs": [""],
      }
    ];

    var response = await http.post(
      Uri.parse(url),
      headers: RequestDataProvider.contentHeader,
      body: jsonEncode(<String, dynamic>{
        "WFAction": '${wfData["actID"]}',
        "LaunchDataItems": launchDataItemss,
        "LaunchToUsers": wfData["LaunchToUsers"],
        "UserID": '$uID'
      }),
    );

    var res = await json.decode(response.body);
    print(res);
    return res["Success"];
  }
}
