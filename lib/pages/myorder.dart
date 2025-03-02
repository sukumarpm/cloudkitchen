import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:input_quantity/input_quantity.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  late double _deviceHeight;
  late double _deviceWidth;
  late double quantity = 1.00;
  late double priceperpiece = 20.00;
  double total = 0;
  List results1 = [];
  List results = [];
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  final MyController c = Get.put(MyController());
  List listImages = [];

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    listImages = c.profiledata['order_history'];
    results = listImages;
    print('listImages:$listImages');

    setResults('');
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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
                    (results.isNotEmpty)
                        ? Column(
                            children: [
                              addVerticalSpace(10),
                              Column(
                                children: [
                                  Container(
                                    color: const Color(0xffE3EBF2),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          // margin: const EdgeInsets.symmetric(vertical: 10),
                                          height: _deviceHeight * .40,
                                          child: ListView.separated(
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const MySeparator(
                                                          color: Colors.green),
                                              // ListView.builder(
                                              itemCount: results.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 100,
                                                          width: _deviceWidth *
                                                              .40,
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
                                                                  results[index]
                                                                      ['url'],
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
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(results[index]
                                                                ['title']),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            2.0)),
                                                            const Text(
                                                              'Per item',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.0),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            1.0)),
                                                            Text(
                                                              'Rs. ${results[index]['price']}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14.0),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    'Qty: ${results[index]['qty']}'),
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
                                              width: _deviceWidth * .8,
                                              height: 40,
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(),
                                                color: Colors.transparent,
                                              ),
                                              child: ElevatedButton(
                                                  child: const Text("REORDER"),
                                                  onPressed: () {
                                                    Get.find<MyController>()
                                                            .cartList =
                                                        c.profiledata[
                                                            'order_history'];
                                                    // const GetSnackBar(
                                                    //   title: 'Nice!',
                                                    //   message:
                                                    //       'Old order has been reloaded.',
                                                    //   icon: Icon(Icons.refresh),
                                                    //   duration: Duration(seconds: 3),
                                                    // );
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const AlertDialog(
                                                            title:
                                                                Text('Nice!'),
                                                            content: Text(
                                                                'Old order has been reloaded.'),
                                                          );
                                                        });
                                                    _navigationService
                                                        .pushNamed("/cart");
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
                          )
                        : SizedBox(
                            height: _deviceHeight * .8,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void setResults(String query) {
    results1 = results.where((elem) => elem['title'] != query).toList();
    print('in set results: ${results1.toString()}');
    total = 0;
    setState(() {
      for (var val in results1) {
        total += double.parse(val['price']) * val['qty'];
      }
      results = results1;
    });
  }
}
