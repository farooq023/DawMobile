import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../providers/launchInDocProv.dart';
import '../providers/forwardWfPro.dart';

import '../widgets/modelHeader.dart';

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
  TextEditingController recipientController = TextEditingController(); // dateCtrl
  TextEditingController dateCtrl = TextEditingController(); // dateCtrl

  List<String> recipientsString = [];
  List<Map> recipients = [];
  List<Map> files = [];

  List<String> rcvdResult = [];

  List actions = [];
  List actionIds = [];

  double marginBottom = 10;
  double labelSize = 20;

  bool rcvdFromProviders = false;

  @override
  void initState() {
    recipientController.addListener(fetchUsers);
    callProviders();
  }

  void callProviders() async {
    List<List> actionsWithIds = await Provider.of<LaunchInDocProv>(context, listen: false).getWfActions();
    actions = actionsWithIds[0];
    actionIds = actionsWithIds[1];
    List<Map> rcvdWfData = await Provider.of<ForwardWfPro>(context, listen: false).getWfData(widget.detIDs);
    subjectCtrl.text = rcvdWfData[0]["subject"];
    priorityCtrl.text = rcvdWfData[0]["priority"];
    dateCtrl.text = rcvdWfData[0]["wfDeadline"];
    rcvdFromProviders = true;
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
                          Container(
                            width: cWidth,
                            margin: EdgeInsets.only(bottom: marginBottom),
                            child: TextField(
                              enabled: false,
                              controller: subjectCtrl,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.subject,
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
                          if (widget.detIDs.length == 1)
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
                                      margin: const EdgeInsets.only(right: 10, bottom: 10),
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
