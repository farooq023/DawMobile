import 'package:flutter/material.dart';

class PickFileBtn extends StatelessWidget {
  VoidCallback pickFile;
  PickFileBtn(this.pickFile);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          pickFile();
        },
        child: IconButton(
          onPressed: () {
            pickFile();
          },
          icon: const Icon(Icons.upload_file),
        ),
      ),
    );
  }
}
