import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key? key}) : super(key: key);

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  //  Widget chart = BPMChart(data);
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool isBPMEnabled = false;

  // double raw = 0;
  int bpm = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: const Icon(Icons.menu)),
        title: const Text('Heart Rate Monitor'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          isBPMEnabled
              ? SizedBox(
                  height: 200,
                  width: 200,
                  child: FittedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        child: HeartBPMDialog(
                          context: context,
                          onRawData: (v) {},
                          onBPM: (value) => setState(() {
                            setState(() {
                              if (bpmValues.length >= 50) bpmValues.removeAt(0);
                              bpm = value;
                              if (bpm > 150) {
                                bpm = 150;
                              } else if (bpm < 50) {
                                bpm = 50;
                              }
                              bpmValues.add(
                                SensorValue(value: bpm, time: DateTime.now()),
                              );
                            });
                          }),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Place your finget on the camera and Start monitor. Not the flash light, it hot !!!',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
          // isBPMEnabled && bpmValues.isNotEmpty
          //     ? Container(
          //         decoration: BoxDecoration(border: Border.all()),
          //         height: 120,
          //         width: Get.width * 0.9,
          //         child: Expanded(child: BPMChart(bpmValues)),
          //       )
          //     : const SizedBox(),
          !isBPMEnabled
              ? const Text(
                  'This will may at least 10 seconds for a solid result')
              : const SizedBox(),
          isBPMEnabled && bpmValues.isNotEmpty
              ? Text(
                  bpm.toString(),
                  style: GoogleFonts.kanit(fontSize: 40),
                )
              : const SizedBox(),
          isBPMEnabled && bpmValues.isNotEmpty
              ? Text(
                  bpm > 100
                      ? 'Your Heart Rate too high'
                      : bpm < 65
                          ? 'Your Heart Rate too low'
                          : 'Your Heart rate is normal',
                  style: GoogleFonts.kanit(fontSize: 20),
                )
              : const SizedBox(),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.favorite_rounded),
              label: Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () => setState(() {
                if (isBPMEnabled) {
                  isBPMEnabled = false;
                } else {
                  isBPMEnabled = true;
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
