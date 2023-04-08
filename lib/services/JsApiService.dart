import 'dart:async';

import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JsApiService {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  void onWebViewCreated(WebViewController webViewController) async {
    controller.complete(webViewController);
    String fileJsContents = await rootBundle.loadString('lib/js/dist/index.js');
    webViewController.loadUrl(Uri.dataFromString("""
        <script type="text/javascript">
            $fileJsContents
        </script>
        """, mimeType: 'text/html').toString());
  }

  void executeJsFunc(String jsFunc){
    controller.future.then((controller) {
      controller.runJavascriptReturningResult(jsFunc).then((value) => print(value));   
    });
  }
}
