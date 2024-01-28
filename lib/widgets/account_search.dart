import 'dart:convert';
import 'package:add_lab_address_test/widgets/account_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AccountSearh extends StatefulWidget {
  const AccountSearh({super.key});

  @override
  State<AccountSearh> createState() => _AccountSearhState();
}

class _AccountSearhState extends State<AccountSearh> {
  final _accountNumController = TextEditingController();
  String? _accountNumber;
  Map<String, dynamic>? _accountInfo;
  String? _error;

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

    void _addLabAddress(List labData) async {
    final accountNumber = _accountInfo!['default']["customer_code"];
    final labCode = labData[0]["customer_code"];
    final url = Uri.https("cycling-api.cvoapis.com", "/magento/add_lab");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {"account_no": accountNumber, "lab_code": labCode},
        ),
      );
      print(response.body);

      // if(response.statusCode == 200){

      // }
      print(response.statusCode);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter Account Number:"),
        const SizedBox(height: 10),
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
        const SizedBox(height: 20),
        _accountInfo != null
            ? AccountInfo(accountInfo: _accountInfo, onAddLab: _addLabAddress,)
            : Container(
                decoration: const BoxDecoration(color: Colors.red),
                child: Text(_error != null ? _error! : ""),
              ),
      ],
    );
  }
}
