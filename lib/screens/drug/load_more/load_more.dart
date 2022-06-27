import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisExtent: 256,
            mainAxisSpacing: 5,
            crossAxisSpacing: 40,
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

  SliverAppBar createSilverAppBar1() {
    return SliverAppBar(
      backgroundColor: Colors.green,
      expandedHeight: 200,
      pinned: true,
      floating: false,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (constraints.biggest.height <= 85) {
              setState(() {
                isVisible = true;
              });
            } else {
              setState(() {
                isVisible = false;
              });
            }
          });
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            centerTitle: true,
            title: AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.title,
              ),
            ),
            background: Container(
              color: Colors.white,
              child: Image.asset(
                whichBanner(),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget createSilverAppBar2(BuildContext ctx) {
    Size size = MediaQuery.of(ctx).size;
    return MediaQuery.removePadding(
      context: ctx,
      removeTop: true,
      child: SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: true,
        backgroundColor: Colors.green,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade500,
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 5.0),
                ],
              ),
              child: CupertinoTextField(
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
                          .where((e) => e.fullName
                              .toUpperCase()
                              .contains(value.toUpperCase()))
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
            ),
          ),
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

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[createSilverAppBar1(), createSilverAppBar2(context)];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: gridBuilder(size),
        ),
      ),
    );
  }
}
