import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pspdfkit_flutter/src/main.dart';
import 'package:http/http.dart' as http;

class PspdfkitPage extends StatefulWidget {
  @override
  _PspdfkitPageState createState() => _PspdfkitPageState();
}

class _PspdfkitPageState extends State<PspdfkitPage> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() async {
    // By default, this example doesn't set a license key, but instead runs in trial mode (which is the default, and which requires no
    // specific initialization). If you want to use a different license key for evaluation (e.g. a production license), you can uncomment
    // the next line and set the license key.
    //
    // To set the license key for both platforms, use:
    // await Pspdfkit.setLicenseKeys("YOUR_FLUTTER_ANDROID_LICENSE_KEY_GOES_HERE", "YOUR_FLUTTER_IOS_LICENSE_KEY_GOES_HERE");
    //
    // To set the license key for the currently running platform, use:
    // await Pspdfkit.setLicenseKey("YOUR_FLUTTER_LICENSE_KEY_GOES_HERE");
  }

  void showDocument(BuildContext context) async {
    const String DOCUMENT_PATH = 'assets/PDFs/Document.pdf';

    // final bytes = await DefaultAssetBundle.of(context).load(DOCUMENT_PATH);
    //  final list = bytes.buffer.asUint8List();
    var resp = await http.get(Uri.parse(
        'https://www.riodasostras.rj.gov.br/wp-content/uploads/2022/03/1427-loa.pdf'));

    final bytes = resp.bodyBytes;
    print('showDocument list: ${bytes.length}');

    final tempDir = await Pspdfkit.getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/document.pdf';
    print('showDocument Path: $tempDocumentPath');

    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(bytes, flush: true);

    await Pspdfkit.present(tempDocumentPath);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MaterialApp(
      home: Scaffold(body: Builder(
        builder: (BuildContext context) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                ElevatedButton(
                    child: Text('Tap to Open Document',
                        style: themeData.textTheme.headline4
                            ?.copyWith(fontSize: 21.0)),
                    onPressed: () => showDocument(context))
              ]));
        },
      )),
    );
  }
}
