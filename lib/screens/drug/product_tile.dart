import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/screens/drug/info.dart';

import '../../models/drugs.dart';
import '../../models/global.dart';

class DrugTile extends StatelessWidget {
  const DrugTile(this._drug);

  final Drug _drug;

  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double containerWidth = 300;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => InfoScreen(_drug)));
          },
          child: Container(
            width: containerWidth,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: _drug.id,
                        child: Image.network(
                          _drug.imgUrl,
                          height: 100,
                          cacheHeight: 500,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.green,
                              ),
                            ),
                            TextSpan(
                              text: " ${_drug.rating.toStringAsFixed(1)}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(
                    _drug.fullName,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                  ),
                ),
                Text(
                  "${_drug.price.toStringAsFixed(3)} VND /${_drug.unit}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: size.height * 0.05,
          width: containerWidth,
          child: Consumer(
            builder: (context, ref, child) => ElevatedButton(
              onPressed: () {
                showAddedMsg(context, _drug, ref);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
              ),
              child: const Text(
                "Add to cart",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
