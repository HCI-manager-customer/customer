import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/constant.dart';
import '../../models/drugs.dart';
import '../../models/global.dart';
import '../home/home_drawer.dart';
import 'product_tile.dart';
import '../cart/cart_screen.dart';
import '../misc/nearby.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen(this._drug);
  final Drug _drug;

  //random Color
  Color _randomColor() {
    return Color(0xFF000000 + (Random().nextInt(0xFFFFFF) + 1));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    bool isPhone = size.shortestSide < 650 ? true : false;
    var list = [...drugController.drugs];
    list.removeWhere((e) => e.id == _drug.id);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.popAndPushNamed(context, HomeDrawer.routeName);
        }),
        title: Text(
          _drug.title,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.3,
            width: double.infinity,
            child: Image.network(
              _drug.imgUrl,
              fit: BoxFit.fill,
              cacheHeight: 500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              _drug.fullName,
              maxLines: 2,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${_drug.price.toStringAsFixed(3)} VND/${_drug.unit}",
                maxLines: 2,
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                addorInc(_drug, ref);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text(
                "Buy",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                showAddedMsg(
                  context,
                  _drug,
                  ref,
                );
              },
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  primary: Colors.white),
              child: const Text(
                "Add to cart",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: Get.width * 0.85,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Shipping Method: Pickup, Delivery \nFree Shipping for Order above 300,000 VND',
                style: GoogleFonts.kanit(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: Get.width * 0.85,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Delivery Service Provider:',
                    style: GoogleFonts.kanit(fontSize: 18),
                  ),
                  Wrap(
                    spacing: 15,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFE66020),
                            shape: const StadiumBorder()),
                        child: const Text("Giao Hang Nhanh"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFE2492B),
                            shape: const StadiumBorder()),
                        child: const Text("Shoppe"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF152348),
                            shape: const StadiumBorder()),
                        child: const Text("Ahamove"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF03AA4D),
                            shape: const StadiumBorder()),
                        child: const Text("Grab"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFEFAE11),
                            shape: const StadiumBorder()),
                        child: const Text("Be"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, letterSpacing: 1.0),
                children: [
                  const TextSpan(
                    text: "Ingredients: ",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: _drug.ingredients,
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, letterSpacing: 1.0),
                children: [
                  const TextSpan(
                    text: "Uses: ",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: _drug.uses,
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black, letterSpacing: 1.0),
                children: [
                  TextSpan(
                    text: "Contraindications: ",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '\n- Hypersensitivity to aspirin or other salicylates.',
                    style: TextStyle(fontSize: 17),
                  ),
                  TextSpan(
                    text:
                        '\n- Hypersensitivity to any of the ingredients of the drug.',
                    style: TextStyle(fontSize: 17),
                  ),
                  TextSpan(
                    text: '\n- Children under 16 years old.',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(NearbyStoreScreen.routeName),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 18,
                width: double.infinity,
                child: Text(
                  'Nearby Stores',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
              onTap: () {
                final d = drugController.drugs.firstWhere((element) =>
                    element.fullName == 'Peptide Collagen Essence Mask (23g)');
                Get.to(() => InfoScreen(d));
              },
              child: Image.asset('assets/imgs/imaBanner.webp')),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Other Drugs",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPhone ? 2 : (size.width / 200).ceil(),
                crossAxisSpacing: 10,
                mainAxisExtent: 250,
              ),
              itemCount: list.length > 4 ? 4 : list.length,
              itemBuilder: (context, i) => DrugTile(list[i]),
            ),
          ),
        ],
      )),
    );
  }
}
