import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isPopped = false;

  Future<void> _showModalBottomSheet(BuildContext context, String barcode) async {
    final TextEditingController controller = TextEditingController(text: barcode);

    await showModalBottomSheet(
      context: context, 
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                spacing: 7,
                children: [
                  Text("Barcode detect successfuly!", style: TextStyle(fontSize: 22, color: Colors.green[700], fontWeight: FontWeight.bold)),
                  TextField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    readOnly: true, controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10)
                      )
                    ),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop(barcode);
                    }, child: Text("Confirm"))
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
    return Scaffold(
      appBar: AppBar(),
      body: MobileScanner(
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
    );
  }
}