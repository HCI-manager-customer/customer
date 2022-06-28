import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hci_customer/models/user.dart';
import 'package:hci_customer/screens/home/home.dart';
import 'package:hci_customer/screens/misc/nearby.dart';
import 'package:hci_customer/screens/payment/payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controllers/drug_controller.dart';
import 'firebase_options.dart';
import 'provider/general_provider.dart';
import 'screens/home/home_drawer.dart';
import 'screens/login_sceen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      systemNavigationBarColor: Colors.green,
    ),
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final DrugController drugController = Get.put(DrugController());
  runApp(const ProviderScope(child: MyApp()));
}

final navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static const routeName = '/main';

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(fontFamily: "Raleway"),
        ),
      ),
      routes: {
        PaymentScreen.routeName: (context) => const PaymentScreen(),
        MyApp.routeName: (context) => const MyApp(),
        NearbyStoreScreen.routeName: (context) => const NearbyStoreScreen(),
        HomeDrawer.routeName: (context) => const HomeDrawer(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
      home: const MainAppBuilder(),
    );
  }
}

class MainAppBuilder extends ConsumerStatefulWidget {
  const MainAppBuilder();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppBuilderState();
}

class _MainAppBuilderState extends ConsumerState<MainAppBuilder> {
  final db = FirebaseFirestore.instance;

  Future<void> sendUser() async {
    final u = FirebaseAuth.instance.currentUser!;
    final phone = u.phoneNumber ?? 0;
    var user = PharmacyUser(
        mail: u.email,
        name: u.displayName,
        phone: phone.toString(),
        addr: 'user home');
    checkExist(user);
  }

  Future<void> checkExist(PharmacyUser u) async {
    final userCollection = db.collection('users');
    await userCollection.get().then((value) {
      for (var e in value.docs) {
        if (e.data()['mail'] == u.mail) {
          userCollection.doc(u.mail).get().then((doc) {
            u = ref.read(pharmacyUserProvider.notifier).state =
                PharmacyUser.fromFirestore(doc);
          });
          return;
        }
      }
      userCollection.doc(u.mail).set(u.toFirestore());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snap.hasData) {
          sendUser();
          return const HomeDrawer();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
