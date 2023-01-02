import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/languageProvider.dart';
import '../providers/widgetDataProvider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/changeLangButton.dart';

class IconInfo extends StatelessWidget {
  static const routeName = '/iconinfo';

  final double padding = 12;
  final double headingSize = 15;
  final double bodySize = 12;
  final double marginTop = 5;
  List<String> dess = WidgetDataProvider.getIconsDes();

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    var mHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var mWidth = mSize.width;

    List<Widget> iconss = WidgetDataProvider.getIcons(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.iconinfo),
        actions: const [
          ChangeLang(),
        ],
      ),
      drawer: const MainDrawer(),
      body: SafeArea(
        child: Container(
          height: mHeight,
          width: mWidth,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                height: mHeight * 0.08,
                width: mWidth,
                // color: Colors.purple,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.toi,
                    // maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Table(
                border: TableBorder.all(color: Theme.of(context).primaryColor, width: 2.5
                    // borderRadius: BorderRadius.all(Radius),
                    ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(6),
                },
                children: [
                  // ListView.builder(
                  //     itemCount: 5,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return ListTile(
                  //           leading: const Icon(Icons.list),
                  //           trailing: const Text(
                  //             "GFG",
                  //             style:
                  //                 TextStyle(color: Colors.green, fontSize: 15),
                  //           ),
                  //           title: Text("List item $index"));
                  //     }),

                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '#',
                        style: TextStyle(
                          fontSize: headingSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        'Icon',
                        style: TextStyle(
                          fontSize: headingSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: headingSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[0],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[0]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[1],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[1]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[2],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[2]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '4',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[3],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[3]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '5',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[4],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[4]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '6',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[5],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[5]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '7',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[6],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[6]),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        '8',
                        style: TextStyle(
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: marginTop),
                      child: iconss[7],
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(dess[7]),
                    ),
                  ]),
                ],
              ),
              // Table(
              //   children: const [
              //     TableRow(children: [
              //       Text(
              //         "1",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "Mohit",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "25",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //     ]),
              //     TableRow(children: [
              //       Text(
              //         "2",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "Ankit",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "27",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //     ]),
              //     TableRow(children: [
              //       Text(
              //         "3",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "Rakhi",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "26",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //     ]),
              //     TableRow(children: [
              //       Text(
              //         "4",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "Yash",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "29",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //     ]),
              //     TableRow(children: [
              //       Text(
              //         "5",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "Pragati",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //       Text(
              //         "28",
              //         style: TextStyle(fontSize: 15.0),
              //       ),
              //     ]),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
