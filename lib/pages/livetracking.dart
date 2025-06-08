import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/mydisplay.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as lacy;
import 'package:http/http.dart' as http;

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  LatLng destinationLocation =
      const LatLng(8.515870978019988, 76.93557823280698);
  LatLng sourceLocation = const LatLng(8.514501613922755, 76.9596613110107);
  late LatLng deliveryBoyLocation =
      const LatLng(8.515870978019988, 76.93557823280698);
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> polylinePoints = [];
  double remainingDistance = 0.0;
  final PolylinePoints polyresult = PolylinePoints();
  final Completer<GoogleMapController> _googleMapController = Completer();
  final Location _location = Location();
  LocationData? locationData;
  GoogleMapController? controller;
  final MyController c = Get.put(MyController());
  late Map<dynamic, dynamic> deliveryDetails;
  final databaseReference = FirebaseFirestore.instance;
  late MyOrders listCarts;
  late bool stopTracking = true;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  late Timer timer;
  late double _deviceWidth;
  late double _deviceHeight;

  void setCustomIcon() async {
    try {
      final inconsResult = await Future.wait([
        BitmapDescriptor.asset(const ImageConfiguration(size: Size(32, 32)),
            "lib/assets/images/user/profileicones/location-on.png"),
        BitmapDescriptor.asset(const ImageConfiguration(size: Size(32, 32)),
            "lib/assets/images/user/profileicones/location.png"),
        BitmapDescriptor.asset(const ImageConfiguration(size: Size(45, 45)),
            "lib/assets/images/admin/icones/Driverlist1.png")
      ]);
      setState(() {
        sourceIcon = inconsResult[0];
        destinationIcon = inconsResult[1];
        currentIcon = inconsResult[2];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void updateCurrentLocation(Position position) async {
    setState(() {
      destinationLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void updateDelivryLocation(Position position) async {
    setState(() {
      deliveryBoyLocation = LatLng(position.latitude, position.longitude);
    });
    controller?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
  }

  void calculateRemainingDisctance() async {
    double distance = Geolocator.distanceBetween(
        deliveryBoyLocation.latitude,
        deliveryBoyLocation.longitude,
        sourceLocation.latitude,
        sourceLocation.longitude);
    double distanceInKm = distance / 1000;
    setState(() {
      remainingDistance = distanceInKm;
    });
    if (kDebugMode) {
      print('Distance in Km:$distanceInKm');
    }
  }

  void getCurrentLocation() async {
    try {
      LocationData currentLoc = await _location.getLocation();
      setState(() {
        locationData = currentLoc;
      });

      await controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(currentLoc.latitude!, currentLoc.longitude!),
              zoom: 14.5,
              tilt: 59,
              bearing: -70)));

      _location.onLocationChanged.listen((LocationData newLocation) async {
        await controller?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(newLocation.latitude!, newLocation.longitude!),
                zoom: 14.5,
                tilt: 59,
                bearing: -70)));
        setState(() {
          locationData = newLocation;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getPloygon() async {
    try {
      PolylineResult polylineresult =
          await polyresult.getRouteBetweenCoordinates(
              googleApiKey: 'AIzaSyBMYBUiXs2jFnAEFcg3QyUVUIZ-6ccH2o4',
              request: PolylineRequest(
                origin: PointLatLng(
                    sourceLocation.latitude, sourceLocation.longitude),
                destination: PointLatLng(destinationLocation.latitude,
                    destinationLocation.longitude),
                mode: TravelMode.driving,
                optimizeWaypoints: true,
              ));
      if (polylineresult.points.isNotEmpty) {
        setState(() {
          polylinePoints = polylineresult.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
        });
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setCustomIcon();
    getPloygon();
    calculateRemainingDisctance();
    _navigationService = _getIt.get<NavigationService>();
    deliveryDetails = c.deliveryDetails;
    print('orderId 2: ${c.ordercurrent}');
    listCarts = c.ordercurrent;
    print('orderId 3: ${listCarts.order_id}');
    startTracking();
    // Geolocator.getPositionStream(
    //         locationSettings: const LocationSettings(
    //             accuracy: lacy.LocationAccuracy.best, distanceFilter: 10))
    //     .listen((Position position) {
    //   updateCurrentLocation(position);
    // });
  }

  void startTracking() async {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final QuerySnapshot resulta = await FirebaseFirestore.instance
          .collection("orderlocation")
          .where("order_id", isEqualTo: listCarts.order_id!)
          .get();

      List<Object?> data = resulta.docs.map((e) {
        return e.data();
      }).toList();
      if (kDebugMode) {
        print('data:${data.toString()}');
      }
      var trackingData = data[0] as Map;
      // print('latitude: ${trackingData!['latitude']}');
      // print('longitude: ${trackingData['longitude']}');
      if (trackingData.isNotEmpty) {
        double latitude = trackingData['latitude'] as double;
        double longitude = trackingData['longitude'] as double;
        updateUItrackingwithLocation(latitude, longitude);
      } else {
        timer.cancel();
      }
      // if (remainingDistance < 0.03 || stopTracking == true) {
      // if (remainingDistance < 0.03) {
      //   timer.cancel();
      //   _navigationService.goBack();
      // } else {
      //   print('On the way');
      // }
    });
  }

  Future<Map<String, dynamic>?> getOrderTracking(String orderId) async {
    if (kDebugMode) {
      print('orderId 1:$orderId');
    }
    try {
      final DocumentSnapshot orderTrackingDoc = await databaseReference
          .collection('orderlocation')
          .doc(orderId)
          .get();
      if (orderTrackingDoc.exists) {
        return orderTrackingDoc.data() as Map<String, dynamic>;
      } else {
        print('orderTrackingDoc.exists: ${orderTrackingDoc.exists}');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  void updateUItrackingwithLocation(double lat, double lon) {
    setState(() {
      deliveryBoyLocation = LatLng(lat, lon);
    });
    controller?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
    calculateRemainingDisctance();
    getDistance(
        lat, lon, destinationLocation.latitude, destinationLocation.longitude);
  }

  Future<dynamic> getDistance(double? startLatitude, double? startLongitude,
      double? endLatitude, double? endLongitude) async {
    if (kDebugMode) {
      print("====== Location DETAILS =====");
      print("startLatitude: $startLatitude");
      print("startLongitude: $startLongitude");
      print("endLatitude: $endLatitude");
      print("endLongitude: $endLongitude");
      print("====== EVENT END =====");
    }
    String Url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$startLatitude,$startLongitude&origins=$endLatitude,$endLongitude&key=AIzaSyAY7mJ1KP6tD3Tl5TUOwUmCqRzYBfy_MPA';
    final response = await http.get(Uri.parse(Url));

    var responseData = json.decode(response.body);
    if (kDebugMode) {
      print('responseData:$responseData');
    }
    // try {
    //   var response = await http.get(
    //     Uri.parse(Url),
    //   );
    //   if (response.statusCode == 200) {
    //     return jsonDecode(response.body);
    //   } else {
    //     if (kDebugMode) {
    //       print(response.statusCode);
    //     }
    //     return null;
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    //   return null;
    // }
  }

  @override
  void dispose() {
    controller!.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'ORDER TRACKING',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.green.shade300,
      // ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: MediaQuery.of(context).size.height * .75,
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
              initialCameraPosition:
                  CameraPosition(target: sourceLocation, zoom: 13.5),
              markers: {
                Marker(
                    markerId: const MarkerId("Source"),
                    position: sourceLocation,
                    icon: sourceIcon),
                Marker(
                    markerId: const MarkerId("Destination"),
                    position: destinationLocation,
                    icon: destinationIcon),
                if (deliveryBoyLocation.latitude > 0)
                  Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(deliveryBoyLocation.latitude,
                          deliveryBoyLocation.longitude),
                      icon: currentIcon)
              },
              polylines: {
                Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylinePoints,
                    width: 5),
              },
            ),
          ),
        ),
        Positioned(
            child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: MyDisplay(
              size: 14,
              text1:
                  "Remaining Distance: ${remainingDistance.toStringAsFixed(1)} km",
              text2: ''),
          // child: Text(
          //   "Remaining Distance: ${remainingDistance.toStringAsFixed(1)} km",
          //   style: const TextStyle(fontSize: 16),
          // ),
        )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: _deviceWidth * .9,
              height: _deviceHeight * .2,
              child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.grey,
                  margin: const EdgeInsets.all(10),
                  child:
                      // Image.network(
                      //   fooditem.imageurl1!,
                      //   fit: BoxFit.cover,
                      // ),
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8), // Border width
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(20), // Image radius
                                child: Image.asset(
                                    'lib/assets/images/admin/icones/personal info.png',
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          addHorizontalSpace(16),
                          Text(
                            'MARK',
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 9, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const Icon(Icons.call_sharp,
                          size: 40, color: Colors.green),
                    ],
                  )),
            ),
          ),
        ),
      ]),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      // floatingActionButton: FloatingActionButton(
      //   // isExtended: true,
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     setState(() {
      //       stopTracking = !stopTracking;
      //     });
      //   },
      //   // isExtended: true,
      //   child: Icon(
      //     stopTracking ? Icons.pause_circle : Icons.play_circle_fill_outlined,
      //     size: 55,
      //   ),
      // ),
    );
  }
}
