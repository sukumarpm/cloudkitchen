import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/driverclass.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/mydisplay.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart' as orders;
import 'package:cloud_kitchen_2/pages/vendorclass.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grouped_checkbox/grouped_checkbox.dart';
import 'package:choice/choice.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';

class OrderViewAdmin extends StatefulWidget {
  const OrderViewAdmin({super.key});

  @override
  State<OrderViewAdmin> createState() => _OrderViewAdminState();
}

class _OrderViewAdminState extends State<OrderViewAdmin> {
  late double _deviceHeight;
  late double _deviceWidth;
  String? _itemname;
  String? _itemdescrption;
  bool isPickUp = false;
  bool isDelivery = true;
  List<String> choices = ['All', 'Breakfast', 'Lunch', 'Dinner'];
  String? selectedValue;
  final String _selectedValuesJson = 'Nothing to show';
  List<VendorSource> listVendorSource = [];
  List<Driver> listdrivers = [];
  late List<Ingredient> _selectedIngredients;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  final MyController c = Get.put(MyController());
  late orders.MyOrders listCarts;
  double subtotal = 0;
  double total = 0;
  double deliverycharge = 20.00;
  double promodiscount = 5.00;
  late String _mySelection = '';
  late GoogleMapController mapController;
  late LatLng _currentPosition;
  late LatLng _userPosition;
  late bool _isLoading = true;
  late LatLng location;
  late String userWork;
  late bool nouserlocation = true;
  late bool cartshow = false;
  List categoryImage = [
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Rahim',
      'phone': '+91 64719 14564',
      'bikenum': 'BH61HY9873',
    },
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Sundar',
      'phone': '+91 33433 36547',
      'bikenum': 'BH61HY9873',
    },
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Arvi',
      'phone': '+91 24556 36547',
      'bikenum': 'BH61HY9873',
    },
    // {
    //   'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
    //   'title': 'Snacks',
    //   'price': '+91 64734 36547',
    // },
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Senthil',
      'phone': '+91 64719 88888',
      'bikenum': 'BH61HY9873',
    },
  ];

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
  }

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _selectedIngredients = [];
    listCarts = c.ordercurrent;
    listVendorSource = c.allvendordata;
    listdrivers = c.driveractiveadmin;
    late VendorSource vendorSource;
    for (var element in listVendorSource) {
      // if (element['active']) {
      vendorSource = element;
      if (kDebugMode) {
        print('vendorSource.active: ${vendorSource.active}');
        print('vendorSource.active: ${vendorSource.address}');
        print('vendorSource.active: ${vendorSource.discount}');
        print('vendorSource.active: ${vendorSource.location}');
        print('vendorSource.active: ${vendorSource.name}');
      }
      // }
    }
    getLocation();
    setResults('');
    List address = c.profiledata['my_addresses'];
    List locations = c.profiledata['my_locations'];
    //print(double.parse(c.profiledata['my_locations'][0]));
    if (address.isNotEmpty) {
      userWork = c.profiledata['my_addresses'][0]['Work'];
    } else {
      userWork = '';
    }
    if (locations.isNotEmpty) {
      userWork = c.profiledata['my_addresses'][0]['Work'];
    } else {
      userWork = '';
    }

    List location = c.profiledata['my_locations'];
    if (address.isEmpty) {
      nouserlocation = true;
    } else {
      _userPosition =
          LatLng(double.parse(location[0]), double.parse(location[1]));
    }
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void dispose() {
    _selectedIngredients.clear();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    final VendorSource vendorSource = listVendorSource[0];
    _currentPosition = LatLng(double.parse(vendorSource.location[0]),
        double.parse(vendorSource.location[1]));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        10), // Image radius
                                    child: Image.asset(
                                        'lib/assets/images/user/icones/left arrow.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                onTap: () {
                                  _navigationService.goBack();
                                },
                              ),
                              addHorizontalSpace(15),
                              const Text('Current Order'),
                            ],
                          ),
                        ],
                      ),
                      addVerticalSpace(16.0),
                      DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          padding: const EdgeInsets.all(6),
                          color: Colors.green.shade700,
                          child: MyDisplay(
                            size: 16,
                            color: Colors.black,
                            text1: 'Order Status',
                            text2: listCarts.status!,
                          )),
                      addVerticalSpace(16.0),
                      const MyDisplay(
                        size: 14,
                        color: Colors.black,
                        text1: 'FOOD DETAILS',
                        text2: '',
                      ),
                      const MySeparator(
                        height: 1,
                        color: Colors.black45,
                        dashwidth: 2,
                      ),
                      SizedBox(
                        height:
                            cartshow ? (listCarts.items!.length + 1) * 90 : 120,
                        child: ToggleList(
                            toggleAnimationDuration:
                                const Duration(milliseconds: 1000),
                            children: [
                              ToggleListItem(
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
                                        listCarts.order_id!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 12),
                                      ),
                                      Text(
                                        '+91 ${listCarts.user_id}',
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Total Rs.${listCarts.total_amount.toString()}',
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
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(20),
                                    ),
                                    color: Colors.green.shade200,
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
                                        height: listCarts.items!.length * 120,
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    const MySeparator(
                                                        color: Colors.green),
                                            // ListView.builder(
                                            itemCount: listCarts.items!.length,
                                            itemBuilder: (BuildContext context,
                                                int ind) {
                                              orders.Order order =
                                                  listCarts.items![ind];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 80,
                                                    width: 80,
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
                                                        imageUrl: order.url!,
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
                                                                fontSize: 10.0),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          1.0)),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Rs. ${order.price!}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14.0),
                                                              ),
                                                              addHorizontalSpace(
                                                                  20),
                                                              listCarts.status ==
                                                                      'Open'
                                                                  ? Row(
                                                                      children: [
                                                                        InputQty.double(
                                                                            messageBuilder: (minVal, maxVal, value) {
                                                                              if (value! > 12) {
                                                                                return const Text(
                                                                                  "Reach my limit",
                                                                                  style: TextStyle(color: Colors.red),
                                                                                  textAlign: TextAlign.center,
                                                                                );
                                                                              }
                                                                              return null;
                                                                            },
                                                                            onQtyChanged: (val) {
                                                                              print(val);
                                                                              order.qty = val;
                                                                              setResults('');
                                                                            },
                                                                            maxVal: 12,
                                                                            initVal: order.qty!.round(),
                                                                            minVal: 1,
                                                                            decoration: const QtyDecorationProps(isBordered: false, btnColor: Colors.black26, iconColor: Colors.grey, borderShape: BorderShapeBtn.circle, width: 12)),
                                                                      ],
                                                                    )
                                                                  : Container(),
                                                              // GestureDetector(
                                                              //   child: Icon(
                                                              //     Icons
                                                              //         .delete_forever_rounded,
                                                              //     size: 35,
                                                              //     color: Theme.of(
                                                              //             context)
                                                              //         .colorScheme
                                                              //         .tertiary,
                                                              //   ),
                                                              //   onTap: () {
                                                              //     setResults(order
                                                              //         .title!);
                                                              //     showDialog(
                                                              //         context:
                                                              //             context,
                                                              //         builder:
                                                              //             (BuildContext
                                                              //                 context) {
                                                              //           return const AlertDialog(
                                                              //             title: Text(
                                                              //                 'Info!'),
                                                              //             content:
                                                              //                 Text('Item has been removed from your cart.'),
                                                              //           );
                                                              //         });
                                                              //   },
                                                              // ),
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
                                      // Text(
                                      //   '${listorderhistory[index].items![0].title}',
                                      //   style: Theme.of(context).textTheme.bodyLarge,
                                      // ),
                                    ],
                                  ),
                                ),
                                onExpansionChanged: _expansionChangedCallback,
                                headerDecoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                expandedHeaderDecoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'DELIVERY BOY',
                            style: GoogleFonts.sen(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 9, 0, 0),
                                    fontSize: 14)),
                          ),
                          addVerticalSpace(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text('Drivers'),
                              addHorizontalSpace(8),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: DropdownButton(
                                  focusColor: Colors.black26,
                                  dropdownColor: Colors.green.shade200,
                                  items: listdrivers.map((value) {
                                    return DropdownMenuItem(
                                      value: value.phone,
                                      child: Text(
                                        '${value.name}(${value.phone})',
                                        style: const TextStyle(),
                                      ),
                                    );
                                  }).toList(),
                                  value: _mySelection.isNotEmpty
                                      ? _mySelection
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _mySelection = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VENDOR DETAILS',
                                style: GoogleFonts.sen(
                                    textStyle: const TextStyle(
                                        color: Color.fromARGB(255, 9, 0, 0),
                                        fontSize: 14)),
                              ),
                              addVerticalSpace(15),
                              Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              MyDisplay(
                                size: 16,
                                color: Colors.black,
                                text1: 'Vendor',
                                text2: listCarts.vendor!,
                              ),
                              addVerticalSpace(16),
                              Text(
                                'DELIVERY DETAILS',
                                style: GoogleFonts.sen(
                                    textStyle: const TextStyle(
                                        color: Color.fromARGB(255, 9, 0, 0),
                                        fontSize: 14)),
                              ),
                              addVerticalSpace(15),
                              const MySeparator(
                                height: 1,
                                color: Colors.black45,
                                dashwidth: 2,
                              ),
                              !isPickUp
                                  ? Column(
                                      children: [
                                        MyDisplay(
                                          text1: c.profiledata['name'],
                                          text2: '',
                                          color: Colors.black,
                                        ),
                                        MyDisplay(
                                          text1:
                                              '+91 ${c.profiledata['phone_number']}',
                                          text2: '',
                                          color: Colors.black45,
                                          size: 12,
                                        ),
                                        const MyDisplay(
                                          text1: 'Address',
                                          text2: '',
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Wrap(children: <Widget>[
                                              Text(
                                                userWork,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                // textDirection: TextDirection.rtl,
                                                // textAlign: TextAlign.justify,
                                              ),
                                            ]),
                                          ),
                                        ),
                                        // MyDisplay(
                                        //     text1: userWork,
                                        //     text2: '',
                                        //     color: Colors.black45,
                                        //     size: 12),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        const MyDisplay(
                                          text1: 'Pickup Address',
                                          text2: '',
                                          color: Colors.black,
                                        ),
                                        MyDisplay(
                                            text1: vendorSource.address!,
                                            text2: '',
                                            color: Colors.black45,
                                            size: 12),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    color: Color(0xFFDFDFDF)),
                                                left: BorderSide(
                                                    color: Color(0xFFDFDFDF)),
                                                right: BorderSide(
                                                    color: Color(0xFF7F7F7F)),
                                                bottom: BorderSide(
                                                    color: Color(0xFF7F7F7F)),
                                              ),
                                            ),
                                            child: GoogleMap(
                                              onMapCreated: _onMapCreated,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: _currentPosition,
                                                zoom: 16.0,
                                              ),
                                              markers: {
                                                Marker(
                                                    markerId: const MarkerId(
                                                        'Your Location'),
                                                    position: _currentPosition,
                                                    onTap: () {
                                                      debugPrint('Tapped');
                                                    },
                                                    draggable: true,
                                                    onDragEnd:
                                                        ((LatLng newPosition) {
                                                      print(
                                                          '${newPosition.latitude}');
                                                      print(
                                                          '${newPosition.longitude}');
                                                    }),
                                                    onDrag: (value) {
                                                      print('Dragging:$value');
                                                    },
                                                    infoWindow: const InfoWindow(
                                                        title:
                                                            'Drag to update the location',
                                                        snippet:
                                                            'Drag to update the location')),
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),

                          const MySeparator(
                            height: 1,
                            color: Colors.black45,
                            dashwidth: 2,
                          ),
                          addVerticalSpace(5),
                          // SizedBox(
                          //   height: 150,
                          //   child: ListView.separated(
                          //     // <-- SEE HERE
                          //     itemCount: categoryImage.length,
                          //     itemBuilder: (context, index) {
                          //       return ListTile(
                          //         // leading: CircleAvatar(
                          //         //   backgroundColor: const Color.fromARGB(255, 87, 87, 87),
                          //         //   radius: 26,
                          //         //   child: Text("Rs.${categoryImage.getCategory(index)}",
                          //         //       style: const TextStyle(
                          //         //           fontSize: 12, color: Colors.yellow)),
                          //         // ),
                          //         leading: ClipOval(
                          //           child:
                          //               // (categoryImage.getImage(index) != "")
                          //               //     ?
                          //               // Image.network(
                          //               //     categoryImage.getImage(index),
                          //               //     width: 90,
                          //               //     height: 70,
                          //               //     fit: BoxFit.cover,
                          //               //   )

                          //               CachedNetworkImage(
                          //             imageUrl: categoryImage[index]['url'],
                          //             imageBuilder: (context, imageProvider) =>
                          //                 Container(
                          //               width: 80.0,
                          //               height: 100.0,
                          //               decoration: BoxDecoration(
                          //                 shape: BoxShape.circle,
                          //                 image: DecorationImage(
                          //                     image: imageProvider,
                          //                     fit: BoxFit.cover),
                          //               ),
                          //             ),
                          //             placeholder: (context, url) =>
                          //                 const CircularProgressIndicator(),
                          //             errorWidget: (context, url, error) =>
                          //                 const Icon(Icons.error),
                          //           ),
                          //           // : Image.asset(
                          //           //     'lib/assets/Images/mic1.png',
                          //           //   ),
                          //         ),
                          //         title: Text(categoryImage[index]['name']),
                          //         subtitle: Text(categoryImage[index]['phone']),
                          //         trailing: Row(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             GestureDetector(
                          //               child: const Text('ASSIGN'),
                          //               onTap: () {
                          //                 Driver driverinfo = Driver(
                          //                     name: categoryImage[index]
                          //                         ['name'],
                          //                     phone: categoryImage[index]
                          //                         ['phone'],
                          //                     bikenum: categoryImage[index]
                          //                         ['bikenum'],
                          //                     url: categoryImage[index]['url']);
                          //                 Get.find<MyController>()
                          //                     .driverdetails = driverinfo;
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //     separatorBuilder: (context, index) {
                          //       // <-- SEE HERE
                          //       return const MySeparator(color: Colors.green);
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      addVerticalSpace(8),

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

                      addVerticalSpace(16),
                      // SizedBox(
                      //   width: _deviceWidth * .8,
                      //   child: ElevatedButton(
                      //       child: const Text("CONFIRM"),
                      //       onPressed: () {
                      //         Get.find<MyController>().finalprice =
                      //             total.toString();
                      //         _navigationService.pushNamed("/adminhome");
                      //       }),
                      // ),
                      SizedBox(
                        width: _deviceWidth * .8,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    listCarts.status == 'Open'
                                        ? Colors.green
                                        : Colors.grey)),
                            onPressed: listCarts.status == 'Open'
                                ? () {
                                    Get.find<MyController>().finalprice =
                                        total.toString();
                                    _navigationService.pushNamed("/adminhome");
                                  }
                                : () {},
                            child: Text(
                              "CONFIRM",
                              style: TextStyle(
                                  color: listCarts.status == 'Open'
                                      ? Colors.black
                                      : Colors.white),
                            )),
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

  Widget buildCheck() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Checkbox(
                tristate: false,
                fillColor: const WidgetStatePropertyAll<Color>(
                    Color.fromARGB(255, 248, 251, 244)),
                value: isPickUp,
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.0, color: Colors.black54),
                ),
                checkColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    isPickUp = value!;
                  });
                },
              ),
              const Text(
                'Pick Up',
                style: TextStyle(color: Color(0xFF9C9BA6)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                tristate: false,
                checkColor: Colors.black,
                fillColor: const WidgetStatePropertyAll<Color>(
                    Color.fromARGB(255, 248, 251, 244)),
                value: isDelivery,
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.0, color: Colors.black54),
                ),
                onChanged: (bool? value) {
                  setState(() {
                    isDelivery = value!;
                  });
                },
              ),
              const Text(
                'Deliver',
                style: TextStyle(color: Color(0xFF9C9BA6)),
              ),
            ],
          ),
        ],
      );

  void setResults(String query) {
    subtotal = 0;
    setState(() {
      // for (var val in listCarts) {
      //   subtotal += double.parse(val.price!) * val.qty!;
      // }
      total = listCarts.total_amount!;
    });
  }

  void _expansionChangedCallback(int index, bool newValue) {
    setState(() {
      cartshow = !cartshow;
    });
    // );
  }
}

class ColorItem {
  String name;
  Color color;

  ColorItem(this.name, this.color);
}

/// Mocks fetching language from network API with delay of 500ms.
Future<List<Ingredient>> getIngredients(String query) async {
  await Future.delayed(const Duration(milliseconds: 500), null);
  return <Ingredient>[
    const Ingredient(name: 'Rice', position: 1),
    const Ingredient(name: 'Chicken', position: 2),
    const Ingredient(name: 'Muuton', position: 3),
    const Ingredient(name: 'Beaf', position: 4),
    const Ingredient(name: 'Fish', position: 5),
    const Ingredient(name: 'Garam Masala', position: 6),
  ]
      .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

/// Ingredient Class
class Ingredient extends Taggable {
  ///
  final String name;

  ///
  final int position;

  /// Creates Ingredient
  const Ingredient({
    required this.name,
    required this.position,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $name,\n
    "position": $position\n
  }''';
}
