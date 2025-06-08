//******from home */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/HorizontalCouponExample2.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/driverclass.dart';
import 'package:cloud_kitchen_2/pages/exampleapppage.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/fooddetails.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart' as orders;
import 'package:cloud_kitchen_2/pages/mydrawer.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/pages/offers1.dart';
import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:intl/intl.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:toggle_list/toggle_list.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
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
  List<orders.MyOrders> listorderhistory = [];
  List<orders.MyOrders> listordercurrent = [];
  List<orders.MyOrders> listordercancelled = [];
  List<orders.MyOrders> listmyorders = [];
  List<Driver> listdrivers = [];
  late bool flagtotord = false;
  late bool flagearnings = false;
  late bool flagtodayord = true;
  late bool flagtotcancel = false;
  String searchcategory = 'All';
  List data = List.empty();
  late int? totalorders = 0;
  late int? todaysorders = 0;
  late int? cancelledorders = 0;
  late double? sumorders = 0.0;
  late Map<dynamic, dynamic> userdata;
  late String userWork;
  late int activeStep = 2;
  late List favourites;
  late bool cartshow = false;
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
    //print('c.profiledata:${c.profiledata['my_addresses']}');
    var address = c.profiledata['my_addresses'];
    // var address = c.profiledata['my_addresses'];
    if (address?.where((e) => e != null)?.toList()?.isEmpty ?? true) {
      userWork = '';
    } else {
      userWork = c.profiledata['my_addresses'][0]['Work'] ?? '';
    }

    userdata = c.profiledata;
    fetchorderhistory();
    fetchcurrentorder();
    fetchcancelorder();
    filterfavouriteitems();
    totalord();
    fetchdrivers();
    fetchmyorder();
  }

  Future<void> fetchorderhistory() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    const String formatted = '2025-02-01';

    FirebaseFirestore.instance
        .collection('orders')
        // .where("user_id", isEqualTo: userdata['phone_number'].toString())
        .where("status", isEqualTo: "Closed")
        .get()
        .then(
      (querySnapshot) {
        //print('length: ${querySnapshot.size}');
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          //print('str: $str');

          orders.MyOrders orderhistory = orders.MyOrders.fromJson(str);
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
    //print('length listorderhistory: ${listorderhistory.length}');
    Get.find<MyController>().orderhistory = listorderhistory;
  }

  Future<void> fetchcurrentorder() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    //const String formatted = '2025-02-01';

    FirebaseFirestore.instance
        .collection('orders')
        .where("order_date", isEqualTo: formatted)
        .where("status", isEqualTo: "Open")
        .get()
        .then(
      (querySnapshot) {
        //print('length: ${querySnapshot.size}');
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          //print('str: $str');

          orders.MyOrders ordercurrent = orders.MyOrders.fromJson(str);
          listordercurrent.add(ordercurrent);

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
    Get.find<MyController>().ordercurrentadmin = listordercurrent;
  }

  Future<void> fetchcancelorder() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    const String formatted = '2025-02-01';

    FirebaseFirestore.instance
        .collection('orders')
        // .where("user_id", isEqualTo: userdata['phone_number'].toString())
        .where("status", isEqualTo: "Cancelled")
        .get()
        .then(
      (querySnapshot) {
        //print('length: ${querySnapshot.size}');
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          //print('str: $str');

          orders.MyOrders listordercancel = orders.MyOrders.fromJson(str);
          listordercancelled.add(listordercancel);

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
    //print('listordercancelled: ${listordercancelled.length}');
    Get.find<MyController>().ordercanceledadmin = listordercancelled;
  }

  Future<void> fetchmyorder() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    const String formatted = '2025-02-01';
    print(userdata['phone_number']);

    FirebaseFirestore.instance
        .collection('orders')
        // .where("user_id", isEqualTo: userdata['phone_number'].toString())
        .where("driver_phone", isEqualTo: userdata['phone_number'])
        .orderBy("status")
        .get()
        .then(
      (querySnapshot) {
        //print('length: ${querySnapshot.size}');
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          //print('str: $str');

          orders.MyOrders listorders = orders.MyOrders.fromJson(str);
          listmyorders.add(listorders);

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
    //print('listordercancelled: ${listordercancelled.length}');
    Get.find<MyController>().allmyorders = listmyorders;
  }

  Future<void> fetchdrivers() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    // const String formatted = '2025-02-01';

    FirebaseFirestore.instance
        .collection('drivers')
        // .where("user_id", isEqualTo: userdata['phone_number'].toString())
        // .where("active", isEqualTo: true)
        .get()
        .then(
      (querySnapshot) {
        //print('length: ${querySnapshot.size}');
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          print('str: $str');

          Driver listdriversactive = Driver.fromJson(str);
          listdrivers.add(listdriversactive);

          print("listdrivers length: ${listdrivers.length}");
          // MyOrders myorder = MyOrders.fromJson(docSnapshot as Map<String, dynamic>);

          // listFoodSource.add(foodsource);
          // for (var element in orderhistory.items!) {
          //   print('order: ${element.price}');
          // }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print('listordercancelled: ${listordercancelled.length}');
    Get.find<MyController>().driveractiveadmin = listdrivers;
  }

  Future totalord() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    await FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: "Closed")
        .count()
        .get()
        .then(
          (res) => setState(() {
            totalorders = res.count;
          }),
          onError: (e) => print("Error completing: $e"),
        );

    FirebaseFirestore.instance
        .collection('orders')
        .where("status", isEqualTo: "Closed")
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          orders.MyOrders orderh = orders.MyOrders.fromJson(str);
          sumorders = (sumorders! + orderh.total_amount!);
          //print('total_amount: ${orderh.total_amount}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    await FirebaseFirestore.instance
        .collection("orders")
        .where("order_date", isEqualTo: formatted)
        .count()
        .get()
        .then(
          (res) => setState(() {
            todaysorders = res.count;
          }),
          onError: (e) => print("Error completing: $e"),
        );
    await FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: "Cancelled")
        .count()
        .get()
        .then(
          (res) => setState(() {
            cancelledorders = res.count;
          }),
          onError: (e) => print("Error completing: $e"),
        );

    //print('todaysorders A: $todaysorders');
    //print('sum b: $sumorders');
    categoryImage = [
      {
        'url': 'lib/assets/images/food/pexels-sydney-troxell-223521-708488.jpg',
        'title': 'Earnings',
        'icon': Icons.currency_rupee_sharp,
        'value': sumorders,
        'color': Colors.green
      },
      {
        'url': 'lib/assets/images/food/pexels-chanwalrus-1059943.jpg',
        'title': 'Orders Delivered',
        'icon': Icons.shopping_basket_outlined,
        'value': totalorders,
        'color': Colors.blue
      },
      {
        'url': 'lib/assets/images/food/pexels-asphotograpy-103566.jpg',
        'title': 'Today' 's Orders',
        'icon': Icons.today_rounded,
        'value': todaysorders,
        'color': Colors.orange
      },
      {
        'url': 'lib/assets/images/food/pexels-marvin-ozz-1297854-2474658.jpg',
        'title': 'Reviews',
        'icon': Icons.remove_shopping_cart_rounded,
        'value': cancelledorders,
        'color': Colors.red
      },
    ];
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
                              addHorizontalSpace(16),
                              GestureDetector(
                                child: Icon(
                                  Icons.delivery_dining_outlined,
                                  size: 35,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                onTap: () {
                                  _navigationService.pushNamed("/mydeliveries");
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
                                  _navigationService.pushNamed("/searchorder");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const HorizontalCouponExample2(),
                      addVerticalSpace(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: _deviceWidth * .9,
                            height: _deviceHeight * .45,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: categoryImage.length,
                              controller:
                                  ScrollController(keepScrollOffset: true),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      //childAspectRatio: 22 / 30,
                                      // childAspectRatio: _deviceHeight / 400,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1
                                      // childAspectRatio: 1,
                                      ),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: SizedBox(
                                    width: _deviceWidth / 2,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: _deviceWidth * .4,
                                          width: _deviceWidth * .45,
                                          child: GestureDetector(
                                            onTap: () {
                                              switch (categoryImage[index]
                                                  ['title']) {
                                                case 'Earnings':
                                                  setState(() {
                                                    flagearnings = true;
                                                    flagtodayord = false;
                                                    flagtotcancel = false;
                                                    flagtotord = false;
                                                  });
                                                  break;
                                                case 'Orders Delivered':
                                                  setState(() {
                                                    flagearnings = false;
                                                    flagtodayord = false;
                                                    flagtotcancel = false;
                                                    flagtotord = true;
                                                  });
                                                  break;
                                                case 'Todays Orders':
                                                  setState(() {
                                                    flagearnings = false;
                                                    flagtodayord = true;
                                                    flagtotcancel = false;
                                                    flagtotord = false;
                                                  });
                                                  break;
                                                case 'Reviews':
                                                  setState(() {
                                                    flagearnings = false;
                                                    flagtodayord = false;
                                                    flagtotcancel = true;
                                                    flagtotord = false;
                                                  });
                                                  break;
                                                default:
                                              }
                                            },
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
                                                shadowColor:
                                                    categoryImage[index]
                                                        ['color'],
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child:
                                                    // Image.network(
                                                    //   fooditem.imageurl1!,
                                                    //   fit: BoxFit.cover,
                                                    // ),
                                                    Column(
                                                  children: [
                                                    Icon(
                                                      categoryImage[index]
                                                          ['icon'],
                                                      size: 40,
                                                      color:
                                                          categoryImage[index]
                                                              ['color'],
                                                    ),
                                                    Text(categoryImage[index]
                                                            ['value']
                                                        .toString()),
                                                    Text(categoryImage[index]
                                                        ['title'])
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    print(categoryImage[index]['title']);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const MySeparator(color: Colors.green, dashwidth: 5),
                      addVerticalSpace(8),

                      flagearnings
                          ? const SizedBox(
                              child: Column(
                              children: [
                                Text(
                                  'Earnings',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ))
                          : Container(),
                      flagtotord
                          ? Column(
                              children: [
                                const Text(
                                  'Orders Delivered',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: _deviceHeight * .7,
                                  child: ToggleList(
                                    divider: const SizedBox(height: 10),
                                    toggleAnimationDuration:
                                        const Duration(milliseconds: 400),
                                    //scrollPosition: AutoScrollPosition.begin,
                                    trailing: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.expand_more),
                                    ),
                                    children: List.generate(
                                      listorderhistory.length,
                                      (index) => ToggleListItem(
                                        leading: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons
                                                .shopping_cart_checkout_rounded,
                                            color: Colors.green,
                                          ),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listorderhistory[index]
                                                    .order_id!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(fontSize: 17),
                                              ),
                                              Text(
                                                '+91 ${listorderhistory[index].user_id!}',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                'Total Rs.${listorderhistory[index].total_amount.toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        divider: const Divider(
                                          color: Colors.white,
                                          height: 2,
                                          thickness: 2,
                                        ),
                                        content: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              bottom: Radius.circular(20),
                                            ),
                                            color: appColor.withOpacity(0.5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // const SizedBox(
                                              //   height: 8,
                                              // ),
                                              SizedBox(
                                                // margin: const EdgeInsets.symmetric(vertical: 10),
                                                height: cartshow
                                                    ? (listorderhistory[index]
                                                            .items!
                                                            .length) *
                                                        90
                                                    : 120,
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const MySeparator(
                                                                color: Colors
                                                                    .green),
                                                    // ListView.builder(
                                                    itemCount:
                                                        listorderhistory[index]
                                                            .items!
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int ind) {
                                                      orders.Order order =
                                                          listorderhistory[
                                                                  index]
                                                              .items![ind];
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 80,
                                                            width: 80,
                                                            child: Card(
                                                              semanticContainer:
                                                                  true,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              elevation: 5,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    order.url!,
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  // width: _deviceWidth,
                                                                  // height: _deviceHeight * .28,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    image: DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                          ),
                                                          // addVerticalSpace(10),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      '${order.title!} x ${order.qty!} Nos'),

                                                                  // const Padding(
                                                                  //     padding: EdgeInsets
                                                                  //         .symmetric(
                                                                  //             vertical:
                                                                  //                 2.0)),
                                                                  const Text(
                                                                    'Per item',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.0),
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              1.0)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        'Rs. ${order.price!}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),

                                              const SizedBox(
                                                height: 8,
                                              ),
                                              const Divider(
                                                color: Colors.white,
                                                height: 2,
                                                thickness: 2,
                                              ),
                                              OverflowBar(
                                                alignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.find<MyController>()
                                                              .ordercurrent =
                                                          listorderhistory[
                                                              index];
                                                      _navigationService
                                                          .pushNamed(
                                                              '/orderviewdriver');
                                                    },
                                                    child: const Column(
                                                      children: [
                                                        Icon(Icons.edit,
                                                            color:
                                                                Colors.black),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        Text(
                                                          'VIEW',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // TextButton(
                                                  //   onPressed: () {},
                                                  //   child: const Column(
                                                  //     children: [
                                                  //       Icon(
                                                  //           Icons
                                                  //               .delete_outline_outlined,
                                                  //           color:
                                                  //               Colors.black),
                                                  //       Padding(
                                                  //         padding: EdgeInsets
                                                  //             .symmetric(
                                                  //                 vertical:
                                                  //                     2.0),
                                                  //       ),
                                                  //       Text(
                                                  //         'Cancel',
                                                  //         style: TextStyle(
                                                  //             color:
                                                  //                 Colors.black),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        onExpansionChanged:
                                            _expansionChangedCallback,
                                        headerDecoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        expandedHeaderDecoration:
                                            const BoxDecoration(
                                          color: appColor,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      flagtodayord
                          ? Column(
                              children: [
                                const Text(
                                  'Todays Orders',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: _deviceHeight * .7,
                                  child: ToggleList(
                                    divider: const SizedBox(height: 10),
                                    toggleAnimationDuration:
                                        const Duration(milliseconds: 400),
                                    //scrollPosition: AutoScrollPosition.begin,
                                    trailing: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.expand_more),
                                    ),
                                    children: List.generate(
                                      listordercurrent.length,
                                      (index) => ToggleListItem(
                                        leading: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons
                                                .shopping_cart_checkout_rounded,
                                            color: Colors.green,
                                          ),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listordercurrent[index]
                                                    .order_id!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(fontSize: 17),
                                              ),
                                              Text(
                                                '+91 ${listordercurrent[index].user_id!}',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                'Total Rs.${listordercurrent[index].total_amount.toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        divider: const Divider(
                                          color: Colors.white,
                                          height: 2,
                                          thickness: 2,
                                        ),
                                        content: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              bottom: Radius.circular(20),
                                            ),
                                            color: appColor.withOpacity(0.5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // const SizedBox(
                                              //   height: 8,
                                              // ),
                                              SizedBox(
                                                // margin: const EdgeInsets.symmetric(vertical: 10),
                                                // height: _deviceHeight * .45,
                                                height: cartshow
                                                    ? (listordercurrent[index]
                                                            .items!
                                                            .length) *
                                                        90
                                                    : 120,
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const MySeparator(
                                                                color: Colors
                                                                    .green),
                                                    // ListView.builder(
                                                    itemCount:
                                                        listordercurrent[index]
                                                            .items!
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int ind) {
                                                      orders.Order order =
                                                          listordercurrent[
                                                                  index]
                                                              .items![ind];
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 80,
                                                            width: 80,
                                                            child: Card(
                                                              semanticContainer:
                                                                  true,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              elevation: 5,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    order.url!,
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  // width: _deviceWidth,
                                                                  // height: _deviceHeight * .28,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    image: DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                          ),
                                                          // addVerticalSpace(10),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      '${order.title!} x ${order.qty!} Nos'),

                                                                  // const Padding(
                                                                  //     padding: EdgeInsets
                                                                  //         .symmetric(
                                                                  //             vertical:
                                                                  //                 2.0)),
                                                                  const Text(
                                                                    'Per item',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.0),
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              1.0)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        'Rs. ${order.price!}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),

                                              const SizedBox(
                                                height: 8,
                                              ),
                                              const Divider(
                                                color: Colors.white,
                                                height: 2,
                                                thickness: 2,
                                              ),
                                              OverflowBar(
                                                alignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.find<MyController>()
                                                              .ordercurrent =
                                                          listordercurrent[
                                                              index];
                                                      _navigationService
                                                          .pushNamed(
                                                              '/orderviewdriver');
                                                    },
                                                    child: const Column(
                                                      children: [
                                                        Icon(Icons.edit,
                                                            color:
                                                                Colors.black),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        Text(
                                                          'UPDATE',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: const Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            color:
                                                                Colors.black),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        onExpansionChanged:
                                            _expansionChangedCallback,
                                        headerDecoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        expandedHeaderDecoration:
                                            const BoxDecoration(
                                          color: appColor,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      flagtotcancel
                          ? Column(
                              children: [
                                const Text(
                                  'Reviews',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: _deviceHeight * .7,
                                  child: ToggleList(
                                    divider: const SizedBox(height: 10),
                                    toggleAnimationDuration:
                                        const Duration(milliseconds: 400),
                                    //scrollPosition: AutoScrollPosition.begin,
                                    trailing: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.expand_more),
                                    ),
                                    children: List.generate(
                                      listordercancelled.length,
                                      (index) => ToggleListItem(
                                        leading: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons
                                                .shopping_cart_checkout_rounded,
                                            color: Colors.green,
                                          ),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listordercancelled[index]
                                                    .order_id!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(fontSize: 17),
                                              ),
                                              Text(
                                                '+91 ${listordercancelled[index].user_id!}',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                'Total Rs.${listordercancelled[index].total_amount.toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        divider: const Divider(
                                          color: Colors.white,
                                          height: 2,
                                          thickness: 2,
                                        ),
                                        content: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              bottom: Radius.circular(20),
                                            ),
                                            color: appColor.withOpacity(0.5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // const SizedBox(
                                              //   height: 8,
                                              // ),
                                              SizedBox(
                                                // margin: const EdgeInsets.symmetric(vertical: 10),
                                                height: cartshow
                                                    ? (listordercancelled[index]
                                                            .items!
                                                            .length) *
                                                        90
                                                    : 120,
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const MySeparator(
                                                                color: Colors
                                                                    .green),
                                                    // ListView.builder(
                                                    itemCount:
                                                        listordercancelled[
                                                                index]
                                                            .items!
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int ind) {
                                                      orders.Order order =
                                                          listordercancelled[
                                                                  index]
                                                              .items![ind];
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 80,
                                                            width: 80,
                                                            child: Card(
                                                              semanticContainer:
                                                                  true,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              elevation: 5,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    order.url!,
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  // width: _deviceWidth,
                                                                  // height: _deviceHeight * .28,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    image: DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                          ),
                                                          // addVerticalSpace(10),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      '${order.title!} x ${order.qty!} Nos'),

                                                                  // const Padding(
                                                                  //     padding: EdgeInsets
                                                                  //         .symmetric(
                                                                  //             vertical:
                                                                  //                 2.0)),
                                                                  const Text(
                                                                    'Per item',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10.0),
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              1.0)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        'Rs. ${order.price!}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),

                                              const SizedBox(
                                                height: 8,
                                              ),
                                              const Divider(
                                                color: Colors.white,
                                                height: 2,
                                                thickness: 2,
                                              ),
                                              OverflowBar(
                                                alignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.find<MyController>()
                                                              .ordercurrent =
                                                          listordercancelled[
                                                              index];
                                                      _navigationService
                                                          .pushNamed(
                                                              '/orderviewdriver');
                                                    },
                                                    child: const Column(
                                                      children: [
                                                        Icon(Icons.edit,
                                                            color:
                                                                Colors.black),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        Text(
                                                          'VIEW',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // TextButton(
                                                  //   onPressed: () {},
                                                  //   child: const Column(
                                                  //     children: [
                                                  //       Icon(
                                                  //           Icons
                                                  //               .delete_outline_outlined,
                                                  //           color:
                                                  //               Colors.black),
                                                  //       Padding(
                                                  //         padding: EdgeInsets
                                                  //             .symmetric(
                                                  //                 vertical:
                                                  //                     2.0),
                                                  //       ),
                                                  //       Text(
                                                  //         'Cancel',
                                                  //         style: TextStyle(
                                                  //             color:
                                                  //                 Colors.black),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        onExpansionChanged:
                                            _expansionChangedCallback,
                                        headerDecoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        expandedHeaderDecoration:
                                            const BoxDecoration(
                                          color: appColor,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(10), // Image radius
              child: Image.asset(
                  'lib/assets/images/admin/navigation bar/icone.png',
                  fit: BoxFit.contain),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(10), // Image radius
                child: Image.asset(
                    'lib/assets/images/admin/navigation bar/barger menu.png',
                    fit: BoxFit.contain),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _navigationService.pushNamed('/addnewitem');
            },
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(10), // Image radius
                child: Image.asset('lib/assets/images/user/icones/add.png',
                    fit: BoxFit.contain),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(10), // Image radius
                child: Image.asset(
                    'lib/assets/images/admin/navigation bar/notification.png',
                    fit: BoxFit.contain),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(10), // Image radius
                child: Image.asset(
                    'lib/assets/images/admin/navigation bar/profile.png',
                    fit: BoxFit.contain),
              ),
            ),
          ),
        ],
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

  void _expansionChangedCallback(int index, bool newValue) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       'Changed expansion status of item  no.${index + 1} to ${newValue ? "expanded" : "shrunk"}.',
    //     ),
    //   ),
    // );
    setState(() {
      cartshow = !cartshow;
    });
  }
}
