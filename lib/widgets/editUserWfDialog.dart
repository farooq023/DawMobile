import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EditUserWfDialog extends StatelessWidget {

  Map user;
  EditUserWfDialog(this.user);

  TextEditingController editActionController = TextEditingController();
  TextEditingController notesCtrl = TextEditingController();
  TextEditingController editDateController = TextEditingController();
  DateTime userDateOb = DateTime(DateTime.now().day + 1);

  
  @override
  void initState() {

    if (user["date"].isNotEmpty) {
      var userDate = user["date"].split("/");
      String datee = userDate[2] + "-" + userDate[1] + "-" + userDate[0];
      userDateOb = DateTime.parse(datee);
    }

    editActionController.text = user["action"];
    editDateController.text = user["date"];
    notesCtrl.text = user["notes"];
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
