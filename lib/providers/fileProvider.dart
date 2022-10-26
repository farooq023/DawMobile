import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FileProvider with ChangeNotifier {
  String accessToken;
  int uID;

  FileProvider(this.accessToken, this.uID);

  Future<dynamic> getVsIds(double dDetId) async {
    int detId = dDetId.toInt();
    String url =
        'http://10.0.190.191:51/api/WFLaunch/GetAttachsByDetID?userID=$uID&DetId=$detId';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('rcvd');
    var res = await json.decode(response.body);
    var receivedInbox = res['Result'];
    print('rtnng');
    print(receivedInbox);
    return receivedInbox;
  }

  // Future<String> getFileUrl(double dDetId) async {
  //   int detId = dDetId.toInt();
  //   String url =
  //       'http://10.0.190.191:51/api/WFLaunch/GetAttachsByDetID?userID=$uID&DetId=$detId';
  //   var response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );

  //   // print('rcvng vsID');

  //   var res = await json.decode(response.body);

  //   String vsID = res['Result'][0]['vsID'];

  //   // print('rcvd vsID '+vsID);

  //   url =
  //       'http://10.0.190.191:51/api/Common/GetFileNetDoc?userID=$uID&vsid=$vsID&DetId=$detId&PageName=a&DocTypeCode=0';

  //   response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );

  //   // print('rcvng url');
  //   // res = await json.decode(response.body);
  //   // // res = await json.decode(json.encode(response.body));   //error here
  //   // print(res);
  //   // print('rcvng list/array');
  //   // var uv = res['Result']['Document'];
  //   // // List<Map<String, String>> uv = res['Result']['Document'];
  //   // print('rcvd the array');
  //   // Map uv2 = uv[0];
  //   // print('rcvd index element');
  //   // url = uv2['FileURL'];
  //   // // List<String> uv = ['0 in','1 in','2 in'];
  //   // // print(uv.elementAt(0));
  //   // print('rcvd url and now returing');

  //   res = await json.decode(response.body);
  //   url = res['Result']['Document'][0]['FileURL'];

  //   print('url');
  //   print(url);

  //   if (url.startsWith('http://ser-dew-001.scpd.com')) {
  //     print('1');
  //     return url.replaceFirst('ser-dew-001.scpd.com', '10.0.190.191');
  //   } else if (url.startsWith('http://ser-ool-001.scpd.com')) {
  //     print('2');
  //     return url.replaceFirst('http://ser-ool-001.scpd.com', '10.0.190.193');
  //   } else if (url.startsWith('http://SER-OOL-001.scpd.com')) {
  //     print('3');
  //     return url.replaceFirst('SER-OOL-001.scpd.com', '10.0.190.193');
  //   }
  //   return url;
  // }

  Future<String> getFileUrl(double dDetId, String vsID) async {
    int detId = dDetId.toInt();

    String url =
        'http://10.0.190.191:51/api/Common/GetFileNetDoc?userID=$uID&vsid=$vsID&DetId=$detId&PageName=a&DocTypeCode=0';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    var res = await json.decode(response.body);
    url = res['Result']['Document'][0]['FileURL'];

    // print('url');
    // print(url);

    if (url.startsWith('http://ser-dew-001.scpd.com')) {
      // print('1');
      return url.replaceFirst('ser-dew-001.scpd.com', '10.0.190.191');
    } else if (url.startsWith('http://ser-ool-001.scpd.com')) {
      // print('2');
      return url.replaceFirst('http://ser-ool-001.scpd.com', '10.0.190.193');
    } else if (url.startsWith('http://SER-OOL-001.scpd.com')) {
      // print('3');
      return url.replaceFirst('SER-OOL-001.scpd.com', '10.0.190.193');
    }
    return url;
  }
}
