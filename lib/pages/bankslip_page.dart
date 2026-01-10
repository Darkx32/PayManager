import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/pages/scanner_page.dart';

class BankSlipPage extends StatefulWidget {
  const BankSlipPage({super.key});

  @override
  State<StatefulWidget> createState() => _BankSlipState();
}

class _BankSlipState extends State<BankSlipPage> {
  final _key = GlobalKey<ExpandableFabState>();
  List<BankSlip> bankSlips = [];
  bool _isLongPressed = false;

  final currencyFormat = NumberFormat.currency(
    locale: "pt_BR",
    symbol: "R\$",
    decimalDigits: 2
  );

  double totalValue = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      bankSlips.add(BankSlip.createBankSlipDataUsingBarcode("23792372059237481415767022195308213150000382633"));
    });
    updateTotalValue();
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
      appBar: AppBar(),
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
                bankSlips.add(BankSlip.createBankSlipDataUsingBarcode(barcode));
              });
              updateTotalValue();
            },
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
      body: Stack(
        fit: StackFit.expand,
        children: [
        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 65), 
            child: Column(
              children: [
                for(BankSlip bankSlip in bankSlips)
                  GestureDetector(
                    onTap: () {
                      if (_isLongPressed) return;
                      _updateClipboard(bankSlip.barcode);
                    },
                    onLongPress: () {
                      _isLongPressed = true;
                    },
                    onTapDown: (details) {
                      _isLongPressed = false;
                    },
                    onTapCancel: () {
                      _isLongPressed = true;
                    },
                    child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
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
                                Text(currencyFormat.format(bankSlip.value), style: TextStyle(color: Colors.green[600]))
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
                Text("Total: ", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Theme.of(context).colorScheme.onPrimaryContainer)),
                Text("R\$ $totalValue", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Theme.of(context).colorScheme.onPrimaryContainer))
              ],
            ),
          )
        )
      ])
    );
  }

  void updateTotalValue() {
    double newTotal = 0.0;
    for (final bankSlip in bankSlips) {
      newTotal += bankSlip.value;
    }
    setState(() {
      totalValue = newTotal;
    });
  }

  Future<void> _updateClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }
}