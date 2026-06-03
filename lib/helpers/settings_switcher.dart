import 'package:flutter/material.dart';

class SettingsSwitcher extends StatelessWidget {
  final String title;
  final bool value;
  final WidgetStateProperty<Icon> switchIcon;
  final Function(bool) onChange;

  const SettingsSwitcher({
    super.key,
    required this.title,
    required this.value,
    required this.switchIcon,
    required this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade600,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3)
          )
        ],
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: BoxBorder.all(
          color: Theme.of(context).colorScheme.onSurface,
          strokeAlign: BorderSide.strokeAlignOutside
        ),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        children: [
          Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          Spacer(),
          Switch(value: value, 
            thumbIcon: switchIcon,
            onChanged: onChange)
        ],
      )
    );
  }
}