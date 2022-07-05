import 'package:flutter/material.dart';
import 'package:flutter_test_ssl_pinning/main.dart';
import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

class PinningSslData {
  String serverURL = "https://flutter.dev/";
  HttpMethod httpMethod = HttpMethod.Get;
  Map<String, String> headerHttp = {};
  String allowedSHAFingerprint =
      "B2 97 1B C0 DB CE 0D 57 77 D5 A4 B4 3C C7 20 47 49 EB 36 DB";
  int timeout = 0;
  late SHA sha = SHA.SHA1;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void save(
    String url,
    String fingerprint,
    SHA sha,
    Map<String, String> headerHttp,
    int timeout,
    BuildContext context,
  ) async {
    data.serverURL = url;
    data.allowedSHAFingerprint = fingerprint;
    data.sha = sha;
    data.headerHttp = headerHttp;
    data.timeout = timeout;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Saved!"),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void submit(BuildContext context) {
    // First validate form.
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Save our form now.

      save(data.serverURL, data.allowedSHAFingerprint, data.sha,
          data.headerHttp, data.timeout, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                        keyboardType: TextInputType.url,
                        initialValue: data.serverURL,
                        decoration: const InputDecoration(
                          hintText: 'https://yourdomain.com',
                          labelText: 'URL',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter some url';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          data.serverURL = value ?? "";
                        }),
                    DropdownButton(
                      items: [
                        DropdownMenuItem(
                          value: SHA.SHA1,
                          child: Text(SHA.SHA1.toString()),
                        ),
                        DropdownMenuItem(
                          value: SHA.SHA256,
                          child: Text(SHA.SHA256.toString()),
                        )
                      ],
                      value: data.sha,
                      isExpanded: true,
                      onChanged: (SHA? val) {
                        setState(() {
                          data.sha = val!;
                        });
                      },
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: data.allowedSHAFingerprint,
                        decoration: const InputDecoration(
                            hintText: 'OO OO OO OO OO OO OO OO OO OO',
                            labelText: 'Fingerprint'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter some fingerprint';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          data.allowedSHAFingerprint = value ?? "";
                        }),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: '60',
                        decoration: const InputDecoration(
                            hintText: '60', labelText: 'Timeout'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter some timeout';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          data.timeout = int.parse(value!);
                        }),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: MaterialButton(
                        onPressed: () {
                          submit(context);
                        },
                        color: Colors.blue,
                        child: const Text(
                          'SAVE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ));
        }));
  }
}
