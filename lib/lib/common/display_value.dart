// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Render the [Hour] or [Minute] value for `Android` picker
class DisplayValue extends StatelessWidget {
  /// The [value] to display
  final String value;

  /// The [onTap] handler
  final Null Function()? onTap;

  /// Whether the [value] is selected or not
  final bool isSelected;

  final bool isEditMode;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final int? maxValue;

  /// Constructor for the [Widget]
  const DisplayValue({
    Key? key,
    required this.value,
    required this.controller,
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
    final unselectedColor = timeState.widget.unselectedColor ?? Colors.grey;
    const unSelectedBorderColor = Color(0xFFC0C9CE);
    return SizedBox(
      width: 121,
      child: TextFormField(
        controller: controller,
        cursorHeight: 55,
        cursorColor: color,
        style: _commonTimeStyles.copyWith(
          color: isEditMode || isSelected ? color : Colors.black,
        ),
        onChanged: onChanged,
        onTap: onTap,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: unSelectedBorderColor,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: color,
              width: 3.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: unSelectedBorderColor,
              width: 2.0,
            ),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
          MaxValueInputFormatter(maxValue!),
        ],
      ),
    );
  }
}
