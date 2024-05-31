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
    required this.timeValue,
    required this.sunset,
    required this.duskSpanInMinutes,
    required this.validationText,
    required this.validationTextStyle,
    required this.is24HrFormat,
  }) : super(key: key);
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;
  final String validationText;
  final TextStyle validationTextStyle;
  final Time timeValue;
  final bool is24HrFormat;

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
  late bool isAm = true;
  final FocusNode hrFocusNode = FocusNode();
  final FocusNode mnFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeState = TimeModelBinding.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    hrFocusNode.dispose();
    mnFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeAndUpdateTime(isInit: true);
    hrFocusNode.addListener(() {
      timeState.onSelectedInputChange(
        SelectedInput.HOUR,
        isReloadStateNeeded: false,
      );
      if (hourController.text.length == 1) {
        double hour = double.parse('0${hourController.text}');
        timeState.onTimeChange(
          isAm ? hour : hour + 12,
        );
        initializeAndUpdateTime();
      } else if (hourController.text.length == 2) {
        if (!widget.is24HrFormat && double.parse(hourController.text) > 12) {
          initializeAndUpdateTime();
        }
      }
    });
    mnFocusNode.addListener(() {
      timeState.onSelectedInputChange(
        SelectedInput.MINUTE,
        isReloadStateNeeded: false,
      );
      if (minuteController.text.length == 1) {
        timeState.onTimeChange(
          double.parse('0${minuteController.text}'),
        );
        initializeAndUpdateTime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isAm = timeState.time.period == DayPeriod.am;
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

    final ltrMode =
        timeState.widget.ltrMode ? TextDirection.ltr : TextDirection.rtl;

    final hideButtons = timeState.widget.hideButtons;

    Orientation currentOrientation = MediaQuery.of(context).orientation;
    double value = timeState.time.hour.roundToDouble();
    if (timeState.selected == SelectedInput.MINUTE) {
      value = timeState.time.minute.roundToDouble();
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        textDirection: ltrMode,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          DisplayValue(
                            onTap: timeState.widget.disableHour!
                                ? null
                                : () {
                                    if (timeState.edited != EditedInput.HOUR) {
                                      timeState.onEditedInputChange(
                                        EditedInput.HOUR,
                                      );
                                      timeState.onSelectedInputChange(
                                        SelectedInput.HOUR,
                                        isReloadStateNeeded: false,
                                      );
                                    }
                                  },
                            onChanged: (val) {
                              if (val.isNotEmpty && val.length == 2) {
                                FocusScope.of(context).unfocus();
                                double hour = double.parse(hourController.text);
                                timeState.onTimeChange(
                                  isAm || hour > 12 ? hour : hour + 12,
                                );
                                timeState.onSelectedInputChange(
                                  SelectedInput.MINUTE,
                                );
                                checkIsAnyEmptyValues();
                              }
                            },
                            isSelected:
                                timeState.selected == SelectedInput.HOUR,
                            controller: hourController,
                            focusNode: hrFocusNode,
                            isEditMode: timeState.edited == EditedInput.HOUR,
                            maxValue: 23,
                          ),
                          separator(),
                          DisplayValue(
                            onTap: timeState.widget.disableMinute!
                                ? null
                                : () {
                                    if (timeState.edited !=
                                        EditedInput.MINUTE) {
                                      timeState.onEditedInputChange(
                                        EditedInput.MINUTE,
                                      );
                                      timeState.onSelectedInputChange(
                                        SelectedInput.MINUTE,
                                        isReloadStateNeeded: false,
                                      );
                                    }
                                  },
                            onChanged: (val) {
                              if (val.isNotEmpty && val.length == 2) {
                                FocusScope.of(context).unfocus();
                                timeState.onTimeChange(
                                  double.parse(minuteController.text),
                                );
                                checkIsAnyEmptyValues();
                              }
                            },
                            isSelected:
                                timeState.selected == SelectedInput.MINUTE,
                            controller: minuteController,
                            focusNode: mnFocusNode,
                            isEditMode: timeState.edited == EditedInput.MINUTE,
                            maxValue: 59,
                          ),
                        ],
                      ),
                      if (timeState.isErrorMode)
                        const SizedBox(
                          height: 20,
                        ),
                      if (timeState.isErrorMode)
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              widget.validationText,
                              style: widget.validationTextStyle,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      Slider(
                        onChangeEnd: (_) => onChangedSlider(),
                        value: value,
                        onChanged: (val) {
                          timeState.onTimeChange(val);
                          initializeAndUpdateTime();
                        },
                        min: min,
                        max: max,
                        divisions: divisions,
                        activeColor: color,
                        inactiveColor: color.withAlpha(55),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (!hideButtons)
                        ActionButtons(
                          onOkPressed: () {
                            timeState.setDidTapButton(true);
                            if (!checkIsAnyEmptyValues()) {
                              timeState.setDidTapButton(false);
                              timeState.onOk();
                            }
                          },
                        ),
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

  bool checkIsAnyEmptyValues() {
    bool isAnyEmptyValues = false;
    if (hourController.text.trim().isEmpty ||
        minuteController.text.trim().isEmpty) {
      isAnyEmptyValues = true;
      if (timeState.didTapOkButton) {
        timeState.setIsErrorMode(true);
      }
    } else {
      isAnyEmptyValues = false;
      if (timeState.didTapOkButton) {
        timeState.setIsErrorMode(false);
      }
    }
    return isAnyEmptyValues;
  }

  onChangedSlider() {
    if (!timeState.widget.disableAutoFocusToNextInput) {
      if (timeState.selected == SelectedInput.HOUR) {
        if (!(timeState.widget.disableMinute ?? false)) {
          timeState.onSelectedInputChange(SelectedInput.MINUTE);
          FocusScope.of(context).requestFocus(mnFocusNode);
          moveCursorToEnd(SelectedInput.MINUTE);
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
    checkIsAnyEmptyValues();
  }

  void initializeAndUpdateTime({bool isInit = false}) {
    if (isInit) {
      final hourValue = widget.is24HrFormat
          ? widget.timeValue.hour
          : widget.timeValue.hourOfPeriod;
      hourController.text = hourValue.toString().padLeft(2, '0');
      minuteController.text =
          widget.timeValue.minute.toString().padLeft(2, '0');
    } else {
      final hourValue = timeState.widget.is24HrFormat
          ? timeState.time.hour
          : timeState.time.hourOfPeriod;
      hourController.text = hourValue.toString().padLeft(2, '0');
      minuteController.text = timeState.time.minute.toString().padLeft(2, '0');
      checkIsAnyEmptyValues();
      setState(() {});
    }
  }

  void moveCursorToEnd(SelectedInput selectedInput) {
    Future.delayed(const Duration(milliseconds: 50)).whenComplete(() {
      if (selectedInput == SelectedInput.HOUR) {
        hourController.selection = TextSelection.collapsed(
          offset: hourController.text.length,
        );
      } else {
        minuteController.selection = TextSelection.collapsed(
          offset: minuteController.text.length,
        );
      }
    });
  }

  Widget separator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Text(
        ':',
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 64,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
      ),
    );
  }
}
