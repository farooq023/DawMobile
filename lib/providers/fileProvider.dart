import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'requestDataProvider.dart';

class FileProvider with ChangeNotifier {
  String accessToken;
  int uID;

  FileProvider(this.accessToken, this.uID);

  Future<dynamic> getVsIds(double dDetId) async {
    int detId = dDetId.toInt();
    String url = '${RequestDataProvider.ip}api/WFLaunch/GetAttachsByDetID?userID=$uID&DetId=$detId';
    var response = await http.get(
      Uri.parse(url),
      headers: RequestDataProvider.authHeader,
    );

    var res = await json.decode(response.body);
    var vsIds = res['Result'];
    return vsIds;
  }

  Future<String> getFileUrl(double dDetId, String vsID) async {
    int detId = dDetId.toInt();
    String url = '${RequestDataProvider.ip}api/Common/GetFileNetDoc?userID=$uID&vsid=$vsID&DetId=$detId&PageName=a&DocTypeCode=0';
    var response = await http.get(
      Uri.parse(url),
      headers: RequestDataProvider.authHeader,
    );

    var res = await json.decode(response.body);

    if (res['Result'] != null && res['Result']['Document'].length != 0) {
      url = res['Result']['Document'][0]['FileURL'];
      if (url.startsWith('http://ser-dew-001.scpd.com'))
        return url.replaceFirst('ser-dew-001.scpd.com', '10.0.190.191');
      else if (url.startsWith('http://ser-ool-001.scpd.com') || url.startsWith('http://SER-OOL-001.scpd.com'))
        return url.replaceFirst('http://ser-ool-001.scpd.com', '10.0.190.193');
      return url;
    } else {
      return "error";
    }
  }
}
