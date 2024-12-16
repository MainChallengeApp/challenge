import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class SwitchComponent extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;

  const SwitchComponent({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SwitchComponent> createState() => _SwitchComponentState();
}

class _SwitchComponentState extends State<SwitchComponent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Switch(
        value: widget.value,
        trackOutlineColor: widget.value
            ? const WidgetStatePropertyAll(Colors.transparent)
            : WidgetStatePropertyAll(Theme.of(context).colorScheme.themeColor5),
        trackOutlineWidth: const WidgetStatePropertyAll(1),
        inactiveThumbColor: Theme.of(context).colorScheme.tertiary,
        activeTrackColor: Theme.of(context).colorScheme.green,
        onChanged: widget.onChanged,
      ),
    );
  }
}
