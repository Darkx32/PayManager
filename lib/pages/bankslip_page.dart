import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class BankSlipPage extends StatefulWidget {
  const BankSlipPage({super.key});

  @override
  State<StatefulWidget> createState() => _BankSlipState();
}

class _BankSlipState extends State<BankSlipPage> {
  final _key = GlobalKey<ExpandableFabState>();

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
              children: List.generate(20, (i) => 
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1.0,
                    style: BorderStyle.solid
                  )
                ),
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                child: Center(child: Text("Campo de formulário $i")),
              )
            ),
          ),
        ),
    );
  }
}