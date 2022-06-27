import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/general_provider.dart';

class RemoveDialog extends StatelessWidget {
  const RemoveDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        height: size.height * 0.3,
        width: size.width * 0.8,
        child: Material(
          child: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Remove all product from your Cart?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'You can swipe from right to remove individual product',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: Consumer(
                            builder: (context, ref, child) => ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red.shade400),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  ref.read(cartLProvider.notifier).wipe();
                                  int count = 0;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                                child: const Text("Yes")),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.black),
                              )),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
