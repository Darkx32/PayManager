import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/helpers/bank_slip_card.dart';
import 'package:pay_manager/l10n/app_localizations.dart';
import 'package:pay_manager/pages/confirmation_popup.dart';
import 'package:pay_manager/pages/scanner_page.dart';
import 'package:pay_manager/pages/writebarcode_page.dart';

class BankSlipPage extends StatefulWidget {
  const BankSlipPage({super.key, this.toEdit = const []});
  final List<String> toEdit;

  @override
  State<StatefulWidget> createState() => _BankSlipState();
}

class _BankSlipState extends State<BankSlipPage> {
  final _key = GlobalKey<ExpandableFabState>();
  final List<BankSlip> _bankSlips = [];
  final List<BankSlip> _toEditCoppied = [];
  bool _isLongPressed = false;
  int _lengthForNotSum = 0;

  double _totalValue = 0.0;

  void _updateTotalValue() {
    double newTotal = 0.0;
    for (final bankSlip in _bankSlips) {
      if (!bankSlip.isNotToSum) {
        newTotal += bankSlip.value;
      }
    }
    setState(() {
      _totalValue = newTotal;
    });
  }

  Future<void> _updateClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }

  @override
  void initState() {
    super.initState();
    if (widget.toEdit.isNotEmpty) {
      var finalList = List<BankSlip>.empty(growable: true);
      for (var barcode in widget.toEdit) {
        final bankSlip = BankSlip.createBankSlipDataUsingBarcode(barcode);

        if (bankSlip != null) {
          finalList.add(bankSlip);
        }
      }
      setState(() {
        _bankSlips.addAll(finalList);
        _toEditCoppied.addAll(finalList);
      });
    }
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!listEquals(_bankSlips, _toEditCoppied)) {
          bool? canClose = await ConfirmationPopup.show(context);
          if (canClose == null || !context.mounted) return;

          if (canClose) {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (_bankSlips.any((bankSlip) => bankSlip.isSelected))
              IconButton(
                onPressed: () {
                  _lengthForNotSum = 0;
                  for (var bankslip in _bankSlips) {
                    if (bankslip.isSelected) {
                      setState(() {
                        bankslip.isNotToSum = !bankslip.isNotToSum;
                        _lengthForNotSum += bankslip.isNotToSum ? 1 : 0;
                        bankslip.isSelected = false;
                      });
                    }
                  }
                  setState(() {
                    _isLongPressed = false;
                  });
                  _updateTotalValue();
                },
                icon: Icon(Symbols.select),
              ),
            if (_bankSlips.any((bankSlip) => bankSlip.isSelected))
              IconButton(
                onPressed: () {
                  setState(() {
                    _bankSlips.removeWhere((bankslip) => bankslip.isSelected);
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

                final bankSlip = BankSlip.createBankSlipDataUsingBarcode(barcode);

                if (bankSlip == null) return;
                setState(() {
                  _bankSlips.add(bankSlip);
                });
                _updateTotalValue();
              },
              child: const Icon(Symbols.barcode_scanner)),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () async {
                final barcode = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) => const WriteBarcode()));
                if (barcode == null) return;

                final bankSlip = BankSlip.createBankSlipDataUsingBarcode(barcode);

                if (bankSlip == null) return;
                setState(() {
                  _bankSlips.add(bankSlip);
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
                      content: Text(AppLocalizations.of(context)!.bankslip_page_dont_added_any_bankslip),
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
              child: const Icon(Icons.done))
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
          SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 95), 
              child: Column(
                children: [
                  for(BankSlip bankSlip in _bankSlips)
                    BankSlipCard(data: bankSlip, 
                    onTap: () 
                    {
                      if (_isLongPressed) return;
                      if (_bankSlips.any((bankSlip) => bankSlip.isSelected == true)) {
                        setState(() {
                          bankSlip.isSelected = !bankSlip.isSelected;
                        });
                      } else {
                        _updateClipboard(bankSlip.barcode);
                      }
                    },
                    onLongPress: () 
                    {
                      _isLongPressed = true;
                      setState(() {
                        bankSlip.isSelected = !bankSlip.isSelected;
                      });
                    },
                    onTapDown: (details) 
                    {
                      _isLongPressed = false;
                    },
                    onTapCancel: () 
                    {
                      _isLongPressed = true;
                    })
                ]
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 90,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withAlpha(180),
                border: Border.all(
                  color: Colors.transparent
                ),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(BankSlip.convertNumberToStringWithCurrency(_totalValue), style: 
                    TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Theme.of(context).colorScheme.onPrimaryContainer)
                  ),
                  Text("${AppLocalizations.of(context)!.bankslip_page_Amount}: ${_bankSlips.length - _lengthForNotSum}", style: 
                    TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: Theme.of(context).colorScheme.onPrimaryContainer)
                  )
                ],
              )
            )
          )
        ])
      )
    );
  }
}