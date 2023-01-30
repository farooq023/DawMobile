import 'package:flutter/material.dart';

class ModelHeader extends StatelessWidget {
  String modalTitle;
  ModelHeader(this.modalTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 17),
      child: Text(
        modalTitle,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
