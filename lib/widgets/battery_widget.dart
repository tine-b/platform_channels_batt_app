import 'package:battery_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BatteryWidget extends StatelessWidget {
  const BatteryWidget({
    super.key,
    this.hasData = false,
    required this.batteryLevel,
    required this.batteryState,
    required this.message,
  });

  final bool hasData;
  final int batteryLevel;
  final String batteryState;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grayShadow,
            spreadRadius: 2,
            blurRadius: 3,
          )
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.linear,
        child: hasData
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(batteryState.isNotEmpty ? batteryState : message,
                      style: textTheme.titleLarge!.copyWith(
                        letterSpacing: -1.2,
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 8),
                      child: const Divider(
                        thickness: 1.35,
                        color: AppColors.darkBeige,
                      )),
                  Text(
                    'as of ${getDate()}',
                  ),
                ],
              )
            : Text(
                'No data here yet!',
                style: textTheme.headlineSmall!.copyWith(
                  letterSpacing: -1.2,
                  fontStyle: FontStyle.italic,
                ),
              ),
      ),
    );
  }

  String getDate() {
    final df = DateFormat('MMM dd, yyyy hh:mm a');
    return df.format(DateTime.now());
  }
}
