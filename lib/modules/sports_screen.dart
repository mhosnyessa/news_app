import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Sports Page',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
