import 'dart:convert';

import 'package:add_lab_address_test/widgets/lab_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LabSearch extends StatefulWidget {
  const LabSearch({super.key, required this.onAddLab});
  final void Function(List labData) onAddLab;

  @override
  State<LabSearch> createState() => _LabSearchState();
}

class _LabSearchState extends State<LabSearch> {
  final _labCodeNumController = TextEditingController();
  String? _labCodeNumber;
  List<dynamic>? _labCode;
  String? _error;

  Future<void> validateLab(String labCode) async {
    if (_labCodeNumber!.trim().isEmpty) {
      setState(() {
        _error = "Please Enter a Lab Code.";
        _labCodeNumController.clear();
      });
    
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          height: 40,
          child: TextField(
            onSubmitted: (value) {
              _labCodeNumber = _labCodeNumController.text;
              validateLab(_labCodeNumber!);
            },
            controller: _labCodeNumController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text("Lab Code...")),
          ),
        ),
        const SizedBox(height: 20),
        _labCode != null
            ? LabInfo(labCode: _labCode!, onAddLab: widget.onAddLab)
            : Container(
                decoration: const BoxDecoration(color: Colors.red),
                child: Text(_error != null ? _error! : ""),
              ),
      ],
    );
  }
}
