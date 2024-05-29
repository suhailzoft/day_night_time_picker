import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Time _time = Time(hour: 9, minute: 00, second: 00);
  bool iosStyle = false;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Popup Picker Style",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "${_time.hour}:${_time.minute}:${_time.second} ${_time.period.name}"
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      showPicker(
                        showSecondSelector: false,
                        context: context,
                        value: _time,
                        width: 400,
                        onChange: onTimeChanged,
                        minuteInterval: TimePickerInterval.FIVE,
                        onChangeDateTime: (DateTime dateTime) {
                          debugPrint("[debug datetime]:  $dateTime");
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "Open time picker",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  "Inline Picker Style",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  width: 500,
                  // Render inline widget
                  child: showPicker(
                    isInlinePicker: true,
                    elevation: 1,
                    value: _time,
                    onChange: onTimeChanged,
                    minuteInterval: TimePickerInterval.FIVE,
                    accentColor: const Color(0xff004985),
                    unselectedColor: const Color(0xFF5E6C6F),
                    iosStylePicker: iosStyle,
                    minHour: 00,
                    maxHour: 23,
                    is24HrFormat: false,
                  ),
                ),
                Text(
                  "IOS Style",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Switch(
                  value: iosStyle,
                  onChanged: (newVal) {
                    setState(() {
                      iosStyle = newVal;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
