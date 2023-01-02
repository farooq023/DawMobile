import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../providers/launchInDocProv.dart';
import '../widgets/wfSubject.dart';

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

  rules? selectedRule;

  // String actionValue = '';
  double labelSize = 20;
  double marginBottom = 10;

  List priorities = [];
  List priorityIds = [];
  String priorityValue = '';

  List actions = [];
  List actionIds = [];

  List<String> rcvdResult = [];
  // List<String> rcvdResultUsers = [];
  // List<int> rcvdResultId = [];

  List<String> recipientsString = [];
  List<Map> recipients = [];
  List<Map> files = [];
  List<String> incompleteEntries = [];
  bool launching = false;

  @override
  void initState() {
    var newDate = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
    String formattedDate = DateFormat("dd/MM/yyyy").format(newDate);
    dateCtrl.text = formattedDate;
    recipientController.addListener(fetchUsers);
    callProviders();
  }

  void callProviders() async {
    List<List> prioritiesWithIds = await Provider.of<LaunchInDocProv>(context, listen: false).getWfPriorities();
    priorities = prioritiesWithIds[0];
    priorityIds = prioritiesWithIds[1];
    priorityValue = priorities[0];

    List<List> actionsWithIds = await Provider.of<LaunchInDocProv>(context, listen: false).getWfActions();
    actions = actionsWithIds[0];
    actionIds = actionsWithIds[1];
    setState(() {});
  }

  void fetchUsers() async {
    setState(() {});
    if (!recipientController.text.contains(RegExp(r'[0-9]'))) {
      rcvdResult = await Provider.of<LaunchInDocProv>(context, listen: false).getEmployees(recipientController.text);
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
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

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
      var newDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      String formattedDate = DateFormat("dd/MM/yyyy").format(newDate);
      // print("formattedDate");
      // print(formattedDate);
      recipients.add(
        {
          "name": recipient[0],
          "id": recipient[1],
          "action": actions.contains(actionController.text) ? actionController.text : "",
          "date": formattedDate,
          "notes": ""
        },
      );
      recipientController.clear();
    });
  }

  void showUserDialog(int index) {
    TextEditingController editActionController = TextEditingController();
    TextEditingController notesCtrl = TextEditingController();
    TextEditingController editDateController = TextEditingController();
    DateTime userDateOb = DateTime(DateTime.now().day + 1);

    if (recipients[index]["date"].isNotEmpty) {
      var userDate = recipients[index]["date"].split("/");
      String datee = userDate[2] + "-" + userDate[1] + "-" + userDate[0];
      userDateOb = DateTime.parse(datee);
    }

    editActionController.text = recipients[index]["action"];
    editDateController.text = recipients[index]["date"];
    notesCtrl.text = recipients[index]["notes"];

    showDialog(
      context: context,
      // barrierDismissible: false,
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
              padding: EdgeInsets.all(12),
              child: TextFieldSearch(
                itemsInView: 4,
                controller: editActionController,
                initialList: actions,
                label: '',
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
              padding: EdgeInsets.all(12),
              child: TextField(
                controller: editDateController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
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
                    String formattedDate = DateFormat("dd/MM/yyyy").format(pickedDate);
                    editDateController.text = formattedDate;
                    // setState(() {
                    //   String formattedDate =
                    //       DateFormat("dd/MM/yyyy").format(pickedDate);
                    //   editDateController.text = formattedDate;
                    // });
                  }
                },
              ),
            ),
            Container(
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.red,
              //     width: 1,
              //   ),
              // ),
              padding: EdgeInsets.all(12),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: notesCtrl,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: "Notes",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: labelSize,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: notesCtrl.text != ''
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              notesCtrl.clear();
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
              padding: const EdgeInsets.only(top: 24, right: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    if (actions.contains(editActionController.text)) {
                      recipients[index]["action"] = editActionController.text;
                    }
                    recipients[index]["date"] = editDateController.text;
                    recipients[index]["notes"] = notesCtrl.text;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
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

    var modalHeight = mHeight * 0.95;
    // var modalHeaderHeight = modalHeight * 0.05;
    var modalBodyHeight = modalHeight * 0.9;

    Widget incompleteEntriesDialog() {
      return Container(
        height: mHeight * 0.15,
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: incompleteEntries.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(
              incompleteEntries[index],
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      );
    }

    showAlertDialog() {
      return showDialog<void>(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: const Icon(
              Icons.warning,
              color: Colors.red,
              size: 45,
            ),
            content: incompleteEntriesDialog(),
            actions: [
              OutlinedButton(
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    showStatusDialog(bool res) {
      return showDialog<void>(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: res
                ? const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 45,
                  )
                : const Icon(
                    Icons.clear,
                    color: Colors.red,
                    size: 45,
                  ),
            content: Container(
              height: mHeight * 0.07,
              width: double.maxFinite,
              child: Center(
                child: Text(
                  res ? "Execution Successful!" : "An error occured during execution!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              // }
            ),
            actions: [
              OutlinedButton(
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void execute() async {
      setState(() {
        launching = true;
      });
      incompleteEntries.clear();
      if (subjectCtrl.text.isEmpty) {
        incompleteEntries.add("- Add Subject.");
      }
      if (actionController.text.isNotEmpty && !actions.contains(actionController.text)) {
        incompleteEntries.add("- Invalid Action!");
      }
      if (recipients.isEmpty) {
        incompleteEntries.add("- Add at least one recipient.");
      } else {
        var arrayFinalDate = dateCtrl.text.split("/");
        String stringFinalDate = arrayFinalDate[2] + "-" + arrayFinalDate[1] + "-" + arrayFinalDate[0];
        DateTime obfinalDate = DateTime.parse(stringFinalDate);

        for (int i = 0; i < recipients.length; i++) {
          if (recipients[i]["date"].isNotEmpty) {
            var userFinalDate = recipients[i]["date"].split("/");
            String stringUserDate = userFinalDate[2] + "-" + userFinalDate[1] + "-" + userFinalDate[0];
            DateTime obUserDate = DateTime.parse(stringUserDate);

            if (obUserDate.isAfter(obfinalDate)) {
              incompleteEntries.add("- Invalid date selection for " + recipients[i]["name"] + ".");
            }
          }
        }
      }
      if (files.isEmpty) {
        incompleteEntries.add("- Attach at least one file.");
      }
      if (incompleteEntries.length > 0) {
        setState(() {
          launching = false;
        });
        showAlertDialog();
      } else {
        List<String> paths = [];
        for (int i = 0; i < files.length; i++) paths.add(files[i]["path"]);
        dynamic filesData = await Provider.of<LaunchInDocProv>(context, listen: false).uploadFileAndGetItsData(paths);
        int actionID = actionIds[actions.indexOf(actionController.text)]; //    1
        int priorityID = priorityIds[priorities.indexOf(priorityValue)]; //    3
        List wfDate = dateCtrl.text.split("/");
        String wfEndDate = wfDate[2] + "-" + wfDate[1] + "-" + wfDate[0]; //    4

        List<Map> launchToUsers = [];
        for (int i = 0; i < recipients.length; i++) {
          int userActionID;
          if (recipients[i]["action"] == actionController.text)
            userActionID = actionID;
          else
            userActionID = actionIds[actions.indexOf(actionController.text)]; //    date

          var userDateA = recipients[i]["date"].split("/");
          String userDateS = userDateA[2] + "-" + userDateA[1] + "-" + userDateA[0];

          // print("|"+userDateS+"|");

          Map user = {
            //    <String, dynamic>
            "RecipientID": '${recipients[i]["id"]}', //    '${recipients[i]["id"]}'         recipients[i]["id"]
            "RecipientName": recipients[i]["name"],
            "ActionID": '$userActionID', //          '$userActionID'
            "ActionName": recipients[i]["action"],
            "Deadline": userDateS,
            "Comment": recipients[i]["notes"],
          };
          launchToUsers.add(user);
        }

        Map<String, dynamic> finalObject = {
          "actID": actionID,
          "Subject": subjectCtrl.text,
          "PrioID": priorityID,
          "WfEndD": wfEndDate,
          "filessss": filesData,
          "LaunchToUsers": launchToUsers,
        };

        bool res = await Provider.of<LaunchInDocProv>(context, listen: false).launchWorkflow(finalObject);
        launching = false;
        await showStatusDialog(res);
        if (res) Navigator.of(context).pop();
      }
    }

    return Container(
      height: modalHeight,
      // width: mWidth,
      color: Theme.of(context).backgroundColor,
      // padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 18),
            child: Text(
              AppLocalizations.of(context)!.internalMemo,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.red,
            //     width: 1,
            //   ),
            // ),
            height: modalBodyHeight,
            child: SingleChildScrollView(
              child: Container(
                height: mHeight * 1.25,
                // width: mWidth,
                child: Column(
                  children: [
                    WfSubject(cWidth, marginBottom, labelSize, subjectCtrl),
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
                        items: priorities.map((actions) {
                          return DropdownMenuItem(
                            value: actions,
                            child: Text(actions),
                          );
                        }).toList(),
                        onChanged: (dynamic? newValue) {
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        textInputAction: TextInputAction.search,
                        controller: dateCtrl,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            // initialDate: DateTime.now(),
                            initialDate: DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day),
                            firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
                            lastDate: DateTime(DateTime.now().year + 2),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              String formattedDate = DateFormat("dd/MM/yyyy").format(pickedDate);
                              dateCtrl.text = formattedDate;
                            });
                          }
                        },
                      ),
                    ),
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
                              initialList: rcvdResult, //rcvdResult     rcvdResultUsers
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
                                          rcvdResult.contains(recipientController.text) && !recipientsString.contains(recipientController.text)
                                              ? Icons.check_circle_outline
                                              : Icons.clear_outlined,
                                          color: rcvdResult.contains(recipientController.text) && !recipientsString.contains(recipientController.text)
                                              ? Colors.green
                                              : Theme.of(context).primaryColor,
                                          // color: Colors.green,
                                        ),
                                        onPressed:
                                            rcvdResult.contains(recipientController.text) && !recipientsString.contains(recipientController.text)
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
                                    title: const Text('No recipient selected'),
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
                                          color: Theme.of(context).primaryColor,
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
                                                  onPressed: () => showUserDialog(index),
                                                  icon: const Icon(Icons.drive_file_rename_outline),
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                IconButton(
                                                  onPressed: () => removeRecipient(index),
                                                  icon: const Icon(Icons.clear_outlined),
                                                  color: Theme.of(context).primaryColor,
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
                                      Icons.insert_page_break,
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
                                          Icons.insert_drive_file,
                                          color: Theme.of(context).primaryColor,
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
                                                  icon: const Icon(Icons.remove_red_eye_outlined),
                                                  color: Theme.of(context).primaryColor,
                                                  onPressed: () {
                                                    viewFile(index);
                                                    // print("view file");
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete_outline),
                                                  color: Colors.red,
                                                  onPressed: () => removeFile(index),
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
                              margin: EdgeInsets.only(right: 10, bottom: 10),
                              child: FloatingActionButton(
                                backgroundColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  _pickFile();
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
                      height: mHeight * (0.25 / 3),
                      width: cWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: execute,
                        child: launching
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
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
    );
  }
}
