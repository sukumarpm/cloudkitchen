import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
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

class SearchFood extends StatefulWidget {
  const SearchFood({super.key});

  @override
  State<SearchFood> createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {
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
                      Row(
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
                                print('\nScore: ${r.score}\nTitle: ${r.item}');
                              }
                              print(_itemname);
                              setResults(searchkeyController.text);
                            },
                          ),
                        ],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Results',
                          ),
                          addVerticalSpace(8),
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
                                      crossAxisCount: 3,
                                      // childAspectRatio: 22 / 30,
                                      // childAspectRatio: _deviceHeight / 400,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1
                                      // childAspectRatio: 1,
                                      ),
                              itemBuilder: (BuildContext context, int index) {
                                FoodSource? fooditem = results[index];
                                return GestureDetector(
                                  child: SizedBox(
                                    width: _deviceWidth * .4,
                                    height: _deviceHeight * .35,
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
                                            child: CachedNetworkImage(
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
                                            ),
                                            // Image.network(
                                            //   fooditem.imageurl1!,
                                            //   fit: BoxFit.fill,
                                            // ),
                                          ),
                                        ),
                                        Text(
                                          fooditem.itemname!,
                                          style: textTheme.labelSmall,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'POPULAR FOOD',
                          ),
                          addVerticalSpace(8),
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
                                      crossAxisCount: 2,
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
                                          height: _deviceWidth / 3,
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
                                            child: CachedNetworkImage(
                                              imageUrl: fooditem.imageurl2!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            // Image.network(
                                            //   fooditem.imageurl2!,
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              // mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(fooditem.itemname!),
                                                Text('Rs.${fooditem.rate}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
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

                      addVerticalSpace(16),
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
}
