import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/fileProvider.dart';

import './fileViewer.dart';

class VsIdList extends StatefulWidget {
  final String subject;
  final double detID;
  const VsIdList(this.subject, this.detID);

  @override
  State<VsIdList> createState() => _VsIdListState();
}

class _VsIdListState extends State<VsIdList> {
  // List<Map> vsids = [];
  dynamic vsids = [];
  bool received = false;

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    print('now calling Provider');
    vsids = await Provider.of<FileProvider>(context, listen: false)
        .getVsIds(widget.detID);
    print('rcvd from provider');
    received = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    var mHeight = mSize.height;
    var mWidth = mSize.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.subject),
      ),
      body: received
          ? Container(
              child: ListView.builder(
                itemCount: vsids.length,
                itemBuilder: (BuildContext ctxt, int i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileViewer(
                            widget.detID,
                            vsids[i]['vsID'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                        height: mHeight * 0.1,
                        // padding: const EdgeInsets.all(6),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: Colors.black,
                        //     width: 1,
                        //   ),
                        // ),
                        child: Row(
                          children: [
                            Container(
                              // width: mWidth * 0.2375,
                              width: mWidth * 0.20,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${vsids[i]['Serial']}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     color: Colors.black,
                              //     width: 1,
                              //   ),
                              // ),
                              width: mWidth * 0.80,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${vsids[i]['CorrspDesc']}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            // Divider(thickness: 2),
                          ],
                        )
                        // Row(       Text(vsids[i]['CorrspDesc']),
                        //   children: [
                        //     Column(
                        //       children: const [
                        //         Align(
                        //           alignment: Alignment(0, -1),
                        //           child: Icon(
                        //             Icons.account_circle,
                        //             size: 48,
                        //           ),
                        //         ),
                        //         // Align(
                        //         //   alignment: Alignment.center,
                        //         //   child: iconsList[_setInbox[i]['StatusID'] - 1],
                        //         // ),
                        //       ],
                        //     ),
                        //     Container(
                        //       // decoration: BoxDecoration(
                        //       //   border: Border.all(
                        //       //     color: Colors.black,
                        //       //     width: 2,
                        //       //   ),
                        //       // ),
                        //       // width: mWidth * 0.782,
                        //       width: mWidth * 0.81,
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Container(
                        //                 width: mWidth * 0.45,
                        //                 child: Text(
                        //                   "${_setInbox[i]['Sender']}",
                        //                   style: const TextStyle(
                        //                     fontSize: 22,
                        //                     fontWeight: FontWeight.bold,
                        //                     // color: Colors.blue,
                        //                   ),
                        //                   maxLines: 1,
                        //                 ),
                        //               ),
                        //               Container(
                        //                 width: mWidth * 0.25,
                        //                 child: Align(
                        //                   alignment: const Alignment(1, 0),
                        //                   child: Text(
                        //                     "${_setInbox[i]['WFBeginDate']}",
                        //                     style: const TextStyle(
                        //                       fontSize: 15,
                        //                       // fontWeight: FontWeight.bold,
                        //                       // color: Colors.blue,
                        //                     ),
                        //                     maxLines: 1,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Container(
                        //             width: mWidth * 0.45,
                        //             child: Text(
                        //               "${_setInbox[i]['SUBJECT']}",
                        //               style: const TextStyle(
                        //                 fontSize: 18,
                        //                 // color: Colors.blue,
                        //               ),
                        //               maxLines: 1,
                        //             ),
                        //           ),
                        //           Container(
                        //             width: mWidth * 0.85,
                        //             child: Text(
                        //               "${_setInbox[i]['RequisitionNo']}",
                        //               style: const TextStyle(
                        //                 fontSize: 15,
                        //                 // color: Colors.blue,
                        //               ),
                        //               maxLines: 1,
                        //             ),
                        //           ),
                        //           // const Divider(thickness: 1),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        ),
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
