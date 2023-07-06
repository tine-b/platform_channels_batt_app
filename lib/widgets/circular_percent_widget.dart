import 'package:battery_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularPercentWidget extends StatelessWidget {
  const CircularPercentWidget({
    super.key,
    required this.batteryLevel,
  });

  final int batteryLevel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Container(
      margin: const EdgeInsets.only(top: 45),
      height: MediaQuery.of(context).size.width / 1.4,
      width: MediaQuery.of(context).size.width / 1.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayShadow,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: CircularPercentIndicator(
        radius: MediaQuery.of(context).size.width / 3,
        backgroundColor: AppColors.lightGray,
        lineWidth: 25.0,
        animation: true,
        linearGradient: AppColors.blueGreenGradient,
        percent: batteryLevel / 100,
        center: batteryLevel != 0
            ? Text(
                '$batteryLevel%',
                style: textTheme.displayMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              )
            : const Icon(
                size: 60,
                Icons.battery_unknown_rounded,
                color: AppColors.blueGreen,
              ),
        circularStrokeCap: CircularStrokeCap.round,
        animateFromLastPercent: true,
      ),
    );
  }
}
