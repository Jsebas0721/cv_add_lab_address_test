import 'package:flutter/material.dart';

class LabInfo extends StatelessWidget {
  const LabInfo({super.key, required this.labCode, required this.onAddLab});
  final List<dynamic> labCode;
  final void Function(List labData) onAddLab;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const <int, TableColumnWidth>{
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.keyboard_hide_outlined),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.remove_red_eye_outlined)
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.location_on_outlined)
                    ],
                  ),
                ),
              ),
            ]),
            TableRow(children: [
              TableCell(
                child: Text(
                  labCode[0]['customer_code'],
                ),
              ),
              TableCell(
                child: Text(
                  labCode[0]['address_name'],
                ),
              ),
              TableCell(
                  child: Text(labCode[0]['addr2'] +
                      " " +
                      labCode[0]['addr3'] +
                      " " +
                      labCode[0]['country_code']))
            ])
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.onPrimary),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          onPressed: () {
            onAddLab(labCode);
          },
          child: const Text(
            'Add Lab',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
