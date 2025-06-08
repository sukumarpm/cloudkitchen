import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
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

class OrderActive extends StatefulWidget {
  const OrderActive({super.key});

  @override
  State<OrderActive> createState() => _OrderActiveState();
}

class _OrderActiveState extends State<OrderActive> {
  late double _deviceHeight;
  late double _deviceWidth;
  late double quantity = 1.00;
  late double priceperpiece = 20.00;
  double total = 0;
  late List<Cartlists> results1 = [];
  late List<Cartlists> results = [];
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  final MyController c = Get.put(MyController());
  List listImages = [];
  late List<Cartlists> fullCartList;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    //listImages = c.cartList;
    fullCartList = c.fullcartList;
    for (var element in fullCartList) {
      print('listImages. in cart:${element.title}');
    }
    results = c.fullcartList;
    print('listImages:$fullCartList');

    setResults('');
  }

  @override
  void dispose() {
    super.dispose();
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
                            const Text('Cart Details'),
                          ],
                        ),
                      ],
                    ),
                    (fullCartList.isNotEmpty)
                        ? Column(
                            children: [
                              addVerticalSpace(10),
                              Column(
                                children: [
                                  SizedBox(
                                    // margin: const EdgeInsets.symmetric(vertical: 10),
                                    height: _deviceHeight * .55,
                                    child: ListView.separated(
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const MySeparator(
                                                    color: Colors.green),
                                        // ListView.builder(
                                        itemCount: fullCartList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Cartlists cartItem =
                                              fullCartList[index];
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 130,
                                                    width: _deviceWidth * .40,
                                                    child: Card(
                                                      semanticContainer: true,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      elevation: 5,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        imageUrl: cartItem.url!,
                                                        imageBuilder: (context,
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
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                  addHorizontalSpace(10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(cartItem.title!),
                                                      const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0)),
                                                      const Text(
                                                        'Per item',
                                                        style: TextStyle(
                                                            fontSize: 10.0),
                                                      ),
                                                      const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      1.0)),
                                                      Text(
                                                        'Rs. ${cartItem.price!}',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              'Qty:${cartItem.qty!.round()}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14.0)),
                                                          // InputQty.double(
                                                          //     messageBuilder:
                                                          //         (minVal,
                                                          //             maxVal,
                                                          //             value) {
                                                          //       if (value! >
                                                          //           12) {
                                                          //         return const Text(
                                                          //           "Reach my limit",
                                                          //           style: TextStyle(
                                                          //               color: Colors
                                                          //                   .red),
                                                          //           textAlign:
                                                          //               TextAlign
                                                          //                   .center,
                                                          //         );
                                                          //       }
                                                          //       return null;
                                                          //     },
                                                          //     // onQtyChanged:
                                                          //     //     (val) {
                                                          //     //   print(
                                                          //     //       'va: $val');
                                                          //     //   cartItem.qty =
                                                          //     //       val;
                                                          //     //   setResults('');
                                                          //     // },
                                                          //     onQtyChanged:
                                                          //         (value) {},
                                                          //     maxVal: 12,
                                                          //     initVal: cartItem
                                                          //         .qty!
                                                          //         .round(),
                                                          //     minVal: 1,
                                                          //     decoration: const QtyDecorationProps(
                                                          //         isBordered:
                                                          //             false,
                                                          //         btnColor: Colors
                                                          //             .black26,
                                                          //         iconColor:
                                                          //             Colors
                                                          //                 .grey,
                                                          //         borderShape:
                                                          //             BorderShapeBtn
                                                          //                 .circle,
                                                          //         width: 12)),
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
                                                  //             cartItem.title!);
                                                  //         showDialog(
                                                  //             context: context,
                                                  //             builder:
                                                  //                 (BuildContext
                                                  //                     context) {
                                                  //               return const AlertDialog(
                                                  //                 title: Text(
                                                  //                     'Info!'),
                                                  //                 content: Text(
                                                  //                     'Item has been removed from your cart.'),
                                                  //               );
                                                  //             });
                                                  //       },
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              ),
                              addVerticalSpace(16),
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: SizedBox(
                                      height: 170,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        color: const Color(0xffE3EBF2),
                                        margin: const EdgeInsets.all(
                                          14,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Amount(Tax Exclusive) Rs.$total',
                                              style: textTheme.labelLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: _deviceWidth * .8,
                                    height: 60,
                                    decoration: const ShapeDecoration(
                                      shape: RoundedRectangleBorder(),
                                      color: Colors.transparent,
                                    ),
                                    child: ElevatedButton(
                                        child: const Text("CHECK STATUS"),
                                        onPressed: () {
                                          _navigationService
                                              .pushNamed("/ordertracking");
                                        }),
                                  )
                                ],
                              ),
                            ],
                          )
                        : SizedBox(
                            height: _deviceHeight * .8,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Cart is empty'),
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
    results1 = results.where((elem) => elem.title != query).toList();
    print('in set results: ${results1.toString()}');
    print('in set results: $query');
    //   total = 0;
    //   setState(() {
    //     for (var val in results) {
    //       Cartlists cartItem = val;
    //       total += double.parse(cartItem.price) * cartItem.qty;
    //     }
    //     results = results1;
    //   });
    // }
    total = 0;
    setState(() {
      for (var val in results) {
        total += double.parse(val.price!) * val.qty!;
      }
      results = results1;
      fullCartList = results;
    });
  }
}
