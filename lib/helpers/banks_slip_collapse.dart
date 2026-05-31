import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/bankslip_save.dart';

class BanksSlipCollapse extends StatefulWidget {
  final List<MapEntry<dynamic, BankslipSave>> data;
  final String month;
  final String year;
  final Widget Function(MapEntry<dynamic, BankslipSave>) onDraw;

  const BanksSlipCollapse({
    super.key,
    required this.data,
    required this.month,
    required this.year,
    required this.onDraw
  });

  @override
  State<StatefulWidget> createState() => _BanksSlipCollapseState();
}

class _BanksSlipCollapseState extends State<BanksSlipCollapse> with TickerProviderStateMixin {
  bool _isColapsed = true;

  @override
  Widget build(BuildContext context) {
    final String localeString = Localizations.localeOf(context).toString();
    final DateFormat formatter = DateFormat.MMMM(localeString);

    final bankslipsMonth = widget.data.reversed.where((bankslip)  {
      return formatter.format(bankslip.value.date) == widget.month;
    });

    return AnimatedSize(
      alignment: AlignmentGeometry.topCenter,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade700,
              spreadRadius: -5,
              blurRadius: 10,
              offset: const Offset(0, 10)
            )
          ],
          border: Border.all(
            color:  Theme.of(context).colorScheme.onSurface,
            width: 1.0,
            style: BorderStyle.solid
          ),
          borderRadius: BorderRadius.circular(5)
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft
                  )
                ),
                Text("${toBeginningOfSentenceCase(widget.month)}/${widget.year}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 40,
                      onPressed: () { setState(() {
                        _isColapsed = !_isColapsed;
                      });}, icon: Icon(_isColapsed ? Icons.arrow_right : Icons.arrow_drop_down)
                    ),
                  )
                )
              ],
            ),

            if (!_isColapsed)
              ...bankslipsMonth.map((bankSlip) {
                return widget.onDraw(bankSlip);
              })
          ],
        ),
      )
    );
  }
}