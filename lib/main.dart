import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Platform Channels',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 190, 110, 118),
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  static const platform = MethodChannel('tine.dev/battery');
  // Get battery level.
  String _message = '';
  String _batteryState = '';
  double _batteryLevel = 0;
  Widget? _widget;

  Future<void> _getBatteryLevel() async {
    double? batteryLevel;
    String? batteryState;
    String message;

    setState(() {
      _batteryLevel = 0;
    });
    try {
      final Map<dynamic, dynamic>? result = await platform.invokeMethod('getBatteryDetails');
      batteryLevel = result?['level'].toDouble();
      batteryState = result?['status'].toString() ?? '';
      message = '';
    } on PlatformException catch (e) {
      message = '${e.message}';
    }

    setState(() {
      _batteryLevel = batteryLevel ?? 0;
      _message = message;
      _batteryState = batteryState ?? '';
      _widget = withData();
    });
  }

  void _clearDetails() async {
    setState(() {
      _batteryLevel = 0;
      _message = '';
      _batteryState = '';
      _widget = noData();
    });
  }

  String getDate() {
    final df = DateFormat('MMM dd, yyyy hh:mm a');
    return df.format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _widget = noData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Platform Channels'),
          backgroundColor: const Color.fromARGB(255, 222, 140, 149),
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: CircularPercentIndicator(
                radius: MediaQuery.of(context).size.width / 2.75,
                lineWidth: 15.0,
                animation: true,
                animationDuration: 750,
                linearGradient: const LinearGradient(colors: <Color>[
                  Color.fromARGB(255, 225, 184, 188),
                  Color.fromARGB(255, 222, 140, 149),
                  Color.fromARGB(255, 190, 110, 118),
                ]),
                percent: _batteryLevel / 100,
                center: Text(
                  _batteryLevel != 0.0 ? "${_batteryLevel.toInt()}%" : "",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                // progressColor: const Color(0xFFD8A6AB),
              ),
            ),
            SizedBox(
              height: 125,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.linear,
                child: _widget,
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),
                      textStyle: MaterialStateProperty.resolveWith((_) => GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600)),
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        // If the button is pressed, return green, otherwise blue
                        if (states.contains(MaterialState.pressed)) {
                          return const Color(0xFFE9CDD0);
                        }
                        return const Color.fromARGB(255, 190, 110, 118);
                      }),
                      foregroundColor: MaterialStateProperty.resolveWith((_) => Colors.white),
                    ),
                    onPressed: _getBatteryLevel,
                    child: const Text('Get Battery Details'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((_) => const EdgeInsets.symmetric(horizontal: 20.0)),
                      textStyle: MaterialStateProperty.resolveWith((_) => GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600)),
                      shape: MaterialStateProperty.resolveWith((states) {
                        // If the button is pressed, return green, otherwise blue
                        if (states.contains(MaterialState.disabled)) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(
                              color: Colors.grey,
                            ),
                          );
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Color.fromARGB(255, 190, 110, 118)),
                        );
                      }),
                      overlayColor: MaterialStateProperty.resolveWith((states) {
                        // If the button is pressed, return green, otherwise blue
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(255, 243, 227, 229);
                        } else if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return const Color.fromARGB(255, 190, 110, 118);
                      }),
                      foregroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return const Color.fromARGB(255, 190, 110, 118);
                      }),
                    ),
                    onPressed: _batteryState != '' ? _clearDetails : null,
                    child: const Text('Clear Details'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget noData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/kawaii-dinosaur.png',
          height: 50,
          filterQuality: FilterQuality.high,
          color: const Color.fromARGB(255, 190, 110, 118),
          colorBlendMode: BlendMode.srcIn,
        ),
        const SizedBox(width: 20),
        Text('No battery info currently',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            )),
      ],
    );
  }

  Widget withData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_batteryState.isNotEmpty ? _batteryState : _message,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              letterSpacing: -1.2,
            )),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 8),
            child: const Divider(
              thickness: 1.35,
              color: Color.fromARGB(255, 225, 184, 188),
            )),
        Text(
          'as of ${getDate()}',
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.75,
          ),
        ),
      ],
    );
  }
}
