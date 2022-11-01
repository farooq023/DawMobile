import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:swipe/swipe.dart';

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
  dynamic vsids = [];
  bool received = false;
  int currVsId = 0;
  String url = '';

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    vsids = await Provider.of<FileProvider>(context, listen: false)
        .getVsIds(widget.detID);
    // print('rcvd from provider');

    received = true;
    setState(() {});

    fetchFileFromUrl();
  }

  void fetchFileFromUrl() async {
    // print('now fetching url');
    // print(widget.detID);
    // print(vsids[currVsId].toString());

    // print('successfully rcvd url');
    url = '';
    setState(() {});

    url = await Provider.of<FileProvider>(context, listen: false)
        .getFileUrl(widget.detID, vsids[currVsId]['vsID']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    // var mHeight = mSize.height;
    var mHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var mWidth = mSize.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.subject),
      ),
      body: SafeArea(
        child: received
            ? Container(
                child: Column(
                  children: [
                    Container(
                      height: mHeight * 0.1,
                      width: mWidth,
                      // color: Colors.red,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${vsids[currVsId]['CorrspDesc']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: currVsId > 0
                                      ? () {
                                          setState(() {
                                            currVsId--;
                                          });
                                          fetchFileFromUrl();
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: currVsId > 0
                                        ? Theme.of(context).primaryColor
                                        : null,
                                  ),
                                ),
                                Text(
                                  '${currVsId + 1} / ${vsids.length}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: currVsId + 1 == vsids.length
                                      ? null
                                      : () {
                                          setState(() {
                                            currVsId++;
                                          });
                                          fetchFileFromUrl();
                                        },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: currVsId + 1 == vsids.length
                                        ? null
                                        : Theme.of(context).primaryColor,
                                    // color: 1==1 ? Theme.of(context).primaryColor : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: mHeight * 0.9,
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: url != ''
                            ? GestureDetector(
                                child: const PDF(
                                  autoSpacing: true,
                                  fitEachPage: true,
                                ).fromUrl(
                                  url,
                                ),
                                // onHorizontalDragUpdate: (details) {
                                //   int sensitivity = 5;
                                //   if (details.delta.dx < -sensitivity) {
                                //     print('swiped to right');
                                //     if (currVsId + 1 != vsids.length) {
                                //       setState(() {
                                //         currVsId++;
                                //       });

                                //       fetchFileFromUrl();
                                //     }
                                //   } else if (details.delta.dx > sensitivity) {
                                //     print('swiped to left');
                                //     if (currVsId > 0) {
                                //       setState(() {
                                //         currVsId--;
                                //       });
                                //       fetchFileFromUrl();
                                //     }
                                //   }
                                // }

                                // onSwipeRight: currVsId + 1 == vsids.length
                                //     ? null
                                //     : () {
                                //         setState(() {
                                //           currVsId++;
                                //         });
                                //         fetchFileFromUrl();
                                //       },
                              )
                            : const CircularProgressIndicator(),
                      ),
                    )
                  ],
                ),
                // child: ListView.builder(
                //   itemCount: vsids.length,
                //   itemBuilder: (BuildContext ctxt, int i) {
                //     return GestureDetector(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => FileViewer(
                //               widget.detID,
                //               vsids[i]['vsID'],
                //             ),
                //           ),
                //         );
                //       },
                //       child: Container(
                //         height: mHeight * 0.1,
                //         child: Row(
                //           children: [
                //             Container(
                //               width: mWidth * 0.20,
                //               child: Align(
                //                 alignment: Alignment.center,
                //                 child: Text(
                //                   '${vsids[i]['Serial']}',
                //                   style: const TextStyle(
                //                     fontSize: 22,
                //                     fontWeight: FontWeight.bold,
                //                     // color: Colors.blue,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             Container(
                //               width: mWidth * 0.80,
                //               child: Align(
                //                 alignment: Alignment.center,
                //                 child: Text(
                //                   '${vsids[i]['CorrspDesc']}',
                //                   style: const TextStyle(
                //                     fontSize: 22,
                //                     fontWeight: FontWeight.bold,
                //                     // color: Colors.blue,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
