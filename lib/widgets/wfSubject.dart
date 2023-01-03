import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WfSubject extends StatefulWidget {
  double cWidth;
  double marginBottom;
  double labelSize;
  TextEditingController subjectCtrl;
  bool suffix;

  WfSubject(this.cWidth, this.marginBottom, this.labelSize, this.subjectCtrl, this.suffix);

  @override
  State<WfSubject> createState() => _WfSubjectState();
}

class _WfSubjectState extends State<WfSubject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cWidth,
      margin: EdgeInsets.only(bottom: widget.marginBottom),
      child: TextField(
        controller: widget.subjectCtrl,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: AppLocalizations.of(context)!.subject,
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: widget.labelSize,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: widget.subjectCtrl.text != '' && widget.suffix
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.subjectCtrl.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : null,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
