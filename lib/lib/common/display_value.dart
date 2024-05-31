// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Render the [Hour] or [Minute] value for `Android` picker
class DisplayValue extends StatelessWidget {
  /// The [onTap] handler
  final Null Function()? onTap;

  final bool isSelected;

  final bool isEditMode;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final int? maxValue;
  final FocusNode focusNode;

  /// Constructor for the [Widget]
  const DisplayValue({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.onTap,
    this.isSelected = false,
    this.onChanged,
    this.isEditMode = false,
    this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final _commonTimeStyles =
        Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 64,
              fontWeight: FontWeight.w600,
              height: 1.3,
            );
    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    const unSelectedBorderColor = Color(0xFFC0C9CE);
    return SizedBox(
      width: 121,
      height: 118,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: focusNode.hasFocus ? color : unSelectedBorderColor,
            width: focusNode.hasFocus ? 3 : 2,
          ),
        ),
        child: Center(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: color,
            style: _commonTimeStyles.copyWith(
              color: isEditMode || isSelected ? color : Colors.black,
            ),
            onChanged: onChanged,
            onTap: onTap,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
              MaxValueInputFormatter(maxValue!),
            ],
          ),
        ),
      ),
    );
  }
}
