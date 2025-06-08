import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/driverclass.dart';
import 'package:cloud_kitchen_2/pages/foodclass.dart';
import 'package:cloud_kitchen_2/pages/myorders.dart';
import 'package:cloud_kitchen_2/pages/vendorclass.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:get/get_rx/get_rx.dart';

class MyController extends GetxController {
  Map<dynamic, dynamic> profiledata = {}.obs;
  Map<dynamic, dynamic> admindata = {}.obs;
  Map<dynamic, dynamic> driverdata = {}.obs;
  Map<dynamic, dynamic> fooddata = {}.obs;
  late List<MyOrders> orderhistory;
  late List<MyOrders> ordercurrentadmin;
  late List<MyOrders> ordercanceledadmin;
  late List<Driver> driveractiveadmin = [];
  late List<MyOrders> allmyorders;
  late MyOrders ordercurrent;
  late FoodSource fooddetails;
  late Driver driverdetails;
  Map<dynamic, dynamic> deliveryDetails =
      {"latitude": '', "longitude": '', "orderId": ''}.obs;
  late List<FoodSource> allfooddata = [];
  late List<VendorSource> allvendordata;
  RxBool isAdmin = false.obs;
  RxBool isDriver = false.obs;
  RxString verificationId = "".obs;
  late Cartlists cartList;
  late List<Cartlists> fullcartList = [];
  String finalprice = "";
}
