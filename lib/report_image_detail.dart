import 'package:flutter/material.dart';

class ReportImageDetailPage extends StatefulWidget {

  var receiveProductPic;
  ReportImageDetailPage({Key key, this.receiveProductPic}) : super(key: key);

  @override
  _ReportImageDetailPageState createState() => _ReportImageDetailPageState();
}

class _ReportImageDetailPageState extends State<ReportImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.network('https://www.wangpharma.com/cms/FileUpload/Warehouse/receiveBox/${widget.receiveProductPic}'),
    );
  }
}
