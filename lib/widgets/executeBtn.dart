import 'package:flutter/material.dart';

class ExecuteBtn extends StatelessWidget {
  double mHeight;
  double cWidth;
  VoidCallback execute;
  bool launching;
  double labelSize;
  String btnLabel;

  ExecuteBtn(this.mHeight, this.cWidth, this.execute, this.launching, this.labelSize, this.btnLabel);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mHeight * (0.25 / 3),
      width: cWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: execute,
        child: launching
            ? CircularProgressIndicator(
                color: Theme.of(context).backgroundColor,
              )
            : Text(
                btnLabel,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontSize: labelSize,
                ),
              ),
      ),
    );
  }
}
