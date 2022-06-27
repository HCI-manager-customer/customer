import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/state_manager.dart';
import 'package:hci_customer/addons/responsive.dart';
import 'package:hci_customer/controllers/drug_controller.dart';
import '../../models/category.dart';
import '../../models/drugs.dart';
import '../drug/btnDrug.dart';
import 'home_appbar.dart';
import 'smallGrid.dart';
import '../drug/load_more/load_more.dart';
import '../misc/search_dialog.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen();

  static const routeName = 'home';

  bool isTop = false;

  int a = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    bool isPhone = size.shortestSide < 650 ? true : false;
    return GetX<DrugController>(
      init: DrugController(),
      builder: (drugController) {
        if (drugController.drugs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          final drugs = drugController.drugs;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => showSearchDialog(size, context, drugs),
              backgroundColor: Colors.green,
              child: const Icon(Icons.search),
            ),
            appBar: const HomeAppBar(),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _WidgetBtnGroup(isPhone, context),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: _HomeBody(context, isPhone, size, drugs),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void showSearchDialog(Size size, BuildContext context, var list) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return const SearchDialog();
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Widget _HomeBody(
      BuildContext context, bool isPhone, Size size, List<Drug> list) {
    final listA1 = list.where((e) => e.type == 'A1').toList();
    final listA2 = list.where((e) => e.type == 'A2').toList();
    list.shuffle();
    return Column(
      children: [
        _toLoadMoreScreen(context, listA1, 'Near Me'),
        const SizedBox(height: 10),
        buildSmallGrid(isPhone, list),
        _toLoadMoreScreen(context, listA1, 'Unprescribed Drugs'),
        const SizedBox(height: 10),
        buildSmallGrid(isPhone, listA1),
        _toLoadMoreScreen(context, listA2, "Medical Devices/Equipments"),
        const SizedBox(height: 10),
        buildSmallGrid(isPhone, listA2),
      ],
    );
  }

  GestureDetector _toLoadMoreScreen(
      BuildContext context, List<Drug> list, String title) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadMoreScreen(title: title, list: list),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }

  Widget _WidgetBtnGroup(bool isPhone, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
            childAspectRatio: Responsive.isDesktop(context)
                ? 6
                : Responsive.isMobile(context)
                    ? 3
                    : 5,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [...iconList.map((e) => ButtonDrug(e)).toList()],
      ),
    );
  }
}
