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

  final double width;
  final bool editable;
  final bool isEditMode;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(bool)? onTapEditMode;
  final int? maxValue;
  final FocusNode? focusNode;

  /// Constructor for the [Widget]
  const DisplayValue({
    Key? key,
    required this.value,
    this.onTap,
    this.isSelected = false,
    this.editable = false,
    required this.width,
    this.controller,
    this.onChanged,
    this.isEditMode = false,
    this.onTapEditMode,
    this.maxValue,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final _commonTimeStyles =
        Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 62,
              fontWeight: FontWeight.bold,
            );

    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    final unselectedColor = timeState.widget.unselectedColor ?? Colors.grey;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: TextFormField(
              focusNode: focusNode,
              initialValue: controller == null ? value : null,
              controller: controller,
              style: _commonTimeStyles.copyWith(
                color: isSelected ? color : unselectedColor,
              ),
              enabled: isEditMode,
              onTap: onTap,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
              ),
              inputFormatters: editable
                  ? [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      MaxValueInputFormatter(maxValue!),
                    ]
                  : [],
            ),
          ),
          IconButton(
            onPressed: isSelected
                ? () {
                    onTapEditMode!(!isEditMode);
                    Future.delayed(const Duration(milliseconds: 50), () {
                      if (!isEditMode) {
                        FocusScope.of(context).requestFocus(focusNode);
                      }
                    });
                  }
                : null,
            icon: Icon(
              isEditMode ? Icons.check : Icons.edit,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
