import 'package:daw/widgets/changeLangButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../providers/dashboardPro.dart';
import '../widgets/main_drawer.dart';

class Dashboard extends StatefulWidget {
  // const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // String uName = '';

  // final String authToken;
  // String uName = '';

  String newM = '0', recM = '0', retM = '0', reC = '0';
  bool _received = false;

  // Dashboard(this.authToken, this.uName);

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    // print('called');
    // await Provider.of<DashboardPro>(context, listen: false)
    //     .getUsername(context);

    List<String> _totalMails =
        await Provider.of<DashboardPro>(context, listen: false)
            .getUserStats(context);

    newM = _totalMails[0];
    recM = _totalMails[1];
    retM = _totalMails[2];
    reC = _totalMails[3];

    _received = true;

    setState(() {});
  }

  Widget buildGridTile(String totalMails, String tileTitle, Color col) {
    return InkWell(
      // onTap: () {
      //   print('a');
      // },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: col,
          borderRadius: const BorderRadius.all(
            Radius.circular(22),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _totalMails.elementAt(0);
            Text(
              '$totalMails',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "$tileTitle",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
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
        title: Text(AppLocalizations.of(context)!.dashboard),
        actions: [
          ChangeLang()
        ],
      ),
      drawer: const MainDrawer(),
      body: _received
          ? Container(
              height: mHeight,
              width: mWidth,
              padding: const EdgeInsets.all(8),
              // decoration: BoxDecoration(
              //   // color: Theme.of(context).backgroundColor,
              //   border: Border.all(
              //     color: Colors.black,
              //     width: 2,
              //   ),
              // ),
              child: Container(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 11,
                    crossAxisCount: 2,
                    crossAxisSpacing: 11,
                    childAspectRatio: 4/2.55,
                    // childAspectRatio: mWidth * 0.4 / mHeight * 0.05,
                  ),
                  children: [
                    buildGridTile('$newM', AppLocalizations.of(context)!.neww, Colors.green),
                    buildGridTile('$recM', AppLocalizations.of(context)!.rcvd, Colors.pink),
                    buildGridTile('$retM', AppLocalizations.of(context)!.rtrnd, Colors.blue),
                    buildGridTile('$reC', AppLocalizations.of(context)!.rtc, Colors.purple),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
