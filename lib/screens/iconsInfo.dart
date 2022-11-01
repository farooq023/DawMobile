import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/languageProvider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/changeLangButton.dart';

class IconInfo extends StatelessWidget {
  // const IconInfo({super.key});
  static const routeName = '/iconinfo';

  final double padding = 12;

  final double headingSize = 15;
  final double bodySize = 12;
  final double marginTop = 5;
  // Locale myLocale = Localizations.localeOf(context);

  
  

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    var mHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var mWidth = mSize.width;

    const double iconSize = 25;
    List<Widget> iconss = [
    Icon(
      Icons.noise_control_off,
      color: Theme.of(context).primaryColor,
      size: iconSize,
    ),
    Icon(
      Icons.pending,
      color: Theme.of(context).primaryColor,
      size: iconSize,
    ),
    Icon(
      Icons.arrow_circle_right,
      color: Theme.of(context).primaryColor,
      size: iconSize,
    ),
    Icon(
      Icons.check_box,
      color: Colors.green,
      size: iconSize,
    ),
    Icon(
      Icons.arrow_circle_left,
      color: Colors.green,
      size: iconSize,
    ),
    Icon(
      Icons.archive,
      color: Colors.red,
      size: iconSize,
    ),
    Icon(
      Icons.cancel_rounded,
      color: Colors.red,
      size: iconSize,
    ),
    Icon(
      Icons.double_arrow,
      color: Theme.of(context).primaryColor,
      size: iconSize,
    ),
  ];

    List<String> dess =
        Provider.of<LanguageProvider>(context, listen: false).isEng
            ? [
                'Unopened Mail',
                'Opened Mail',
                'Forwarded Mail',
                'Completed Mail',
                'Returned Mail',
                'Archived Mail',
                'Cancelled Mail',
                'Reforwarded Mail'
              ]
            : [
                'بريد غير مفتوح',
                'فتح البريد',
                'البريد المعاد توجيهه',
                'البريد المكتمل',
                'بريد عاد',
                'البريد المؤرشف',
                'البريد الملغى',
                'البريد المعاد توجيهه'
              ];

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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Table(
                border: TableBorder.all(
                    color: Theme.of(context).primaryColor, width: 2.5
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
