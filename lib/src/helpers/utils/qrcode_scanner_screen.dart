import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  MobileScannerController controller = MobileScannerController();

  String? scannedCode;
  bool isTorchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              await controller.toggleTorch();
              setState(() {
                isTorchOn = !isTorchOn;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () async {
              await controller.switchCamera();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (barcodeCapture) {
                final barcodes = barcodeCapture.barcodes;
                if (barcodes.isNotEmpty) {
                  final barcode = barcodes.first;
                  final rawValue = barcode.rawValue;
                  if (rawValue != null && rawValue != scannedCode) {
                    setState(() {
                      scannedCode = rawValue;
                    });
                    // You can add processing logic here if you want:
                    debugPrint('Scanned QR Code: $rawValue');
                    // Optionally stop scanning if only one scan needed
                    controller.stop();
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: scannedCode == null
                  ? const Text('Scan a code')
                  : Text(
                'Scanned Code: $scannedCode',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.start();
              setState(() {
                scannedCode = null;
              });
            },
            child: const Text('Restart Scan'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
