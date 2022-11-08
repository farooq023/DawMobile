import 'package:flutter/material.dart';

class InFilterProvider with ChangeNotifier {
  static bool filter = false;
  static String reqNo = '';
  static String subject = '';
  static String startDate = '';
  static String endDate = '';

  void setFilterToTrue(String req, String sub, String sDate, String eDate){
    // if(filter && req == '' && sub == '' && sDate == '' && eDate == ''){
    //   filter = false;
    //   return;
    // }
    filter = true;
    reqNo = req;
    subject = sub;
    startDate = sDate;
    endDate = eDate;
  }

  static void setFilterToFalse(){
    filter = false;
    reqNo = '';
    subject = '';
    startDate = '';
    endDate = '';
  }
}
