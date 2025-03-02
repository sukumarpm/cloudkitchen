import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/HorizontalCouponExample2.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/fooddetails.dart';
import 'package:cloud_kitchen_2/pages/mydrawer.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart' as orders;
import 'package:cloud_kitchen_2/pages/myorders.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/pages/offers1.dart';
import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:intl/intl.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:input_quantity/input_quantity.dart';

class DeliveryHome extends StatefulWidget {
  const DeliveryHome({super.key});

  @override
  State<DeliveryHome> createState() => _DeliveryHomeState();
}

class _DeliveryHomeState extends State<DeliveryHome> {
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
  List<orders.MyOrders> resultsb = [];
  List<orders.MyOrders> resultsa = [];
  List<FoodSource> listFoodSource = [];
  List<FoodSource> filteredFoodSource = [];
  List<MyOrders> listorderhistory = [];
  String searchcategory = 'All';
  List data = List.empty();
  late Map<dynamic, dynamic> userdata;
  late String userWork;
  late int activeStep = 2;
  double total = 0;
  late List favourites;
  late List<Cartlists> fullCartList;
  List categoryImage = [
    {
      'url': 'lib/assets/images/food/pexels-sydney-troxell-223521-708488.jpg',
      'title': 'Today',
      'price': '120.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-chanwalrus-1059943.jpg',
      'title': 'Month',
      'price': '85.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-asphotograpy-103566.jpg',
      'title': 'Revenue',
      'price': '90.00',
    },
    // {
    //   'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
    //   'title': 'Snacks',
    //   'price': '210.00',
    // },
    {
      'url': 'lib/assets/images/food/pexels-marvin-ozz-1297854-2474658.jpg',
      'title': 'Reviews',
      'price': '210.00',
    },
  ];
  late List<orders.MyOrders> listImages;
  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _auth = _getIt.get<AuthService>();
    listFoodSource = c.allfooddata;
    setResults(searchcategory);
    print('c.profiledata:${c.profiledata}');
    // var address = c.profiledata['my_addresses'];
    if (c.profiledata['my_addresses'].isEmpty) {
      userWork = '';
    } else {
      userWork = c.profiledata['my_addresses'][0]['Work'] ?? '';
    }

    userdata = c.profiledata;
    fullCartList = c.fullcartList;
    fetchorderhistory();
    fetchcurrentorder();
    filterfavouriteitems();

    setState(() {
      resultsb = listImages;
      userdata = c.profiledata;
    });

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
    setState(() {
      listImages = listorderhistory;
    });

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
  }

  Future<bool> checkavail() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    QuerySnapshot resulta = await FirebaseFirestore.instance
        .collection('orders')
        .where("user_id", isEqualTo: userdata['phone_number'].toString())
        .where("status", isEqualTo: "Open")
        .get();
    final List<DocumentSnapshot> documents = resulta.docs;
    print('documents.isEmpty:${documents.isEmpty}');
    return documents.isNotEmpty;
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
                                      },
                                    );
                                  })),
                        ],
                      ),
                      const MySeparator(color: Colors.green),
                      addVerticalSpace(8),
                      SizedBox(
                        height: _deviceHeight * .9,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomScrollView(
                                  slivers: [
                                    const SliverToBoxAdapter(
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Today' 's Order'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    for (int i = 0; i < listImages.length; i++)
                                      SliverPadding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        sliver: SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              childCount: listImages[i]
                                                  .items!
                                                  .length, //extend by 1 for header
                                              (context, index) {
                                            List<orders.Order> orderhist =
                                                listImages[i].items!;
                                            return index == 0
                                                ? Column(
                                                    children: [
                                                      (orderhist.isNotEmpty)
                                                          ? DottedBorder(
                                                              borderType:
                                                                  BorderType
                                                                      .RRect,
                                                              radius:
                                                                  const Radius
                                                                      .circular(
                                                                      24),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(12),
                                                              dashPattern: const <double>[
                                                                4,
                                                                1
                                                              ],
                                                              strokeWidth: 1,
                                                              child: Column(
                                                                children: [
                                                                  addVerticalSpace(
                                                                      10),
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        color: const Color(
                                                                            0xffE3EBF2),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              // margin: const EdgeInsets.symmetric(vertical: 10),
                                                                              height: _deviceHeight * .30,
                                                                              child: Expanded(
                                                                                child: ListView.separated(
                                                                                    separatorBuilder: (BuildContext context, int index) => const MySeparator(color: Colors.green),
                                                                                    // ListView.builder(
                                                                                    itemCount: orderhist.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      orders.Order order = orderhist[index];
                                                                                      return Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: 128 / 1.5,
                                                                                                width: 128,
                                                                                                child: Card(
                                                                                                  semanticContainer: true,
                                                                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                  ),
                                                                                                  elevation: 5,
                                                                                                  margin: const EdgeInsets.all(10),
                                                                                                  child: CachedNetworkImage(
                                                                                                    imageUrl: order.url!,
                                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                                      // width: _deviceWidth,
                                                                                                      // height: _deviceHeight * .28,
                                                                                                      decoration: BoxDecoration(
                                                                                                        shape: BoxShape.rectangle,
                                                                                                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                                                      ),
                                                                                                    ),
                                                                                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                                                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              // addVerticalSpace(10),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(order.title!),
                                                                                                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                                                                                                  const Text(
                                                                                                    'Per item',
                                                                                                    style: TextStyle(fontSize: 10.0),
                                                                                                  ),
                                                                                                  const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                                                                                                  Text(
                                                                                                    'Rs. ${order.price}',
                                                                                                    style: const TextStyle(fontSize: 14.0),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      Text('Qty: ${order.qty}'),
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              // Column(
                                                                                              //   mainAxisAlignment:
                                                                                              //       MainAxisAlignment.start,
                                                                                              //   children: [
                                                                                              //     GestureDetector(
                                                                                              //       child: Icon(
                                                                                              //         Icons
                                                                                              //             .delete_forever_rounded,
                                                                                              //         size: 35,
                                                                                              //         color:
                                                                                              //             Theme.of(context)
                                                                                              //                 .colorScheme
                                                                                              //                 .tertiary,
                                                                                              //       ),
                                                                                              //       onTap: () {
                                                                                              //         setResults(
                                                                                              //             results[index]
                                                                                              //                 ['title']);
                                                                                              //       },
                                                                                              //     ),
                                                                                              //   ],
                                                                                              // ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    }),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    const Text(
                                                                                      'Order status:',
                                                                                      style: TextStyle(fontWeight: FontWeight.w700),
                                                                                    ),
                                                                                    Text(' ${listImages[i].status}'),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Stack(
                                                                              alignment: Alignment.bottomCenter,
                                                                              children: <Widget>[
                                                                                // Padding(
                                                                                //   padding: const EdgeInsets.only(
                                                                                //       top: 12.0),
                                                                                //   child: SizedBox(
                                                                                //     height: 170,
                                                                                //     child: Card(
                                                                                //       shape: RoundedRectangleBorder(
                                                                                //         borderRadius:
                                                                                //             BorderRadius.circular(
                                                                                //                 20),
                                                                                //       ),
                                                                                //       color:
                                                                                //           const Color(0xffE3EBF2),
                                                                                //       margin: const EdgeInsets.all(
                                                                                //         16,
                                                                                //       ),
                                                                                //       child: Row(
                                                                                //         mainAxisAlignment:
                                                                                //             MainAxisAlignment
                                                                                //                 .spaceAround,
                                                                                //         children: [
                                                                                //           Text(
                                                                                //             'Rs.$total + Other Chharges',
                                                                                //             style: textTheme
                                                                                //                 .titleLarge,
                                                                                //           ),
                                                                                //         ],
                                                                                //       ),
                                                                                //     ),
                                                                                //   ),
                                                                                // ),
                                                                                Container(
                                                                                  width: _deviceWidth * .4,
                                                                                  height: 40,
                                                                                  decoration: const ShapeDecoration(
                                                                                    shape: RoundedRectangleBorder(),
                                                                                    color: Colors.transparent,
                                                                                  ),
                                                                                  child: ElevatedButton(
                                                                                      child: const Text("REORDER"),
                                                                                      onPressed: () async {
                                                                                        List<Cartlists> cart = [];
                                                                                        for (var element in orderhist) {
                                                                                          cart.add(Cartlists(title: element.title, price: element.price, qty: element.qty, url: element.url));
                                                                                        }
                                                                                        Get.find<MyController>().fullcartList = cart;
                                                                                        // const GetSnackBar(
                                                                                        //   title: 'Nice!',
                                                                                        //   message:
                                                                                        //       'Old order has been reloaded.',
                                                                                        //   icon: Icon(Icons.refresh),
                                                                                        //   duration: Duration(seconds: 3),
                                                                                        // );
                                                                                        if (await checkavail()) {
                                                                                          // _navigationService.pushNamed("/home");
                                                                                          if (context.mounted) {
                                                                                            /// statements after async gap without warning
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return const AlertDialog(
                                                                                                    title: Text('Oops!'),
                                                                                                    content: Text('You have an existing order.'),
                                                                                                  );
                                                                                                });
                                                                                          }
                                                                                          print('Exist1');
                                                                                        } else {
                                                                                          _navigationService.pushNamed("/cart");
                                                                                        }
                                                                                        // showDialog(
                                                                                        //     context: context,
                                                                                        //     builder: (BuildContext context) {
                                                                                        //       return const AlertDialog(
                                                                                        //         title: Text('Nice!'),
                                                                                        //         content: Text('Old order has been reloaded.'),
                                                                                        //       );
                                                                                        //     });
                                                                                        // _navigationService
                                                                                        //     .pushNamed("/cart");
                                                                                      }),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  addVerticalSpace(
                                                                      16),
                                                                ],
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              height:
                                                                  _deviceHeight *
                                                                      .8,
                                                              child:
                                                                  const Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                      'Order History is empty'),
                                                                  Icon(
                                                                    Icons
                                                                        .hourglass_empty,
                                                                    size: 80,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                    ],
                                                  )
                                                : Container();
                                          }),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 1,
                      spreadRadius: -20,
                      offset: Offset(1.0, 0.0),
                    )
                  ],
                  color: Color(0xffF6F8FA),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                      onTap: () {},
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(10), // Image radius
                          child: Image.asset(
                              'lib/assets/images/user/icones/add.png',
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
    favourites = userdata['favourites'];
    // print('favourites: $favourites');
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
