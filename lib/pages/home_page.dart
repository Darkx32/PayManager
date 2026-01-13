import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/pages/bankslip_page.dart';

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
              for (var bankslipSave in _allBankslipsBox.values.toList())
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
                      spacing: 7,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Date: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(DateFormat("dd/MM/yyyy").format(bankslipSave.date), style: TextStyle(fontWeight: FontWeight.bold))
                          ]
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