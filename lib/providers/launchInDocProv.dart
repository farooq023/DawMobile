import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import 'requestDataProvider.dart';
import 'inboxFilterPro.dart';

class LaunchInDocProv with ChangeNotifier {
  String accessToken;
  int uID;

  LaunchInDocProv(this.accessToken, this.uID);

  Future<List<List>> getWfPriorities() async {
    String url = '${RequestDataProvider.ip}api/Lookups/WfPriorities';
    var response = await http.get(Uri.parse(url), headers: RequestDataProvider.authHeader);

    var res = await json.decode(response.body);
    var rcvdPriorities = res['Result'];

    List<String> priorities = [];
    List<int> priorityId = [];

    String desc = "Desc";
    if (LanguageProvider.appLocale == const Locale('en')) desc = "DescEn";

    for (int i = 0; i < rcvdPriorities.length; i++) {
      priorities.add(rcvdPriorities[i][desc]);
      priorityId.add(rcvdPriorities[i]["ID"]);
    }

    return [priorities, priorityId];
  }

  Future<List<List>> getWfActions() async {
    String url = '${RequestDataProvider.ip}api/Lookups/WfActionsAll';
    var response = await http.get(Uri.parse(url), headers: RequestDataProvider.authHeader);

    var res = await json.decode(response.body);
    var rcvdActions = res['Result'];

    List<String> actions = [];
    List<int> actionIds = [];

    String desc = "Desc";
    if (LanguageProvider.appLocale == const Locale('en')) desc = "DescEn";

    for (int i = 0; i < rcvdActions.length; i++) {
      actions.add(rcvdActions[i][desc]);
      actionIds.add(rcvdActions[i]["ID"]);
    }

    return [actions, actionIds];
  }

  Future<List<String>> getEmployees(String text) async {
    String url = '${RequestDataProvider.ip}api/WFLaunch/SearchEmployees';
    var response = await http.post(
      Uri.parse(url),
      headers: RequestDataProvider.authHeader,
      body: {
        'UserID': '$uID',
        'SearchTerm': text,
      },
    );

    List<String> users = [];

    var res = await json.decode(response.body);

    if (res.containsKey('Result')) {
      var rcvdUsers = res['Result']['result'];
      String primName = "Name";
      String secName = "NameEn";
      if (LanguageProvider.appLocale == const Locale('en')) {
        primName = "NameEn";
        secName = "Name";
      }
      for (int i = 0; i < rcvdUsers.length; i++) {
        String n = rcvdUsers[i][primName] ?? rcvdUsers[i][secName];
        users.add(n + "   i" + rcvdUsers[i]['UserID'].toString());
      }
    }
    return users;
  }

  Future<List> uploadFileAndGetItsData(List<String> files) async {
    var request = http.MultipartRequest('POST', Uri.parse('${RequestDataProvider.ip}api/Common/PostFiles'));
    request.headers.addAll(RequestDataProvider.authHeader);
    for (int i = 0; i < files.length; i++) {
      request.files.add(await http.MultipartFile.fromPath("", files[i]));
    }
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final res = json.decode(responsed.body);
    return res["Result"];
  }

  Future<bool> launchWorkflow(Map<String, dynamic> wfData) async {
    String url = '${RequestDataProvider.ip}api/WFLaunch/Launch';

    List<Map<String, dynamic>> launchDataItemss = [
      {
        "Subject": wfData["Subject"],
        "PriorityID": '${wfData["PrioID"]}',
        "WfEndDate": wfData["WfEndD"],
        "Attachs": [
          {
            "vsID": "",
            "DocTypeCode": 0,
            "CorrepCode": "",
            "isCurrent": 0,
            "Serial": 1,
            "UploadMethod": 1,
            "AllowSignMemo": false,
            "AllowRestoreMainDocument": false,
            "Files": wfData["filessss"],
          }
        ],
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
    return res["Success"];
  }
}
