import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _isWebViewReady = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My WebView'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isWebViewReady
              ? () {
                  _controller.future.then((controller) {
                    controller.evaluateJavascript(
                      "helloWorld();"
                    ).then((result) {
                      print(result);
                    });
                  });
                }
              : null,
          child: Icon(Icons.add),
        ),
        body: WebView(
          initialUrl: 'https://www.google.com',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
  _controller.complete(webViewController);
String fileJsContents = await rootBundle.loadString('lib/js/dist/index.js');
webViewController.loadUrl(Uri.dataFromString("""
    <script type="text/javascript">
        $fileJsContents
    </script>
  """, mimeType: 'text/html').toString());
          },
          onPageFinished: (url) {
            setState(() {
              _isWebViewReady = true;
            });
          },
        ),
      ),
    );
  }
}
