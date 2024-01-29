import 'package:add_lab_address_test/widgets/lab_search.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key, required this.accountInfo, required this.onAddLab});
  final Map<String, dynamic>? accountInfo;
  final void Function(List labData) onAddLab;

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  bool _isAddingLab = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.white, thickness: 5),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                  child: Text(widget.accountInfo!['default']['customer_code'])),
              TableCell(
                  child: Text(widget.accountInfo!['default']['address_name']))
            ])
          ],
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isAddingLab = !_isAddingLab;
            });
          },
          label: Text(
            _isAddingLab ? "Cancel" : "Add New Lab",
            style: const TextStyle(color: Colors.white),
          ),
          icon: Icon(_isAddingLab ? Icons.remove_circle : Icons.add_circle,
              color: Colors.white),
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(_isAddingLab
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: 20),
        _isAddingLab ?  LabSearch(onAddLab: widget.onAddLab) : Container(),
      ],
    );
  }
}
