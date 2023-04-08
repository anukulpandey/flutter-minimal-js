import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_js_api/components/FlutterWebView.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(FlutterWebView(onWebViewCreated,_controller));
}

final Completer<WebViewController> _controller =
      Completer<WebViewController>();

void onWebViewCreated (WebViewController webViewController) async {
            _controller.complete(webViewController);
            String fileJsContents =
                await rootBundle.loadString('lib/js/dist/index.js');
            webViewController.loadUrl(Uri.dataFromString("""
        <script type="text/javascript">
            $fileJsContents
        </script>
        """, mimeType: 'text/html').toString());
          }