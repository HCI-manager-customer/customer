import 'package:flutter/material.dart';

class SortDateBox extends StatelessWidget {
  const SortDateBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all()),
      child: DropdownButton(
        dropdownColor: Colors.white,
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        hint: const Text(
          'Sort by Date:',
          style: TextStyle(color: Colors.black),
        ),
        onChanged: (v) {},
        items: const [
          DropdownMenuItem(
            value: 'up',
            child: Text('Ascending'),
          ),
          DropdownMenuItem(
            value: 'down',
            child: Text('Descending '),
          ),
        ],
      ),
    );
  }
}
