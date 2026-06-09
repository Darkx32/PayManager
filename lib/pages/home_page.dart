import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/core/record_date.dart';
import 'package:pay_manager/helpers/banks_slip_card.dart';
import 'package:pay_manager/helpers/banks_slip_collapse.dart';
import 'package:pay_manager/pages/bankslip_page.dart';
import 'package:pay_manager/preferences.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<BankslipSave> _allBankslipsBox;
  bool _isLoading = true;
  final List<RecordDate> _allDates = [];
  List<MapEntry<dynamic, BankslipSave>> get _bankSlips =>
    _allBankslipsBox.toMap().entries.toList();
  final ScrollController _scrollController = ScrollController();
  bool _showSecondFab = false;

  Future<void> _initHive() async {
    _isLoading = true;
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(BankslipSaveAdapter().typeId)){
      Hive.registerAdapter(BankslipSaveAdapter());
    }
    _allBankslipsBox = await Hive.openBox<BankslipSave>("bankslips");

    _updateAllDates();
    setState(() {
      _isLoading = false;
    });
  }

  void _updateAllDates() {
    final dateFormater = DateFormat.MMMM(Localizations.localeOf(context).toString());

    for (var bankSlip in _bankSlips) {
      String month = dateFormater.format(bankSlip.value.date);
      bool exists = _allDates.any((item) =>
        item.month == month &&
        item.year == bankSlip.value.date.year);
      
      if (!exists) {
        _allDates.add(RecordDate(month: month, year: bankSlip.value.date.year));
      }
    }
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    const double threshold = 50.0;
    final bool isPullingDown = position.pixels < -threshold;
    final bool isPullingUp = position.pixels > (position.maxScrollExtent + threshold);

    if (isPullingUp) {
      setState(() {
        _showSecondFab = true;
      });
    } else if (isPullingDown) {
      setState(() {
        _showSecondFab = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initHive();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AutoExclude autoExclude = context.watch<AutoExclude>();

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedScale(
            scale: _showSecondFab ? 1.0 : 0.0, 
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceInOut,
            child: FloatingActionButton.small(
              heroTag: "Settings",
              onPressed: () async {
                await Navigator.pushNamed(context, "/settings");
                setState(() {
                  _initHive();
                });
              },
              shape: CircleBorder(),
              child: const Icon(Icons.settings),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "New",
            onPressed: () async {
              final bankslipSave = await Navigator.push(context, MaterialPageRoute<BankslipSave>(builder: (context) => const BankSlipPage()));
              if (bankslipSave == null) return;

              _allBankslipsBox.add(bankslipSave);
              setState(() {
                _initHive();
              });
            },
            shape: CircleBorder(),
            child: const Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 50, bottom: 80),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
          ),
          child: Column(
            children: [
              for (int i = _allDates.length - 1; i >= 0; --i) 
                BanksSlipCollapse(
                  data: _bankSlips,
                  month: _allDates[i].month, 
                  year: _allDates[i].year.toString(),
                  onDraw: (bankSlip) {
                    return BanksSlipCard(data: bankSlip.value,
                      onEdit: (BankslipSave bankslipSave) {
                        _allBankslipsBox.put(bankSlip.key, bankslipSave);
                        setState(() {});
                      },
                      onDelete: () {
                        _allBankslipsBox.delete(bankSlip.key);
                        setState(() {});
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