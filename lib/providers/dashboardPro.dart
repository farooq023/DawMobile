import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import './auth.dart';

class DashboardPro with ChangeNotifier {

  String accessToken;
  // String uName;
  int userID;

  // String name = '';
  // String jobTitle = '';


  DashboardPro(this.accessToken, this.userID);

  Future<List<int>> getUserStats(BuildContext context) async {
    // print('***** Received request *****');

    String url =
        'http://10.0.190.191:51/api/Dashboard/UserStatistics?UserID=$userID';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );


    var res = await json.decode(response.body);
    // print(res);

    // print('******* received mailssssss *******');


    List<int> totalMails = [];

    // print('******* created list *******');

    // print(response.body);
    int newM = res['Result']['NewInternalInboxCount'] + res['Result']['NewOutgoingInboxCount'];
    // int newM = int.parse(res['Result']['NewInternalInboxCount']) + int.parse(res['Result']['NewOutgoingInboxCount']);

    totalMails.add(newM);
    
    totalMails.add(res['Result']['ReceivedInboxCount']);
    totalMails.add(res['Result']['BackInboxCount']);
    totalMails.add(res['Result']['BackToCreatorInboxCount']);
    


    // int.parse(b);

    // print('newM************');
    // print(newM);

    return totalMails;
  }
}
