import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:flutter/material.dart';

/// Render the [Ok] and [Cancel] buttons
class ActionButtons extends StatelessWidget {
  final VoidCallback onOkPressed;
  const ActionButtons({Key? key,required this.onOkPressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    final defaultButtonStyle = TextButton.styleFrom(
      textStyle: TextStyle(color: color),
    );

    if (timeState.widget.isOnValueChangeMode) {
      return const SizedBox(
        height: 8,
      );
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (timeState.widget.showCancelButton)
            TextButton(
              style: (timeState.widget.cancelButtonStyle) ?? defaultButtonStyle,
              onPressed: timeState.onCancel,
              child: Text(
                timeState.widget.cancelText,
                style: timeState.widget.cancelStyle,
              ),
            ),
          SizedBox(width: timeState.widget.buttonsSpacing ?? 0),
          ElevatedButton(
            style: timeState.widget.buttonStyle,
            onPressed: onOkPressed,
            child: Text(
              timeState.widget.okText,
              style: timeState.widget.okStyle,
            ),
          ),
        ],
      ),
    );
  }
}
