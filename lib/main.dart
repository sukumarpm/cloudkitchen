import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/city.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/vendorclass.dart';
import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/firebase_options.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_kitchen_2/themes/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:json_string/json_string.dart';

void main() async {
  await setup();
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MaterialApp(home: OnBoard())),
  );
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerservice();
}

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    name: "cloudkitchen",
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp1 extends StatelessWidget {
  late AuthService _auth;
  late NavigationService _navigationService;

  MyApp1({super.key}) {
    final GetIt getIt = GetIt.instance;
    _auth = getIt.get<AuthService>();
    _navigationService = getIt.get<NavigationService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) {
    //   print('_auth.user:${_auth.user}');
    // }
    return GetMaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: _auth.user != null ? "/home" : "/login",
      // initialRoute: _auth.user != null ? "/home" : "/dropdown",
      // initialRoute: _auth.user != null ? "/home" : "/imageup",
      // initialRoute: _auth.user != null ? "/register" : "/fmlogo",
      // initialRoute: "/login",
      routes: _navigationService.routes,
    );
  }
}

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  List<FoodSource> listFoodSource = [];
  List<VendorSource> listVendorSource = [];

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();

    getallfood();
    getvendors();
  }

  Future<void> getallfood() async {
    final FirebaseFirestore firebase = FirebaseFirestore.instance;
    final QuerySnapshot resulta =
        await firebase.collection("fooditems").orderBy("item_name").get();

    List<Object?> allData = resulta.docs.map((doc) => {doc.data()}).toList();

    final ref = FirebaseFirestore.instance
        .collection("fooditems")
        .doc("SF")
        .withConverter(
          fromFirestore: City.fromFirestore,
          toFirestore: (City city, _) => city.toFirestore(),
        );

    FirebaseFirestore.instance.collection("fooditems").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          FoodSource foodsource = FoodSource.fromFirestore(docSnapshot);

          listFoodSource.add(foodsource);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    Get.find<MyController>().allfooddata = listFoodSource;
  }

  Future<void> getvendors() async {
    FirebaseFirestore.instance.collection("vendors").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          VendorSource vendorsource = VendorSource.fromFirestore(docSnapshot);
          listVendorSource.add(vendorsource);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    Get.find<MyController>().allvendordata = listVendorSource;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: StreamBuilder<List<FoodSource>>(
      //   stream: getAllUsers(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       final List<FoodSource> users = snapshot.data as List<FoodSource>;
      //       return ListView(
      //           children: users.map((user) {
      //         return ListTile(
      //           leading: CircleAvatar(child: Text('${user.itemname}')),
      //           title: Text(user.itemdescription!),
      //           subtitle: Text(user.rate!),
      //         );
      //       }).toList());
      //     } else if (snapshot.hasError) {
      //       print('Error:${snapshot.error}');
      //       return const Center(child: Text('Something went wrong.'));
      //     } else {
      //       return const Text('Loading Users...');
      //     }
      //   },
      // ),
      body: Center(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(
              5, MediaQuery.of(context).size.height * .1, 5, 5),
          child: Column(
            children: [
              Image.asset(
                'lib/assets/images/user/logo/LOGO.png',
                fit: BoxFit.contain,
                height: 75,
                width: 75,
              ),
              ImageSlideshow(
                /// Width of the [ImageSlideshow].
                width: MediaQuery.of(context).size.width * .7,

                /// Height of the [ImageSlideshow].
                height: MediaQuery.of(context).size.height * .6,

                /// The page to show when first creating the [ImageSlideshow].
                initialPage: 0,

                /// The color to paint the indicator.
                indicatorColor: Theme.of(context).colorScheme.tertiary,

                /// The color to paint behind th indicator.
                indicatorBackgroundColor: const Color.fromARGB(255, 24, 10, 10),

                /// Called whenever the page in the center of the viewport changes.
                onPageChanged: (value) {
                  // if (kDebugMode) {
                  //   print('Page changed: $value');
                  // }
                },

                /// Auto scroll interval.
                /// Do not auto scroll with null or 0.
                autoPlayInterval: 3000,

                /// Loops back to first slide.
                isLoop: true,

                /// The widgets to display in the [ImageSlideshow].
                /// Add the sample image file into the images folder
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/user/onboading/amico.png',
                        fit: BoxFit.contain,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to Sura's Kitchen",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            'Your journey to mouthwatering meals starts here',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w300, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/user/onboading/bro.png',
                        fit: BoxFit.contain,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Explore Unlimited Options',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            'Your journey to mouthwatering meals starts here',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w300, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/onboard/pana.png',
                        fit: BoxFit.contain,
                      ),
                      Column(
                        children: [
                          Text(
                            'Order with Confidence',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            'Your journey to mouthwatering meals starts here',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w300, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/user/onboading/rafiki.png',
                        fit: BoxFit.contain,
                      ),
                      Column(
                        children: [
                          Text(
                            'Your Responsibility, Our Promise',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            'Your journey to mouthwatering meals starts here',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w300, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Image.asset(
                  //   'lib/assets/images/user/onboading/bro.png',
                  //   fit: BoxFit.contain,
                  // ),
                  // Image.asset(
                  //   'lib/assets/images/onboard/pana.png',
                  //   fit: BoxFit.contain,
                  // ),
                  // Image.asset(
                  //   'lib/assets/images/user/onboading/rafiki.png',
                  //   fit: BoxFit.contain,
                  // ),
                ],
              ),
              addVerticalSpace(50),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.green)),
                      child: const Text(
                        "GET STARTED",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // _navigationService.pushReplacedNamed("/login");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp1()));
                      })),
              // addVerticalSpace(10),
              // Text(
              //   'Skip',
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context)
              //       .textTheme
              //       .titleLarge!
              //       .copyWith(fontWeight: FontWeight.w300, fontSize: 18),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class MyModel {
  String? name;

  MyModel({required this.name});

  MyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;

    return data;
  }
}
