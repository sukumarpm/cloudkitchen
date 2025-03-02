import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/HorizontalCouponExample2.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/fooddetails.dart';
import 'package:cloud_kitchen_2/pages/mydrawer.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/pages/offers1.dart';
import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:intl/intl.dart';
import 'package:progress_stepper/progress_stepper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _deviceWidth;
  late double _deviceHeight;
  static const Color primaryColor = Color.fromARGB(255, 33, 56, 1);
  static const Color secondaryColor = Color.fromARGB(255, 54, 98, 98);
  late double quantity = 1.00;
  late double priceperpiece = 20.00;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  late AuthService _auth;
  final MyController c = Get.put(MyController());
  List<FoodSource> results1 = [];
  List<FoodSource> results = [];
  List<FoodSource> listFoodSource = [];
  List<FoodSource> filteredFoodSource = [];
  List<MyOrders> listorderhistory = [];
  String searchcategory = 'All';
  List data = List.empty();
  late Map<dynamic, dynamic> userdata;
  late String userWork;
  late int activeStep = 2;
  late List favourites;
  List categoryImage = [
    {
      'url': 'lib/assets/images/food/pexels-sydney-troxell-223521-708488.jpg',
      'title': 'Breakfast',
      'price': '120.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-chanwalrus-1059943.jpg',
      'title': 'Lunch',
      'price': '85.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-asphotograpy-103566.jpg',
      'title': 'Dinner',
      'price': '90.00',
    },
    // {
    //   'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
    //   'title': 'Snacks',
    //   'price': '210.00',
    // },
    {
      'url': 'lib/assets/images/food/pexels-marvin-ozz-1297854-2474658.jpg',
      'title': 'All',
      'price': '210.00',
    },
  ];
  List listImages = [
    {
      'url': 'lib/assets/images/food/pexels-sydney-troxell-223521-708488.jpg',
      'title': 'Chicken 65',
      'price': '120.00',
      'offerpercent': '15',
    },
    // {
    //   'url': 'lib/assets/images/food/pexels-chanwalrus-1059943.jpg',
    //   'title': 'Mutton Curry',
    //   'price': '85.00',
    //   'offerpercent':'15',
    // },
    // {
    //   'url': 'lib/assets/images/food/pexels-asphotograpy-103566.jpg',
    //   'title': 'Rice with Curd',
    //   'price': '90.00',
    //   'offerpercent':'20',
    // },
    // {
    //   'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
    //   'title': 'Liver Fry',
    //   'price': '210.00',
    //   'offerpercent':'5',
    // },
    // {
    //   'url': 'lib/assets/images/food/pexels-janetrangdoan-1128678.jpg',
    //   'title': 'Special Meals',
    //   'price': '75.00',
    //   'offerpercent':'10',
    // },
    // {
    //   'url': 'lib/assets/images/food/pexels-marvin-ozz-1297854-2474658.jpg',
    //   'title': 'Our Fabulous',
    //   'price': '80.00',
    //   'offerpercent':'15',
    // },
    {
      'url': 'lib/assets/images/food/pexels-asphotograpy-103566.jpg',
      'title': 'Rice with Curd',
      'price': '45.00',
      'offerpercent': '20',
    },
    {
      'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
      'title': 'Liver Fry',
      'price': '60.00',
      'offerpercent': '5',
    },
    {
      'url': 'lib/assets/images/food/pexels-janetrangdoan-1128678.jpg',
      'title': 'Special Meals',
      'price': '100.00',
      'offerpercent': '5',
    },
  ];
  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _auth = _getIt.get<AuthService>();
    listFoodSource = c.allfooddata;
    setResults(searchcategory);
    print('c.profiledata:${c.profiledata}');
    // var address = c.profiledata['my_addresses'];
    if (c.profiledata['my_addresses'] == null ||
        c.profiledata['my_addresses'].length == 0) {
      userWork = '';
    } else {
      userWork = c.profiledata['my_addresses'][0]['Work'] ?? '';
    }

    userdata = c.profiledata;
    fetchorderhistory();
    fetchcurrentorder();
    filterfavouriteitems();
    // for (var i = 0; i < data.length; i++) {
    //   listFoodSource.add(FoodSource.fromJson(data[i]));
    // }
    // for (var element in data) {
    //   // if (kDebugMode) {
    //   //   print(element['free']);
    //   // }
    //   // if (element['active']) {
    //   listFoodSource.add(FoodSource.fromJson(element));
    //   // }
    // }
  }

  Future<void> fetchorderhistory() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    const String formatted = '2025-02-01';

    FirebaseFirestore.instance
        .collection('orders')
        .where("user_id", isEqualTo: userdata['phone_number'].toString())
        .where("status", isNotEqualTo: "Open")
        .get()
        .then(
      (querySnapshot) {
        print('length: ${querySnapshot.size}');
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          print('str: $str');

          MyOrders orderhistory = MyOrders.fromJson(str);
          listorderhistory.add(orderhistory);

          // print("values: ${orderhistory.items}");
          // MyOrders myorder = MyOrders.fromJson(docSnapshot as Map<String, dynamic>);

          // listFoodSource.add(foodsource);
          // for (var element in orderhistory.items!) {
          //   print('order: ${element.price}');
          // }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    Get.find<MyController>().orderhistory = listorderhistory;

    // FirebaseFirestore.instance.collection("fooditems").get().then(
    //   (querySnapshot) {
    //     for (var docSnapshot in querySnapshot.docs) {
    //       final str = docSnapshot.data();
    //       FoodSource foodsource = FoodSource.fromFirestore(docSnapshot);

    //       listFoodSource.add(foodsource);
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
  }

  Future<void> fetchcurrentorder() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    List<Cartlists> cart = c.fullcartList;

    if (cart.isEmpty) {
      Get.find<MyController>().fullcartList = cart;
      FirebaseFirestore.instance
          .collection('orders')
          .where("user_id", isEqualTo: userdata['phone_number'].toString())
          .where("status", isEqualTo: "Open")
          .where("order_date", isEqualTo: formatted)
          .get()
          .then(
        (querySnapshot) {
          print('length: ${querySnapshot.size}');
          for (var docSnapshot in querySnapshot.docs) {
            final str = docSnapshot.data();
            print('str: $str');

            MyOrders orderhistory = MyOrders.fromJson(str);
            for (var element in orderhistory.items!) {
              cart.add(Cartlists(
                  title: element.title,
                  price: element.price,
                  qty: element.qty,
                  url: element.url));
            }

            // listFoodSource.add(foodsource);
            for (var element in orderhistory.items!) {
              print('order: ${element.price}');
            }
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
      Get.find<MyController>().fullcartList = cart;
    }

    // FirebaseFirestore.instance.collection("fooditems").get().then(
    //   (querySnapshot) {
    //     for (var docSnapshot in querySnapshot.docs) {
    //       final str = docSnapshot.data();
    //       FoodSource foodsource = FoodSource.fromFirestore(docSnapshot);

    //       listFoodSource.add(foodsource);
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    TextTheme textTheme = Theme.of(context).textTheme;
    ElevatedButtonThemeData ebuttonTheme =
        Theme.of(context).elevatedButtonTheme;
    return Scaffold(
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  'lib/assets/images/user/icones/burger menu.png',
                                  fit: BoxFit.cover),
                              addHorizontalSpace(25),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DELIVER TO',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
                                  ),
                                  userWork.isNotEmpty
                                      ? Wrap(children: <Widget>[
                                          Text(
                                            '${userWork.substring(1, 15)} ...',
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            // textDirection: TextDirection.rtl,
                                            // textAlign: TextAlign.justify,
                                          ),
                                        ])
                                      : const Wrap(children: <Widget>[
                                          Text(
                                            '',
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            // textDirection: TextDirection.rtl,
                                            // textAlign: TextAlign.justify,
                                          ),
                                        ])
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                child: Icon(
                                  Icons.history_outlined,
                                  size: 35,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                onTap: () {
                                  _navigationService.pushNamed("/orderhistory");
                                },
                              ),
                              addHorizontalSpace(16),
                              GestureDetector(
                                child: Icon(
                                  Icons.person_2_sharp,
                                  size: 35,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                onTap: () {
                                  _navigationService.pushNamed("/userprofile");
                                },
                              ),
                              addHorizontalSpace(16),
                              GestureDetector(
                                child: Image.asset(
                                  'lib/assets/images/user/icones/orderbasket.png',
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  _navigationService.pushNamed("/orderactive");
                                },
                              ),
                              // GestureDetector(
                              //     onTap: () {
                              //       _auth.logout();
                              //       Get.snackbar('Thanks!.',
                              //           'You are logged out successfully!',
                              //           barBlur: 1,
                              //           backgroundColor: Colors.white,
                              //           margin: const EdgeInsets.all(20),
                              //           duration: const Duration(seconds: 5),
                              //           snackPosition: SnackPosition.BOTTOM);
                              //       _navigationService
                              //           .pushReplacedNamed("/login");
                              //     },
                              //     child: const Icon(
                              //       Icons.logout_rounded,
                              //       size: 36,
                              //       color: Colors.red,
                              //     )),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Welcome,${userdata['name']}!',
                                style: const TextStyle(
                                    color: primaryColor, fontSize: 24),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.search,
                                    size: 35,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                onTap: () async {
                                  _navigationService.pushNamed("/searchfood");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const HorizontalCouponExample2(),
                      addVerticalSpace(8),
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          height: _deviceHeight * .25,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 4 / 3,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 2000),
                          viewportFraction: 0.9,
                        ),
                        itemCount: listImages.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            SizedBox(
                          width: _deviceWidth,
                          child: Column(
                            children: [
                              SizedBox(
                                height: _deviceHeight * .20,
                                width: _deviceWidth * .9,
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: const EdgeInsets.all(10),
                                  child: CouponCard(
                                    height: 200,
                                    backgroundColor: Colors.grey,
                                    clockwise: true,
                                    curvePosition: 75,
                                    curveRadius: 30,
                                    curveAxis: Axis.vertical,
                                    borderRadius: 10,
                                    firstChild: Container(
                                      decoration: const BoxDecoration(
                                        color: secondaryColor,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${listImages[itemIndex]['offerpercent']} %',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Text(
                                                    'OFF',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                              color: Colors.white54, height: 0),
                                          const Expanded(
                                            child: Center(
                                              child: Text(
                                                'WINTER IS\nHERE',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    secondChild: Image.asset(
                                        listImages[itemIndex]['url']),
                                  ),
                                  // Image.asset(
                                  //   listImages[itemIndex]['url'],
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // CarouselSlider(
                      //     options: CarouselOptions(
                      //       height: 120.0,
                      //       enlargeCenterPage: true,
                      //       autoPlay: true,
                      //       aspectRatio: 16 / 9,
                      //       autoPlayCurve: Curves.fastOutSlowIn,
                      //       enableInfiniteScroll: true,
                      //       autoPlayAnimationDuration:
                      //           const Duration(milliseconds: 800),
                      //       viewportFraction: 0.6,
                      //     ),
                      //     items: listImages.map((i) {
                      //       return Builder(
                      //         builder: (BuildContext context) {
                      //           return Image.asset(listImages[i]['url']);
                      //         },
                      //       );
                      //     }).toList()),
                      // const Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       'My Order:',
                      //       style: TextStyle(fontSize: 16.0),
                      //     ),
                      //   ],
                      // ),
                      // CarouselSlider(
                      //   items: [
                      //     //1st Image of Slider
                      //     Container(
                      //       margin: const EdgeInsets.all(6.0),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         image: const DecorationImage(
                      //           image: NetworkImage(
                      //               "https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737684759144926.png?alt=media&token=c0dd3f16-a035-4360-b3d3-264b241f4c27"),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       margin: const EdgeInsets.all(6.0),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         image: const DecorationImage(
                      //           image: NetworkImage(
                      //               "https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737654222256928.png?alt=media&token=d473a9f5-6a0d-4a50-98e0-45590adaaf0c"),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //   ],

                      //   //Slider Container properties
                      //   options: CarouselOptions(
                      //     height: 80.0,
                      //     enlargeCenterPage: true,
                      //     autoPlay: true,
                      //     aspectRatio: 16 / 9,
                      //     autoPlayCurve: Curves.fastOutSlowIn,
                      //     enableInfiniteScroll: true,
                      //     autoPlayAnimationDuration:
                      //         const Duration(milliseconds: 600),
                      //     viewportFraction: 0.4,
                      //   ),
                      // ),
                      // ProgressStepper(
                      //   width: _deviceWidth*.9,
                      //   height: 25,
                      //   padding: 1,
                      //   currentStep: 2,
                      //   bluntHead: true,
                      //   bluntTail: true,
                      //   color: Colors.grey,
                      //   progressColor: Colors.lightGreen,
                      //   labels: const <String>[
                      //     'Waiting',
                      //     'Received',
                      //     'Preparing',
                      //     'On the way',
                      //     'Complete'
                      //   ],
                      //   defaultTextStyle: const TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      //   selectedTextStyle: const TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w300,
                      //   ),
                      // ),
                      // addVerticalSpace(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CATEGORY',
                          ),
                          addVerticalSpace(8),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              height: _deviceWidth * .3,
                              child: ListView.builder(
                                  itemCount: categoryImage.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int key = index;
                                    return GestureDetector(
                                      child: SizedBox(
                                        width: _deviceWidth * .25,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: _deviceWidth * .2,
                                              child: Card(
                                                semanticContainer: true,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                elevation: 5,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Image.asset(
                                                  categoryImage[index]['url'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Text(categoryImage[index]['title'])
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        print(categoryImage[index]['title']);
                                        setResults(
                                            categoryImage[index]['title']);
                                      },
                                    );
                                  })),
                          // SizedBox(
                          //   width: _deviceWidth * .9,
                          //   // height: _deviceHeight * .5,
                          //   child: GridView.builder(
                          //     scrollDirection: Axis.vertical,
                          //     itemCount: categoryImage.length,
                          //     controller:
                          //         ScrollController(keepScrollOffset: true),
                          //     shrinkWrap: true,
                          //     gridDelegate:
                          //         const SliverGridDelegateWithFixedCrossAxisCount(
                          //             crossAxisCount: 2,
                          //             // childAspectRatio: 22 / 30,
                          //             // childAspectRatio: _deviceHeight / 400,
                          //             mainAxisSpacing: 1,
                          //             crossAxisSpacing: 1
                          //             // childAspectRatio: 1,
                          //             ),
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return GestureDetector(
                          //         child: SizedBox(
                          //           width: _deviceWidth / 3,
                          //           child: Column(
                          //             children: [
                          //               SizedBox(
                          //                 height: _deviceWidth / 3,
                          //                 child: Card(
                          //                   semanticContainer: true,
                          //                   clipBehavior:
                          //                       Clip.antiAliasWithSaveLayer,
                          //                   shape: RoundedRectangleBorder(
                          //                     borderRadius:
                          //                         BorderRadius.circular(10.0),
                          //                   ),
                          //                   elevation: 5,
                          //                   margin: const EdgeInsets.all(10),
                          //                   child: Image.asset(
                          //                     categoryImage[index]['url'],
                          //                     fit: BoxFit.cover,
                          //                   ),
                          //                 ),
                          //               ),
                          //               Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.center,
                          //                 mainAxisSize: MainAxisSize.max,
                          //                 children: [
                          //                   Column(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment.start,
                          //                     // crossAxisAlignment:
                          //                     //     CrossAxisAlignment.start,
                          //                     // mainAxisSize: MainAxisSize.max,
                          //                     children: [
                          //                       Text(categoryImage[index]
                          //                           ['title']),
                          //                     ],
                          //                   ),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         onTap: () {
                          //           print(categoryImage[index]['title']);
                          //           setResults(categoryImage[index]['title']);
                          //         },
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filter: $searchcategory',
                          ),
                          // addVerticalSpace(8),
                          SizedBox(
                            width: _deviceWidth * .9,
                            // height: _deviceHeight * .5,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: results.length,
                              controller:
                                  ScrollController(keepScrollOffset: true),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.2,
                                      // childAspectRatio: _deviceHeight / 400,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1
                                      // childAspectRatio: 1,
                                      ),
                              itemBuilder: (BuildContext context, int index) {
                                FoodSource? fooditem = results[index];
                                return GestureDetector(
                                  child: SizedBox(
                                    width: _deviceWidth / 3,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 110,
                                          child: Card(
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              elevation: 5,
                                              margin: const EdgeInsets.all(10),
                                              child:
                                                  // Image.network(
                                                  //   fooditem.imageurl1!,
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  CachedNetworkImage(
                                                imageUrl: fooditem.imageurl1!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  // width: _deviceWidth,
                                                  // height: _deviceHeight * .28,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                        ),
                                        Text(fooditem.itemname ?? '')
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    // print(fooditem.itemname);
                                    Get.find<MyController>().fooddetails =
                                        fooditem;
                                    _navigationService
                                        .pushNamed('/fooddetails');
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const MySeparator(color: Colors.green),
                      addVerticalSpace(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Favourites',
                          ),
                          // addVerticalSpace(8),
                          SizedBox(
                            width: _deviceWidth * .9,
                            // height: _deviceHeight * .5,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: filteredFoodSource.length,
                              controller:
                                  ScrollController(keepScrollOffset: true),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      // childAspectRatio: 22 / 30,
                                      // childAspectRatio: _deviceHeight / 400,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1
                                      // childAspectRatio: 1,
                                      ),
                              itemBuilder: (BuildContext context, int index) {
                                FoodSource? fooditem =
                                    filteredFoodSource[index];
                                return GestureDetector(
                                  child: SizedBox(
                                    width: _deviceWidth / 3,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 90,
                                          child: Card(
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              elevation: 5,
                                              margin: const EdgeInsets.all(10),
                                              child:
                                                  // Image.network(
                                                  //   fooditem.imageurl1!,
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  CachedNetworkImage(
                                                imageUrl: fooditem.imageurl1!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  // width: _deviceWidth,
                                                  // height: _deviceHeight * .28,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                        ),
                                        Text(fooditem.itemname ?? '')
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    // print(fooditem.itemname);
                                    Get.find<MyController>().fooddetails =
                                        fooditem;
                                    _navigationService
                                        .pushNamed('/fooddetails');
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const MySeparator(color: Colors.green),
                      addVerticalSpace(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today' 's Dishes',
                          ),
                          // addVerticalSpace(8),
                          SizedBox(
                            width: _deviceWidth * .9,
                            // height: _deviceHeight * .5,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: listFoodSource.length,
                              controller:
                                  ScrollController(keepScrollOffset: true),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      // childAspectRatio: 22 / 30,
                                      // childAspectRatio: _deviceHeight / 400,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1
                                      // childAspectRatio: 1,
                                      ),
                              itemBuilder: (BuildContext context, int index) {
                                FoodSource? fooditem = listFoodSource[index];
                                return GestureDetector(
                                  child: SizedBox(
                                    width: _deviceWidth / 3,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 90,
                                          child: Card(
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              elevation: 5,
                                              margin: const EdgeInsets.all(10),
                                              child:
                                                  // Image.network(
                                                  //   fooditem.imageurl1!,
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  CachedNetworkImage(
                                                imageUrl: fooditem.imageurl1!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  // width: _deviceWidth,
                                                  // height: _deviceHeight * .28,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                        ),
                                        Text(fooditem.itemname ?? '')
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    // print(fooditem.itemname);
                                    Get.find<MyController>().fooddetails =
                                        fooditem;
                                    _navigationService
                                        .pushNamed('/fooddetails');
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // InlineChoice<String>.single(
                      //   clearable: true,
                      //   value: selectedValue,
                      //   onChanged: setSelectedValue,
                      //   itemCount: choices.length,
                      //   itemBuilder: (state, i) {
                      //     return ChoiceChip(
                      //       selected: state.selected(choices[i]),
                      //       onSelected: state.onSelected(choices[i]),
                      //       label: Text(choices[i]),
                      //     );
                      //   },
                      //   listBuilder: ChoiceList.createWrapped(
                      //     spacing: 10,
                      //     runSpacing: 10,
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 20,
                      //       vertical: 25,
                      //     ),
                      //   ),
                      // ),
                      const MySeparator(color: Colors.green),
                      addVerticalSpace(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FEATURED ITEMS',
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: _deviceWidth * .6,
                              child: ListView.builder(
                                  itemCount: listImages.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int key = index;
                                    return GestureDetector(
                                      child: SizedBox(
                                        width: _deviceWidth * .6,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: _deviceWidth * .5,
                                              child: Card(
                                                semanticContainer: true,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                elevation: 5,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Image.asset(
                                                  listImages[index]['url'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Text(listImages[index]['title'])
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        print(listImages[index]['title']);
                                      },
                                    );
                                  })),
                        ],
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     const Text(
                      //       'POPULAR FOOD',
                      //     ),
                      //     addVerticalSpace(8),
                      //     SizedBox(
                      //       width: _deviceWidth * .9,
                      //       // height: _deviceHeight * .5,
                      //       child: GridView.builder(
                      //         scrollDirection: Axis.vertical,
                      //         itemCount: listImages.length,
                      //         controller:
                      //             ScrollController(keepScrollOffset: true),
                      //         shrinkWrap: true,
                      //         gridDelegate:
                      //             const SliverGridDelegateWithFixedCrossAxisCount(
                      //                 crossAxisCount: 2,
                      //                 // childAspectRatio: 22 / 30,
                      //                 // childAspectRatio: _deviceHeight / 400,
                      //                 mainAxisSpacing: 1,
                      //                 crossAxisSpacing: 1
                      //                 // childAspectRatio: 1,
                      //                 ),
                      //         itemBuilder: (BuildContext context, int index) {
                      //           return GestureDetector(
                      //             child: SizedBox(
                      //               width: _deviceWidth / 3,
                      //               child: Column(
                      //                 children: [
                      //                   SizedBox(
                      //                     height: _deviceWidth / 3,
                      //                     child: Card(
                      //                       semanticContainer: true,
                      //                       clipBehavior:
                      //                           Clip.antiAliasWithSaveLayer,
                      //                       shape: RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(10.0),
                      //                       ),
                      //                       elevation: 5,
                      //                       margin: const EdgeInsets.all(10),
                      //                       child: Image.asset(
                      //                         listImages[index]['url'],
                      //                         fit: BoxFit.cover,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.start,
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     mainAxisSize: MainAxisSize.max,
                      //                     children: [
                      //                       Column(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.start,
                      //                         // crossAxisAlignment:
                      //                         //     CrossAxisAlignment.start,
                      //                         // mainAxisSize: MainAxisSize.max,
                      //                         children: [
                      //                           Text(
                      //                               listImages[index]['title']),
                      //                           Text(
                      //                               'Rs.${listImages[index]['price']}'),
                      //                         ],
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             onTap: () {
                      //               print(listImages[index]['title']);
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // addVerticalSpace(16),
                      // Stack(
                      //   alignment: Alignment.bottomCenter,
                      //   children: <Widget>[
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 12.0),
                      //       child: SizedBox(
                      //         height: 170,
                      //         child: Card(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(20),
                      //           ),
                      //           color: const Color(0xffE3EBF2),
                      //           margin: const EdgeInsets.all(
                      //             16,
                      //           ),
                      //           child: Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceAround,
                      //             children: [
                      //               Text(
                      //                 'Rs.${quantity * priceperpiece}',
                      //                 style: textTheme.titleLarge,
                      //               ),
                      //               Container(
                      //                 height: 45,
                      //                 decoration: BoxDecoration(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .tertiary,
                      //                     borderRadius:
                      //                         BorderRadius.circular(25)),
                      //                 child: Row(
                      //                   children: [
                      //                     InputQty.double(
                      //                         onQtyChanged: (val) {
                      //                           print(val);
                      //                           setState(() {
                      //                             quantity = val;
                      //                           });
                      //                         },
                      //                         maxVal: 12,
                      //                         initVal: 1,
                      //                         minVal: 1,
                      //                         decoration:
                      //                             const QtyDecorationProps(
                      //                                 isBordered: false,
                      //                                 btnColor: Colors.black26,
                      //                                 iconColor: Colors.grey,
                      //                                 borderShape:
                      //                                     BorderShapeBtn.circle,
                      //                                 width: 12)),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: _deviceWidth * .8,
                      //       height: 60,
                      //       decoration: const ShapeDecoration(
                      //         shape: RoundedRectangleBorder(),
                      //         color: Colors.transparent,
                      //       ),
                      //       child: ElevatedButton(
                      //           child: const Text("ADD TO CART"),
                      //           onPressed: () {}),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text(
                        'Any queries?. Contact Us',
                        style: TextStyle(fontSize: 16),
                      ),
                      content: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.green.shade400)),
                          onPressed: () {
                            _navigationService.pushNamed("/home");
                          },
                          child: const Text(
                            'Phone: +91 76453 65298',
                            style: TextStyle(color: Colors.black),
                          )));
                });
          });
        },
        // isExtended: true,
        child: const Icon(
          Icons.contact_support,
          size: 55,
        ),
      ),
    );
  }

  void setResults(String query) {
    String tempquery = query;
    if (query == 'All') {
      query = '';
    }
    results1 = listFoodSource
        .where((elem) =>
            elem.when.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    // print('in set results: ${results1[0].itemname}');
    setState(() {
      searchcategory = tempquery;
      results = results1;
    });
  }

  void filterfavouriteitems() {
    if (userdata['favourites'] != null || userdata['favourites'].length != 0) {
      favourites = userdata['favourites'];
      //print('favourites: $favourites');
      for (var element in listFoodSource) {
        var found = favourites.contains(element.itemname);
        // print('element:$element');
        // print('found:$found');
        if (found) {
          filteredFoodSource.add(element);
        }
      }
    }
  }
}
