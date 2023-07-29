import 'dart:io';

import 'package:flutter/material.dart';

import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final _qrKey = GlobalKey(debugLabel: 'QR');

  late QRViewController _controller;
  Barcode? _barcode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await _controller.pauseCamera();
    }
    _controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Scanner"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            bottom: 10,
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: _buildResult(),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) => QRView(
        key: _qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
        ),
      );

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this._controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this._barcode = barcode;
      });
    });
  }

  Widget _buildResult() {
    return InkWell(
      onTap: () {
        if (_barcode != null && _barcode!.code != null) {
          if (_isLink()) {
            _launchURL(_barcode!.code.toString());
          } else {
            FlutterClipboard.copy(_barcode!.code.toString());
            Fluttertoast.showToast(
              msg: "Copied",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Text(
          _barcode != null
              ? '${_isLink() ? "Tap to Launch in Browser:\n" : "Tap to Copy:"} ${_barcode!.code}'
              : 'Scan a code!',
          style: TextStyle(
            color: Colors.white,
          ),
          maxLines: 8,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  bool _isLink() {
    return _barcode!.code!.startsWith('http') ||
        _barcode!.code!.startsWith('https');
  }

  Future<void> _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print("URL NOT VALID $e");
    }
  }
}
