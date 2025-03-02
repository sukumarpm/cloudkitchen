import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/likebutton.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:json_string/json_string.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({super.key});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);
  late double _deviceHeight;
  late double _deviceWidth;
  late double quantity = 1.00;
  late double priceperpiece = 20.00;
  final MyController c = Get.put(MyController());
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  List results1 = [];
  List results = [];
  late Cartlists cartItem;
  late FoodSource listImages;
  late List favourites;
  int? _value;
  late dynamic source;
  bool _isFavorite = false;
  late List<Cartlists> fullcartListL;
  late Map<dynamic, dynamic> userdata;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();

    // if (kDebugMode) {
    //   print('foodtitle:${c.fooddetails}');
    //   c.fooddetails.ingredients.map(
    //     (e) {
    //       print(e.name);
    //     },
    //   );
    // }
    listImages = c.fooddetails;
    userdata = c.profiledata;
    favourites = userdata['favourites'];
    fullcartListL = c.fullcartList;
    for (var element in fullcartListL) {
      print('listImages from cloud:${element.title}');
    }
    //print(favourites);
    // try {
    //   final jsonString = JsonString(listImages.ingredients);
    //   print(jsonString);
    //   // ...
    // } on JsonFormatException catch (e) {
    //   print('Invalid JSON format: $e');
    // }
    final ing = JsonString(listImages.ingredients);
    source = ing.decodedValue;
    _isFavorite = favourites.contains(listImages.itemname);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<bool> checkavail() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    QuerySnapshot resulta = await FirebaseFirestore.instance
        .collection('orders')
        .where("user_id", isEqualTo: userdata['phone_number'].toString())
        .where("status", isEqualTo: "Open")
        .where("order_date", isEqualTo: formatted)
        .get();
    final List<DocumentSnapshot> documents = resulta.docs;
    //print('documents.isEmpty:${documents.isEmpty}');
    return documents.isNotEmpty;
  }

  Future<void> addtocart() async {
    userdata['favourites'] = favourites;
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(userdata['phone_number'].toString())
        .set({
      "name": userdata['name'],
      "phone_number": userdata['phone_number'],
      "password": userdata['password'],
      "dob": userdata['dob'],
      "created_on": userdata['created_on'],
      "favourites": userdata['favourites'],
      "notifications": userdata['notifications'],
      "reviews": userdata['reviews'],
      "order_history": userdata['order_history'],
      "order_latest": userdata['order_latest'],
      "my_locations": userdata['my_locations'],
      "imageurl": userdata['imageurl'],
      "my_addresses": userdata['my_addresses'],
    });
    print('listImages.itemname:${listImages.itemname}');
    print('fullcartListL:$fullcartListL');
    for (var element in fullcartListL) {
      print('listImages before:${element.title}');
    }
    fullcartListL.removeWhere((item) => item.title == listImages.itemname);
    for (var element in fullcartListL) {
      print('listImages. after:${element.title}');
    }

    fullcartListL.add(Cartlists(
      title: listImages.itemname!,
      price: listImages.rate!,
      qty: quantity,
      url: listImages.imageurl1!,
    ));
    for (var element in fullcartListL) {
      print('listImages. after adding:${element.title}');
    }

    Get.find<MyController>().fullcartList = fullcartListL;
    _navigationService.pushNamed("/cart");
  }

  @override
  Widget build(BuildContext context) {
    //Map<String, dynamic> curritem = Get.arguments ?? '';
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(10), // Image radius
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
                              const Text('Details'),
                            ],
                          ),
                        ],
                      ),
                      addVerticalSpace(16.0),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // SizedBox(
                          //   height: _deviceHeight * .28,
                          //   width: _deviceWidth * .9,
                          //   child: Image.network(listImages.imageurl1!,
                          //       fit: BoxFit.fitWidth),
                          // ),
                          SizedBox(
                            height: _deviceHeight * .28,
                            child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: const EdgeInsets.all(5),
                                child:
                                    // Image.network(
                                    //   listImages.imageurl1!,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    CachedNetworkImage(
                                  imageUrl: listImages.imageurl1!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: _deviceWidth,
                                    height: _deviceHeight * .28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                          ),
                        ],
                      ),
                      addVerticalSpace(8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                listImages.itemname ?? '',
                                style: textTheme.headlineMedium
                                    ?.copyWith(fontSize: 20),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (!_isFavorite) {
                                    favourites.add(listImages.itemname);
                                  } else {
                                    favourites.remove(listImages.itemname);
                                  }

                                  favourites = favourites.toSet().toList();
                                  //print('favourites:$favourites');
                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                  _controller
                                      .reverse()
                                      .then((value) => _controller.forward());
                                },
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.7, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: _controller,
                                          curve: Curves.easeOut)),
                                  child: _isFavorite
                                      ? const Icon(
                                          Icons.favorite,
                                          size: 30,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.favorite_border,
                                          size: 30,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(10),
                          SizedBox(
                            child: Wrap(children: <Widget>[
                              Text(
                                listImages.itemdescription!,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                // textDirection: TextDirection.LTR,
                                textAlign: TextAlign.justify,
                              ),
                            ]),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text(
                          //     listImages.itemdescription ?? '',
                          //   ),
                          // ),
                        ],
                      ),
                      addVerticalSpace(10),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       c.fooddetails.ingredients[0],
                      //       style: textTheme.headlineLarge!.copyWith(
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.black),
                      //     ),
                      //   ],
                      // ),
                      addVerticalSpace(20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_border,
                                  size: 16,
                                ),
                                Text('4.7', style: textTheme.titleMedium),
                              ],
                            ),
                            addHorizontalSpace(_deviceWidth * .15),
                            Row(
                              children: [
                                const Icon(
                                  Icons.fire_truck_outlined,
                                  size: 16,
                                ),
                                Text('Free', style: textTheme.titleMedium),
                              ],
                            ),
                            addHorizontalSpace(_deviceWidth * .15),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 16,
                                ),
                                Text('20 min', style: textTheme.titleMedium),
                              ],
                            ),
                          ],
                        ),
                      ),
                      addVerticalSpace(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'INGREDIENTS',
                          ),
                          addVerticalSpace(8),
                          // Wrap(
                          //   children: List<Widget>.generate(
                          //     1,
                          //     (int idx) {
                          //       final ing = JsonString(listImages.ingredients);
                          //       print('later: $ing');
                          //       final source = ing.decodedValue;
                          //       return ChoiceChip(
                          //           label: Text(source["name"]),
                          //           selected: _value == idx,
                          //           onSelected: (bool selected) {
                          //             setState(() {
                          //               _value = (selected ? idx : null)!;
                          //             });
                          //           });
                          //     },
                          //   ).toList(),
                          // ),
                          SizedBox(
                            width: _deviceHeight * .8,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: source.length,
                              controller:
                                  ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      // childAspectRatio: 22 / 30,
                                      // childAspectRatio: _deviceHeight / 400,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1
                                      // childAspectRatio: 1,
                                      ),
                              itemBuilder: (BuildContext context, int index) {
                                // final ing = JsonString(listImages.ingredients);
                                // final source = ing.decodedValue;
                                return SizedBox(
                                    height: 40,
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.apartment_rounded,
                                          size: 16,
                                        ),
                                        Text(source[index]["name"]),
                                      ],
                                    ));
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
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     const Text(
                      //       'COMPLETE YOUR MEAL',
                      //     ),
                      //     Container(
                      //         margin: const EdgeInsets.symmetric(vertical: 10),
                      //         height: 150,
                      //         child: ListView.builder(
                      //             itemCount: listImages,
                      //             scrollDirection: Axis.horizontal,
                      //             itemBuilder:
                      //                 (BuildContext context, int index) {
                      //               int key = index;
                      //               return GestureDetector(
                      //                 child: SizedBox(
                      //                   width: _deviceWidth / 3,
                      //                   child: Column(
                      //                     children: [
                      //                       SizedBox(
                      //                         height: 120,
                      //                         child: Card(
                      //                           semanticContainer: true,
                      //                           clipBehavior:
                      //                               Clip.antiAliasWithSaveLayer,
                      //                           shape: RoundedRectangleBorder(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     10.0),
                      //                           ),
                      //                           elevation: 5,
                      //                           margin:
                      //                               const EdgeInsets.all(10),
                      //                           child: Image.asset(
                      //                             listImages[index]['url'],
                      //                             fit: BoxFit.cover,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       Text(listImages[index]['title'])
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 onTap: () {
                      //                   print(listImages[index]['title']);
                      //                 },
                      //               );
                      //             })),
                      //   ],
                      // ),

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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: const Color(0xffE3EBF2),
                                margin: const EdgeInsets.all(
                                  16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Rs.${quantity * double.parse(listImages.rate!)}',
                                      style: textTheme.titleLarge,
                                    ),
                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Row(
                                        children: [
                                          InputQty.double(
                                              onQtyChanged: (val) {
                                                //print(val);
                                                setState(() {
                                                  quantity = val;
                                                });
                                              },
                                              maxVal: 12,
                                              initVal: 1,
                                              minVal: 1,
                                              decoration:
                                                  const QtyDecorationProps(
                                                      isBordered: false,
                                                      btnColor: Colors.black26,
                                                      iconColor: Colors.grey,
                                                      borderShape:
                                                          BorderShapeBtn.circle,
                                                      width: 12)),
                                        ],
                                      ),
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
                                child: const Text("ADD TO CART"),
                                onPressed: () async {
                                  if (await checkavail()) {
                                    _navigationService.pushNamed("/home");
                                    if (context.mounted) {
                                      /// statements after async gap without warning
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              title: Text('Oops!'),
                                              content: Text(
                                                  'You have an existing order.'),
                                            );
                                          });
                                    }
                                    //print('Exist1');
                                  } else {
                                    await addtocart();
                                  }
                                }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setResults(String query) {
    results1 = listImages as List;
    print('in set results: ${results1.toString()}');
    setState(() {
      results = results1;
    });
  }
}
