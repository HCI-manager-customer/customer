import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hci_customer/debug/debug.dart';
import 'package:hci_customer/models/user.dart';
import 'package:hci_customer/screens/home/home.dart';
import 'package:hci_customer/screens/misc/nearby.dart';
import 'package:hci_customer/screens/payment/payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/notification_controller.dart';
import 'controllers/user_action_controller.dart';
import 'firebase_options.dart';
import 'provider/general_provider.dart';
import 'screens/home/home_drawer.dart';
import 'screens/login_sceen.dart';

Future _connectToFirebaseEmulator() async {
  const localHostString = '192.168.1.85';

  await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    if (USE_EMULATOR) {
      await _connectToFirebaseEmulator();
    }
  } on Exception catch (e) {
    log(e.toString());
  }

  FirebaseInAppMessaging.instance.triggerEvent('abc');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      systemNavigationBarColor: Colors.green,
    ),
  );
  Get.put(NotificationController());
  // Get.put(DrugController());
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
        primarySwatch: Colors.green,
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

  Widget sendUser() {
    final u = FirebaseAuth.instance.currentUser!;
    final phone = u.phoneNumber ?? 0;
    var user = PharmacyUser(
        imgUrl: u.photoURL,
        mail: u.email,
        name: u.displayName,
        phone: phone.toString(),
        addr: 'user home');
    checkExist(user);
    Get.put(UserActionoController());
    return const HomeDrawer();
  }

  Future<void> checkExist(PharmacyUser u) async {
    final userCollection = db.collection('users');
    await userCollection.get().then((value) {
      for (var e in value.docs) {
        if (e.data()['mail'] == u.mail) {
          userCollection.doc(u.mail).get().then((doc) {
            u = ref.read(pharmacyUserProvider.notifier).state =
                PharmacyUser.fromMap(doc.data() as Map<String, dynamic>);
          });
          return;
        }
      }
      userCollection.doc(u.mail).set(u.toMap());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (USE_EMULATOR) {
      return const DebugScreen();
    } else {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snap.hasData) {
            return sendUser();
            // Get.to(() => const HomeDrawer());
          } else {
            return const LoginScreen();
            // Get.to(() => const LoginScreen());
          }
        },
      );
    }
  }
}
