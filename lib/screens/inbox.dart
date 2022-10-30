import 'package:daw/widgets/changeLangButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import '../providers/auth.dart';
import '../providers/inboxPro.dart';

// import './fileViewer.dart';
import './vsidList.dart';

import '../widgets/main_drawer.dart';
// import '../widgets/inboxTile.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  static const routeName = '/inbox';

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  List<Map> _setInbox = [];
  bool _received = false;
  int _selection = 0;
  List<double> selectedDetIds = [];

  // List<IconData> iconsList = [
  //   Icons.noise_control_off,
  // ];

  static const double iconSize = 25;
  List<Widget> iconsList = const [
    Icon(
      Icons.noise_control_off,
      color: Color(0xFF1976D2),
      size: iconSize,
    ),
    Icon(
      Icons.pending,
      size: iconSize,
    ),
    Icon(
      Icons.arrow_circle_right,
      size: iconSize,
    ),
    Icon(
      Icons.check_box,
      size: iconSize,
    ),
    Icon(
      Icons.arrow_circle_left,
      size: iconSize,
    ),
    Icon(
      Icons.archive,
      size: iconSize,
    ),
    Icon(
      Icons.cancel_rounded,
      size: iconSize,
    ),
    Icon(
      Icons.double_arrow,
      size: iconSize,
    ),
  ];

  int _falseForwards = 0, _falseNewWF = 0, _falseCompletes = 0, _falseNotes = 0;

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    // print('now calling Providers');
    _setInbox =
        await Provider.of<InboxPro>(context, listen: false).getFullInbox();
    _received = true;

    setState(() {});
  }

  void setSelection() {
    _selection = 0;
    setState(() {
      // _setInbox = Provider.of<InboxPro>(context, listen: false).savedInbox;
    });
  }


  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    final mHeight = mSize.height;
    final mWidth = mSize.width;

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          // title: Text('Inbox'),
          title: Text(AppLocalizations.of(context)!.inbox),
          // title: const Text('Incoming Workflows'),
          actions: _selection != 0
              ? [
                  TextButton(
                    onPressed: setSelection,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        // fontSize: 10,
                      ),
                    ),
                  ),
                ]
              : [
                const ChangeLang(),
              ],
        ),
        drawer: const MainDrawer(),
        body: SafeArea(
          child: _received
              ? Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Colors.black,
                  //     width: 2,
                  //   ),
                  // ),
                  // margin: const EdgeInsets.all(8),
        
                  child: _setInbox.length > 0
                      ? (_selection == 0
                          ? (ListView.builder(
                              itemCount: _setInbox.length,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return GestureDetector(
                                  // onDoubleTap: () {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => FileViewer(
                                  //         _setInbox[i]['DETID'],
                                  //       ),
                                  //     ),
                                  //   );
                                  // },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VsIdList(
                                          _setInbox[i]['SUBJECT'],
                                          _setInbox[i]['DETID'],
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    _selection = 1;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: mHeight * 0.17,
                                    padding: const EdgeInsets.all(6),
                                    // color: ,
                                    child: Row(
                                      children: [
                                        Container(
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(
                                          //     color: Colors.black,
                                          //     width: 2,
                                          //   ),
                                          // ),
                                          width: mWidth * 0.138,
                                          child: Column(
                                            children: [
                                              const Align(
                                                alignment: Alignment(0, -1),
                                                child: Icon(
                                                  Icons.account_circle,
                                                  size: 48,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: iconsList[
                                                    _setInbox[i]['StatusID'] - 1],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(
                                          //     color: Colors.black,
                                          //     width: 2,
                                          //   ),
                                          // ),
                                          // width: mWidth * 0.782,
                                          width: mWidth * 0.81,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: mWidth * 0.45,
                                                    child: Text(
                                                      "${_setInbox[i]['Sender']}",
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        // color: Colors.blue,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: mWidth * 0.25,
                                                    child: Align(
                                                      alignment:
                                                          const Alignment(1, 0),
                                                      child: Text(
                                                        "${_setInbox[i]['WFBeginDate']}",
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          // fontWeight: FontWeight.bold,
                                                          // color: Colors.blue,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: mWidth * 0.45,
                                                child: Text(
                                                  "${_setInbox[i]['SUBJECT']}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    // color: Colors.blue,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              Container(
                                                width: mWidth * 0.85,
                                                child: Text(
                                                  "${_setInbox[i]['RequisitionNo']}",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    // color: Colors.blue,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              // const Divider(thickness: 1),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ))
                          :
        
                          // ********* Selection container below *********
        
                          ListView.builder(
                              itemCount: _setInbox.length,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return CheckboxListTile(
                                  title: Container(
                                    height: mHeight * 0.17,
                                    // padding: const EdgeInsets.all(6),
                                    // color: ,
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(
                                      //     color: Colors.black,
                                      //     width: 2,
                                      //   ),
                                      // ),
                                      // width: mWidth * 0.782,
                                      width: mWidth * 0.81,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: mWidth * 0.45,
                                                child: Text(
                                                  "${_setInbox[i]['Sender']}",
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    // color: Colors.blue,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              Container(
                                                width: mWidth * 0.25,
                                                child: Align(
                                                  alignment:
                                                      const Alignment(1, 0),
                                                  child: Text(
                                                    "${_setInbox[i]['WFBeginDate']}",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      // fontWeight: FontWeight.bold,
                                                      // color: Colors.blue,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: mWidth * 0.45,
                                            child: Text(
                                              "${_setInbox[i]['SUBJECT']}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                // color: Colors.blue,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                          Container(
                                            width: mWidth * 0.85,
                                            child: Text(
                                              "${_setInbox[i]['RequisitionNo']}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                // color: Colors.blue,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                          // const Divider(thickness: 1),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // 3.
                                  value: _setInbox[i]['isChecked'],
                                  // 4.
                                  onChanged: (bool? value) {
                                    setState(
                                      () {
                                        _setInbox[i]['isChecked'] = value!;
                                        if (selectedDetIds
                                            .contains(_setInbox[i]['DETID'])) {
                                          selectedDetIds
                                              .remove(_setInbox[i]['DETID']);
                                          if (_setInbox[i]['_falseForwards'] ==
                                              false) {
                                            _falseForwards--;
                                          }
                                          if (_setInbox[i]['_falseNewWF'] ==
                                              false) {
                                            _falseNewWF--;
                                          }
                                          if (_setInbox[i]['_falseCompletes'] ==
                                              false) {
                                            _falseCompletes--;
                                          }
                                          if (_setInbox[i]['_falseNotes'] ==
                                              false) {
                                            _falseNotes--;
                                          }
                                        } else {
                                          selectedDetIds
                                              .add(_setInbox[i]['DETID']);
                                          if (_setInbox[i]['_falseForwards'] ==
                                              false) {
                                            _falseForwards++;
                                          }
                                          if (_setInbox[i]['_falseNewWF'] ==
                                              false) {
                                            _falseNewWF++;
                                          }
                                          if (_setInbox[i]['_falseCompletes'] ==
                                              false) {
                                            _falseCompletes++;
                                          }
                                          if (_setInbox[i]['_falseNotes'] ==
                                              false) {
                                            _falseNotes++;
                                          }
                                        }
                                      },
                                    );
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              },
                            ))
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inbox,
                                size: 28,
                              ),
                              Text(
                                AppLocalizations.of(context)!.nom,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
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
        ),
        bottomNavigationBar: _selection != 0
            ? BottomAppBar(
                color: Theme.of(context).backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.forward),
                      onPressed:
                          selectedDetIds.length > 0 && _falseForwards == 0
                              ? () {
                                  // print('pressed');
                                }
                              : null,
                    ),
                    IconButton(
                      icon: Icon(Icons.new_label),
                      onPressed: selectedDetIds.length > 0 && _falseNewWF == 0
                          ? () {
                              // print('pressed');
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_rounded),
                      onPressed:
                          selectedDetIds.length == 1 && _falseCompletes == 0
                              ? () {
                                  // print('pressed');
                                }
                              : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.note_add),
                      onPressed: selectedDetIds.length == 1 && _falseNotes == 0
                          ? () {
                              // print('pressed');
                            }
                          : null,
                    ),
                  ],
                ),
              )
            : null);
  }
}
