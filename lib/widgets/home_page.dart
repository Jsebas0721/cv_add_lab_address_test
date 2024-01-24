import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _accountNumController = TextEditingController();
  String? _error;
  String? _accountNumber;
  Map<String, dynamic>? _accountInfo;

  @override
  void initState() {
    super.initState();
    _accountNumController.addListener(getAccountNum);
  }

  void getAccountNum() {
    _accountNumber = _accountNumController.text;
  }

  Future<void> getAccountData(String accountNum) async {
    if (_accountNumber!.trim().isEmpty) {
      setState(() {
        _error = "Please Enter an Account Number.";
        _accountNumController.clear();
      });
      return;
    }
    final url =
        Uri.https("cycling-api.cvoapis.com", "/magento/account/$accountNum");

    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200 && response.body != '[]') {
        setState(() {
          _accountInfo = json.decode(response.body);
          _accountNumController.clear();
        });
      } else if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data";
        });
        print(_error);
      } else if (response.body == '[]') {
        setState(() {
          _accountInfo = null;
          _accountNumController.clear();
          _error = "Account number doesn't exist.";
        });
        print(_error);
      }
    } catch (e) {
      print("Something went wrong. $e");
    }
  }

  @override
  void dispose() {
    _accountNumController.dispose();
    super.dispose();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Account Number:"),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    onSubmitted: (value) {
                      getAccountData(_accountNumber!);
                    },
                    controller: _accountNumController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search",
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            _accountInfo != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(250),
                          1: FixedColumnWidth(250),
                        },
                        children: [
                          const TableRow(
                            children: [
                              TableCell(
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Customer Account",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.account_box),
                                    ],
                                  ),
                                ),
                              ),
                              TableCell(
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Address Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.location_pin)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(children: [
                            TableCell(
                                child: Text(
                                    _accountInfo!['default']['customer_code'])),
                            TableCell(
                                child: Text(
                                    _accountInfo!['default']['address_name']))
                          ])
                        ],
                      ),
                    ],
                  )
                : Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    child: Text(_error != null ? _error! : ""),
                  )
          ],
        ),
      ),
    );
  }
}
