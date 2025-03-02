import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/mydisplay.dart';
import 'package:cloud_kitchen_2/pages/vendorclass.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:url_launcher/url_launcher.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
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
  late List<Ingredient> _selectedIngredients;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  final MyController c = Get.put(MyController());
  List<Cartlists> listCarts = [];
  double subtotal = 0;
  double total = 0;
  double deliverycharge = 20.00;
  double promodiscount = 5.00;
  late GoogleMapController mapController;
  late LatLng _currentPosition;
  late LatLng _userPosition;
  late bool _isLoading = true;
  late LatLng location;
  late String userWork;
  late bool nouserlocation = true;

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
  }

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _selectedIngredients = [];
    listCarts = c.fullcartList;
    listVendorSource = c.allvendordata;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              const Text('Order Summary'),
                            ],
                          ),
                        ],
                      ),
                      addVerticalSpace(16.0),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRICING',
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
                          addVerticalSpace(5),
                          MyDisplay(
                            size: 16,
                            color: Colors.black,
                            text1: 'Subtotal',
                            text2: subtotal.toString(),
                          ),
                          MyDisplay(
                            size: 16,
                            color: Colors.grey,
                            text1: 'Delivery Fees',
                            text2: deliverycharge.toString(),
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
                                        regEx: r".{4,}",
                                        hintText: "QU873bT",
                                        initialValue: null,
                                        obscureText: false,
                                        height: _deviceHeight * .1,
                                        keytype: TextInputType.visiblePassword,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Text('APPLY'),
                            ],
                          ),
                          MyDisplay(
                            size: 16,
                            color: Colors.grey,
                            text1: 'Promo/Discount',
                            text2: promodiscount.toString(),
                          ),
                          addVerticalSpace(5),
                          Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          MyDisplay(
                            size: 16,
                            color: Colors.black,
                            text1: 'total',
                            text2: total.toString(),
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
                          Row(
                            children: [
                              SizedBox(
                                width: _deviceWidth * .40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    print("DOOR DELIVERY");
                                    setState(() {
                                      isPickUp = !isPickUp;
                                      isDelivery = !isDelivery;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                      width: isDelivery ? 2.0 : 1.0,
                                      color: isDelivery
                                          ? Colors.green
                                          : Colors.black12,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'DOOR DELIVERY',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                              addHorizontalSpace(8.0),
                              SizedBox(
                                width: _deviceWidth * .3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    print("PICK UP");
                                    setState(() {
                                      isPickUp = !isPickUp;
                                      isDelivery = !isDelivery;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                      width: isPickUp ? 2.0 : 1.0,
                                      color: isPickUp
                                          ? Colors.green
                                          : Colors.black12,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'PICK UP',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(8),
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: _deviceWidth * .9,
                                        child: CustomFormField(
                                          onSaved: (value) {
                                            setState(() {
                                              _itemname = value;
                                            });
                                          },
                                          regEx: r".{4,}",
                                          hintText: "update address",
                                          initialValue: null,
                                          obscureText: false,
                                          height: _deviceHeight * .1,
                                          keytype:
                                              TextInputType.visiblePassword,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                        child: !nouserlocation
                                            ? GoogleMap(
                                                onMapCreated: _onMapCreated,
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: _userPosition,
                                                  zoom: 16.0,
                                                ),
                                                markers: {
                                                  Marker(
                                                      markerId: const MarkerId(
                                                          'Your Location'),
                                                      position: _userPosition,
                                                      onTap: () {
                                                        debugPrint('Tapped');
                                                        openMap(
                                                            _userPosition
                                                                .latitude,
                                                            _userPosition
                                                                .longitude);
                                                      },
                                                      draggable: true,
                                                      onDragEnd: ((LatLng
                                                          newPosition) {
                                                        print(
                                                            '${newPosition.latitude}');
                                                        print(
                                                            '${newPosition.longitude}');
                                                      }),
                                                      onDrag: (value) {
                                                        print(
                                                            'Dragging:$value');
                                                      },
                                                      infoWindow: const InfoWindow(
                                                          title:
                                                              'Drag to update the location',
                                                          snippet:
                                                              'Drag to update the location')),
                                                },
                                              )
                                            : const Text(
                                                'User location unavailable'),
                                      ),
                                    ),
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
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                          initialCameraPosition: CameraPosition(
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

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const MyDisplay(
                            text1: 'Delivery Instructions',
                            text2: '',
                            color: Colors.black,
                          ),
                          addVerticalSpace(5),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Wrap(children: <Widget>[
                                Text(
                                  'Include flat name, road or any specific landmark that may guide the rider.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  // textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.justify,
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                              width: _deviceWidth * .9,
                              height: _deviceHeight * .1,
                              child: TextFormField(
                                onSaved: (value) => (value) {
                                  setState(() {
                                    _itemdescrption = value;
                                  });
                                },
                                cursorColor: Colors.green,
                                initialValue: null,
                                style: const TextStyle(color: Colors.black),
                                obscureText: false,
                                expands: false,
                                maxLines: 8,
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  return RegExp(r".{15,}").hasMatch(value!)
                                      ? null
                                      : 'Enter a valid value.';
                                },
                                decoration: InputDecoration(
                                  fillColor: const Color(0xffE3EBF2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Item Description',
                                  hintStyle: const TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ))
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
                      SizedBox(
                        width: _deviceWidth * .8,
                        child: ElevatedButton(
                            child: const Text("CONFIRM & PAY NOW"),
                            onPressed: () {
                              Get.find<MyController>().finalprice =
                                  total.toString();
                              _navigationService.pushNamed("/gpay");
                            }),
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
      for (var val in listCarts) {
        subtotal += double.parse(val.price!) * val.qty!;
      }
      total = subtotal + deliverycharge + promodiscount;
    });
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
