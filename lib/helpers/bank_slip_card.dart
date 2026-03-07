import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/l10n/app_localizations.dart';

class BankSlipCard extends StatelessWidget {
  final BankSlip data;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(TapDownDetails) onTapDown;
  final VoidCallback onTapCancel;
  final TextDecoration _decorationForNotSum = TextDecoration.lineThrough;
  
  const BankSlipCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.onLongPress,
    required this.onTapDown,
    required this.onTapCancel
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            onTapDown: onTapDown,
            onTapCancel: onTapCancel,
            child: Container(
            decoration: BoxDecoration(
              color: data.isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.surfaceContainerHigh,
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
                      fontWeight: FontWeight.w900, decoration: data.isNotToSum ? _decorationForNotSum : TextDecoration.none
                    )),
                    Text(data.barcode, softWrap: true, 
                      style: TextStyle(fontWeight: FontWeight.bold, decoration: data.isNotToSum ? _decorationForNotSum : TextDecoration.none)),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppLocalizations.of(context)!.date}:", style: TextStyle(
                          fontWeight: FontWeight.w800, decoration: data.isNotToSum ? _decorationForNotSum : TextDecoration.none
                        )),
                        Text(DateFormat("dd/MM/yyyy").format(data.date), style: TextStyle(
                          color: Colors.green[600], decoration: data.isNotToSum ? _decorationForNotSum : TextDecoration.none
                        ))
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppLocalizations.of(context)!.value}:", style: TextStyle(
                          fontWeight: FontWeight.w800, decoration: data.isNotToSum ? _decorationForNotSum : TextDecoration.none
                        )),
                        Text(data.getCurrencyToString(), style: TextStyle(
                          color: Colors.green[600], decoration: data.isNotToSum ? _decorationForNotSum : TextDecoration.none
                          ))
                      ],
                    ),
                  ]
                ),
              ],
            ),
          ),
        );
  }
}