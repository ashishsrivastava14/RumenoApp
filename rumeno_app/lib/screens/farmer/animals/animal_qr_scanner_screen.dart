import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../models/models.dart';

/// A full-screen QR scanner that looks up an animal by its tag ID or animal ID.
/// Calls [onAnimalFound] with the matched [Animal] and pops itself on success.
class AnimalQrScannerScreen extends StatefulWidget {
  final void Function(Animal animal) onAnimalFound;

  const AnimalQrScannerScreen({super.key, required this.onAnimalFound});

  @override
  State<AnimalQrScannerScreen> createState() => _AnimalQrScannerScreenState();
}

class _AnimalQrScannerScreenState extends State<AnimalQrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final scannedValue = barcode.rawValue!.trim();
    final animal = getAnimalByTag(scannedValue) ?? getAnimalById(scannedValue);

    if (animal != null) {
      _hasScanned = true;
      Navigator.pop(context);
      widget.onAnimalFound(animal);
    } else {
      _hasScanned = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No animal found for "$scannedValue"'),
          backgroundColor: RumenoTheme.errorRed,
          action: SnackBarAction(
            label: 'Scan again',
            textColor: Colors.white,
            onPressed: () => setState(() => _hasScanned = false),
          ),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _hasScanned = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Animal QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Scanner overlay frame
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: RumenoTheme.primaryGreen, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Instructions + controls
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Point the camera at the animal\'s QR code',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => _controller.toggleTorch(),
                      icon: const Icon(Icons.flash_on, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      onPressed: () => _controller.switchCamera(),
                      icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
