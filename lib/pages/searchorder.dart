import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart' as orders;
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:toggle_list/toggle_list.dart';

class SearchOrder extends StatefulWidget {
  const SearchOrder({super.key});

  @override
  State<SearchOrder> createState() => _SearchOrderState();
}

class _SearchOrderState extends State<SearchOrder> {
  late double _deviceHeight;
  late double _deviceWidth;
  late double quantity = 1.00;
  late double priceperpiece = 20.00;
  late NavigationService _navigationService;
  String _itemname = '';
  final GetIt _getIt = GetIt.instance;
  String? searchkey = '';
  final TextEditingController searchkeyController = TextEditingController();
  List<FoodSource> results1 = [];
  List<FoodSource> results = [];
  final MyController c = Get.put(MyController());
  List<FoodSource> listFoodSource = [];
  late bool flagtodayord = false;
  List<orders.MyOrders> listorders = [];
  final _additemkey = GlobalKey<FormState>();
  List listImages = [
    {
      'url': 'lib/assets/images/food/pexels-sydney-troxell-223521-708488.jpg',
      'title': 'Chicken 65',
      'price': '120.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-chanwalrus-1059943.jpg',
      'title': 'Mutton Fry',
      'price': '85.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-chanwalrus-1059943.jpg',
      'title': 'Mutton Curry',
      'price': '85.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-asphotograpy-103566.jpg',
      'title': 'Rice with Curd',
      'price': '90.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
      'title': 'Liver Fry',
      'price': '210.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
      'title': 'Chicken Fry',
      'price': '210.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-janetrangdoan-1128678.jpg',
      'title': 'Special Meals',
      'price': '75.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-marvin-ozz-1297854-2474658.jpg',
      'title': 'Our Fabulous Curry',
      'price': '80.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-asphotograpy-103566.jpg',
      'title': 'Rice with Curd',
      'price': '45.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
      'title': 'Liver Fry',
      'price': '60.00',
    },
    {
      'url': 'lib/assets/images/food/pexels-janetrangdoan-1128678.jpg',
      'title': 'Special Meals',
      'price': '100.00',
    },
  ];

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    listFoodSource = c.allfooddata;
  }

  Future<void> findorder(String phone) async {
    print('phone:$phone');
    listorders = [];
    await FirebaseFirestore.instance
        .collection('orders')
        .where("user_id", isEqualTo: phone)
        // .where("status", isEqualTo: "Closed")
        .get()
        .then(
      (querySnapshot) {
        //print('length: ${querySnapshot.size}');
        for (var docSnapshot in querySnapshot.docs) {
          final str = docSnapshot.data();
          //print('str: $str');

          orders.MyOrders orderhistory = orders.MyOrders.fromJson(str);

          listorders.add(orderhistory);

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
    print('length listorders: ${listorders.length}');
    setState(() {
      flagtodayord = true;
    });
    Get.find<MyController>().orderhistory = listorders;
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: GestureDetector(
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          10), // Image radius
                                      child: Image.asset(
                                          'lib/assets/images/user/icones/left arrow.png',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  onTap: () {
                                    _navigationService.goBack();
                                  },
                                ),
                              ),
                              addHorizontalSpace(15),
                              const Text('Search'),
                            ],
                          ),
                        ],
                      ),
                      Form(
                        key: _additemkey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: _deviceWidth * .35,
                                    child: CustomFormField(
                                      onSaved: (value) {
                                        print('search: $value');
                                        setState(() {
                                          _itemname = value;
                                        });
                                      },
                                      regEx: r".{3,}",
                                      hintText: "Example 'Fry'",
                                      initialValue: null,
                                      obscureText: false,
                                      height: _deviceHeight * .1,
                                      keytype: TextInputType.visiblePassword,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: const Text('APPLY'),
                              onTap: () async {
                                _additemkey.currentState!.save();
                                print('_itemname:$_itemname');
                                await findorder(_itemname);
                                final fuse = Fuzzy(
                                  listImages,
                                  options: FuzzyOptions(
                                    findAllMatches: true,
                                    tokenize: true,
                                    threshold: 0.5,
                                  ),
                                );
                                final result = fuse.search(_itemname);

                                print(
                                    'A score of 0 indicates a perfect match, while a score of 1 indicates a complete mismatch.');

                                for (var r in result) {
                                  print(
                                      '\nScore: ${r.score}\nTitle: ${r.item}');
                                }
                                print(_itemname);
                                setResults(searchkeyController.text);
                              },
                            ),
                          ],
                        ),
                      ),
                      // SearchBarAnimation(
                      //   textEditingController: searchkeyController,
                      //   searchBoxWidth: MediaQuery.of(context).size.width * .9,
                      //   isOriginalAnimation: true,
                      //   enableKeyboardFocus: true,
                      //   hintText: 'Type to search',
                      //   durationInMilliSeconds: 500,
                      //   onChanged: () {},
                      //   onFieldSubmitted: () {},
                      //   isSearchBoxOnRightSide: false,
                      //   onEditingComplete: () {
                      //     // if (kDebugMode) {
                      //     //   print('onChanged');
                      //     // }
                      //   },
                      //   onExpansionComplete: () {
                      //     debugPrint(
                      //         'do something just after searchbox is opened.');
                      //   },
                      //   onCollapseComplete: () {
                      //     debugPrint(
                      //         'do something just after searchbox is closed.');
                      //   },
                      //   onPressButton: (isSearchBarOpens) {
                      //     // setState(() {
                      //     //   viaEmail = false;
                      //     // });
                      //     debugPrint(
                      //         'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
                      //   },
                      //   trailingWidget: GestureDetector(
                      //     child: const Icon(
                      //       Icons.search,
                      //       size: 18,
                      //       color: Colors.black,
                      //     ),
                      //     onTap: () async {
                      //       // final fuse = Fuzzy(
                      //       //   listImages,
                      //       //   options: FuzzyOptions(
                      //       //     findAllMatches: true,
                      //       //     tokenize: true,
                      //       //     threshold: 0.5,
                      //       //   ),
                      //       // );
                      //       // final result =
                      //       //     fuse.search(searchkeyController.text);

                      //       // print(
                      //       //     'A score of 0 indicates a perfect match, while a score of 1 indicates a complete mismatch.');

                      //       // for (var r in result) {
                      //       //   print(
                      //       //       '\nScore: ${r.score}\nTitle: ${r.item}');
                      //       // }
                      //       print(searchkeyController.text);
                      //       setResults(searchkeyController.text);
                      //     },
                      //   ),
                      //   secondaryButtonWidget: const Icon(
                      //     Icons.close,
                      //     size: 14,
                      //     color: Colors.black,
                      //   ),
                      //   buttonWidget: GestureDetector(
                      //     child: const Icon(
                      //       Icons.search,
                      //       size: 14,
                      //       color: Colors.black,
                      //     ),
                      //     onTap: () {
                      //       setState(() {
                      //         searchkey = '';
                      //       });
                      //     },
                      //   ),
                      // ),
                      addVerticalSpace(16),
                      listorders.isNotEmpty
                          ? Column(
                              children: [
                                const Text(
                                  'Todays Orders',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: _deviceHeight * .5,
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
                                      listorders.length,
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
                                                listorders[index].order_id!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(fontSize: 17),
                                              ),
                                              Text(
                                                '+91 ${listorders[index].user_id!}',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                'Total Rs.${listorders[index].total_amount.toString()}',
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
                                            color:
                                                Colors.green.withOpacity(0.5),
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
                                                height: _deviceHeight * .45,
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const MySeparator(
                                                                color: Colors
                                                                    .green),
                                                    // ListView.builder(
                                                    itemCount: listorders[index]
                                                        .items!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int ind) {
                                                      orders.Order order =
                                                          listorders[index]
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
                                                          listorders[index];
                                                      _navigationService
                                                          .pushNamed(
                                                              '/orderviewadmin');
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
                                          color: Colors.black38,
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
                          : SizedBox(
                            height: _deviceHeight*.6,
                            child: const Center(
                                child: Text('No orders found'),
                              ),
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
    results1 = listFoodSource
        .where((elem) =>
            elem.itemname
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            elem.itemdescription
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    print('in set results: ${results1[0].itemname}');
    setState(() {
      results = results1;
    });
  }

  void _expansionChangedCallback(int index, bool newValue) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       'Changed expansion status of item  no.${index + 1} to ${newValue ? "expanded" : "shrunk"}.',
    //     ),
    //   ),
    // );
  }
}
