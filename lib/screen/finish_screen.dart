import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key});
  static const router = '/finish-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finish Screen'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
