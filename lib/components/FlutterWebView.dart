import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class FlutterWebView extends StatefulWidget {
  final onWebViewCreated;
  final controller;
  FlutterWebView(this.onWebViewCreated,this.controller);

  @override
  _FlutterWebViewState createState() => _FlutterWebViewState();
}

class _FlutterWebViewState extends State<FlutterWebView> {
  bool _isWebViewReady = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: _isWebViewReady?null: widget.onWebViewCreated,
              onPageFinished: (url) {
                setState(() {
                  _isWebViewReady = true;
                });
              },
            ),
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        floatingActionButton: ElevatedButton(
          onPressed: _isWebViewReady
              ? () {
                  widget.controller.future.then((controller) {
                    controller
                        .runJavascriptReturningResult("helloWorld();")
                        .then((value) => print(value));
                  });
                }
              : null,
          child: Icon(Icons.add),
        ),
        // add more children here
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
