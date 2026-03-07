import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/helpers/bank_slip_card.dart';
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

    final bankSlips = _allBankslipsBox.toMap().entries.toList();

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
          padding: EdgeInsets.only(top: 50, bottom: 80),
          child: Column(
            children: [
              for (int i = bankSlips.length - 1; i >= 0;i--)
                BankSlipCard(data: bankSlips[i].value, onEdit: (BankslipSave bankslipSave) => {
                  setState(() {
                    _allBankslipsBox.put(bankSlips[i].key, bankslipSave);
                  })
                }, onDelete: () => {
                  setState(() {
                    _allBankslipsBox.delete(bankSlips[i].key);
                  })
                })
            ],
          ),
        ),
      ),
    );
  }
}