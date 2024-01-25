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
  final _labCodeNumController = TextEditingController();
  String? _labCodeNumber;
  String? _error;
  String? _accountNumber;
  bool _isAddingLab = false;
  Map<String, dynamic>? _accountInfo;
  List<dynamic>? _labCode;
  // @override
  // void initState() {
  //   super.initState();
  //   _accountNumController.addListener(getAccountNum);
  // }

  // void getAccountNum() {
  //   _accountNumber = _accountNumController.text;
  // }

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

  Future<void> validateLab(String labCode) async {
    if (_labCodeNumber!.trim().isEmpty) {
      setState(() {
        _error = "Please Enter a Lab Code.";
        _labCodeNumController.clear();
      });
      return;
    }
    final url = Uri.https("cycling-api.cvoapis.com", "/magento/lab/$labCode");

    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200 && response.body != '[]') {
        setState(() {
          _labCode = json.decode(response.body);
          _labCodeNumController.clear();
        });
      } else if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data";
        });
        print(_error);
      } else if (response.body == '[]') {
        setState(() {
          _labCode = null;
          _labCodeNumController.clear();
          _error = "Lab Code number doesn't exist.";
        });
        print(_error);
      }
    } catch (e) {
      print("Something went wrong. $e");
    }
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
                      _accountNumber = _accountNumController.text;
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isAddingLab = !_isAddingLab;
                              });
                            },
                            icon: Icon(
                                _isAddingLab
                                    ? Icons.remove_circle
                                    : Icons.add_circle,
                                color: Colors.white),
                            label: Text(
                              _isAddingLab ? "Cancel" : "Add New Lab",
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  _isAddingLab
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _isAddingLab
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      height: 40,
                                      child: TextField(
                                        onSubmitted: (value) {
                                          _labCodeNumber =
                                              _labCodeNumController.text;
                                          validateLab(_labCodeNumber!);
                                        },
                                        controller: _labCodeNumController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text("Lab Code...")),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _labCode != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Table(
                                            columnWidths: const <int,
                                                TableColumnWidth>{
                                              0: FixedColumnWidth(250),
                                              1: FixedColumnWidth(250),
                                              2: FixedColumnWidth(1000),
                                            },
                                            children: [
                                              const TableRow(children: [
                                                TableCell(
                                                  child: SizedBox(
                                                    height: 30,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Lab Code",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Icon(Icons
                                                            .keyboard_hide_outlined),
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
                                                          "Lab Name",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Icon(Icons
                                                            .remove_red_eye_outlined)
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
                                                          "Address",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Icon(Icons
                                                            .location_on_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Text(
                                                    _labCode![0]
                                                        ['customer_code'],
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    _labCode![0]
                                                        ['address_name'],
                                                  ),
                                                ),
                                                TableCell(
                                                    child: Text(_labCode![0]
                                                            ['addr2'] +
                                                        " " +
                                                        _labCode![0]['addr3'] +
                                                        " " +
                                                        _labCode![0]
                                                            ['country_code']))
                                              ])
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary),
                                              shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              //fetch and push
                                            },
                                            child: const Text(
                                              'Add Lab',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.red),
                                        child:
                                            Text(_error != null ? _error! : ""),
                                      ),
                              ],
                            )
                          : Container(),
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
