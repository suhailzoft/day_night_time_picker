import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/ampm.dart';
import 'package:day_night_time_picker/lib/common/action_buttons.dart';
import 'package:day_night_time_picker/lib/common/display_value.dart';
import 'package:day_night_time_picker/lib/common/filter_wrapper.dart';
import 'package:day_night_time_picker/lib/common/wrapper_container.dart';
import 'package:day_night_time_picker/lib/common/wrapper_dialog.dart';
import 'package:day_night_time_picker/lib/daynight_banner.dart';
import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/material.dart';

/// Private class. [StatefulWidget] that renders the content of the picker.
// ignore: must_be_immutable
class DayNightTimePickerAndroid extends StatefulWidget {
  const DayNightTimePickerAndroid({
    Key? key,
    required this.sunrise,
    required this.sunset,
    required this.duskSpanInMinutes,
  }) : super(key: key);
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;

  @override
  DayNightTimePickerAndroidState createState() =>
      DayNightTimePickerAndroidState();
}

/// Picker state class
class DayNightTimePickerAndroidState extends State<DayNightTimePickerAndroid> {
  late TimeModelBindingState timeState;
  late TextEditingController hourController = TextEditingController();
  late TextEditingController minuteController =
      TextEditingController.fromValue(const TextEditingValue(text: '00'));
  bool isEditMode = false;
  final FocusNode hrFocusNode = FocusNode();
  final FocusNode mnFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeState = TimeModelBinding.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double min =
        getMin(timeState.widget.minMinute, timeState.widget.minuteInterval);
    double max =
        getMax(timeState.widget.maxMinute, timeState.widget.minuteInterval);

    int minDiff = (max - min).round();
    int divisions = getDivisions(minDiff, timeState.widget.minuteInterval);

    if (timeState.selected == SelectedInput.HOUR) {
      min = timeState.widget.minHour!;
      max = timeState.widget.maxHour!;
      divisions = (max - min).round();
    }

    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;

    final hourValue = timeState.widget.is24HrFormat
        ? timeState.time.hour
        : timeState.time.hourOfPeriod;

    final ltrMode =
        timeState.widget.ltrMode ? TextDirection.ltr : TextDirection.rtl;

    final hideButtons = timeState.widget.hideButtons;

    Orientation currentOrientation = MediaQuery.of(context).orientation;
    double value = timeState.time.hour.roundToDouble();
    hourController.text = hourValue.toString().padLeft(2, '0');
    if (timeState.selected == SelectedInput.MINUTE) {
      value = timeState.time.minute.roundToDouble();
      minuteController.text = timeState.time.minute.toString().padLeft(2, '0');
    } else if (timeState.selected == SelectedInput.SECOND) {
      value = timeState.time.second.roundToDouble();
    }

    return Center(
      child: SingleChildScrollView(
        physics: currentOrientation == Orientation.portrait
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: FilterWrapper(
          child: WrapperDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DayNightBanner(
                  sunrise: widget.sunrise,
                  sunset: widget.sunset,
                  duskSpanInMinutes: widget.duskSpanInMinutes,
                ),
                WrapperContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const AmPm(),
                      const SizedBox(height: 8),
                      const Spacer(),
                      Row(
                        textDirection: ltrMode,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DisplayValue(
                            onTap: timeState.widget.disableHour!
                                ? null
                                : () {
                                    if (timeState.selected ==
                                        SelectedInput.MINUTE) {
                                      setState(() {
                                        isEditMode = false;
                                      });
                                    }
                                    timeState.onSelectedInputChange(
                                      SelectedInput.HOUR,
                                    );
                                  },
                            value: hourValue.toString().padLeft(2, '0'),
                            isSelected:
                                timeState.selected == SelectedInput.HOUR,
                            controller: hourController,
                            width: 80,
                            editable: true,
                            isEditMode: isEditMode,
                            onTapEditMode: (val) {
                              if (hourController.text.isNotEmpty) {
                                if (!val) {
                                  timeState.onTimeChange(
                                      double.parse(hourController.text));
                                }
                                setState(() {
                                  isEditMode = val;
                                });
                              }
                            },
                            maxValue: 23,
                            focusNode: hrFocusNode,
                          ),
                          const DisplayValue(
                            value: ':',
                            width: 30,
                          ),
                          DisplayValue(
                            onTap: timeState.widget.disableMinute!
                                ? null
                                : () {
                                    if (timeState.selected ==
                                        SelectedInput.HOUR) {
                                      setState(() {
                                        isEditMode = false;
                                      });
                                    }
                                    timeState.onSelectedInputChange(
                                      SelectedInput.MINUTE,
                                    );
                                  },
                            value: timeState.time.minute
                                .toString()
                                .padLeft(2, '0'),
                            isSelected:
                                timeState.selected == SelectedInput.MINUTE,
                            width: 80,
                            editable: true,
                            isEditMode: isEditMode,
                            controller: minuteController,
                            onTapEditMode: (val) {
                              if (minuteController.text.isNotEmpty) {
                                if (!val) {
                                  timeState.onTimeChange(
                                    double.parse(minuteController.text),
                                  );
                                }
                                setState(() {
                                  isEditMode = val;
                                });
                              }
                            },
                            maxValue: 59,
                            focusNode: mnFocusNode,
                          ),
                          ...timeState.widget.showSecondSelector
                              ? [
                                  const DisplayValue(
                                    value: ':',
                                    width: 30,
                                  ),
                                  DisplayValue(
                                    onTap: () {
                                      timeState.onSelectedInputChange(
                                        SelectedInput.SECOND,
                                      );
                                    },
                                    value: timeState.time.second
                                        .toString()
                                        .padLeft(2, '0'),
                                    isSelected: timeState.selected ==
                                        SelectedInput.SECOND,
                                    width: 80,
                                    editable: true,
                                  ),
                                ]
                              : [],
                        ],
                      ),
                      Slider(
                        onChangeEnd: (_) => onChangedSlider(),
                        value: value,
                        onChanged: timeState.onTimeChange,
                        min: min,
                        max: max,
                        divisions: divisions,
                        activeColor: color,
                        inactiveColor: color.withAlpha(55),
                      ),
                      const Spacer(),
                      if (!hideButtons) const ActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onChangedSlider() {
    if (!timeState.widget.disableAutoFocusToNextInput) {
      if (timeState.selected == SelectedInput.HOUR) {
        if (!(timeState.widget.disableMinute ?? false)) {
          timeState.onSelectedInputChange(SelectedInput.MINUTE);
        } else if (timeState.widget.showSecondSelector) {
          timeState.onSelectedInputChange(SelectedInput.SECOND);
        }
      } else if (timeState.selected == SelectedInput.MINUTE &&
          timeState.widget.showSecondSelector) {
        timeState.onSelectedInputChange(SelectedInput.SECOND);
      }
    }
    if (timeState.widget.isOnValueChangeMode) {
      timeState.onOk();
    }
  }
}
