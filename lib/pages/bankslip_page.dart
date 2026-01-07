import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class BankSlipPage extends StatefulWidget {
  const BankSlipPage({super.key});

  @override
  State<StatefulWidget> createState() => _BankSlipState();
}

class _BankSlipState extends State<BankSlipPage> {
  ScanResult? scanResult;

  final _key = GlobalKey<ExpandableFabState>();

  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");

  final _aspectTolerance = 0.00;
  final _selectedCamera = 0;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        children: [
          FloatingActionButton.small(
            heroTag: null,
            onPressed: _scan,
            child: const Icon(Symbols.barcode_scanner)),
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {},
            child: const Icon(Symbols.barcode)),
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {},
            child: const Icon(Icons.done),)
        ],
      ),
      body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 65), 
            child: Column(
              children: List.generate(20, (i) => 
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                color: Colors.grey[200],
                child: Center(child: Text("Campo de formulário $i")),
              )
            ),
          ),
        ),
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus
          )
        )
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
            ? 'The user did not grant the camera permission!'
            : 'Unknown error: $e'
        );
      });
    }
  }
}