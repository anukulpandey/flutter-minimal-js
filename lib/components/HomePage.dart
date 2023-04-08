import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_js_api/services/JsApiService.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text="no message found , kindly tap on refresh button";
  JsApiService? _jsApiService;
  @override
  void initState() {
    _jsApiService = JsApiService();
    super.initState();
  }

  bool _isWebViewReady = false;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Minimal Js Api'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: _isWebViewReady?null: _jsApiService?.onWebViewCreated,
              onPageFinished: (url) {
                setState(() {
                  _isWebViewReady = true;
                });
              },
            ),
            Container(child: Center(child: Text(text)),)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isWebViewReady
              ? () {
                  _jsApiService?.controller.future.then((controller) {
                    controller
                        .runJavascriptReturningResult("helloWorld();")
                        .then((value) {
                          setState(() {
                            text=value.toString();
                          });
                        });
                  });
                }
              : null,
          child: Icon(Icons.restart_alt_rounded),
        ),
      ),
    );
  }
}
