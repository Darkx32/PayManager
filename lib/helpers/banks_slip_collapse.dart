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

class _BanksSlipCollapseState extends State<BanksSlipCollapse> {
  bool _isColapsed = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color:  Theme.of(context).colorScheme.onSurface,
          width: 1.0,
          style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.circular(5)
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft
                )
              ),
              Text("${toBeginningOfSentenceCase(widget.month)}/${widget.year}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            for (var bankSlip in widget.data.reversed) 
              if (DateFormat.MMMM(Localizations.localeOf(context).toString()).format(bankSlip.value.date) == widget.month)
                widget.onDraw(bankSlip)
        ],
      ),
    );
  }
}