import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/languageProvider.dart';

class ChangeLang extends StatelessWidget {
  const ChangeLang({this.btnColor = Colors.white});

  final Color btnColor;

  @override
  Widget build(BuildContext context) {
    void _changeLang() {
      Navigator.pushReplacementNamed(context, ModalRoute.of(context)!.settings.name!);
      Provider.of<LanguageProvider>(context, listen: false).changeLanguage();
    }

    return IconButton(
      color: btnColor,
      onPressed: _changeLang,
      icon: const Icon(Icons.language),
    );
  }
}
