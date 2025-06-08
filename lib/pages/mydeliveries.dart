import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart' as orders;
import 'package:cloud_kitchen_2/pages/myorders.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:cloud_kitchen_2/pages/exampleapppage.dart';

class MyDeliveries extends StatefulWidget {
  const MyDeliveries({super.key});

  @override
  State<MyDeliveries> createState() => _MyDeliveriesState();
}

class _MyDeliveriesState extends State<MyDeliveries> {
  late double _deviceWidth;
  late double _deviceHeight;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  late List<MyOrders> allmydeliveries;
  final MyController c = Get.put(MyController());
  late bool cartshow = false;
  late bool isdeliveryStarted = false;
  final Location location = Location();
  late String order_id = '';
  final databaseReference = FirebaseFirestore.instance;
  final Location _location = Location();
  LocationData? locationData;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    allmydeliveries = c.allmyorders;
    print('allmydeliveries length ${allmydeliveries.length}');
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(10), // Image radius
                                child: GestureDetector(
                                  child: Image.asset(
                                      'lib/assets/images/user/icones/left arrow.png',
                                      fit: BoxFit.contain),
                                  onTap: () {
                                    _navigationService.goBack();
                                  },
                                ),
                              ),
                            ),
                            addHorizontalSpace(15),
                            const Text('My Deliveries'),
                          ],
                        ),
                      ],
                    ),
                    allmydeliveries.isNotEmpty
                        ? Column(
                            children: [
                              const Text(
                                'My Orders',
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
                                    allmydeliveries.length,
                                    (index) => ToggleListItem(
                                      leading: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.shopping_cart_checkout_rounded,
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
                                              allmydeliveries[index].order_id!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(fontSize: 17),
                                            ),
                                            Text(
                                              '+91 ${allmydeliveries[index].user_id!}',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              'Total Rs.${allmydeliveries[index].total_amount.toString()}',
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
                                              //height: _deviceHeight * .45,
                                              height: cartshow
                                                  ? (allmydeliveries[index]
                                                          .items!
                                                          .length) *
                                                      90
                                                  : 120,
                                              child: ListView.separated(
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                              int index) =>
                                                          const MySeparator(
                                                              color:
                                                                  Colors.green),
                                                  // ListView.builder(
                                                  itemCount:
                                                      allmydeliveries[index]
                                                          .items!
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int ind) {
                                                    orders.Order order =
                                                        allmydeliveries[index]
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
                                              alignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.find<MyController>()
                                                            .ordercurrent =
                                                        allmydeliveries[index];
                                                    _navigationService
                                                        .pushNamed(
                                                            '/orderviewadmin');
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Column(
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
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            _deviceWidth * .4,
                                                        child: ElevatedButton(
                                                            child: const Text(
                                                                "START DELIVERY"),
                                                            onPressed: () {
                                                              order_id =
                                                                  allmydeliveries[
                                                                          index]
                                                                      .order_id!;
                                                              Get.find<MyController>()
                                                                          .deliveryDetails[
                                                                      'orderId'] =
                                                                  order_id;
                                                              startDelivery();
                                                            }),
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
                              SizedBox(
                                width: _deviceWidth * .8,
                                child: ElevatedButton(
                                    child: const Text("GO BACK"),
                                    onPressed: () {
                                      _navigationService.goBack();
                                    }),
                              ),
                            ],
                          )
                        : Container(),
                  ]))))
    ])));
  }

  void getCurrentLocation() async {
    try {
      LocationData currentLoc = await _location.getLocation();
      setState(() {
        locationData = currentLoc;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void startDelivery() {
    setState(() {
      isdeliveryStarted = true;
    });
    if (isdeliveryStarted) {
      _subscribeToLocationChanges();
      addOrderTracking(locationData!.latitude!, locationData!.longitude!);
    }
  }

  void _subscribeToLocationChanges() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (kDebugMode) {
        print(
            'current location: ${currentLocation.latitude},${currentLocation.longitude}');
      }
      updateOrderLocation(
          currentLocation.latitude!, currentLocation.longitude!);

      // location.enableBackgroundMode(enable: true);
      // enableBackgroundMode();
    });
  }

  Future<bool> enableBackgroundMode() async {
    bool bgModeEnabled = await location.isBackgroundModeEnabled();
    if (bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      print(bgModeEnabled); //True!
      return bgModeEnabled;
    }
  }

  Future<void> addOrderTracking(double latitude, double longitude) async {
    try {
      final DocumentSnapshot orderTrackingDoc = await databaseReference
          .collection('orderlocation')
          .doc(order_id)
          .get();
      if (orderTrackingDoc.exists) {
        databaseReference.collection('orderlocation').doc(order_id).update(
          {
            "latitude": latitude,
            "longitude": longitude,
          },
        );
      } else {
        databaseReference.collection('orderlocation').doc(order_id).set(
          {"latitude": latitude, "longitude": longitude, "order_id": order_id},
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> updateOrderLocation(double latitude, double longitude) async {
    print('order_id:$order_id, $latitude: $longitude');
    try {
      final DocumentSnapshot orderTrackingDoc = await databaseReference
          .collection('orderlocation')
          .doc(order_id)
          .get();

      if (orderTrackingDoc.exists) {
        var result = FirebaseFirestore.instance
            .collection('orderlocation')
            .doc(order_id)
            .update(
          {"latitude": latitude, "longitude": longitude},
        );

        // databaseReference.collection('orderlocation').doc(order_id).update(
        //   {
        //     "latitude": latitude,
        //     "longitude": longitude,
        //   },
        // );
      } else {
        databaseReference.collection('orderlocation').doc(order_id).set(
          {"latitude": latitude, "longitude": longitude, "order_id": order_id},
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
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
