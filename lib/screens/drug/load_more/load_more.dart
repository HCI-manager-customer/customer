import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hci_customer/settings.dart';

import '../../../models/drugs.dart';
import '../product_tile.dart';
import '../../misc/search_dialog.dart';

class LoadMoreScreen extends StatefulWidget {
  const LoadMoreScreen({
    required this.title,
    required this.list,
  });
  final String title;
  final List<Drug> list;

  @override
  State<LoadMoreScreen> createState() => _LoadMoreScreenState();
}

class _LoadMoreScreenState extends State<LoadMoreScreen> {
  final filterController = TextEditingController();
  var focusNode = FocusNode();

  List<Drug> filterlist = [];
  bool isVisible = false;
  @override
  void initState() {
    filterlist = widget.list;
    super.initState();
  }

  String whichBanner() {
    switch (widget.list.first.type) {
      case ('A2'):
        return banner2;
      default:
        return banner1;
    }
  }

  Widget gridBuilder(Size size) {
    int count = (size.width / 300).ceil();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AnimationLimiter(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisExtent: 256,
            mainAxisSpacing: 5,
            crossAxisSpacing: 20,
          ),
          itemCount: filterlist.length,
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredGrid(
              position: i,
              columnCount: count,
              duration: const Duration(milliseconds: 700),
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: DrugTile(filterlist[i]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showSearchDialog(Size size, BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DraggableHome(
      appBarColor: Colors.green,
      headerWidget: Image.asset(
        whichBanner(),
        fit: BoxFit.cover,
      ),
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      alwaysShowLeadingAndAction: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          focusNode.unfocus();
          Future.delayed(const Duration(milliseconds: 1), () {
            focusNode.requestFocus();
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.search),
      ),
      title: Text(widget.title),
      body: [
        searchBarMore(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: gridBuilder(size),
        ),
      ],
    );
  }

  Widget searchBarMore() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CupertinoTextField(
        focusNode: focusNode,
        suffix: IconButton(
            onPressed: () {
              showSearchDialog(size, context);
            },
            icon: const Icon(Icons.manage_search_outlined)),
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              filterlist = widget.list;
            });
          } else {
            setState(() {
              filterlist = widget.list
                  .where((e) =>
                      e.fullName.toUpperCase().contains(value.toUpperCase()))
                  .toList();
            });
          }
        },
        keyboardType: TextInputType.text,
        placeholder: 'Search',
        placeholderStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
          fontFamily: 'Brutal',
        ),
        prefix: const Padding(
          padding: EdgeInsets.only(left: 15, right: 10),
          child: Icon(
            Icons.search,
            size: 18,
            color: Colors.black,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
