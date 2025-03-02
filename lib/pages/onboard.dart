import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    //getallfood();
  }

  // Future<void> getallfood() async {
  //   final FirebaseFirestore firebase = FirebaseFirestore.instance;
  //   final QuerySnapshot resulta =
  //       await firebase.collection("fooditems").orderBy("item_name").get();

  //   List<FoodSource?> allData = resulta.docs.map((doc) {
  //     FoodSource foodsourceList =
  //         FoodSource.fromJson(Map<String, dynamic>.from(doc as Map));
  //     return foodsourceList;
  //   }).toList();
  //   if (kDebugMode) {
  //     print('result - main 1:$allData');
  //   }
  //   // Get.find<MyController>().allfooddata = allData;
  //   if (kDebugMode) {
  //     String str = allData[0].toString();
  //     print('in main: $str');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Center(
    //     child: Container(
    //       color: Theme.of(context).colorScheme.primary,
    //       height: MediaQuery.of(context).size.height,
    //       width: MediaQuery.of(context).size.width,
    //       padding: EdgeInsets.fromLTRB(
    //           5, MediaQuery.of(context).size.height * .1, 5, 5),
    //       child: Column(
    //         children: [
    //           Image.asset(
    //             'lib/assets/images/user/logo/LOGO.png',
    //             fit: BoxFit.contain,
    //             height: 75,
    //             width: 75,
    //           ),
    //           ImageSlideshow(
    //             /// Width of the [ImageSlideshow].
    //             width: MediaQuery.of(context).size.width * .7,

    //             /// Height of the [ImageSlideshow].
    //             height: MediaQuery.of(context).size.height * .6,

    //             /// The page to show when first creating the [ImageSlideshow].
    //             initialPage: 0,

    //             /// The color to paint the indicator.
    //             indicatorColor: Theme.of(context).colorScheme.tertiary,

    //             /// The color to paint behind th indicator.
    //             indicatorBackgroundColor: const Color.fromARGB(255, 24, 10, 10),

    //             /// Called whenever the page in the center of the viewport changes.
    //             onPageChanged: (value) {
    //               if (kDebugMode) {
    //                 print('Page changed: $value');
    //               }
    //             },

    //             /// Auto scroll interval.
    //             /// Do not auto scroll with null or 0.
    //             autoPlayInterval: 3000,

    //             /// Loops back to first slide.
    //             isLoop: true,

    //             /// The widgets to display in the [ImageSlideshow].
    //             /// Add the sample image file into the images folder
    //             children: [
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Image.asset(
    //                     'lib/assets/images/user/onboading/amico.png',
    //                     fit: BoxFit.contain,
    //                   ),
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         "Welcome to Sura's Kitchen",
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w700, fontSize: 18),
    //                       ),
    //                       Text(
    //                         'Your journey to mouthwatering meals starts here',
    //                         textAlign: TextAlign.center,
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w300, fontSize: 18),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Image.asset(
    //                     'lib/assets/images/user/onboading/bro.png',
    //                     fit: BoxFit.contain,
    //                   ),
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         'Explore Unlimited Options',
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w700, fontSize: 18),
    //                       ),
    //                       Text(
    //                         'Your journey to mouthwatering meals starts here',
    //                         textAlign: TextAlign.center,
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w300, fontSize: 18),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Image.asset(
    //                     'lib/assets/images/onboard/pana.png',
    //                     fit: BoxFit.contain,
    //                   ),
    //                   Column(
    //                     children: [
    //                       Text(
    //                         'Order with Confidence',
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w700, fontSize: 18),
    //                       ),
    //                       Text(
    //                         'Your journey to mouthwatering meals starts here',
    //                         textAlign: TextAlign.center,
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w300, fontSize: 18),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Image.asset(
    //                     'lib/assets/images/user/onboading/rafiki.png',
    //                     fit: BoxFit.contain,
    //                   ),
    //                   Column(
    //                     children: [
    //                       Text(
    //                         'Your Responsibility, Our Promise',
    //                         textAlign: TextAlign.center,
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w700, fontSize: 18),
    //                       ),
    //                       Text(
    //                         'Your journey to mouthwatering meals starts here',
    //                         textAlign: TextAlign.center,
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .titleLarge!
    //                             .copyWith(
    //                                 fontWeight: FontWeight.w300, fontSize: 18),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),

    //               // Image.asset(
    //               //   'lib/assets/images/user/onboading/bro.png',
    //               //   fit: BoxFit.contain,
    //               // ),
    //               // Image.asset(
    //               //   'lib/assets/images/onboard/pana.png',
    //               //   fit: BoxFit.contain,
    //               // ),
    //               // Image.asset(
    //               //   'lib/assets/images/user/onboading/rafiki.png',
    //               //   fit: BoxFit.contain,
    //               // ),
    //             ],
    //           ),
    //           addVerticalSpace(50),
    //           SizedBox(
    //               width: MediaQuery.of(context).size.width * .8,
    //               child: ElevatedButton(
    //                   style: ButtonStyle(
    //                       shape: WidgetStateProperty.all<OutlinedBorder>(
    //                           RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(10.0))),
    //                       backgroundColor: WidgetStateProperty.all<Color>(
    //                           Theme.of(context).colorScheme.tertiary)),
    //                   child: const Text("GET STARTED"),
    //                   onPressed: () {
    //                     _navigationService.pushReplacedNamed("/home");
    //                   })),
    //           // addVerticalSpace(10),
    //           // Text(
    //           //   'Skip',
    //           //   textAlign: TextAlign.center,
    //           //   style: Theme.of(context)
    //           //       .textTheme
    //           //       .titleLarge!
    //           //       .copyWith(fontWeight: FontWeight.w300, fontSize: 18),
    //           // )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
