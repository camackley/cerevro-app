
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WebViewPage extends StatefulWidget {
  WebViewPage({Key key}) : super(key: key);
  static String tag ="web-view-page";

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    var url = ModalRoute.of(context).settings.arguments;
    return WebviewScaffold(
      url: url,
      withLocalStorage: true,
      withJavascript: true
    );
  }
}