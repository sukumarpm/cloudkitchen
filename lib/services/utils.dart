// Future<void> setupFirebase() async {
//   await Firebase.initializeApp(
//     name: "ilangaivanI",
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }

import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> registerservice() async {
  final GetIt getIT = GetIt.instance;
  // getIT.registerSingleton<AuthService>(AuthService());
  // getIT.registerSingleton<NavigationService>(NavigationService());
  getIT.registerSingleton<AuthService>(AuthService());
  getIT.registerSingleton<NavigationService>(NavigationService());
}

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}
