import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/screens/presciption_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CameraDrug extends ConsumerStatefulWidget {
  const CameraDrug();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraDrugState();
}

class _CameraDrugState extends ConsumerState<CameraDrug> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      ref.read(ImgPath.notifier).state = image;
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException {}
  }

  Future takePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      final imageTemp = File(image!.path);
      ref.read(ImgPath.notifier).state = image;
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height * 0.45;
    double width = size.width * 0.7;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: image != null
                  ? SizedBox(
                      width: width,
                      height: height,
                      child: Image.file(image!),
                    )
                  : Container(
                      color: Colors.grey,
                      width: width,
                      height: height,
                      child: const Icon(Icons.image),
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50,
                  width: 180,
                  child: ElevatedButton.icon(
                    onPressed: () => pickImage(),
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Pick Image'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (!kIsWeb)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 50,
                    width: 180,
                    child: ElevatedButton.icon(
                      onPressed: () => takePicture(),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Picture'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
