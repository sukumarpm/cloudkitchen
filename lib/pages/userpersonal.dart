import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/mydisplay.dart';
import 'package:cloud_kitchen_2/pages/orderviewadmin.dart';
import 'package:cloud_kitchen_2/pages/vendorclass.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UserPersonalPage extends StatefulWidget {
  const UserPersonalPage({super.key});

  @override
  State<UserPersonalPage> createState() => _UserPersonalPageState();
}

class _UserPersonalPageState extends State<UserPersonalPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  String? _itemname;
  String? _itemdescrption;
  bool isHome = false;
  bool isWork = true;
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
  late String userHome;
  late String imageurl = '';
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
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
    // print(double.parse(c.profiledata['my_locations'][0]));
    if (address.isNotEmpty) {
      userHome = c.profiledata['my_addresses'][0]['Home'];
      userWork = c.profiledata['my_addresses'][0]['Work'];
    } else {
      userHome = '';
      userWork = '';
    }
    List location = c.profiledata['my_locations'];
    if (address.isEmpty) {
      nouserlocation = true;
    } else {
      _userPosition =
          LatLng(double.parse(location[0]), double.parse(location[1]));
    }

    imageurl = c.profiledata['imageurl'];
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

  Future<void> pickimage() async {
    context.loaderOverlay.show();
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
      }
    } catch (e) {
      print('error: $e');
      Get.showSnackbar(
        GetSnackBar(
          title: 'warning',
          message: 'failed to pick up image $e',
          icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> uploadImageToFirebase(File image) async {
    // setState(() {
    //   isLoading = true;
    // });
    // Reference reference = FirebaseStorage.instance
    //     .ref()
    //     .child("images/${DateTime.now().microsecondsSinceEpoch}.png)");
    String? newimageurl = c.profiledata['phone_number'].toString();
    Reference reference =
        FirebaseStorage.instance.ref().child("images/$newimageurl.png");
    await reference.putFile(image).whenComplete(() => Get.showSnackbar(
          const GetSnackBar(
            title: 'Info',
            message: 'Image uploaded successfully',
            icon: Icon(Icons.refresh),
            duration: Duration(seconds: 3),
          ),
        ));
    String imageurl1 = await reference.getDownloadURL();
    final FirebaseFirestore firebase = FirebaseFirestore.instance;
    // var collection = firebase.collection('fmusers');
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(c.profiledata['phone_number'].toString())
        .update({"imageurl": imageurl1});
    // collection
    //     .doc(c.profiledata['email'])
    //     .update({'imageurl': imageurl1}) // <-- Updated data
    //     .then((_) async {
    final QuerySnapshot resulta = await _firebase
        .collection("customers")
        .where("phone_number",
            isEqualTo: c.profiledata['phone_number'].toString())
        .get();
    List<Object?> data = resulta.docs.map((e) {
      return e.data();
    }).toList();
    if (data.isNotEmpty) {
      Map<dynamic, dynamic> userData = data[0] as Map;
      Get.find<MyController>().profiledata = userData;
      print('phone: $userData');
      // Get.snackbar('Welcome!. ', userData['name'] + '!',
      //     barBlur: 1,
      //     backgroundColor: Colors.white,
      //     margin: const EdgeInsets.all(25.0),
      //     duration: const Duration(seconds: 5),
      //     snackPosition: SnackPosition.BOTTOM);
      //   GetSnackBar(
      //   title: 'Info',
      //   message: userData['name'],
      //   icon: const Icon(Icons.refresh),
      //   duration: const Duration(seconds: 3),
      // );
    }

    setState(() {
      _isLoading = false;
      imageurl = imageurl1;
      context.loaderOverlay.hide();
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
    // _userPosition = LatLng(double.parse(c.profiledata['my_locations'][0]),
    //     double.parse(c.profiledata['my_locations'][1]));
    return Scaffold(
      body: LoaderOverlay(
        child: SafeArea(
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
                                const Text('Personal Profile'),
                              ],
                            ),
                          ],
                        ),
                        addVerticalSpace(16.0),
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor:
                              const Color.fromARGB(255, 160, 169, 246),
                          child: ClipOval(
                              child: (imageurl != null)
                                  ?
                                  // Image.network(
                                  //     c.profiledata['imageurl'],
                                  //     // width: 90,
                                  //     // height: 70,
                                  //     // fit: BoxFit.cover,
                                  //   )
                                  CachedNetworkImage(
                                      imageUrl: imageurl,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            width: 130.0,
                                            height: 130.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ))
                                  :
                                  // Image.asset(
                                  //     'lib/assets/Images/mic1.png',
                                  //     width: 130,
                                  //     height: 130,
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  const Icon(Icons.error)),
                        ),
                        GestureDetector(
                          onTap: () =>
                              {pickimage(), context.loaderOverlay.show()},
                          child: const Icon(
                            Icons.select_all_rounded,
                            size: 30,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal',
                              style: GoogleFonts.sen(
                                  textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 9, 0, 0),
                                      fontSize: 14)),
                            ),
                            addVerticalSpace(15),
                            const MySeparator(
                                color: Colors.green, dashwidth: 5),
                            addVerticalSpace(5),
                            MyDisplay(
                              size: 16,
                              color: Colors.grey,
                              text1: 'Name',
                              text2: c.profiledata['name'],
                            ),
                            MyDisplay(
                              size: 16,
                              color: Colors.grey,
                              text1: 'Phone',
                              text2:
                                  '+91 ${c.profiledata['phone_number'].toString()}',
                            ),
                            const MyDisplay(
                              size: 16,
                              color: Colors.black,
                              text1: 'My Addresses',
                              text2: '',
                            ),
                            addVerticalSpace(5),
                            const MySeparator(
                                color: Colors.green, dashwidth: 5),
                            addVerticalSpace(15),
                            Row(
                              children: [
                                SizedBox(
                                  width: _deviceWidth * .30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("DOOR DELIVERY");
                                      setState(() {
                                        isHome = !isHome;
                                        isWork = !isWork;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                        width: isWork ? 2.0 : 1.0,
                                        color: isWork
                                            ? Colors.green
                                            : Colors.black12,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      'HOME',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ),
                                addHorizontalSpace(8.0),
                                SizedBox(
                                  width: _deviceWidth * .3,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("WORK");
                                      setState(() {
                                        isHome = !isHome;
                                        isWork = !isWork;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                        width: isHome ? 2.0 : 1.0,
                                        color: isHome
                                            ? Colors.green
                                            : Colors.black12,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      'WORK',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            !isHome
                                ? Column(
                                    children: [
                                      // MyDisplay(
                                      //   text1: c.profiledata['name'],
                                      //   text2: '',
                                      //   color: Colors.black,
                                      // ),
                                      // MyDisplay(
                                      //   text1:
                                      //       '+91 ${c.profiledata['phone_number']}',
                                      //   text2: '',
                                      //   color: Colors.black45,
                                      //   size: 12,
                                      // ),
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
                                              userHome,
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
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: SizedBox(
                                      //     width: _deviceWidth * .9,
                                      //     child: CustomFormField(
                                      //       onSaved: (value) {
                                      //         setState(() {
                                      //           _itemname = value;
                                      //         });
                                      //       },
                                      //       regEx: r".{4,}",
                                      //       hintText: "update address",
                                      //       initialValue: null,
                                      //       obscureText: false,
                                      //       height: _deviceHeight * .1,
                                      //       keytype:
                                      //           TextInputType.visiblePassword,
                                      //     ),
                                      //   ),
                                      // ),
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
                                        text1: 'Address',
                                        text2: '',
                                        color: Colors.black,
                                      ),
                                      // MyDisplay(
                                      //     text1: vendorSource.address!,
                                      //     text2: '',
                                      //     color: Colors.black,
                                      //     size: 12),
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
                              child: const Text("EDIT"),
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
                value: isHome,
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.0, color: Colors.black54),
                ),
                checkColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    isHome = value!;
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
                value: isWork,
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.0, color: Colors.black54),
                ),
                onChanged: (bool? value) {
                  setState(() {
                    isWork = value!;
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
