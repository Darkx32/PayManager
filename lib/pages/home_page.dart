import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/core/record_date.dart';
import 'package:pay_manager/helpers/banks_slip_card.dart';
import 'package:pay_manager/helpers/banks_slip_collapse.dart';
import 'package:pay_manager/pages/bankslip_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<BankslipSave> _allBankslipsBox;
  bool _isLoading = true;
  final List<RecordDate> _allDates = [];
  late List<MapEntry<dynamic, BankslipSave>> _bankSlips;

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BankslipSaveAdapter());
    _allBankslipsBox = await Hive.openBox<BankslipSave>("bankslips");

    await _initLists();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _initLists() async {
    _bankSlips = _allBankslipsBox.toMap().entries.toList();
    for (var bankSlip in _bankSlips) {
      String month = DateFormat.MMMM(Localizations.localeOf(context).toString()).format(bankSlip.value.date);
      bool exists = _allDates.any((item) =>
        item.month == month &&
        item.year == bankSlip.value.date.year);
      
      if (!exists) {
        _allDates.add(RecordDate(month: month, year: bankSlip.value.date.year));
      }
    }
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
          padding: EdgeInsets.only(top: 50, bottom: 80),
          child: Column(
            children: [
              for (int i = _allDates.length - 1; i >= 0; --i) 
                BanksSlipCollapse(
                  data: _bankSlips,
                  month: _allDates[i].month, 
                  year: _allDates[i].year.toString(),
                  onDraw: (bankSlip) {
                    return BanksSlipCard(data: bankSlip.value,
                      onEdit: (BankslipSave bankslipSave) => {
                        setState(() {
                          _allBankslipsBox.put(bankSlip.key, bankslipSave);
                        })
                      },
                      onDelete: () => {
                        setState(() {
                          _allBankslipsBox.delete(bankSlip.key);
                        })
                      }
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}