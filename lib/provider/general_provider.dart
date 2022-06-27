import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/cart.dart';
import '../models/user.dart';
import '../screens/home/drawer.dart';

final googleSignInProvider = StateProvider((_) => GoogleSignIn());
final pharmacyUserProvider =
    StateProvider((_) => PharmacyUser(mail: '', name: '', phone: '', addr: ''));

final cartLProvider =
    StateNotifierProvider<CartListNotifier, List<Cart>>((ref) {
  return CartListNotifier();
});

final UserProvider = StateProvider((_) => FirebaseAuth.instance);
final ScreenProvider = StateProvider((_) => MenuItems.home);
