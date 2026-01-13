import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/pages/scanner_page.dart';
import 'package:pay_manager/pages/writebarcode_page.dart';

class BankSlipPage extends StatefulWidget {
  const BankSlipPage({super.key});

  @override
  State<StatefulWidget> createState() => _BankSlipState();
}

class _BankSlipState extends State<BankSlipPage> {
  final _key = GlobalKey<ExpandableFabState>();
  final List<BankSlip> _bankSlips = [];
  final List<String> _toDelete = [];
  bool _isLongPressed = false;

  double _totalValue = 0.0;

  void _updateTotalValue() {
    double newTotal = 0.0;
    for (final bankSlip in _bankSlips) {
      newTotal += bankSlip.value;
    }
    setState(() {
      _totalValue = newTotal;
    });
  }

  void _setToDelete(String barcode) {
    setState(() {
      if (_toDelete.contains(barcode)) {
        _toDelete.remove(barcode);
      } else {
        _toDelete.add(barcode);
      }
    });
  }

  bool _deleteItem(BankSlip bankSlip) {
    final barcode = bankSlip.barcode;
    final hasInList = _toDelete.contains(barcode);

    _toDelete.remove(barcode);

    return hasInList;
  }

  Future<void> _updateClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _bankSlips.add(BankSlip.createBankSlipDataUsingBarcode("23792372059237481415767022195308213150000382633"));
    });
    _updateTotalValue();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); 
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_toDelete.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _bankSlips.removeWhere((bankslip) => _deleteItem(bankslip));
                });
                _updateTotalValue();
              }, 
              icon: const Icon(Icons.delete)
            )
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        children: [
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () async {
              final barcode = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) => const ScannerPage()));
              if (barcode == null) return;

              setState(() {
                _bankSlips.add(BankSlip.createBankSlipDataUsingBarcode(barcode));
              });
              _updateTotalValue();
            },
            child: const Icon(Symbols.barcode_scanner)),
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () async {
              final barcode = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) => const WriteBarcode()));
              if (barcode == null) return;

              setState(() {
                _bankSlips.add(BankSlip.createBankSlipDataUsingBarcode(barcode));
              });
              _updateTotalValue();
            },
            child: const Icon(Symbols.barcode)),
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {
              if (_bankSlips.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You don't added any bankslip"),
                    duration: const Duration(seconds: 3),
                  )
                );
              } else {
                List<String> allBarcodes = [];
                for(final bankslip in _bankSlips) {
                  allBarcodes.add(bankslip.barcode);
                }
                BankslipSave bankslipSave = BankslipSave(barcodes: allBarcodes, date: DateTime.now(), totalValue: _totalValue);
                Navigator.pop(context, bankslipSave);
              }
            },
            child: const Icon(Icons.done),)
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 65), 
            child: Column(
              children: [
                for(BankSlip bankSlip in _bankSlips)
                  GestureDetector(
                    onTap: () {
                      if (_isLongPressed) return;
                      if (_toDelete.isNotEmpty) {
                        _setToDelete(bankSlip.barcode);
                      } else {
                        _updateClipboard(bankSlip.barcode);
                      }
                    },
                    onLongPress: () {
                      _isLongPressed = true;
                      _setToDelete(bankSlip.barcode);
                    },
                    onTapDown: (details) {
                      _isLongPressed = false;
                    },
                    onTapCancel: () {
                      _isLongPressed = true;
                    },
                    child: Container(
                    decoration: BoxDecoration(
                      color: _toDelete.contains(bankSlip.barcode) ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.surfaceContainerHigh,
                      border: Border.all(
                        color:  Theme.of(context).colorScheme.onSurface,
                        width: 1.0,
                        style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      spacing: 7,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Barcode:", style: TextStyle(fontWeight: FontWeight.w900)),
                            Text(bankSlip.barcode, softWrap: true, 
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Date:", style: TextStyle(fontWeight: FontWeight.w800)),
                                Text(DateFormat("dd/MM/yyyy").format(bankSlip.date), style: TextStyle(color: Colors.green[600]))
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Value:", style: TextStyle(fontWeight: FontWeight.w800)),
                                Text(bankSlip.getCurrencyToString(), style: TextStyle(color: Colors.green[600]))
                              ],
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
            ]
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 80,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              border: Border.all(
                color: Colors.transparent
              ),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Row(
              children: [
                Text(BankSlip.convertNumberToStringWithCurrency(_totalValue), style: 
                  TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Theme.of(context).colorScheme.onPrimaryContainer)
                )
              ],
            ),
          )
        )
      ])
    );
  }
}