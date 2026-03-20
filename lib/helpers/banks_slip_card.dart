import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/l10n/app_localizations.dart';
import 'package:pay_manager/pages/bankslip_page.dart';
import 'package:pay_manager/pages/confirmation_popup.dart';

class BanksSlipCard extends StatelessWidget {
  final BankslipSave data;
  final Function(BankslipSave) onEdit;
  final VoidCallback onDelete;

  const BanksSlipCard({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onLongPress: () async {
              await Clipboard.setData(ClipboardData(
                text: BankSlip.convertNumberToCurrency(data.totalValue).substring(3)));
            },
            child: 
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
                spacing: 0,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap
                        ),
                        onPressed: () async {
                          final bankslipSave = await Navigator.push(context, MaterialPageRoute<BankslipSave>(
                            builder: (context) => BankSlipPage(toEdit: data.barcodes)
                          ));
                          if (bankslipSave == null) return;

                          onEdit(bankslipSave);
                        }, 
                        icon: Icon(Icons.edit)
                      ),
                      Spacer(),
                      Text("${AppLocalizations.of(context)!.date}: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(DateFormat("dd/MM/yyyy").format(data.date), style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap
                        ),
                        onPressed: () async {
                          bool? userChoose = await ConfirmationPopup.show(context, 
                            description: AppLocalizations.of(context)!.confirmation_popup_delete_home_page
                          );
                          if (userChoose == null) return;

                          if (userChoose) {
                            onDelete();
                          }
                        }, 
                        icon: Icon(Icons.delete)
                      ),
                    ]
                  ),
                  Center(
                    child: Text(BankSlip.convertNumberToCurrency(data.totalValue), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                      color: Colors.green[600])),
                  )
                ],
              ),
            ),
          );
  }
}