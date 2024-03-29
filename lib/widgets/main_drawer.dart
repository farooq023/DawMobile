import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/auth.dart';
import '../providers/languageProvider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String name = '', jobTitle = '';

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    name = await Provider.of<Auth>(context, listen: false).name;
    jobTitle = await Provider.of<Auth>(context, listen: false).jobTitle;
    setState(
      () {},
    );
  }

  Widget buildListTile(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          // fontWeight: FontWeight.bold,
        ),
      ),
      onTap: route.startsWith('/')
          ? () {
              Navigator.pushReplacementNamed(context, route);
            }
          : route == 'logout'
              ? () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                  // Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route route) => false);

                  // Navigator.popUntil(context, ModalRoute.withName('/login'));
                  // Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
                }
              : () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .changeLanguage();

                  // print(ModalRoute.of(context)!.settings.name);

                  Navigator.pushReplacementNamed(
                      context, ModalRoute.of(context)!.settings.name!);
                },
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

    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      // backgroundColor: Colors.red,
      child: SafeArea(
        child: Container(
          height: mHeight,
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     width: 4,
          //     color: Colors.red,
          //   ),
          // ),
          child: Column(
            children: [
              Container(
                height: mHeight * 0.15,
                child: ListTile(
                  // dense: true,
                  // visualDensity: const VisualDensity(vertical: 4),
                  tileColor: Theme.of(context).primaryColor,
                  leading: const CircleAvatar(
                    // backgroundColor: Colors.grey,
                    child: Icon(Icons.account_circle),
                  ),
                  title: Container(
                    height: mHeight * 0.06,
                    width: mWidth * 0.25,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.black,
                    //     width: 1
                    //   )
                    // ),
                    child: Text(
                      '$name',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Container(
                    height: mHeight * 0.06,
                    width: mWidth * 0.25,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.black,
                    //     width: 1
                    //   )
                    // ),
                    child: Text(
                      '$jobTitle',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Container(
                height: mHeight * 0.85,
                width: double.infinity,
                // padding: EdgeInsets.all(15),
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     width: 1,
                //     color: Colors.black,
                //   ),
                // ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          buildListTile(
                              Icons.dashboard,
                              AppLocalizations.of(context)!.dashboard,
                              '/dashboard'),
                          buildListTile(Icons.inbox,
                              AppLocalizations.of(context)!.inbox, '/inbox'),
                          buildListTile(Icons.outbox,
                              AppLocalizations.of(context)!.sent, '/outbox'),
                          buildListTile(Icons.archive,
                              AppLocalizations.of(context)!.arch, '/archived'),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        children: [
                          buildListTile(
                              Icons.info_outline,
                              AppLocalizations.of(context)!.iconinfo,
                              '/iconinfo'),
                          buildListTile(Icons.logout,
                              AppLocalizations.of(context)!.logOut, 'logout'),
                        ],
                      ),
                    ),

                    // buildListTile(Icons.language,
                    //     AppLocalizations.of(context)!.changeLang, 'changeLang'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
