import 'package:add_lab_address_test/widgets/account_search.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            'assets/images/clearvision-logo.png',
            color: Colors.white,
            width: 350,
            height: 100,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15),
        child: AccountSearh(),
      ),
    );
  }
}
