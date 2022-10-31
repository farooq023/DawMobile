import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:provider/provider.dart';

import '../providers/fileProvider.dart';

class FileViewer extends StatefulWidget {
  // static const routeName = '/fileviewer';
  final double detID;
  final String vsID;

  const FileViewer(this.detID, this.vsID);

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  // bool _received = false;
  // dynamic file;
  String url = '';

  @override
  void initState() {
    callProviders();
  }

  void callProviders() async {
    url = await Provider.of<FileProvider>(context, listen: false)
        .getFileUrl(widget.detID, widget.vsID);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // drawer: const MainDrawer(),
      body: Container(
        child: Center(
          child: url != ''
              ? const PDF(
                  autoSpacing: true,
                  fitEachPage: true,
                ).fromUrl(
                  url,
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
