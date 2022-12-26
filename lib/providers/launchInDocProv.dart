import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './languageProvider.dart';
import './ipProvider.dart';
import 'inboxFilterPro.dart';

class LaunchInDocProv with ChangeNotifier {
  String accessToken;
  int uID;

  // bool filter;
  // LaunchInDocProv(this.accessToken, this.uID); getWfPriorities

  LaunchInDocProv(this.accessToken, this.uID);
  // bool rcvd = false;

  Future<List<List>> getWfPriorities() async {
    String url = '${IpProvider.ip}api/Lookups/WfPriorities';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

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

    List<List> prioritiess = [];
    prioritiess.add(priorities);
    prioritiess.add(priorityId);
    return prioritiess;
  }

  Future<List<List>> getWfActions() async {
    // if (!rcvd) {
    String url = '${IpProvider.ip}api/Lookups/WfActionsAll';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    var res = await json.decode(response.body);
    var rcvdActions = res['Result'];

    List<String> actions = [];
    List<int> actionIds = [];
    String desc = "Desc";

    if (LanguageProvider.appLocale == const Locale('en')) desc = "DescEn";

    // if (LanguageProvider.appLocale == const Locale('ar')) {
    //   for (int i = 0; i < rcvdActions.length; i++) {
    //     actions.add(rcvdActions[i]['Desc']);
    //   }
    // } else {
    //   for (int i = 0; i < rcvdActions.length; i++) {
    //     actions.add(rcvdActions[i]['DescEn']);
    //   }
    // }

    for (int i = 0; i < rcvdActions.length; i++) {
      actions.add(rcvdActions[i][desc]);
      actionIds.add(rcvdActions[i]["ID"]);
    }

    List<List> actionss = [];
    actionss.add(actions);
    actionss.add(actionIds);
    return actionss;
  }

  Future<List<String>> getEmployees(String text) async {
    // if (!rcvd) {

    String url = '${IpProvider.ip}api/WFLaunch/SearchEmployees';
    // print('called in prov');
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'UserID': '$uID',
        'SearchTerm': text,
      },
    );

    // List<Map> users = [];
    List<String> users = [];
    // List<List> users2 = [[], []];

    String primName = "Name";
    String secName = "NameEn";
    var res = await json.decode(response.body);

    if (res.containsKey('Result')) {
      var rcvdUsers = res['Result']['result'];
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

  Future<dynamic> uploadFileAndGetItsData(List<String> files) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${IpProvider.ip}api/Common/PostFiles'));
    request.headers.addAll({"Authorization": "Bearer $accessToken"});
    for (int i = 0; i < files.length; i++) {
      request.files.add(await http.MultipartFile.fromPath("", files[i]));
    }

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final res = json.decode(responsed.body);

    print(res);
    return res["Result"];
  }

  Future<bool> launchWorkflow(Map<String, dynamic> wfData) async {
    // print("**** LAUNCHING WORKFLOW ****");

    String url = '${IpProvider.ip}api/WFLaunch/Launch';

    List<Map<String,dynamic>> launchDataItemss = [
      {   //    <String, dynamic>
        "Subject": wfData["Subject"],
        "PriorityID": '${wfData["PrioID"]}' ,         //      '${wfData["PrioID"]}'       wfData["PrioID"],  
        "WfEndDate": wfData["WfEndD"],
        "Attachs": [
          {"Files": wfData["filessss"]}
        ],
        "RecentlySignedDocVSIDs": [""],
      }
    ];

    // print("created launchDataItemss");

    // Map finalOB = {   //    <String, dynamic>
    //   "WFAction": '${wfData["actID"]}',
    //   "LaunchDataItems": launchDataItemss,
    //   "LaunchToUsers": wfData["LaunchToUsers"],
    //   "UserID": '$uID'
    // };

    // String encodedOb = json.encode(finalOB);
    // print(encodedOb);

    // final jsonEncodeer = JsonEncoder();
    // String encodedOb = jsonEncodeer.convert(finalOB);
    // print(encodedOb);

    print({                                            //    <String, dynamic>
        "WFAction": '${wfData["actID"]}',             //    '${wfData["actID"]}'
        "LaunchDataItems": launchDataItemss,
        "LaunchToUsers": wfData["LaunchToUsers"],
        "UserID": '$uID'      //    '$uID'
      });
    

    var response = await http.post(
      Uri.parse(url),
      headers: <String,String>{    //    <String, String>
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Content-Type': 'application/json',       //    multipart/form-data
        // 'Accept': '*/*'
      },

      // body: json.encode({                                            //    <String, dynamic>
      //   "WFAction": '${wfData["actID"]}',
      //   "LaunchDataItems": launchDataItemss,
      //   "LaunchToUsers": wfData["LaunchToUsers"],
      //   "UserID": '$uID'
      // }),

      

      body: jsonEncode(<String,dynamic>{                                            //    <String, dynamic>
        "WFAction": '${wfData["actID"]}',             //    '${wfData["actID"]}'
        "LaunchDataItems": launchDataItemss,
        "LaunchToUsers": wfData["LaunchToUsers"],
        "UserID": '$uID'      //    '$uID'
      }),
      
      // body: <String, dynamic>{
      //   "WFAction": '${wfData["actID"]}',
      //   "LaunchDataItems": launchDataItemss,
      //   "LaunchToUsers": wfData["LaunchToUsers"],
      //   "UserID": '$uID'
      // },

      // body: finalOB.toString(),

      // body: jsonEncodeer.convert(finalOB),

      // body: finalOB,

      // body: json.encode(finalOB),

      // body: encodedOb,
    );

    // print("Decoding Response");
    var res = await json.decode(response.body);
    // print("Response:");
    print(res);

    return res["Success"];

    // if(res["Success"]) return "Success";
    // else return "Failed";

    // bool a = res['Success'];

    // if(a) {
    //   print("Success Success Success Success");
    // }
    // else{
    //   print(res['Message']);
    // }
  }
}
