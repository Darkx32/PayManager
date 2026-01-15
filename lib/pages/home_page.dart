import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/bankslip.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/pages/bankslip_page.dart';
import 'package:pay_manager/pages/confirmation_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<BankslipSave> _allBankslipsBox;
  bool _isLoading = true;

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BankslipSaveAdapter());
    _allBankslipsBox = await Hive.openBox<BankslipSave>("bankslips");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bankslipSave = await Navigator.push(context, MaterialPageRoute<BankslipSave>(builder: (context) => const BankSlipPage()));
          if (bankslipSave == null) return;

          setState(() {
            _allBankslipsBox.add(bankslipSave);
          });
        },
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              for (var entries in _allBankslipsBox.toMap().entries)
                GestureDetector(
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
                                  builder: (context) => BankSlipPage(toEdit: entries.value.barcodes)
                                ));
                                if (bankslipSave == null) return;

                                setState(() {
                                  _allBankslipsBox.put(entries.key, bankslipSave);
                                });
                              }, 
                              icon: Icon(Icons.edit)
                            ),
                            Spacer(),
                            const Text("Date: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(DateFormat("dd/MM/yyyy").format(entries.value.date), style: TextStyle(fontWeight: FontWeight.bold)),
                            Spacer(),
                            IconButton(
                              padding: EdgeInsets.zero,
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap
                              ),
                              onPressed: () async {
                                bool? userChoose = await ConfirmationPopup.show(context);
                                if (userChoose == null) return;

                                if (userChoose) {
                                  setState(() {
                                    _allBankslipsBox.delete(entries.key);
                                  });
                                }
                              }, 
                              icon: Icon(Icons.delete)
                            ),
                          ]
                        ),
                        Center(
                          child: Text(BankSlip.convertNumberToStringWithCurrency(entries.value.totalValue), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                            color: Colors.green[600])),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}