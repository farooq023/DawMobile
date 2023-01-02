// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:swipe/swipe.dart';

import '../providers/fileProvider.dart';

// import './fileViewer.dart';

class VsIdList extends StatefulWidget {
  final String subject;
  final double detID;
  VsIdList(this.subject, this.detID);

  @override
  State<VsIdList> createState() => _VsIdListState();
}

class _VsIdListState extends State<VsIdList> {
  dynamic vsids = [];
  bool received = false;
  int vsIdIndex = 0;
  String url = '';

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    vsids = await Provider.of<FileProvider>(context, listen: false).getVsIds(widget.detID);
    // print('rcvd from provider');

    received = true;
    setState(() {});

    fetchFileFromUrl();
  }

  void fetchFileFromUrl() async {
    setState(() {
      url = '';
    });
    url = await Provider.of<FileProvider>(context, listen: false).getFileUrl(widget.detID, vsids[vsIdIndex]['vsID']);
    setState(() {});
  }

  void prevDoc() {
    setState(() {
      vsIdIndex--;
    });
    fetchFileFromUrl();
  }

  void nextDoc() {
    setState(() {
      vsIdIndex++;
    });
    fetchFileFromUrl();
  }

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    var mHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var mWidth = mSize.width;

    // var gestureWidth = mWidth * 0.14;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.subject),
      ),
      body: SafeArea(
        child: received
            ? Container(
                // height: mHeight,
                // width: mWidth,
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     color: Colors.black,
                //     width: 1,
                //   ),
                // ),
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
                            '${vsids[vsIdIndex]['CorrspDesc']}',
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
                                  onPressed: vsIdIndex > 0 ? prevDoc : null,
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: vsIdIndex > 0 ? Theme.of(context).primaryColor : null,
                                  ),
                                ),
                                Text(
                                  '${vsIdIndex + 1} / ${vsids.length}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: vsIdIndex + 1 == vsids.length ? null : nextDoc,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: vsIdIndex + 1 == vsids.length ? null : Theme.of(context).primaryColor,
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
                      width: double.infinity,
                      child: Center(
                        child: url != ''
                            ? url != "error"
                                ? Row(
                                    children: [
                                      Container(
                                        width: mWidth * 0.05,
                                        child: FittedBox(
                                          child: IconButton(
                                            onPressed: vsIdIndex > 0 ? prevDoc : null,
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: vsIdIndex > 0 ? Theme.of(context).primaryColor : null,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: mWidth * 0.9,
                                        padding: const EdgeInsets.all(15),
                                        child: const PDF(
                                          autoSpacing: true,
                                          fitEachPage: true,
                                        ).fromUrl(
                                          url,
                                        ),
                                      ),
                                      Container(
                                        width: mWidth * 0.05,
                                        height: mHeight * 0.5,
                                        child: FittedBox(
                                          child: IconButton(
                                            onPressed: vsIdIndex + 1 == vsids.length ? null : nextDoc,
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 50,
                                              color: vsIdIndex + 1 == vsids.length ? null : Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text("An errror occured while viewing file."),
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
