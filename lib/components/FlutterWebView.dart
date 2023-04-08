import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class FlutterWebView extends StatefulWidget {
  @override
  _FlutterWebViewState createState() => _FlutterWebViewState();
}

class _FlutterWebViewState extends State<FlutterWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isWebViewReady = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            _controller.complete(webViewController);
            String fileJsContents =
                await rootBundle.loadString('lib/js/dist/index.js');
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
        floatingActionButton: ElevatedButton(
          onPressed: _isWebViewReady
              ? () {
                  _controller.future.then((controller) {
                    controller
                        .runJavascriptReturningResult("helloWorld();")
                        .then((value) => print(value));
                  });
                }
              : null,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
