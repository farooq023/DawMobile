import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/inboxPro.dart';
import '../providers/widgetDataProvider.dart';

// import './fileViewer.dart';
import './vsidList.dart';

import '../widgets/main_drawer.dart';
import '../widgets/changeLangButton.dart';
import '../widgets/searchFilterIn.dart';
import '../widgets/launchInDoc.dart';
import '../widgets/forwardWf.dart';

// import '../widgets/inboxTile.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  static const routeName = '/inbox';

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  bool _received = false;

  List<Map> _rcvdInbox = [];
  List<Map> _setInbox = [];
  int _selection = 0;
  List<double> selectedDetIds = [];
  String searchText = '';
  var focusS = FocusNode();

  final GlobalKey btnKey = GlobalKey();
  int _falseForwards = 0, _falseNewWF = 0, _falseCompletes = 0, _falseNotes = 0;

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    _rcvdInbox = await Provider.of<InboxPro>(context, listen: false).getFullInbox();
    _setInbox = _rcvdInbox;
    _received = true;

    if (mounted) {
      setState(() {});
    }

    // RenderBox box = btnKey.currentContext!.findRenderObject() as RenderBox;
    // Offset position = box.localToGlobal(Offset.zero);

    // print(position.dx);
    // print(position.dy);

    // setState(() {
    //   bx = position.dx;
    //   by = position.dy;
    // });
  }

  void searchMail() {
    _setInbox = [];
    for (int i = 0; i < _rcvdInbox.length; i++) {
      if (_rcvdInbox[i]["searchString"]
          // .toString()
          .toLowerCase()
          .contains(searchText)) {
        _setInbox.add(_rcvdInbox[i]);
      }
    }
    setState(() {});
  }

  void setSelection() {
    _selection = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    final mHeight = mSize.height;
    final mWidth = mSize.width;

    List<Widget> iconsList = WidgetDataProvider.getIcons(context);

    void launchInModal() {
      showModalBottomSheet(
        // showDialog // showModalBottomSheet // showGeneralDialog
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return LaunchInDoc();
        },
      );
    }

    void forwardWfModal() {
      showModalBottomSheet(
        // showDialog // showModalBottomSheet // showGeneralDialog
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return ForwardWf(selectedDetIds);
        },
      );
    }

    void searchModal() {
      showModalBottomSheet(
        // showDialog // showModalBottomSheet // showGeneralDialog
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return SearchFilterIn();
        },
      );
    }

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(AppLocalizations.of(context)!.inbox),
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
                  IconButton(
                    color: Colors.white,
                    onPressed: () {
                      searchModal();
                    },
                    icon: const Icon(Icons.tune),
                  ),
                  const ChangeLang(),
                ],
        ),
        drawer: const MainDrawer(),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onPressed: () {
        //     LaunchInModal();
        //   },
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          // mini: false,
          onPressed: () {
            // LaunchInModal();
            dynamic state = btnKey.currentState;
            state.showButtonMenu();
          },
          child: PopupMenuButton(
            // constraints: BoxConstraints.expand(
            //   width: mWidth * 0.3,
            //   height: mHeight * 0.17,
            // ),
            constraints: BoxConstraints.expand(
              width: mWidth * 0.22,
              height: mHeight * 0.16,
            ),
            key: btnKey,
            child: Icon(Icons.add),
            // onSelected: (value) {
            //   print(value);
            // },
            elevation: 0,
            color: Theme.of(context).backgroundColor.withOpacity(0),
            // color: Colors.purple,
            // position: PopupMenuPosition.values[1],
            // position: PopupMenuPosition.over,
            offset: const Offset(0, -150),
            // offset: Offset(bx - 216, -(by - 575)),
            // color: Colors.white.withOpacity(0.5),
            // color: Colors.black,
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.note_add_outlined),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(15),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: ElevatedButton(
                    onPressed: () {
                      // dynamic state = btnKey.currentState;
                      // state.showButtonMenu();
                      // state.close();
                      // btnKey.currentState = !btnKey.currentState;
                      // print(btnKey.currentState);
                      launchInModal();
                    },
                    child: Icon(Icons.note_alt_outlined),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ];
            },
          ),
        ),
        body: _received
            ? _selection == 0
                ? Column(
                    children: [
                      Container(
                        // height: mHeight * 0.08,
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          // style: TextStyle(fontSize: 10.0, height: 2.0, color: Colors.black),
                          onChanged: (val) {
                            searchText = val.toLowerCase();
                            searchMail();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: AppLocalizations.of(context)!.search,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                      Expanded(
                        child: _setInbox.length > 0
                            ? ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                // shrinkWrap: true,
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
                                      focusS.unfocus();
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
                                      height: mHeight * 0.135,
                                      padding: const EdgeInsets.all(6),
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(
                                      //     width: 1,
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
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
                                                Align(
                                                  alignment: Alignment(0, -1),
                                                  child: Icon(
                                                    Icons.account_circle,
                                                    size: 48,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: iconsList[_setInbox[i]['StatusID'] - 1],
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: mWidth * 0.45,
                                                      child: Text(
                                                        "${_setInbox[i]['Sender']}",
                                                        style: const TextStyle(
                                                          // color:
                                                          //     Theme.of(context)
                                                          //         .primaryColor,
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
                                                        alignment: const Alignment(1, 0),
                                                        child: Text(
                                                          "${_setInbox[i]['WFBeginDate']}",
                                                          style: const TextStyle(
                                                            fontSize: 15,
                                                            // color: Theme.of(
                                                            //         context)
                                                            //     .primaryColor,
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
                                                      // color: Theme.of(context)
                                                      //     .primaryColor,
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
                                                      // color: Theme.of(context)
                                                      //     .primaryColor,
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
                              )
                            : Column(
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
                    ],
                  )
                :

                // ********* Selection container below *********

                ListView.builder(
                    itemCount: _setInbox.length,
                    itemBuilder: (BuildContext ctxt, int i) {
                      return CheckboxListTile(
                        title: Container(
                          height: mHeight * 0.135,
                          child: Container(
                            width: mWidth * 0.81,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: mWidth * 0.45,
                                      child: Text(
                                        "${_setInbox[i]['Sender']}",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      width: mWidth * 0.25,
                                      child: Align(
                                        alignment: const Alignment(1, 0),
                                        child: Text(
                                          "${_setInbox[i]['WFBeginDate']}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context).primaryColor,
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
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                      // color: Colors.blue,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                Container(
                                  width: mWidth * 0.85,
                                  child: Text(
                                    "${_setInbox[i]['RequisitionNo']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
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
                              if (selectedDetIds.contains(_setInbox[i]['DETID'])) {
                                selectedDetIds.remove(_setInbox[i]['DETID']);
                                if (_setInbox[i]['EnableTransfer'] == false || _setInbox[i]['ActionID'] == 4) {
                                  _falseForwards--;
                                }
                                if (_setInbox[i]['EnableStartNewWF'] == false) {
                                  _falseNewWF--;
                                }
                                if (_setInbox[i]['EnableCompleteTask'] == false) {
                                  _falseCompletes--;
                                }
                                if (_setInbox[i]['EnableAddNotes'] == false) {
                                  _falseNotes--;
                                }
                              } else {
                                selectedDetIds.add(_setInbox[i]['DETID']);
                                if (_setInbox[i]['EnableTransfer'] == false || _setInbox[i]['ActionID'] == 4) {
                                  _falseForwards++;
                                }
                                if (_setInbox[i]['EnableStartNewWF'] == false) {
                                  _falseNewWF++;
                                }
                                if (_setInbox[i]['EnableCompleteTask'] == false) {
                                  _falseCompletes++;
                                }
                                if (_setInbox[i]['EnableAddNotes'] == false) {
                                  _falseNotes++;
                                }
                              }
                            },
                          );
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
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
                      onPressed: selectedDetIds.length > 0 && _falseForwards == 0
                          ? () {
                              forwardWfModal();
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
                      onPressed: selectedDetIds.length == 1 && _falseCompletes == 0
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
