import 'package:cloud_kitchen_2/pages/addnewdriver.dart';
import 'package:cloud_kitchen_2/pages/addnewitem.dart';
import 'package:cloud_kitchen_2/pages/adminhome.dart';
import 'package:cloud_kitchen_2/pages/adminprofile.dart';
import 'package:cloud_kitchen_2/pages/cart.dart';
import 'package:cloud_kitchen_2/pages/deliveryhome.dart';
import 'package:cloud_kitchen_2/pages/driverhome.dart';
import 'package:cloud_kitchen_2/pages/driverlist.dart';
import 'package:cloud_kitchen_2/pages/editdriver.dart';
import 'package:cloud_kitchen_2/pages/fooddetails.dart';
import 'package:cloud_kitchen_2/pages/forgot.dart';
import 'package:cloud_kitchen_2/pages/gmap.dart';
import 'package:cloud_kitchen_2/pages/gpay.dart';
import 'package:cloud_kitchen_2/pages/home.dart';
import 'package:cloud_kitchen_2/pages/login.dart';
import 'package:cloud_kitchen_2/pages/onboard.dart';
import 'package:cloud_kitchen_2/pages/orderactive.dart';
import 'package:cloud_kitchen_2/pages/orderhistory.dart';
import 'package:cloud_kitchen_2/pages/orderplaced.dart';
import 'package:cloud_kitchen_2/pages/ordersummary.dart';
import 'package:cloud_kitchen_2/pages/orderviewadmin.dart';
import 'package:cloud_kitchen_2/pages/orderviewdriver.dart';
import 'package:cloud_kitchen_2/pages/register.dart';
import 'package:cloud_kitchen_2/pages/searchfood.dart';
import 'package:cloud_kitchen_2/pages/searchorder.dart';
import 'package:cloud_kitchen_2/pages/searchuser.dart';
import 'package:cloud_kitchen_2/pages/userpersonal.dart';
import 'package:cloud_kitchen_2/pages/userprofile.dart';
import 'package:cloud_kitchen_2/pages/verifycode.dart';
import 'package:cloud_kitchen_2/pages/verifyotp.dart';
import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/home": (context) => const Home(),
    "/login": (context) => const Login(),
    "/onboard": (context) => const OnBoard(),
    "/forgot": (context) => const Forgot(),
    "/verifycode": (context) => const VerifyCode(),
    "/verifyotp": (context) => const VerifyOTP(),
    "/register": (context) => const Register(),
    "/adminprofile": (context) => const AdminProfile(),
    "/userprofile": (context) => const UserProfile(),
    "/addnewitem": (context) => const AddNewItem(),
    "/fooddetails": (context) => const FoodDetails(),
    "/searchfood": (context) => const SearchFood(),
    "/gmap": (context) => const GMap(),
    "/cart": (context) => const Cart(),
    "/ordersummary": (context) => const OrderSummary(),
    "/gpay": (context) => const PayMaterialApp(),
    "/orderplaced": (context) => const OrderPlaced(),
    "/orderhistory": (context) => const OrderHistory(),
    "/userpersonalpage": (context) => const UserPersonalPage(),
    "/driverlist": (context) => const DriverList(),
    "/orderactive": (context) => const OrderActive(),
    "/deliveryhome": (context) => const DeliveryHome(),
    "/adminhome": (context) => const AdminHome(),
    "/orderviewadmin": (context) => const OrderViewAdmin(),
    "/searchorder": (context) => const SearchOrder(),
    "/driverhome": (context) => const DriverHome(),
    "/orderviewdriver": (context) => const OrderViewDriver(),
    "/addnewdriver": (context) => const AddNewDriver(),
    "/editdriver": (context) => const EditDriver(),
    "/searchuser": (context) => const SearchUser(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushNamedWithParm(String routeName, final String title) {
    _navigatorKey.currentState?.pushNamed(routeName, arguments: {title});
  }

  void pushReplacedNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
