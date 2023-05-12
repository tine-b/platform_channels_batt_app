import 'package:battery_app/utils/colors.dart';
import 'package:flutter/material.dart';

class BatteryButtons extends StatelessWidget {
  const BatteryButtons({
    super.key,
    required this.batteryState,
    required this.getBatteryLevel,
    required this.clearDetails,
  });

  final String batteryState;
  final Function() getBatteryLevel;
  final Function() clearDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.darkBeige,
            foregroundColor: Colors.white,
          ),
          onPressed: getBatteryLevel,
          child: const Text(
            'Get Battery Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton.filled(
          onPressed: batteryState.isNotEmpty ? clearDetails : null,
          icon: const Icon(Icons.refresh_outlined),
          style: IconButton.styleFrom(backgroundColor: AppColors.darkBeige),
        ),
      ],
    );
  }
}
