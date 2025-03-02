import 'dart:async';

import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GMap extends StatefulWidget {
  const GMap({super.key});

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  late GoogleMapController mapController;
  late double _deviceHeight;
  late double _deviceWidth;
  late LatLng _currentPosition;
  bool _isLoading = true;
  LatLng location = const LatLng(53.2734, -7.77832031);
  final _registerFormKey = GlobalKey<FormState>();
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  String? _street;
  String? _postcode;
  String? _arealandmark;
  String? _address;

  @override
  void initState() {
    super.initState();
    _currentPosition = location;
    _navigationService = _getIt.get<NavigationService>();
    // getLocation();
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    location = LatLng(lat, long);
    print('${location.latitude}');
    print('${location.longitude}');
    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .2,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFF7F7F7F)),
                                left: BorderSide(color: Color(0xFF7F7F7F)),
                                right: BorderSide(color: Color(0xFF7F7F7F)),
                                bottom: BorderSide(color: Color(0xFF7F7F7F)),
                              ),
                            ),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('MAP AREA')),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .5,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFDFDFDF)),
                                left: BorderSide(color: Color(0xFFDFDFDF)),
                                right: BorderSide(color: Color(0xFF7F7F7F)),
                                bottom: BorderSide(color: Color(0xFF7F7F7F)),
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
                                    markerId: const MarkerId('Your Location'),
                                    position: _currentPosition,
                                    onTap: () {
                                      debugPrint('Tapped');
                                    },
                                    draggable: true,
                                    onDragEnd: ((LatLng newPosition) {
                                      print('${newPosition.latitude}');
                                      print('${newPosition.longitude}');
                                    }),
                                    onDrag: (value) {
                                      print('Dragging:$value');
                                    },
                                    infoWindow: const InfoWindow(
                                        title: 'Drag to update the location',
                                        snippet:
                                            'Drag to update the location')),
                              },
                            ),
                          ),
                        ),
                  SizedBox(
                    width: _deviceWidth * .7,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.tertiary),
                            overlayColor:
                                WidgetStateProperty.all<Color>(Colors.white)),
                        onPressed: () {
                          getLocation();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                'lib/assets/images/user/profile icones/location.png',
                                fit: BoxFit.fitWidth),
                            addHorizontalSpace(20),
                            Text('Use Current Location',
                                style: textTheme.labelLarge),
                          ],
                        )),
                  ),
                  const Text(
                    'Drag the location marker in the map to update the current loction',
                    style: TextStyle(fontSize: 10),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    height: _deviceHeight * .45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _registerForm(),
                          ],
                        ),
                        _registerButton(),
                        // _registerAccountLink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _registerForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addVerticalSpace(10),
          const Text(
            'ADDRESS',
          ),
          SizedBox(
            width: _deviceWidth * .9,
            child: CustomFormField(
              onSaved: (value) {
                setState(() {
                  _address = value;
                });
              },
              regEx: r".{4,}",
              hintText: "Address",
              initialValue: null,
              obscureText: false,
              height: _deviceHeight * .1,
              keytype: TextInputType.visiblePassword,
            ),
          ),
          SizedBox(
            width: _deviceWidth * .9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'STREET',
                    ),
                    SizedBox(
                      width: _deviceWidth * .50,
                      child: CustomFormField(
                        onSaved: (value) {
                          setState(() {
                            _street = value;
                          });
                        },
                        regEx: r".{4,}",
                        hintText: "Street",
                        initialValue: null,
                        obscureText: false,
                        height: _deviceHeight * .1,
                        keytype: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('POSTAL CODE'),
                    SizedBox(
                      width: _deviceWidth * .35,
                      child: CustomFormField(
                        onSaved: (value) {
                          setState(() {
                            _postcode = value;
                          });
                        },
                        regEx: r".{6,}",
                        hintText: "XXXXXX",
                        initialValue: null,
                        obscureText: false,
                        height: _deviceHeight * .1,
                        keytype: TextInputType.visiblePassword,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          addVerticalSpace(10),
          const Text(
            'AREA, LANDMARK',
          ),
          SizedBox(
            width: _deviceWidth * .9,
            child: CustomFormField(
              onSaved: (value) {
                setState(() {
                  _arealandmark = value;
                });
              },
              regEx: r".{6,}",
              hintText: "Enter Arena and Landmark",
              initialValue: null,
              obscureText: false,
              height: _deviceHeight * .1,
              keytype: TextInputType.visiblePassword,
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: _deviceWidth * .8,
      child: ElevatedButton(
          child: const Text("REGISTER"),
          onPressed: () async {
            if (_registerFormKey.currentState!.validate()) {
              _registerFormKey.currentState!.save();
              // int numericValue;
              // bool okToProceed = _address != "" &&
              //     _address != null &&
              //     _street != "" &&
              //     _street != null &&
              //     _postcode != "" &&
              //     _postcode != null &&
              //     _arealandmark != "" &&
              //     _arealandmark != null &&
              //     _postcode == _arealandmark;
              // if (kDebugMode) {
              //   print("====== REGISTRATION DETAILS =====");
              //   print("phone: $_street");
              //   print("address: $_postcode");
              //   print("name: $_address");
              //   print("====== EVENT END =====");
              // }
              // if (okToProceed) {
              //   final QuerySnapshot resulta = await _firebase
              //       .collection("customers")
              //       .where("phone_number", isEqualTo: _street)
              //       .get();
              //   final List<DocumentSnapshot> documents = resulta.docs;

              //   if (documents.isNotEmpty) {
              //     Get.snackbar('Oops!. ',
              //         'Account with this Phone number already exist! Please try with different number',
              //         barBlur: 1,
              //         backgroundColor: Colors.white,
              //         margin: EdgeInsets.all(_deviceHeight * .1),
              //         duration: const Duration(seconds: 5),
              //         snackPosition: SnackPosition.BOTTOM);
              //   } else {
              //     final int newid;
              //     DateTime now = DateTime.now();
              //     DateTime pickedDate = DateTime(now.year, now.month, now.day);
              //     String formattedDate =
              //         DateFormat('yyyy-MM-dd').format(pickedDate);

              //     await _firebase.collection('customers').doc(_street).set(
              //       {
              //         "name": _address,
              //         "phone_number": _street,
              //         "password": _postcode,
              //         "dob": "",
              //         "created_on": formattedDate,
              //         "favourites": [],
              //         "notifications": [],
              //         "reviews": [],
              //         "order_history": [],
              //         "order_latest": [],
              //         "my_locations": [],
              //         "imageurl": "",
              //         "my_addresses": []
              //       },
              //     );
              //     Get.snackbar('Congrats!.',
              //         'Resgistration has been completed successfully!',
              //         barBlur: 1,
              //         backgroundColor: Colors.white,
              //         margin: EdgeInsets.all(_deviceHeight * .1),
              //         duration: const Duration(seconds: 5),
              //         snackPosition: SnackPosition.BOTTOM);
              //     _navigationService.pushNamed("/home");
              //   }
              // } else if (_postcode != _arealandmark) {
              //   Get.snackbar(
              //       'Oops!. ', 'Confirm Passcode does not match Passcode',
              //       barBlur: 1,
              //       backgroundColor: Colors.white,
              //       margin: EdgeInsets.all(_deviceHeight * .1),
              //       duration: const Duration(seconds: 5),
              //       snackPosition: SnackPosition.BOTTOM);
              // } else {
              //   Get.snackbar('Oops!. ', 'Please fill all fields',
              //       barBlur: 1,
              //       backgroundColor: Colors.white,
              //       margin: EdgeInsets.all(_deviceHeight * .1),
              //       duration: const Duration(seconds: 5),
              //       snackPosition: SnackPosition.BOTTOM);
              // }
            } else {}
          }),
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => {
        // _navigationService.pushNamed("/register")
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: Color(0xFF646982),
            fontSize: 16,
          ),
        ),
        addHorizontalSpace(15),
        GestureDetector(
          onTap: () {
            _navigationService.pushNamed("/login");
          },
          child: const Text(
            'LOGIN',
          ),
        ),
      ]),
    );
  }
}
