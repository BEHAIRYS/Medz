import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medz/Classes/Medicine.dart';
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
      child: Container(
        margin: EdgeInsets.all(10),
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
      ),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    Medicine? newMed;
    _controller!.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        newMed = Medicine.fromJSON(
          json.decode(
            scanData.code!,
          ),
        );
        setState(() {
          result = scanData;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MedicineInfo(med: newMed!);
            },
          ),
        );
      }
    });
  }
}
