import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medz/Screens/medicineInfo.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: result != null
                  ? Text('${result!.code}')
                  : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    _controller!.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
