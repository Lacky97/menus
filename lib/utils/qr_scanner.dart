import 'dart:io';
import 'dart:math';

import 'package:favicon/favicon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menus/model/qrs.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../boxes.dart';

// ignore: must_be_immutable
class QRScanner extends StatefulWidget {
  QRScanner({Key? key, required this.boxes}) : super(key: key);

  Box<Qrs> boxes;

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  late bool oneTime;
  late bool areEqual;
  @override
  void initState() {
    print(
        '-------------------------------------------------------------------------------------------------------------------------------------------');
    setState(() {
      oneTime = false;
      areEqual = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    //Hive.box('transactions').close();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    barcode != null ? _launch(barcode!.code) : null;
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        buildQrView(context),
        Positioned(bottom: 10, child: buildResult())
      ]),
    );
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller?.resumeCamera();
  }

  _launch(url) async {
    if (oneTime) {
      setState(() {
        oneTime = false;
      });
      if (barcode != null) {
        
          await launch(url).then((value) => !oneTime
              ? addQR(
                  Uri.parse(url)
                      .host
                      .split('.')[Uri.parse(url).host.split('.').length - 2],
                  url.toString())
              : null);


        // informarsi meglio su canlaunch alcuni device non aprono il qr code
        /*
        await launch(url).then((value) => !oneTime
              ? addQR(
                  Uri.parse(url)
                      .host
                      .split('.')[Uri.parse(url).host.split('.').length - 2],
                  url.toString())
              : null);*/

      }
    }
  }

  Future addQR(String siteName, String url) async {
    var iconUrl = await Favicon.getBest(url.toString());

    widget.boxes.values.forEach((element) {
      print(element.name);
      print(siteName);
      print(element.name == siteName);
      if (element.name == siteName)
        setState(() {
          areEqual = true;
        });
    });
    if (!areEqual) {
      final qr = Qrs()
        ..name = siteName
        ..url = url
        ..imageUrl = iconUrl == null ? '' : iconUrl.url.toString()
        ..randomColor = iconUrl == null
            ? Colors.primaries[Random().nextInt(Colors.primaries.length)].value
                .toString()
            : '000000'
        ..category = 'Resturant/Bar';

      final box = Boxes.getQrs();
      box.add(qr);
    } else {
      setState(() {
        areEqual = false;
      });
    }
  }

  Future<String> _getNameSite(url) async {
    return url.host.split('.')[url.host.split('.').length - 2];
  }

  Widget buildResult() {
    // ignore: unnecessary_statements
    barcode != null ? _getNameSite(Uri.parse(barcode!.code)) : null;
    return Container();
  }

  Widget buildQrView(BuildContext context) {
    print(
        '----------------------------------------------------------------------------------------------------------------------------------------------');

    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).accentColor,
        borderRadius: 10,
        borderWidth: 10,
        borderLength: 20,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((barcode) => setState(() {
          this.barcode = barcode;
          oneTime = true;
        }));
  }
}
