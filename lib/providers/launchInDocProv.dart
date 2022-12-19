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

  Future<List<String>> getWfPriorities() async {
    // if (!rcvd) {
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

    if (LanguageProvider.appLocale == const Locale('ar')) {
      for (int i = 0; i < rcvdPriorities.length; i++) {
        priorities.add(rcvdPriorities[i]['Desc']);
      }
    } else {
      // print('here');
      for (int i = 0; i < rcvdPriorities.length; i++) {
        priorities.add(rcvdPriorities[i]['DescEn']);
      }
    }

    // print(priorities);

    return priorities;
  }

  Future<List<String>> getWfActions() async {
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

    if (LanguageProvider.appLocale == const Locale('ar')) {
      for (int i = 0; i < rcvdActions.length; i++) {
        actions.add(rcvdActions[i]['Desc']);
      }
    } else {
      // print('here');
      for (int i = 0; i < rcvdActions.length; i++) {
        actions.add(rcvdActions[i]['DescEn']);
      }
    }

    return actions;
  }

  // Future<List<String>> getEmployees(String text) async {
  //   // if (!rcvd) {

  //   String url = '${IpProvider.ip}api/WFLaunch/SearchEmployees';
  //   // print('called in prov');
  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //     body: {
  //       'UserID': '$uID',
  //       'SearchTerm': text,
  //     },
  //   );

  //   List<String> users = [];

  //   String primName = "Name";
  //   String secName = "NameEn";
  //   var res = await json.decode(response.body);
  //   if (res.containsKey('Result')) {
  //     var rcvdUsers = res['Result']['result'];

  //     if (LanguageProvider.appLocale == const Locale('en')) {
  //       primName = "NameEn";
  //       secName = "Name";
  //     }

  //     for (int i = 0; i < rcvdUsers.length; i++) {
  //       // users.add(rcvdUsers[i]['Name']);
  //       // rcvdUsers[i]['Name'] == null ? users.add(rcvdUsers[i]['NameEn']) : users.add(rcvdUsers[i]['Name']);
  //       users.add(rcvdUsers[i][primName] ?? rcvdUsers[i][secName]);
  //     }
  //   }
  //   return users;
  // }

  // ************************************************** //
  // ************************************************** //
  // ************************************************** //

  // Future<List<Map<String, dynamic>>> getEmployees(String text) async {
  //   // if (!rcvd) {

  //   String url = '${IpProvider.ip}api/WFLaunch/SearchEmployees';
  //   // print('called in prov');
  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //     body: {
  //       'UserID': '$uID',
  //       'SearchTerm': text,
  //     },
  //   );

  //   // List<Map<String, dynamic>> users = [];
  //   List<Map<String, dynamic>> users = [];
  //   var res = await json.decode(response.body);
  //   if (res.containsKey('Result')) {
  //     var rcvdActions = res['Result']['result'];

  //     // List<String> users = [];

  //     print('here');

  //     if (LanguageProvider.appLocale == const Locale('ar')) {
  //       for (int i = 0; i < rcvdActions.length; i++) {
  //         // users.add(rcvdActions[i]['Name']);
  //         // rcvdActions[i]['Name'] == null ? users.add(rcvdActions[i]['NameEn']) : users.add(rcvdActions[i]['Name']);
  //         users.add(
  //           {
  //             "label": rcvdActions[i]['Name'] ?? rcvdActions[i]['NameEn'],
  //             "value": rcvdActions[i]['Name'] ?? rcvdActions[i]['NameEn'],
  //           },
  //         );
  //       }
  //     } else {
  //       // print('here');
  //       for (int i = 0; i < rcvdActions.length; i++) {
  //         // users.add(rcvdActions[i]['NameEn']);
  //         // users.add(rcvdActions[i]['NameEn'] ?? rcvdActions[i]['Name']);     label
  //         users.add(
  //           {
  //             "label": rcvdActions[i]['NameEn'] ?? rcvdActions[i]['Name'],
  //             "value": rcvdActions[i]['NameEn'] ?? rcvdActions[i]['Name'],
  //           },
  //         );
  //       }
  //     }
  //   }

  //   print('returning');
  //   return users;

  //   // return [
  //   //   "p8admin المشرف العام",
  //   //   "husam",
  //   //   "Nada",
  //   // ];
  // }

  // ************************************************** //
  // ************************************************** //
  // ************************************************** //

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
        users.add( n + "   i" + rcvdUsers[i]['UserID'].toString() );
        // users.add(
        //   {
        //     "UserID": rcvdUsers[i]['UserID'],
        //     "name": rcvdUsers[i][primName] ?? rcvdUsers[i][secName],
        //   },
        // );
      }
      // for (int i = 0; i < rcvdUsers.length; i++) {
      //   users2[0].add(
      //     {
      //       "UserID": rcvdUsers[i]['UserID'],
      //     },
      //   );
      //   users2[1].add(
      //     {
      //       "Name": rcvdUsers[i][primName] ?? rcvdUsers[i][secName],
      //     },
      //   );
      // }
    }

    print('returning');
    return users;
    // return users2;
  }
}
