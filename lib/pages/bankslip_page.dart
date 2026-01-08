import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pay_manager/core/bankslip.dart';

class BankSlipPage extends StatefulWidget {
  const BankSlipPage({super.key});

  @override
  State<StatefulWidget> createState() => _BankSlipState();
}

class _BankSlipState extends State<BankSlipPage> {
  final _key = GlobalKey<ExpandableFabState>();
  List<BankSlip> bankSlips = [];

  final currencyFormat = NumberFormat.currency(
    locale: "pt_BR",
    symbol: "R\$",
    decimalDigits: 2
  );

  @override
  void initState() {
    super.initState();
    bankSlips.add(BankSlip.createBankSlipDataUsingBarcode("34191132000000976981090189577400336372867000"));
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
              Navigator.pushNamed(context, "/scanner");
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
      body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 65), 
            child: Column(
              children: [
                for(BankSlip bankSlip in bankSlips)
                  Container(
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
                  )
          ]
        ),
      )
    );
  }
}