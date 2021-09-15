import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class QRScanner extends StatefulWidget {
  QRScanner({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  late bool oneTime;

  @override
  void initState() {
    print('-------------------------------------------------------------------------------------------------------------------------------------------');
    setState(() {
      oneTime = false;
    });
    super.initState();
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    //barcode != null ? _launch(barcode!.code) : null;
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
    print(oneTime);
    if (oneTime) {
      setState((){
        oneTime = false;
      });
      if (barcode != null) {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    }
  }

  Future<void> _bhooo() async {
    print(Uri.parse(barcode!.code).host.split('.')[Uri.parse(barcode!.code).host.split('.').length - 2]);
  }

  Widget buildResult(){
    barcode != null ? _bhooo() : null;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white),
      child: Text(barcode != null ? 'Result : ${barcode!.code}' : 'Scan code!',
          maxLines: 3));}

  Widget buildQrView(BuildContext context)  {
    print('----------------------------------------------------------------------------------------------------------------------------------------------');
    
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
      );}

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream
        .listen((barcode) => setState(() { this.barcode = barcode;
        oneTime = true;}));
  }
}
