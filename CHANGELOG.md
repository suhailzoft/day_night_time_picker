## [1.3.1] - 31st March 2024.

- Add an option to change `am` and `pm` label
- Time is now responsive and stay at center as height grows
- Add an option to adjust wheel magnification
- Make wheel bounce when overscrolling like native iOS scroll physics
- Add an option to customize text style for `hours`, `minutes` and `seconds` labels
- Add an option to change background color of [Dialog]

## [1.3.0+1] - 15th August 2023.

- added `settings` prop to pass [RouteSettings] to the [PageRouteBuilder]

## [1.3.0] - 17th June 2023.

- added prop to set the sunrise/sunset/dusk timing
- added `showCancelButton` to display the cancel button or not
- auto focus next selector bug fixed
- added linting

## [1.2.0+2] - 12th March 2023.

- Minor bug fix.

## [1.2.0+1] - 5th March 2023.

- Minor bug fix. **IMPORTANT** for people using the `iosStyle`.

## [1.2.0] - 23nd February 2023.

- _**Includes breaking changes**_
- Refactored code to only have one function i.e. `createPicker`.
  - `createInlinePicker` is now deprecated.
- Added support to `second` input as well
- Renamed prop `disableAutoFocusMinuteAfterHour` to `disableAutoFocusToNextInput` to work with `second` input as well

## [1.1.6] - 22nd February 2023.

- Added prop `width` and `height` for the picker
- Added prop `disableAutoFocusMinuteAfterHour` to disable autofocus to minute after hour is selected

## [1.1.5] - 14th January 2023.

- Fixed where toggling AM/PM was not triggering the onChange

## [1.1.4] - 26th October 2022.

- Added option to hide buttons
- Fixed issue where newly selected time does not update UI

## [1.1.3] - 24th August 2022.

- Added prop `wheelHeight` (only for `createInlinePicker`)
- Fixed typo in README

## [1.1.2] - 23th June 2022.

- Added prop `cancelButtonStyle`
- Added prop `buttonsSpacing`

## [1.1.1] - 14th June 2022.

- Added optional `onCancel` parameter as a callback for the Cancel button

## [1.1.0] - 27th May 2022.

- Added Support for Flutter 3.0
- Added ButtonStyle for `createInlinePicker` and `showPicker`
- Fixed an issue with the ios style picker

## [1.0.5] - 3rd January 2022.

- Fixed overflow issue on smaller devices
- added Bool `ltrMode = true` for ltrMode `false = rtl` on Displaying the TextDirection
- fixed issue where 24HrFormat is not used with iOS Styled Picker

## [1.0.4+1] - 29th December 2021.

- Fixed import
- Refactored

## [1.0.4] - 28th December 2021.

- Separate `TextStyle` for `ok` and `cancel` text.
- Remove adding `.toUpperCase()` to `ok` and `cancel` text.
- Bug fixes
- Refactoring

## [1.0.3+1] - 28th July 2021.

- Added `TextStyle` prop for ok/cancel button.

## [1.0.3] - 28th May 2021.

- Added Thirty in the `MinuteInterval` enum.

## [1.0.2] - 3rd May 2021.

- Workaround fix for `ImageFilter.blur`.

## [1.0.1+1] - 19th April 2021.

- Added prop to auto focus minute picker.

## [1.0.1] - 11th March 2021.

- Added prop to control Dialog padding.

## [1.0.0] - 11th March 2021.

- Null safety!
- Fixed text scale factor.
- Fixed return data on navigator pop()
- Changed FlatButton to TextButton.

## [0.5.0] - 13th February 2021.

- Added option to return value for inline widget on every onValueChange.
- Added option to hide sun/moon animation header.
- Added `themeData` property.
- Minor performance fixes.
- Other bug fixes.

## [0.4.0] - 21st November 2020.

- Added time picker range.
- Added minute interval.
- Enable/disable hour or minute.
- Added option to render as inline widget.
- Other bug fixes.

## [0.3.0+2] - 08th October 2020.

- Update img src in readme. Yeah twice, coz I am stupid.

## [0.3.0+2] - 08th October 2020.

- Update img src in readme. Yeah twice, coz I am stupid.

## [0.3.0+1] - 08th October 2020.

- Update img src in readme

## [0.3.0] - 08th October 2020.

- Added IOS style picker

## [0.2.1+1] - 08th October 2020.

- Displacement issue fix for Sun and Moon assets

## [0.2.1] - 11th August 2020.

- Added optional `unselectedColor` for options

## [0.2.0+1] - 31st July 2020.

- Updated Documentation

## [0.2.0] - 31st July 2020.

- Added optional callback to return data in DateTime.
- Added other bunch of parameters to customize the picker

## [0.1.3+3] - 17th April 2020.

- Barrier color.

## [0.1.3+2] - 16th April 2020.

- Typo.

## [0.1.3+1] - 16th April 2020.

- Minor patches.

## [0.1.3] - 16th April 2020.

- Added more blur customization.

## [0.1.2] - 16th April 2020.

- Minor optimizations.

## [0.1.1] - 3rd April 2020.

- Minor changes related to example project.

## [0.1.0] - 3rd April 2020.

- Initial release.
