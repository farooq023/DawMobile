import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/launchInDocProv.dart';
import 'package:textfield_search/textfield_search.dart';

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

  String actionValue = '';
  String priorityValue = '';
  double labelSize = 20;
  double marginBottom = 10;

  List<String> priorities = [];
  List<String> actions = [];
  List<Map> rcvdResult = [];
  List<String> rcvdResultUsers = [];
  // List<Map> rcvdResultUsers2 = [
  //   {
  //     "name":"farooq",
  //     "id":5,
  //   },
  //   {
  //     "name":"tariq",
  //     "id" : 6,
  //   },
  //   {
  //     "name":"taimoor",
  //     "id" : 7,
  //   },
  // ];
  // String i = ('a');
  List<int> rcvdResultId = [];

  List<String> recipients = [];

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
    rcvdResult = await Provider.of<LaunchInDocProv>(context, listen: false)
        .getEmployees(recipientController.text);

    rcvdResultUsers = [];
    for (int i = 0; i < rcvdResult.length; i++) {
      rcvdResultUsers.add(rcvdResult[i]["name"]);
    }

    setState(() {});
  }

  // Future<List<String, dynamic>> fetchComplexData() async {
  //   // rcvdResult = await Provider.of<LaunchInDocProv>(context, listen: false)
  //   //     .getEmployees(recipientController.text);

  //   // rcvdResultUsers = [];
  //   // for (int i = 0; i < rcvdResult.length; i++) {
  //   //   rcvdResultUsers.add(rcvdResult[i]["Name"]);
  //   // }

  //   // setState(() {});
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   List<String, dynamic> _list = [];
  //   _list = [
  //     {
  //       'label': 'abcdef',
  //       'value': 1,
  //     },
  //     {
  //       'label': 'abcdaerggthef',
  //       'value': 2,
  //     },
  //     {
  //       'label': 'ghdsgvbdhj',
  //       'value': 3,
  //     },
  //   ];

  //   // create a list from the text input of three items
  //   // to mock a list of items from an http call where
  //   // the label is what is seen in the textfield and something like an
  //   // ID is the selected value
  //   // _list.add(new TestItem.fromJson(_jsonList[0]));
  //   // _list.add(new TestItem.fromJson(_jsonList[1]));
  //   // _list.add(new TestItem.fromJson(_jsonList[2]));

  //   return _list;
  // }

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    var mHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var mWidth = mSize.width;

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
              height: mHeight * 0.04,
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
                        width: mWidth * 0.82,
                        margin: EdgeInsets.only(bottom: marginBottom),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: Colors.purple,
                        //     width: 1,
                        //   ),
                        // ),
                        child: TextFormField(
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
                        width: mWidth * 0.82,
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
                        width: mWidth * 0.82,
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
                        width: mWidth * 0.82,
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
                      Container(
                        width: mWidth * 0.82,
                        // height: mHeight * 0.2,
                        // decoration: BoxDecoration(
                        //   // borderRadius: BorderRadius.circular(10),
                        //   border: Border.all(
                        //     color: Theme.of(context).primaryColor,
                        //     width: 1,
                        //   ),
                        // ),
                        margin: EdgeInsets.only(bottom: marginBottom),
                        child: TextFieldSearch(
                          itemsInView: 4,
                          controller: recipientController,
                          initialList: rcvdResultUsers, //rcvdResult     rcvdResultUsers2
                          // future: () {
                          //   return fetchComplexData();
                          // },
                          label: 'name',
                          // getSelectedValue: () {
                          //   print('in getSelectedValue');
                          //   // print(value);
                          // },
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
                                    // disabledColor: Colors.red,
                                    onPressed: rcvdResultUsers.contains(
                                                recipientController.text) &&
                                            !recipients.contains(
                                                recipientController.text)
                                        ? () {
                                            setState(() {
                                              recipients.add(
                                                  recipientController.text);
                                              recipientController.clear();
                                            });
                                          }
                                        : () {
                                            setState(() {
                                              recipientController.clear();
                                            });
                                          },
                                    // onPressed: null,
                                    icon: Icon(
                                      rcvdResultUsers.contains(
                                                  recipientController.text) &&
                                              !recipients.contains(
                                                  recipientController.text)
                                          ? Icons.check
                                          : Icons.clear_outlined,
                                      color: Theme.of(context).primaryColor,
                                      // color: Colors.green,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Container(
                        height: mHeight * 0.2,
                        width: mWidth * 0.82,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        child: recipients.length == 0
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
                                      recipients[index],
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          recipients.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(Icons.clear_outlined),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  );
                                },
                              ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 15),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       print(priorityValue);
                      //       print('TEXT');
                      //       print(actionController.text);
                      //       print('TEXT 2');
                      //       print(rcptController.text);
                      //       print('************');
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
