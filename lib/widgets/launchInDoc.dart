import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../providers/launchInDocProv.dart';

class LaunchInDoc extends StatefulWidget {
  const LaunchInDoc({super.key});

  @override
  State<LaunchInDoc> createState() => _LaunchInDocState();
}

enum rules { toDoNeeded, forInfo, forSave }

class _LaunchInDocState extends State<LaunchInDoc> {
  TextEditingController subjectCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();

  TextEditingController priorityController = TextEditingController();
  TextEditingController actionController = TextEditingController();
  TextEditingController recipientController = TextEditingController();

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

  rules? selectedRule;

  String actionValue = '';
  String priorityValue = '';
  double labelSize = 20;
  double marginBottom = 10;

  List<String> priorities = [];
  List<String> actions = [];
  // List<Map> rcvdResult = [];
  List<String> rcvdResult = [];
  // List<String> rcvdResultUsers = [];
  // List<int> rcvdResultId = [];

  List<String> recipientsString = [];
  List<Map> recipients = [];
  List<Map> files = [];

  @override
  void initState() {
    var newDate = DateTime(
        DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
    String formattedDate = DateFormat("dd/MM/yyyy").format(newDate);
    dateCtrl.text = formattedDate;

    recipientController.addListener(fetchUsers);
    callProviders();
  }

  void callProviders() async {
    priorities = await Provider.of<LaunchInDocProv>(context, listen: false)
        .getWfPriorities();
    priorityValue = priorities[0];

    actions = await Provider.of<LaunchInDocProv>(context, listen: false)
        .getWfActions();
    // print(actionValue.characters);
    // actionValue = 'sf';
    // print(actionValue.characters);
    actionValue = actions[0];
    // print(actionValue.characters);
    setState(() {});
  }

  void fetchUsers() async {
    if (!recipientController.text.contains(RegExp(r'[0-9]'))) {
      rcvdResult = await Provider.of<LaunchInDocProv>(context, listen: false)
          .getEmployees(recipientController.text);
      setState(() {});
    }
  }

  void removeRecipient(int index) {
    setState(() {
      recipients.removeAt(index);
      recipientsString.removeAt(index);
    });
  }

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    // print(result.files.first.name);
    // print(result.files.first.size);
    // print(result.files.first.path);

    for (int i = 0; i < files.length; i++) {
      if (result.files.first.path == files[i]["path"]) {
        // final snackBar = SnackBar(
        //   content: const Text('Document already attached.'),
        //   behavior: SnackBarBehavior.floating,
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    }

    setState(() {
      files.add({
        "name": result.files.first.name,
        "path": result.files.first.path,
      });
    });
  }

  void viewFile(int index) {
    OpenFile.open(files[index]["path"]);
  }

  void removeFile(int index) {
    print(files);
    setState(() {
      files.removeAt(index);
    });
  }

  void addRecipient() {
    setState(() {
      recipientsString.add(recipientController.text);
      var recipient = recipientController.text.split("   ");
      recipient[1] = recipient[1].substring(1);
      var newDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      String formattedDate = DateFormat("dd/MM/yyyy").format(newDate);
      print("formattedDate");
      print(formattedDate);
      recipients.add(
        {
          "name": recipient[0],
          "id": recipient[1],
          "action": actions.contains(actionController.text)
              ? actionController.text
              : "",
          "date": formattedDate
        },
      );
      recipientController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    var mHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var mWidth = mSize.width;
    var cWidth = mWidth * 0.82;

    Future<void> showSimpleDialog(int index) async {
      TextEditingController editActionController = TextEditingController();
      TextEditingController editDateController = TextEditingController();

      var userDate = recipients[index]["date"].split("/");
      String datee = userDate[2] +
          "-" +
          userDate[1] +
          "-" +
          userDate[0]; //    "dd/MM/yyyy"
      DateTime userDateOb = DateTime.parse(datee);
      print(userDateOb);

      editActionController.text = recipients[index]["action"];
      editDateController.text = recipients[index]["date"];

      // if (recipients[index]["date"].isEmpty) {
      //   var newDate = DateTime(
      //       DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      //   String formattedDate = DateFormat("dd/MM/yyyy").format(newDate);
      //   editDateController.text = formattedDate;
      // }

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Column(
              children: [
                Text(
                  'Individual User Options',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  recipients[index]["name"],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Container(
                // height: mHeight * 0.1,
                // width: mWidth * 0.1,
                // color: Colors.purple,
                padding: EdgeInsets.all(12),
                child: TextFieldSearch(
                  itemsInView: 4,
                  controller: editActionController,
                  initialList: actions,
                  label: '',
                  // getSelectedValue: (value) {
                  //   print("Selected value");
                  //   print(value);
                  // },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    hintText: "Type to search actions...",
                    labelText: AppLocalizations.of(context)!.action,
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: labelSize,
                    ),
                    // border: CustomBorderTextFieldSkin().getSkin(),
                    suffixIcon: editActionController.text != ''
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                editActionController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              Container(
                // width: cWidth,
                // margin: EdgeInsets.only(bottom: marginBottom),
                padding: EdgeInsets.all(12),
                child: TextField(
                  
                  controller: editDateController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    // hintText: AppLocalizations.of(context)!.search,
                    // labelText: "Ending Date",
                    labelText: AppLocalizations.of(context)!.endingDate,
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: labelSize,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixIcon: editDateController.text != ''
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                editDateController.clear();
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                  textInputAction: TextInputAction.search,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: userDateOb, //        round/selected date
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 2),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        String formattedDate =
                            DateFormat("dd/MM/yyyy").format(pickedDate);
                        editDateController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 12),
                // color: Colors.black87,
                // height: mHeight * 0.1,
                // width: mWidth * 0.1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () {
                      if (actions.contains(editActionController.text)) {
                        recipients[index]["action"] = editActionController.text;
                      }
                      if (editDateController.text != "") {
                        recipients[index]["date"] = editDateController.text;
                      }
                      Navigator.of(context).pop();
                      // Navigator.of(context,rootNavigator: true).pop();
                    },
                  ),
                ),
              ),

              // Navigator.of(context).pop();
              // Container(
              //   width: mWidth * 0.1,
              //   // height: mHeight * 0.09,
              //   margin: EdgeInsets.only(bottom: marginBottom),
              //   child: TextFieldSearch(
              //     itemsInView: 4,
              //     controller: editActionController,
              //     initialList: actions,
              //     label: '',
              //     // getSelectedValue: (value) {
              //     //   print("Selected value");
              //     //   print(value);
              //     // },
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Theme.of(context).backgroundColor,
              //       hintText: 'Type to search actions...',
              //       labelText: AppLocalizations.of(context)!.action,
              //       labelStyle: TextStyle(
              //         color: Theme.of(context).primaryColor,
              //         fontSize: labelSize,
              //       ),
              //       // border: CustomBorderTextFieldSkin().getSkin(),
              //       suffixIcon: editActionController.text != ''
              //           ? IconButton(
              //               onPressed: () {
              //                 setState(() {
              //                   editActionController.clear();
              //                 });
              //               },
              //               icon: Icon(
              //                 Icons.clear,
              //                 color: Theme.of(context).primaryColor,
              //               ),
              //             )
              //           : null,
              //     ),
              //   ),
              // ),
            ],
          );
        },
      );
    }

    return Container(
      height: mHeight * 0.95,
      width: mWidth,
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.all(10),
      child: SafeArea(
        child: Column(
          //     Column       ListView
          children: [
            Container(
              // height: mHeight * 0.04,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.purple,
              //     width: 1,
              //   ),
              // ),
              margin: const EdgeInsets.only(top: 10, bottom: 18),
              child: Text(
                AppLocalizations.of(context)!.internalMemo,
                // 'Internal Memo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.values[1],
              //   children: [

              //     Text(
              //       AppLocalizations.of(context)!.internalMemo,
              //       // 'Internal Memo',
              //       style: TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold,
              //         color: Theme.of(context).primaryColor,
              //       ),
              //     ),
              //   ],
              // ),
            ),
            Container(
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.purple,
              //     width: 1,
              //   ),
              // ),
              height: mHeight * 0.825,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Container(
                  height: mHeight * 1.25,
                  width: mWidth,
                  child: Column(
                    children: [
                      Container(
                        width: cWidth,
                        margin: EdgeInsets.only(bottom: marginBottom),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: subjectCtrl,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            // hintText: AppLocalizations.of(context)!.search,
                            // labelText: AppLocalizations.of(context)!.reqNo,
                            // labelText: 'Subject',
                            labelText: AppLocalizations.of(context)!.subject,
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: labelSize,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: subjectCtrl.text != ''
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        subjectCtrl.clear();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : null,
                          ),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                      Container(
                        width: cWidth,
                        margin: EdgeInsets.only(bottom: marginBottom),
                        child: DropdownButtonFormField(
                          // hint: const Text("Priority"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).backgroundColor,
                            // labelText: 'Priority',
                            labelText: AppLocalizations.of(context)!.priority,
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: labelSize,
                            ),
                            // border: CustomBorderTextFieldSkin().getSkin(),
                          ),
                          isExpanded: true,
                          value: priorityValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: priorities.map((String actions) {
                            return DropdownMenuItem(
                              value: actions,
                              child: Text(actions),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              priorityValue = newValue!;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: cWidth,
                        // height: mHeight * 0.09,
                        margin: EdgeInsets.only(bottom: marginBottom),
                        child: TextFieldSearch(
                          itemsInView: 4,
                          controller: actionController,
                          initialList: actions,
                          label: '',
                          // getSelectedValue: (value) {
                          //   print("Selected value");
                          //   print(value);
                          // },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).backgroundColor,
                            hintText: 'Type to search actions...',
                            labelText: AppLocalizations.of(context)!.action,
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: labelSize,
                            ),
                            // border: CustomBorderTextFieldSkin().getSkin(),
                            suffixIcon: actionController.text != ''
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        actionController.clear();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Container(
                        width: cWidth,
                        margin: EdgeInsets.only(bottom: marginBottom),
                        child: TextField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            // hintText: AppLocalizations.of(context)!.search,
                            // labelText: "Ending Date",
                            labelText: AppLocalizations.of(context)!.endingDate,
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: labelSize,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: dateCtrl.text != ''
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        dateCtrl.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.clear),
                                  )
                                : null,
                          ),
                          textInputAction: TextInputAction.search,
                          controller: dateCtrl,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 2),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                String formattedDate =
                                    DateFormat("dd/MM/yyyy").format(pickedDate);
                                dateCtrl.text = formattedDate;
                              });
                            }
                          },
                        ),
                      ),
                      // Container(
                      //   width: cWidth,
                      //   // height: mHeight * 0.2,
                      //   // decoration: BoxDecoration(
                      //   //   // borderRadius: BorderRadius.circular(10),
                      //   //   border: Border.all(
                      //   //     color: Theme.of(context).primaryColor,
                      //   //     width: 1,
                      //   //   ),
                      //   // ),
                      //   margin: EdgeInsets.only(bottom: marginBottom),
                      //   child: TextFieldSearch(
                      //     itemsInView: 4,
                      //     controller: recipientController,
                      //     initialList:
                      //         rcvdResult, //rcvdResult     rcvdResultUsers
                      //     // future: () {
                      //     //   return fetchComplexData();
                      //     // },
                      //     label: '',
                      //     // getSelectedValue: () {
                      //     //   print('in getSelectedValue');
                      //     //   // print(value);
                      //     // },
                      //     decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Theme.of(context).backgroundColor,
                      //       // labelText: AppLocalizations.of(context)!.action,
                      //       labelText: 'Recipient',
                      //       hintText: 'Type to search recipients...',
                      //       labelStyle: TextStyle(
                      //         color: Theme.of(context).primaryColor,
                      //         fontSize: labelSize,
                      //       ),
                      //       // border: CustomBorderTextFieldSkin().getSkin(),
                      //       suffixIcon: recipientController.text != ''
                      //           ? IconButton(
                      //               icon: Icon(
                      //                 rcvdResult.contains(
                      //                             recipientController.text) &&
                      //                         !recipientsString.contains(
                      //                             recipientController.text)
                      //                     ? Icons.check
                      //                     : Icons.clear_outlined,
                      //                 color: Theme.of(context).primaryColor,
                      //                 // color: Colors.green,
                      //               ),
                      //               onPressed: rcvdResult.contains(
                      //                           recipientController.text) &&
                      //                       !recipientsString.contains(
                      //                           recipientController.text)
                      //                   ? addRecipient
                      //                   : () {
                      //                       setState(() {
                      //                         recipientController.clear();
                      //                       });
                      //                     },
                      //             )
                      //           : null,
                      //     ),
                      //   ),
                      // ),
                      Container(
                        width: cWidth,
                        margin: EdgeInsets.only(bottom: marginBottom),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: mWidth * 0.75,
                              child: TextFieldSearch(
                                itemsInView: 4,
                                controller: recipientController,
                                initialList:
                                    rcvdResult, //rcvdResult     rcvdResultUsers
                                label: '',
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context).backgroundColor,
                                  // labelText: AppLocalizations.of(context)!.action,
                                  labelText: 'Recipient',
                                  hintText: 'Type to search recipients...',
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: labelSize,
                                  ),
                                  // border: CustomBorderTextFieldSkin().getSkin(),
                                  suffixIcon: recipientController.text != ''
                                      ? IconButton(
                                          icon: Icon(
                                            rcvdResult.contains(
                                                        recipientController
                                                            .text) &&
                                                    !recipientsString.contains(
                                                        recipientController
                                                            .text)
                                                ? Icons.check
                                                : Icons.clear_outlined,
                                            color:
                                                Theme.of(context).primaryColor,
                                            // color: Colors.green,
                                          ),
                                          onPressed: rcvdResult.contains(
                                                      recipientController
                                                          .text) &&
                                                  !recipientsString.contains(
                                                      recipientController.text)
                                              ? addRecipient
                                              : () {
                                                  setState(() {
                                                    recipientController.clear();
                                                  });
                                                },
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            Container(
                              height: mHeight * 0.2,
                              child: recipientsString.length == 0
                                  ? ListTile(
                                      leading: Icon(
                                        // Icons.account_circle,
                                        Icons.no_accounts_rounded,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title:
                                          const Text('No recipient selected'),
                                      // trailing: Icon(
                                      //   Icons.clear,
                                      //   color: Theme.of(context).primaryColor,
                                      // ),
                                    )
                                  : ListView.builder(
                                      itemCount: recipients.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Icon(
                                            Icons.account_circle,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text(
                                            recipients[index]["name"],
                                          ),
                                          trailing: Container(
                                            width: mWidth * 0.18,
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(
                                            //     color: Theme.of(context)
                                            //         .primaryColor,
                                            //     width: 1,
                                            //   ),
                                            // ),
                                            child: FittedBox(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () =>
                                                        showSimpleDialog(index),
                                                    icon: const Icon(Icons
                                                        .drive_file_rename_outline),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  IconButton(
                                                    onPressed: () =>
                                                        removeRecipient(index),
                                                    icon: const Icon(
                                                        Icons.clear_outlined),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: mHeight * 0.25,
                        width: cWidth,
                        margin: EdgeInsets.only(bottom: marginBottom),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              // height: mHeight * 0.2,
                              child: files.length == 0
                                  ? ListTile(
                                      leading: Icon(
                                        // Icons.account_circle,
                                        Icons.no_accounts_rounded,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: const Text('No attachment'),
                                      // trailing: Icon(
                                      //   Icons.clear,
                                      //   color: Theme.of(context).primaryColor,
                                      // ),
                                    )
                                  : ListView.builder(
                                      itemCount: files.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Icon(
                                            Icons.insert_drive_file_outlined,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text(
                                            files[index]["name"],
                                          ),
                                          trailing: Container(
                                            width: mWidth * 0.18,
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(
                                            //     color: Theme.of(context)
                                            //         .primaryColor,
                                            //     width: 1,
                                            //   ),
                                            // ),
                                            child: FittedBox(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons
                                                        .remove_red_eye_outlined),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    onPressed: () {
                                                      viewFile(index);
                                                      // print("view file");
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete_outline),
                                                    color: Colors.red,
                                                    onPressed: () =>
                                                        removeFile(index),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Theme.of(context).primaryColor,
                                //     width: 1,
                                //   ),
                                // ),
                                margin: EdgeInsets.only(right: 8, bottom: 8),
                                child: FloatingActionButton(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  // mini: false,
                                  onPressed: () {
                                    _pickFile();
                                    // print("object");
                                    // LaunchInModal();
                                    // dynamic state = btnKey.currentState;
                                    // state.showButtonMenu();
                                  },
                                  child: IconButton(
                                    onPressed: () {
                                      _pickFile();
                                    },
                                    icon: const Icon(Icons.upload_file),
                                    // child: Text('ElevatedButton'),
                                    // style: ElevatedButton.styleFrom(
                                    //   shape: StadiumBorder(),
                                    //   side:
                                    //       BorderSide(color: Colors.red, width: 2),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.only(bottom: marginBottom),
                        width: cWidth,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // _pickFile();
                            // print(actionController.text);
                            // print(actionController);
                          },
                          child: Text(
                            'Execute',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: labelSize,
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 15),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       print(recipients);
                      //     },
                      //     child: const Text('print'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
