import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebViewController controller;

  bool isControllerInit = false;
  @override
  void initState() {
    super.initState();
    rootBundle.loadString('lib/js/dist/index.js').then((val) {
      print("val===${val}");
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              print("Progress: $progress%");
            },
            onPageStarted: (String url) {
              print("Page started loading: $url");
            },
            onPageFinished: (String url) {
              print("Page finished loading: $url");
              setState(() {
                isControllerInit = true;
              });
            },
            onHttpError: (HttpResponseError error) {
              print("HTTP error: ${error}");
            },
            onWebResourceError: (WebResourceError error) {
              print("Web resource error: ${error.description}");
            },
          ),
        )
        ..loadHtmlString("""
    <script type="text/javascript">
        $val
    </script>
""")
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter WebView Example')),
      body: isControllerInit
          ? WebViewWidget(controller: controller)
          : Text("not init"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await controller.runJavaScriptReturningResult('helloWorld();');
          print("res===$res");
        },
        child: Text("click me"),
      ),
    );
  }
}
