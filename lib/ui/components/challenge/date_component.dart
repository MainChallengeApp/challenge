import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class DateComponent extends StatefulWidget {
  final DateTime? date;
  final String text;
  final Color? textColor;
  final Function()? onTap;

  const DateComponent({
    super.key,
    required this.date,
    required this.text,
    this.onTap,
    this.textColor,
  });

  @override
  State<DateComponent> createState() => _DateComponentState();
}

class _DateComponentState extends State<DateComponent> {
  @override
  Widget build(BuildContext context) {
    return TapContainerComponent(
        onTap: widget.onTap,
        padding: const EdgeInsets.only(
            left: CustomContainerComponent.standardPadding,
            right: CustomContainerComponent.standardPadding,
            top: 5,
            bottom: 5),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.text,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: widget.textColor),
                  ),
                  Text(
                    (widget.date != null ? _dateFormat(widget.date!) : '-'),
                    style: Theme.of(context)
                        .textTheme
                        .textInputSmall
                        .copyWith(color: widget.textColor),
                  )
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  widget.date != null ? _timeFormat(widget.date!) : '',
                  style: Theme.of(context)
                      .textTheme
                      .subTitle
                      .copyWith(color: widget.textColor),
                ))
          ],
        ));
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _timeFormat(DateTime date) {
    return '${date.hour <= 9 ? '0' : ''}${date.hour}:${date.minute <= 9 ? '0' : ''}${date.minute}';
  }
}
