import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/core/bankslip_save.dart';
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
  final List<String> _selected = [];
  bool _isLongPressed = false;
  TextDecoration _decorationForNotSum = TextDecoration.lineThrough;
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

  void _setToSelected(String barcode) {
    setState(() {
      if (_selected.contains(barcode)) {
        _selected.remove(barcode);
      } else {
        _selected.add(barcode);
      }
    });
  }

  bool _deleteItem(BankSlip bankSlip) {
    final barcode = bankSlip.barcode;
    final hasInList = _selected.contains(barcode);

    _selected.remove(barcode);

    return hasInList;
  }

  Future<void> _updateClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }

  @override
  void initState() {
    super.initState();
    if (widget.toEdit.isNotEmpty) {
      for (var barcode in widget.toEdit) {
        final bankSlip = BankSlip.createBankSlipDataUsingBarcode(barcode);

        if (bankSlip != null) {
          setState(() {
            _bankSlips.add(bankSlip);
          });
        }
      }
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
        if (_bankSlips.isNotEmpty) {
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
            if (_selected.isNotEmpty)
              IconButton(
                onPressed: () {
                  _lengthForNotSum = 0;
                  for (var bankslip in _bankSlips) {
                    if (_selected.contains(bankslip.barcode)) {
                      setState(() {
                        bankslip.isNotToSum = !bankslip.isNotToSum;
                        _lengthForNotSum += bankslip.isNotToSum ? 1 : 0;
                      });
                    }
                  }
                  setState(() {
                    _selected.clear();
                    _isLongPressed = false;
                  });
                  _updateTotalValue();
                },
                icon: Icon(Symbols.select),
              ),
            if (_selected.isNotEmpty)
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
                        if (_selected.isNotEmpty) {
                          _setToSelected(bankSlip.barcode);
                        } else {
                          _updateClipboard(bankSlip.barcode);
                        }
                      },
                      onLongPress: () {
                        _isLongPressed = true;
                        _setToSelected(bankSlip.barcode);
                      },
                      onTapDown: (details) {
                        _isLongPressed = false;
                      },
                      onTapCancel: () {
                        _isLongPressed = true;
                      },
                      child: Container(
                      decoration: BoxDecoration(
                        color: _selected.contains(bankSlip.barcode) ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.surfaceContainerHigh,
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
                              Text("${AppLocalizations.of(context)!.bankslip_page_barcode}:", style: TextStyle(
                                fontWeight: FontWeight.w900, decoration: bankSlip.isNotToSum ? _decorationForNotSum : TextDecoration.none
                              )),
                              Text(bankSlip.barcode, softWrap: true, 
                                style: TextStyle(fontWeight: FontWeight.bold, decoration: bankSlip.isNotToSum ? _decorationForNotSum : TextDecoration.none)),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${AppLocalizations.of(context)!.date}:", style: TextStyle(
                                    fontWeight: FontWeight.w800, decoration: bankSlip.isNotToSum ? _decorationForNotSum : TextDecoration.none
                                  )),
                                  Text(DateFormat("dd/MM/yyyy").format(bankSlip.date), style: TextStyle(
                                    color: Colors.green[600], decoration: bankSlip.isNotToSum ? _decorationForNotSum : TextDecoration.none
                                  ))
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${AppLocalizations.of(context)!.value}:", style: TextStyle(
                                    fontWeight: FontWeight.w800, decoration: bankSlip.isNotToSum ? _decorationForNotSum : TextDecoration.none
                                  )),
                                  Text(bankSlip.getCurrencyToString(), style: TextStyle(
                                    color: Colors.green[600], decoration: bankSlip.isNotToSum ? _decorationForNotSum : TextDecoration.none
                                    ))
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