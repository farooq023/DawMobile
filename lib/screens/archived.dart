import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/archivedPro.dart';

import './vsidList.dart';

import '../widgets/main_drawer.dart';
import '../widgets/changeLangButton.dart';

class Archived extends StatefulWidget {
  // const Archived({super.key});
  static const routeName = '/archived';

  @override
  State<Archived> createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
  List<Map> rcvdArchvd = [];
  bool received = false;
  int selection = 0;

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    rcvdArchvd = await Provider.of<ArchivedPro>(context, listen: false)
        .getFullArchived();
    received = true;

    // if (mounted) {
    //   setState(() {});
    // }

    setState(() {});
  }

  void setSelection() {
    selection = 0;
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
    // const double iconSize = 25;
    // List<Widget> iconsList = [
    //   Icon(
    //     Icons.noise_control_off,
    //     color: Theme.of(context).primaryColor,
    //     size: iconSize,
    //   ),
    //   Icon(
    //     Icons.pending,
    //     color: Theme.of(context).primaryColor,
    //     size: iconSize,
    //   ),
    //   Icon(
    //     Icons.arrow_circle_right,
    //     color: Theme.of(context).primaryColor,
    //     size: iconSize,
    //   ),
    //   Icon(
    //     Icons.check_box,
    //     color: Colors.green,
    //     size: iconSize,
    //   ),
    //   Icon(
    //     Icons.arrow_circle_left,
    //     color: Colors.green,
    //     size: iconSize,
    //   ),
    //   Icon(
    //     Icons.archive,
    //     color: Colors.red,
    //     size: iconSize,
    //   ),
    //   Icon(
    //     Icons.cancel_rounded,
    //     color: Colors.red,
    //     size: iconSize,
    //   ),
    //   Icon(
    //     Icons.double_arrow,
    //     color: Theme.of(context).primaryColor,
    //     size: iconSize,
    //   ),
    // ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.arch),
        actions: selection != 0
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
        child: received
            ? rcvdArchvd.length > 0
                ? (selection == 0
                    ? (ListView.builder(
                        itemCount: rcvdArchvd.length,
                        itemBuilder: (BuildContext ctxt, int i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VsIdList(
                                    rcvdArchvd[i]['SUBJECT'],
                                    rcvdArchvd[i]['DETID'],
                                  ),
                                ),
                              );
                            },
                            // onLongPress: () {
                            //   selection = 1;
                            //   setState(() {});
                            // },
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
                                      children: const [
                                        Align(
                                          alignment: Alignment(0, -1),
                                          child: Icon(
                                            Icons.account_circle,
                                            size: 48,
                                          ),
                                        ),
                                        // Align(
                                        //   alignment: Alignment.center,
                                        //   child: iconsList[
                                        //       rcvdArchvd[i]['StatusID'] - 1],
                                        // ),
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
                                                "${rcvdArchvd[i]['Recipient']}",
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
                                                  "${rcvdArchvd[i]['WFBeginDate']}",
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
                                            "${rcvdArchvd[i]['SUBJECT']}",
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
                                            "${rcvdArchvd[i]['RequisitionNo']}",
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
                        itemCount: rcvdArchvd.length,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: mWidth * 0.45,
                                          child: Text(
                                            "${rcvdArchvd[i]['Recipient']}",
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
                                            alignment: const Alignment(1, 0),
                                            child: Text(
                                              "${rcvdArchvd[i]['WFBeginDate']}",
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
                                        "${rcvdArchvd[i]['SUBJECT']}",
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
                                        "${rcvdArchvd[i]['RequisitionNo']}",
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
                            value: rcvdArchvd[i]['isChecked'],
                            // 4.
                            onChanged: (bool? value) {
                              // setState(
                              //   () {
                              //     rcvdArchvd[i]['isChecked'] = value!;
                              //     if (selectedDetIds
                              //         .contains(rcvdArchvd[i]['DETID'])) {
                              //       selectedDetIds
                              //           .remove(rcvdArchvd[i]['DETID']);
                              //       if (rcvdArchvd[i]['_falseForwards'] ==
                              //           false) {
                              //         _falseForwards--;
                              //       }
                              //       if (rcvdArchvd[i]['_falseNewWF'] == false) {
                              //         _falseNewWF--;
                              //       }
                              //       if (rcvdArchvd[i]['_falseCompletes'] ==
                              //           false) {
                              //         _falseCompletes--;
                              //       }
                              //       if (rcvdArchvd[i]['_falseNotes'] == false) {
                              //         _falseNotes--;
                              //       }
                              //     } else {
                              //       selectedDetIds.add(rcvdArchvd[i]['DETID']);
                              //       if (rcvdArchvd[i]['_falseForwards'] ==
                              //           false) {
                              //         _falseForwards++;
                              //       }
                              //       if (rcvdArchvd[i]['_falseNewWF'] == false) {
                              //         _falseNewWF++;
                              //       }
                              //       if (rcvdArchvd[i]['_falseCompletes'] ==
                              //           false) {
                              //         _falseCompletes++;
                              //       }
                              //       if (rcvdArchvd[i]['_falseNotes'] == false) {
                              //         _falseNotes++;
                              //       }
                              //     }
                              //   },
                              // );
                            },
                            controlAffinity: ListTileControlAffinity.leading,
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
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
      ),
    );
  }
}
