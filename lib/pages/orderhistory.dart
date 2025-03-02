import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart' as orders;
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  late double _deviceHeight;
  late double _deviceWidth;
  late double quantity = 1.00;
  late double priceperpiece = 20.00;
  double total = 0;
  List<orders.MyOrders> results1 = [];
  List<orders.MyOrders> results = [];
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  final MyController c = Get.put(MyController());
  late List<orders.MyOrders> listImages;
  late Map<dynamic, dynamic> userdata;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    listImages = c.orderhistory;
    results = listImages;
    userdata = c.profiledata;
    print('listImages:$listImages');

    // setResults('');
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
        body: SafeArea(
      child: 
      Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
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
                                    _navigationService.pushNamed("/home");
                                  },
                                ),
                              ),
                            ),
                            addHorizontalSpace(15),
                            const Text('Order History Details'),
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
                          List<orders.Order> orderhist = listImages[i].items!;
                          return index == 0
                              ? Column(
                                  children: [
                                    (orderhist.isNotEmpty)
                                        ? DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(24),
                                            padding: const EdgeInsets.all(12),
                                            dashPattern: const <double>[4, 1],
                                            strokeWidth: 1,
                                            child: Column(
                                              children: [
                                                addVerticalSpace(10),
                                                Column(
                                                  children: [
                                                    Container(
                                                      color: const Color(
                                                          0xffE3EBF2),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            // margin: const EdgeInsets.symmetric(vertical: 10),
                                                            height:
                                                                _deviceHeight *
                                                                    .30,
                                                            child: Expanded(
                                                              child: ListView
                                                                  .separated(
                                                                      separatorBuilder: (BuildContext context,
                                                                              int
                                                                                  index) =>
                                                                          const MySeparator(
                                                                              color: Colors
                                                                                  .green),
                                                                      // ListView.builder(
                                                                      itemCount:
                                                                          orderhist
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        orders
                                                                            .Order
                                                                            order =
                                                                            orderhist[index];
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
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Text(
                                                                    'Order status:',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                  Text(
                                                                      ' ${listImages[i].status}'),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Stack(
                                                            alignment: Alignment
                                                                .bottomCenter,
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
                                                                width:
                                                                    _deviceWidth *
                                                                        .4,
                                                                height: 40,
                                                                decoration:
                                                                    const ShapeDecoration(
                                                                  shape:
                                                                      RoundedRectangleBorder(),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                child:
                                                                    ElevatedButton(
                                                                        child: const Text(
                                                                            "REORDER"),
                                                                        onPressed:
                                                                            () async {
                                                                          List<Cartlists>
                                                                              cart =
                                                                              [];
                                                                          for (var element
                                                                              in orderhist) {
                                                                            cart.add(Cartlists(
                                                                                title: element.title,
                                                                                price: element.price,
                                                                                qty: element.qty,
                                                                                url: element.url));
                                                                          }
                                                                          Get.find<MyController>().fullcartList =
                                                                              cart;
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
                                                addVerticalSpace(16),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: _deviceHeight * .8,
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text('Order History is empty'),
                                                Icon(
                                                  Icons.hourglass_empty,
                                                  size: 80,
                                                  color: Colors.green,
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
    ));
  }

  // void setResults(String query) {
  //   results1 = results.where((elem) => elem.title != query).toList();
  //   print('in set results: ${results1.toString()}');
  //   total = 0;
  //   setState(() {
  //     for (var val in results1) {
  //       total += double.parse(val.price!) * val.qty!;
  //     }
  //     results = results1;
  //   });
  // }
}
