import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

import './screens/login.dart';
import './screens/dashboard.dart';
import './screens/inbox.dart';
// import './screens/fileViewer.dart';

import './providers/auth.dart';
import './providers/dashboardPro.dart';
import './providers/inboxPro.dart';
import './providers/fileProvider.dart';
import './providers/languageProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: LanguageProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, DashboardPro>(
          create: (ctx) => DashboardPro('', 0),
          update: (_, auth, data) =>
              DashboardPro(auth.accessToken, auth.userID),
        ),
        ChangeNotifierProxyProvider<Auth, InboxPro>(
          create: (ctx) => InboxPro('', 0),
          update: (_, auth, data) => InboxPro(auth.accessToken, auth.userID),
        ),
        ChangeNotifierProxyProvider<Auth, FileProvider>(
          create: (ctx) => FileProvider('', 0),
          update: (_, auth, data) =>
              FileProvider(auth.accessToken, auth.userID),
        ),
        // ChangeNotifierProvider.value(
        //   value: LanguageProvider(),
        // ),
      ],
      // child: MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider.value(
      //       value: Auth(),
      //     ),
      //   ],
      // ),
      child: Consumer2<Auth, LanguageProvider>(
        builder: (ctx, auth, lang, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DAW',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          locale: LanguageProvider.appLocale,
          theme: ThemeData(
            primaryColor: const Color(0xFF1976D2),
            backgroundColor: const Color.fromARGB(255, 237, 244, 250),
            // colorScheme: ColorSch(0xFF81c784),
            bottomAppBarColor: const Color(0xFF64B5F6),
            // accentColor: Colors.deepOrange, Color(0xFFC8E6C9),
            // fontFamily: 'Lato',
          ),

          // home: auth.isAuth ? Login() : Dashboard(),
          home: auth.isAuth ? Login() : Inbox(),
          // home: Login(),
          routes: {
            Login.routeName: (ctx) => Login(),
            Dashboard.routeName: (ctx) => Dashboard(),
            Inbox.routeName: (ctx) => Inbox(),
          },
        ),
      ),
    );
  }
}
