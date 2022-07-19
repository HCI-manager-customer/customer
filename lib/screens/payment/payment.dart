import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_customer/screens/orders/remove_all_dialog.dart';
import 'package:string_validator/string_validator.dart';

import '../../models/cart.dart';
import '../../provider/general_provider.dart';
import '../orders/btnConfirmOrder.dart';
import 'payment_tile.dart';

final isFilledProvider = StateProvider((_) => false);

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen();

  static const routeName = '/payment';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  var addressCtl = TextEditingController();
  var nameCtl = TextEditingController();
  var phoneCtl = TextEditingController();

  String dropValue = 'Cash';

  final u = FirebaseAuth.instance.currentUser!;

  final _form = GlobalKey<FormState>();

  bool isNameFilled = true;
  bool isPhoneFilled = false;
  bool isAddrFilled = false;
  bool isFilled = false;

  @override
  void initState() {
    nameCtl.text = u.displayName.toString();
    if (!isPhoneNumber(u.phoneNumber.toString())) {
      isPhoneFilled = false;
      phoneCtl.text = '';
    } else {
      isPhoneFilled = true;
      phoneCtl.text = u.phoneNumber.toString();
    }
    addressCtl.text = '';

    nameCtl.addListener(() {
      ref.read(pharmacyUserProvider.notifier).state.name = nameCtl.text;

      isFilledFunc();
    });
    phoneCtl.addListener(() {
      ref.read(pharmacyUserProvider.notifier).state.phone = phoneCtl.text;
      isFilledFunc();
    });
    addressCtl.addListener(() {
      ref.read(pharmacyUserProvider.notifier).state.addr = addressCtl.text;
      isFilledFunc();
    });

    super.initState();
  }

  @override
  void dispose() {
    nameCtl.dispose();
    addressCtl.dispose();
    phoneCtl.dispose();
    super.dispose();
  }

  bool isPhoneNumber(String input) {
    return isNumeric(input) && isLength(input, 9, 10);
  }

  bool initFill() {
    final u = ref.watch(pharmacyUserProvider);
    setState(() {
      isFilled = isPhoneNumber(u.phone.toString()) ||
          u.name.toString().isNotEmpty ||
          u.addr.toString().isNotEmpty;
    });
    return isFilled;
  }

  double price = 0;

  double calcTotal(List<Cart> list) {
    price = 0;
    for (var element in list) {
      price += element.price;
    }
    return price;
  }

  void isFilledFunc() {
    final u = ref.watch(pharmacyUserProvider);
    ref.read(isFilledProvider.notifier).state =
        isPhoneNumber(u.phone.toString()) &
            u.name.toString().isNotEmpty &
            u.addr.toString().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var cartL = ref.watch(cartLProvider);
    price = 0;
    for (var element in cartL) {
      price += element.price;
    }

    initFill();
    final u = ref.watch(pharmacyUserProvider);
    nameCtl.text = u.name!;
    phoneCtl.text = u.phone ?? '0';
    addressCtl.text = u.addr!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const DeliveryWidget(),
                const Divider(),
                SizedBox(
                  width: size.width * 0.8,
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _form,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.person,
                                size: 25, color: Colors.green),
                            const Spacer(),
                            SizedBox(
                                width: size.width * 0.7,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      isNameFilled = false;
                                      return 'Empty Name';
                                    }
                                    isNameFilled = true;
                                    return null;
                                  },
                                  controller: nameCtl,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                      labelText: 'Full Name'),
                                )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 25,
                              color: Colors.green,
                            ),
                            const Spacer(),
                            SizedBox(
                                width: size.width * 0.7,
                                child: TextFormField(
                                  validator: (value) {
                                    if (!isPhoneNumber(value.toString())) {
                                      isPhoneFilled = false;
                                      return 'Invaild Phone Number';
                                    }
                                    isPhoneFilled = true;
                                    return null;
                                  },
                                  controller: phoneCtl,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                      labelText: 'Phone Number'),
                                )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.home,
                              size: 25,
                              color: Colors.green,
                            ),
                            const Spacer(),
                            SizedBox(
                                width: size.width * 0.7,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      isAddrFilled = false;
                                      return 'Empty Address';
                                    }
                                    isAddrFilled = true;
                                    return null;
                                  },
                                  controller: addressCtl,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: const InputDecoration(
                                      labelText: 'Delivery Address'),
                                )),
                          ],
                        ),
                        const ETAtime('1 week'),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.payment,
                              size: 25,
                              color: Colors.green,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: size.width * 0.7,
                              child: DropdownButton(
                                isExpanded: true,
                                iconEnabledColor: Colors.green,
                                value: dropValue,
                                onChanged: (s) {
                                  setState(() {
                                    dropValue = s.toString();
                                  });
                                },
                                style: GoogleFonts.kanit(),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Momo',
                                    child: Text(
                                      'Momo',
                                      style: TextStyle(color: Colors.pink),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Cash',
                                    child: Text(
                                      'Cash on Delivery',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Zalo Pay',
                                    child: Text(
                                      'Zalo Pay',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Bank',
                                    child: Text(
                                      'Bank',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Consumer(
                  builder: ((context, ref, child) {
                    var list = ref.watch(cartLProvider);
                    price = calcTotal(list);
                    return _listviewPayment(list, context);
                  }),
                ),
                SizedBox(height: size.height * 0.1)
              ],
            ),
          ),
          BtnConfirmOrder(dropValue, price),
        ],
      ),
    );
  }

  ListView _listviewPayment(List<Cart> list, BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, i) {
        return Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  ref.read(cartLProvider.notifier).removeCartAt(list[i]);
                  if (ref.watch(cartLProvider).isEmpty) {
                    Navigator.pop(context, true);
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Remove',
              )
            ],
          ),
          child: PaymentTile(i),
        );
      },
      itemCount: list.length,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      centerTitle: true,
      title: const Text("Checkout"),
      leading: BackButton(
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) {
                  return const RemoveDialog();
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
            },
            icon: const Icon(
              Icons.delete_rounded,
            ))
      ],
    );
  }
}

class DeliveryWidget extends StatelessWidget {
  const DeliveryWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: RichText(
        text: const TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30,
              ),
            ),
            WidgetSpan(
              child: Text(
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                "    Delivery Location",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ETAtime extends StatelessWidget {
  const ETAtime(this.time);
  final String time;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(
          Icons.delivery_dining,
          size: 25,
          color: Colors.green,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: SizedBox(
            width: size.width * 0.7,
            child: Text(
              "ETA: $time",
              style: const TextStyle(letterSpacing: 1, fontSize: 17),
            ),
          ),
        ),
      ],
    );
  }
}
