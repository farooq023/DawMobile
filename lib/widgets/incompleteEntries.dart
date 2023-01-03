import 'package:flutter/material.dart';

class IncompleteEntries extends StatelessWidget {
  double mHeight;
  List<String> incompleteEntries;
  IncompleteEntries(this.mHeight, this.incompleteEntries);

  Widget incompleteEntriesDialog() {
    return Container(
      height: mHeight * 0.15,
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: incompleteEntries.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(
            incompleteEntries[index],
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: const Icon(
        Icons.warning,
        color: Colors.red,
        size: 45,
      ),
      content: incompleteEntriesDialog(),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
