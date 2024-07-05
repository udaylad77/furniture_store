import 'package:flutter/material.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Person'),
        ),
        body: Center(
          child: Text(
            'Person',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}
