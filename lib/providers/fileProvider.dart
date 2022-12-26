import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './ipProvider.dart';

class FileProvider with ChangeNotifier {
  String accessToken;
  int uID;

  FileProvider(this.accessToken, this.uID);

  Future<dynamic> getVsIds(double dDetId) async {
    int detId = dDetId.toInt();
    String url =
        '${IpProvider.ip}api/WFLaunch/GetAttachsByDetID?userID=$uID&DetId=$detId';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    var res = await json.decode(response.body);
    var receivedInbox = res['Result'];
    return receivedInbox;
  }


  Future<String> getFileUrl(double dDetId, String vsID) async {
    int detId = dDetId.toInt();

    String url =
        '${IpProvider.ip}api/Common/GetFileNetDoc?userID=$uID&vsid=$vsID&DetId=$detId&PageName=a&DocTypeCode=0';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    var res = await json.decode(response.body);
    print("res is");
    print(res);
    url = res['Result']['Document'][0]['FileURL'];

    if (url.startsWith('http://ser-dew-001.scpd.com')) {
      return url.replaceFirst('ser-dew-001.scpd.com', '10.0.190.191');
    } else if (url.startsWith('http://ser-ool-001.scpd.com')) {
      return url.replaceFirst('http://ser-ool-001.scpd.com', '10.0.190.193');
    } else if (url.startsWith('http://SER-OOL-001.scpd.com')) {
      return url.replaceFirst('SER-OOL-001.scpd.com', '10.0.190.193');
    }
    return url;
  }
}
