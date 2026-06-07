import 'package:flutter/material.dart';

class SettingsSwitcher extends StatelessWidget {
  final String title;
  final bool value;
  final WidgetStateProperty<Icon> switchIcon;
  final Function(bool) onChange;
  final String? tooltip;
  final Widget? child;

  const SettingsSwitcher({
    super.key,
    required this.title,
    required this.value,
    required this.switchIcon,
    required this.onChange,
    this.tooltip,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    final bool showChild = child != null && value;

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
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          strokeAlign: BorderSide.strokeAlignOutside
        ),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 6,
            children: [
              Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (tooltip != null)
                Tooltip(
                  message: tooltip,
                  triggerMode: TooltipTriggerMode.tap,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w500,
                    
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(Icons.info_outline, size: 18),
                  ) 
                ),
              Spacer(),
              Switch(value: value, 
                thumbIcon: switchIcon,
                onChanged: onChange)
            ],
          ),
          if (showChild)
            Divider(color: Theme.of(context).colorScheme.onSurface),
          if (showChild)
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 6),
              child: child,
            )
        ],
      ) 
    );
  }
}