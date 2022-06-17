import 'package:flutter/material.dart';
import 'package:hci_customer/addons/responsive.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.green),
          elevation: 0,
          title: const Text(
            'Advanced Search',
            style: TextStyle(color: Colors.green),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: SearchBox(),
              ),
              SizedBox(
                width: Responsive.isDesktop(context)
                    ? size.width * 0.3
                    : double.infinity,
                child: Center(
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 20,
                    children: const [
                      btnSpawn("Fever"),
                      btnSpawn("Cold"),
                      btnSpawn("Medical Equipments"),
                      btnSpawn("Masks"),
                      btnSpawn("Shampoo"),
                      btnSpawn("Skin Care"),
                      btnSpawn("Healthy Food"),
                      btnSpawn("Vitamin"),
                      btnSpawn("Vision Care"),
                      btnSpawn("Weight Loss"),
                      btnSpawn("Others"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class btnSpawn extends StatelessWidget {
  const btnSpawn(this.txt);

  final String txt;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(),
          ),
        ),
      ),
      child: Text(txt),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: 500,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), border: Border.all()),
      child: const TextField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: 'Search', hintStyle: TextStyle(color: Colors.black)),
      ),
    );
  }
}
