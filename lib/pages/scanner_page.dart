import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/core/string_plus.dart';
import 'package:pay_manager/l10n/app_localizations.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isPopped = false;

  Future<void> _showModalBottomSheet(BuildContext context, String barcode) async {
    final BankSlip? digitableCode = BankSlip.createBankSlipDataUsingBarcode(barcode);
    if (digitableCode == null) return;
    final TextEditingController controller = TextEditingController(text: digitableCode.barcode.toBankslipFormat());

    await showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width
      ),
      context: context, 
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                spacing: 7,
                children: [
                  Text(AppLocalizations.of(context)!.scanner_page_barcode_detect, style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                  TextField(
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    readOnly: true, controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), 
                      borderSide: const BorderSide(
                        width: 3.0,
                        color: Colors.white
                      ))
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10)
                      ),
                      side: const BorderSide(
                        width: 2.0,
                        color: Colors.white
                      )
                    ),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop(barcode);
                    }, child: Text(AppLocalizations.of(context)!.confirm, style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)))
                ],
              ),
            )
        ));
      }
    );

    setState(() {
      isPopped = false;
    });
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final Rect scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero), 
      width: width * 0.8, 
      height: height * 0.2
    );

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            scanWindow: null,
            onDetect: (capture) async {
              if (isPopped || !mounted) return;

              for (final barcode in capture.barcodes) {
                final displayValue = barcode.displayValue;
                if (displayValue != null) {
                  if (displayValue.length == 44 || displayValue.length == 47) {
                    setState(() {
                      isPopped = true;
                    });

                    await _showModalBottomSheet(context, displayValue);
                  }
                }
              }
            },
          ),

          CustomPaint(
            painter: ScannerOverlayPainter(scanWindow: scanWindow),
            child: Container(),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 2.0,
                    color: Colors.white
                  )
                ),
                child: Text(AppLocalizations.of(context)!.scanner_page_cancel, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))
              ),
            )
          )
        ],
      )
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final double borderRadius;

  ScannerOverlayPainter({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          scanWindow,
          Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scanWindow,
        Radius.circular(borderRadius),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}