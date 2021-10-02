import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Page',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
