import 'dart:async';
import 'package:battery_app/widgets/battery_widget.dart';
import 'package:battery_app/utils/colors.dart';
import 'package:battery_app/widgets/battery_buttons.dart';
import 'package:battery_app/widgets/circular_percent_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Platform Channels',
      theme: ThemeData(
        textTheme: GoogleFonts.workSansTextTheme(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Platform Channels'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //* The setup for the Method Channel
  //* Should be the same in AppDelegate.swift & MainActivity.kt
  static const platform = MethodChannel('batteryMethodChannel');

  String _batteryState = ''; //* Stores battery infromation
  int _batteryLevel = 0; //* Stores battery percentage
  bool _hasData = false; //* Used for empty state screen
  String _message = ''; //* Used for error message handling

  @override
  void initState() {
    super.initState();
    _hasData = false; //* Initial state is an empty state
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: AppColors.lightBeige,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.blueGreen,
          centerTitle: true,
        ),
        body: Column(
          children: [
            //* Circular Percent Widget - contains battery percentage
            CircularPercentWidget(batteryLevel: _batteryLevel),
            //* BatteryWidget - contains battery details
            BatteryWidget(
              hasData: _hasData,
              batteryLevel: _batteryLevel,
              batteryState: _batteryState,
              message: _message,
            ),
            //* Battery Buttons - contains button for fetching and resetting data
            BatteryButtons(
              batteryState: _batteryState,
              getBatteryLevel: _getBatteryDetails,
              clearDetails: _clearDetails,
            ),
          ],
        ),
      ),
    );
  }

  //* Fetching of battery details using Platform Channels
  FutureOr<void> _getBatteryDetails() async {
    try {
      //* Map in Dart
      //* Dictionary is the expected result from Swift
      //* HashMap is the expected result from Kotlin
      //* Method name should be the same in AppDelegate.swift & MainActivity.kt
      final Map<dynamic, dynamic>? result =
          await platform.invokeMethod('getBatteryDetails');
      _batteryLevel = result?['level'] ?? 0;
      _batteryState = result?['status'].toString() ?? '';
      _message = '';
      setState(() => _hasData = true);
    } on PlatformException catch (e) {
      //* Assign error message in message to battery details portion of app
      _message = '${e.message}';
      setState(() => _hasData = false);
    }
  }

  //* Clearing of all data for empty state
  void _clearDetails() async {
    setState(() {
      _batteryLevel = 0;
      _message = '';
      _batteryState = '';
      _hasData = false;
    });
  }
}
