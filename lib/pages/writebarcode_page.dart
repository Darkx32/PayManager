import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pay_manager/core/bankslip.dart';

class WriteBarcode extends StatefulWidget {
  const WriteBarcode({super.key});

  @override
  State<StatefulWidget> createState() => _WriteBarcodeState();
}

class _WriteBarcodeState extends State<WriteBarcode> {
  bool _allChecked = false;
  BankSlip? bankSlip;

  var maskFormatter = MaskTextInputFormatter(
    mask: "#####.##### #####.###### #####.###### # ##############",
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );
  
  void _buttonPress() {
    Navigator.pop(context, bankSlip!.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            spacing: 7,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  maxLines: 1, 
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 54) {
                      _allChecked = false;
                      return "It's no a real bankslip";
                    } else {
                      _allChecked = true;
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      _allChecked = maskFormatter.getUnmaskedText().length == 47;
                      if (_allChecked) {
                        bankSlip = BankSlip.createBankSlipDataUsingBarcode(maskFormatter.getUnmaskedText());
                      } else {
                        bankSlip = null;
                      }
                    });
                  },
                  maxLength: 54,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  )
              ),

              Container(
                padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                child: 
                Row(
                  children: [
                    Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_allChecked ? DateFormat("dd/MM/yyyy").format(bankSlip!.date) : "-"),
                    Spacer(),
                    Text("Value: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_allChecked ? bankSlip!.getCurrencyToString() : "-")
                  ],
                ),
              )
            ],
          ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: 
          Container(
            padding: EdgeInsets.all(10),
            child: 
              ElevatedButton(onPressed: _allChecked ? _buttonPress : null, 
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Theme.of(context).colorScheme.onSurface), 
                child: const Text("Confirm")),
            )
          )
      ]) 
    );
  }
}