import 'package:flutter/material.dart';
import 'package:frank_futer/widgets/cards.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frank Futer'),
      ),
      body: Column(
        children: const <Widget>[
          Expanded(flex: 1, child: Cards()),
        ],
      ),
    );
  }
}
