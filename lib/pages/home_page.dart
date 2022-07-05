import 'package:flutter/material.dart';
import 'package:flutter_test_ssl_pinning/main.dart';
import 'package:flutter_test_ssl_pinning/pages/settings_page.dart';
import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Platform messages are asynchronous, so we initialize in an async method.
  void check(
    String url,
    String fingerprint,
    SHA sha,
    Map<String, String> headerHttp,
    int timeout,
    BuildContext context,
  ) async {
    List<String> allowedShA1FingerprintList = [fingerprint];

    try {
      // Platform messages may fail, so we use a try/catch PlatformException.
      String checkMsg = await SslPinningPlugin.check(
          serverURL: url,
          headerHttp: headerHttp,
          sha: sha,
          allowedSHAFingerprints: allowedShA1FingerprintList,
          timeout: timeout);

      debugPrint("RESULT: $checkMsg");

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(leading: const Icon(Icons.gpp_good, color: Colors.white,),title: Text(checkMsg, style: const TextStyle(color: Colors.white),)),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(leading: const Icon(Icons.gpp_bad, color: Colors.white,),title: Text(e.toString(), style: const TextStyle(color: Colors.white),)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SSL Certificate Pinning"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Open Settings Page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text("URL: ${data.serverURL}\n"
            "with ${data.sha} key:\n "
            "${data.allowedSHAFingerprint}", textAlign: TextAlign.center,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          check(data.serverURL, data.allowedSHAFingerprint, data.sha,
              data.headerHttp, data.timeout, context);
        },
        child: const Icon(Icons.safety_check),
      ),
    );
  }
}
