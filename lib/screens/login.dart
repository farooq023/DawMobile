import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/auth.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Login({super.key});

  String name = '', pass = '';
  final _focusU = FocusNode(), _focusP = FocusNode();
  int _ersI = -1, spin = 0, fill = 0, inv = 0;

  // final List<String> _ers = [
  //   'Fill all fields!',
  //   'Invalid Credentials!',
  // ];

  closeKeyboards() {
    _focusU.unfocus();
    _focusP.unfocus();
  }

  // @override
  void _submit() async {
    // await closeKeyboards();
    _focusU.unfocus();
    _focusP.unfocus();

    // _focusP.unfocus;
    _clear;
    // await 5000;

    if (name == '' || pass == '') {
      setState(() {
        inv = 0;
        fill = 1;
      });
    } else {
      setState(() {
        spin = 1;
      });

      String res =
          await Provider.of<Auth>(context, listen: false).login(name, pass);

      setState(() {
        spin = 0;
      });

      if (res == 'failure') {
        setState(() {
          fill = 0;
          inv = 1;
        });
      }
    }
  }

  void _clear() {
    setState(() {
      inv = 0;
      fill = 0;
    });
  }

  void _nextText(_) {
    FocusScope.of(context).requestFocus(_focusP);
  }

  @override
  Widget build(BuildContext context) {
    var mSize = MediaQuery.of(context).size;
    var mHeight = mSize.height;
    var mWidth = mSize.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: mHeight,
            width: mWidth,
            // color: Theme.of(context).backgroundColor,
            // color: Theme.of(context).primaryColor,
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage(
            //       "assets/images/primaryBg.png",
            //     ),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Center(
              // alignment: Alignment.center,
              child: Container(
                height: mHeight * 0.68,
                width: mWidth * 0.8,
                // color: Colors.black,
                // decoration: const BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(25)),
                //   color: Colors.black,
                // ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.asset('assets/images/appLogo.jpg'),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        // 'Document Automated',
                        AppLocalizations.of(context)!.documentAutomated,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        // 'Workflow',
                        AppLocalizations.of(context)!.workflow,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        child: Text(
                          // 'User Login',
                          AppLocalizations.of(context)!.userLogin,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // 'Username',
                              AppLocalizations.of(context)!.username,
                              style: TextStyle(
                                fontSize: 21,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextField(
                              enabled: spin == 1 ? false : true,
                              onSubmitted: _nextText,
                              onTap: _clear,
                              focusNode: _focusU,
                              textInputAction: TextInputAction.next,
                              cursorColor: Theme.of(context).primaryColor,
                              onChanged: (val) => {name = val},
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                                // labelText: 'Enter Name',
                                // hintText: 'Enter Your Name',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Text(
                                // 'Password',
                                AppLocalizations.of(context)!.password,
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: TextField(
                                enabled: spin == 1 ? false : true,
                                onSubmitted: (_) {
                                  // print('onSubmitted2 executed');
                                  _submit();
                                },
                                cursorColor: Theme.of(context).primaryColor,
                                onTap: _clear,
                                focusNode: _focusP,
                                textInputAction: TextInputAction.send,
                                obscureText: true,
                                onChanged: (val) => {pass = val},
                                decoration: InputDecoration(
                                  // fillColor: Theme.of(context).primaryColor,
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  // iconColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(top: 10),
                            //   child: _ersI == -1
                            //       ? const Text(
                            //           '',
                            //           style: TextStyle(fontSize: 18),
                            //         )
                            //       : Text(
                            //           _ers[_ersI],
                            //           style: const TextStyle(
                            //             fontSize: 18,
                            //             color: Colors.red,
                            //           ),
                            //         ),
                            // ),

                            if (fill == 0 && inv == 0)
                              Container(
                                child: const Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),

                            if (fill == 1)
                              Container(
                                child: Text(
                                  AppLocalizations.of(context)!.fill,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),

                            if (inv == 1)
                              Container(
                                child: Text(
                                  AppLocalizations.of(context)!.inv,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),

                            Container(
                              height: 50,
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                // onPressed: _submit,
                                onPressed: spin == 1 ? null : _submit,
                                child: Text(
                                  // 'Enter',
                                  AppLocalizations.of(context)!.enter,
                                  style: const TextStyle(fontSize: 21),
                                ),
                              ),
                            ),
                            Center(
                              child: spin != 0
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}