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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('batteryMethodChannel');
  // Get battery level.
  String _message = '';
  String _batteryState = '';
  int _batteryLevel = 0;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    _hasData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: AppColors.lightBeige,
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColors.blueGreen,
          centerTitle: true,
        ),
        body: Column(
          children: [
            CircularPercentWidget(batteryLevel: _batteryLevel),
            BatteryWidget(
              hasData: _hasData,
              batteryLevel: _batteryLevel,
              batteryState: _batteryState,
              message: _message,
            ),
            BatteryButtons(
              batteryState: _batteryState,
              getBatteryLevel: _getBatteryLevel,
              clearDetails: _clearDetails,
            ),
          ],
        ),
      ),
    );
  }

  FutureOr<void> _getBatteryLevel() async {
    try {
      final Map<dynamic, dynamic>? result = await platform.invokeMethod('getBatteryDetails');
      _batteryLevel = result?['level'] ?? 0;
      _batteryState = result?['status'].toString() ?? '';
      _message = '';
      setState(() => _hasData = true);
    } on PlatformException catch (e) {
      _message = '${e.message}';
      setState(() => _hasData = false);
    }
  }

  void _clearDetails() async {
    setState(() {
      _batteryLevel = 0;
      _message = '';
      _batteryState = '';
      _hasData = false;
    });
  }
}
