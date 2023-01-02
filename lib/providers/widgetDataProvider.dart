import 'package:flutter/material.dart';
import './languageProvider.dart';

// class RequestDataProvider {
class WidgetDataProvider with ChangeNotifier {
  static double iconSize = 25;
  static List<Widget> getIcons(context) {
    return [
      Icon(
        Icons.noise_control_off,
        color: Theme.of(context).primaryColor,
        size: iconSize,
      ),
      Icon(
        Icons.pending,
        // color: Theme.of(context).primaryColor,
        size: iconSize,
      ),
      Icon(
        Icons.arrow_circle_right,
        // color: Theme.of(context).primaryColor,
        size: iconSize,
      ),
      Icon(
        Icons.check_box,
        color: Colors.green,
        size: iconSize,
      ),
      Icon(
        Icons.arrow_circle_left,
        color: Colors.green,
        size: iconSize,
      ),
      Icon(
        Icons.archive,
        color: Colors.red,
        size: iconSize,
      ),
      Icon(
        Icons.cancel_rounded,
        color: Colors.red,
        size: iconSize,
      ),
      Icon(
        Icons.double_arrow,
        // color: Theme.of(context).primaryColor,
        size: iconSize,
      ),
    ];
  }

  static List<String> getIconsDes() {
    return LanguageProvider.isEng
        ? [
            'Unopened Mail',
            'Opened Mail',
            'Forwarded Mail',
            'Completed Mail',
            'Returned Mail',
            'Archived Mail',
            'Cancelled Mail',
            'Reforwarded Mail',
          ]
        : [
            'بريد غير مفتوح',
            'فتح البريد',
            'البريد المعاد توجيهه',
            'البريد المكتمل',
            'بريد عاد',
            'البريد المؤرشف',
            'البريد الملغى',
            'البريد المعاد توجيهه'
          ];
  }
}
