import 'package:flutter/material.dart';

class WfStatusDialog extends StatelessWidget {
  bool res;
  double mHeight;

  WfStatusDialog(this.res, this.mHeight);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: res
          ? const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 45,
            )
          : const Icon(
              Icons.clear,
              color: Colors.red,
              size: 45,
            ),
      content: Container(
        height: mHeight * 0.07,
        width: double.maxFinite,
        child: Center(
          child: Text(
            res ? "Execution Successful!" : "An error occured during execution!",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        // }
      ),
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
