import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../providers/launchInDocProv.dart';
import '../providers/forwardWfPro.dart';
import '../providers/fileProvider.dart';

import '../screens/inbox.dart';

import '../widgets/modelHeader.dart';
import '../widgets/wfSubject.dart';
import '../widgets/executeBtn.dart';
import '../widgets/incompleteEntries.dart';
import '../widgets/pickFileBtn.dart';
import '../widgets/wfStatusDialog.dart';

class ForwardWf extends StatefulWidget {
  final List<double> detIDs;
  ForwardWf(this.detIDs);

  @override
  State<ForwardWf> createState() => _ForwardWfState();
}

class _ForwardWfState extends State<ForwardWf> {
  TextEditingController subjectCtrl = TextEditingController();
  TextEditingController priorityCtrl = TextEditingController();
  TextEditingController actionController = TextEditingController();
  TextEditingController recipientController = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  String reqNo = "";
  int prioId = 0;
  List attachments = [];

  List<String> recipientsString = [];
  List<Map> recipients = [];
  List<String> rcvdResult = [];
  List actions = [];
  List actionIds = [];
  double marginBottom = 10;
  double labelSize = 20;
  bool rcvdFromProviders = false;
  bool forwarding = false;
  List<String> incompleteEntries = [];
  List<Map> files = [];
  int prevFiles = 0;
  List<Map> newFiles = [];

  @override
  void initState() {
    recipientController.addListener(fetchUsers);
    callProviders();
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

  void addRecipient() {
    setState(() {
      recipientsString.add(recipientController.text);
      var recipient = recipientController.text.split("   ");
      recipient[1] = recipient[1].substring(1);
      var newDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      String formattedDate = DateFormat("dd/MM/yyyy").format(newDate);
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

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    for (int i = 0; i < files.length; i++) {
      if (result.files.first.path == files[i]["FileURL"]) {
        // final snackBar = SnackBar(
        //   content: const Text('Document already attached.'),
        //   behavior: SnackBarBehavior.floating,
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    }

    setState(() {
      newFiles.add({
        "FileName": result.files.first.name,
        "FileURL": result.files.first.path,
        "deletable": true,
      });
      files.add({
        "FileName": result.files.first.name,
        "FileURL": result.files.first.path,
        "deletable": true,
      });
    });
  }

  void viewFile(int index) {
    if (files[index]["deletable"])
      OpenFile.open(files[index]["FileURL"]);
    else {}
  }

  void removeFile(int index) {
    setState(() {
      newFiles.removeAt(index - prevFiles);
      files.removeAt(index);
    });
  }

  void callProviders() async {
    List<List> actionsWithIds = await Provider.of<LaunchInDocProv>(context, listen: false).getWfActions();
    actions = actionsWithIds[0];
    actionIds = actionsWithIds[1];

    List<Map> rcvdWfData = await Provider.of<ForwardWfPro>(context, listen: false).getWfData(widget.detIDs);
    subjectCtrl.text = rcvdWfData[0]["subject"];
    priorityCtrl.text = rcvdWfData[0]["priority"];
    prioId = rcvdWfData[0]["priorityID"];
    reqNo = rcvdWfData[0]["reqNo"];
    dateCtrl.text = rcvdWfData[0]["wfDeadline"];
    attachments = rcvdWfData[0]["attachs"];
    for (var attachment in attachments) {
      Map fileData = await Provider.of<FileProvider>(context, listen: false).getFilesUrlAndName(widget.detIDs[0], attachment["vsID"]);
      // print(fileData);
      if (fileData.containsKey("FileName")) {
        prevFiles += 1;
        files.add(fileData);
      }
    }

    rcvdFromProviders = true;
    setState(() {});
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
    var modalBodyHeight = modalHeight * 0.91;

    showAlertDialog() {
      return showDialog<void>(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return IncompleteEntries(mHeight, incompleteEntries);
        },
      );
    }

    showStatusDialog(bool res) {
      return showDialog<void>(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          if (res)
            return WfStatusDialog(res, "Operation Successful.", mHeight);
          else
            return WfStatusDialog(res, "An error occured during execution!", mHeight);
        },
      );
    }

    void forward() async {
      setState(() {
        forwarding = true;
      });
      incompleteEntries.clear();
      if (!actions.contains(actionController.text)) {
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
      // if (files.isEmpty) {
      //   incompleteEntries.add("- Attach at least one file.");
      // }
      if (incompleteEntries.isNotEmpty) {
        setState(() {
          forwarding = false;
        });
        showAlertDialog();
      } else {
        List finalAttachments = attachments;
        if (newFiles.length > 0) {
          List<String> paths = [];
          for (int i = 0; i < newFiles.length; i++) paths.add(newFiles[i]["FileURL"]);
          List filesData = await Provider.of<LaunchInDocProv>(context, listen: false).uploadFileAndGetItsData(paths);
          Map newAttach = {
            "vsID": "",
            "DocTypeCode": 1,
            "CorrepCode": "",
            "isCurrent": 0,
            "Serial": 2,
            "UploadMethod": 1,
            "AllowSignMemo": false,
            "AllowRestoreMainDocument": false,
            "Files": filesData
          };
          finalAttachments.add(newAttach);
        }
        int actionID = actionIds[actions.indexOf(actionController.text)]; //    1
        List wfDate = dateCtrl.text.split("/");
        String wfEndDate = wfDate[2] + "-" + wfDate[1] + "-" + wfDate[0]; //    4

        List<Map> launchToUsers = [];

        for (var recipient in recipients) {
          int userActionID;
          if (recipient["action"] == actionController.text)
            userActionID = actionID;
          else
            userActionID = actionIds[actions.indexOf(actionController.text)];
          var userDateA = recipient["date"].split("/");
          String userDateS = userDateA[2] + "-" + userDateA[1] + "-" + userDateA[0];

          Map user = {
            "RecipientID": '${recipient["id"]}', //    '${recipient["id"]}'         recipient["id"]
            "RecipientName": recipient["name"],
            "ActionID": '$userActionID', //          '$userActionID'
            "ActionName": recipient["action"],
            "Deadline": userDateS,
            "Comment": recipient["notes"],
          };
          launchToUsers.add(user);
        }

        // List finalAttachments = attachments;

        Map<String, dynamic> finalObject = {
          "DetID": widget.detIDs[0],
          "ReqNo": reqNo,
          "attachments": finalAttachments,
          "actID": actionID,
          "Subject": subjectCtrl.text,
          "PrioID": prioId,
          "WfEndD": wfEndDate,
          "LaunchToUsers": launchToUsers,
        };
        bool res = await Provider.of<ForwardWfPro>(context, listen: false).forwardWorkflow(finalObject);
        setState(() {
          forwarding = false;
        });
        await showStatusDialog(res);
        // if (res) Navigator.of(context).pop();
        if (res) Navigator.pushReplacementNamed(context, Inbox.routeName);
      }
    }

    return Container(
      height: modalHeight,
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          ModelHeader("Forward Workflow"),
          Container(
            height: modalBodyHeight,
            child: rcvdFromProviders
                ? SingleChildScrollView(
                    child: Container(
                      height: mHeight * 1.25,
                      child: Column(
                        children: [
                          WfSubject(cWidth, marginBottom, labelSize, subjectCtrl, false),
                          Container(
                            width: cWidth,
                            // margin: EdgeInsets.only(bottom: marginBottom),
                            child: TextField(
                              enabled: false,
                              controller: priorityCtrl,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.priority,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: labelSize,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              textInputAction: TextInputAction.search,
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
                              enabled: false,
                              controller: dateCtrl,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.endingDate,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: labelSize,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              textInputAction: TextInputAction.search,
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
                                    initialList: rcvdResult,
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
                                                color: rcvdResult.contains(recipientController.text) &&
                                                        !recipientsString.contains(recipientController.text)
                                                    ? Colors.green
                                                    : Theme.of(context).primaryColor,
                                                // color: Colors.green,
                                              ),
                                              onPressed: rcvdResult.contains(recipientController.text) &&
                                                      !recipientsString.contains(recipientController.text)
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
                                                child: FittedBox(
                                                  child: Row(
                                                    children: [
                                                      // IconButton(
                                                      //   onPressed: () => showUserDialog(index),
                                                      //   icon: const Icon(Icons.drive_file_rename_outline),
                                                      //   color: Theme.of(context).primaryColor,
                                                      // ),
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
                          // if (widget.detIDs.length == 1)
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
                                                files[index]["FileName"],
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
                                                      files[index]["deletable"]
                                                          ? IconButton(
                                                              icon: const Icon(Icons.delete_outline),
                                                              color: Colors.red,
                                                              onPressed: () => removeFile(index),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                                if (widget.detIDs.length == 1)
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: PickFileBtn(_pickFile),
                                  ),
                              ],
                            ),
                          ),
                          ExecuteBtn(mHeight, cWidth, forward, forwarding, labelSize, "Forward"),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
