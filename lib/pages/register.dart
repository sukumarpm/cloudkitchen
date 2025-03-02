import 'dart:developer';

import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late double _deviceHeight;
  late double _deviceWidth;
  final _registerFormKey = GlobalKey<FormState>();
  String? _phone;
  String? _passcode;
  String? _confirmpasscode;
  String? _name;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late NavigationService _navigationService;
  late AuthService _auth;
  final GetIt _getIt = GetIt.instance;
  bool isloading = false;
  final MyController c = Get.put(MyController());

  final ButtonStyle style = TextButton.styleFrom(
    foregroundColor: Colors.greenAccent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      side: BorderSide(
        color: Colors.blueGrey,
        width: 3,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _auth = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            addVerticalSpace(20),
            Text('Register',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800)),
            const Text(
              "Please Register to you existing account",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            addVerticalSpace(
              _deviceHeight * .10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                height: _deviceHeight * .65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TextButton(
                    //   style: TextButton.styleFrom(
                    //     foregroundColor: Colors.white,
                    //   ),
                    //   onPressed: () {
                    //     Provider.of<ThemeProvider>(context, listen: false)
                    //         .toggleTheme();
                    //   },
                    //   child: Text(
                    //     'TextButton',
                    //     style: TextStyle(
                    //         color: Theme.of(context).secondaryHeaderColor),
                    //   ),
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset(
                        //   'lib/assets/images/user/logo/LOGO.png',
                        //   fit: BoxFit.contain,
                        //   height: 75,
                        //   width: 75,
                        // ),
                        // _pageTitle(),
                        // SizedBox(
                        //   height: _deviceHeight * 0.04,
                        // ),
                        _registerForm(),
                        SizedBox(
                          height: _deviceHeight * 0.05,
                        ),
                        // _registerButton(),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // Column(
                        //   children: [_registerAccountLink(), _supportNumber()],
                        // ),
                        // _registerAccountLink(),
                        // SizedBox(
                        //   height: _deviceHeight * 0.02,
                        // ),
                        // _supportNumber(),
                      ],
                    ),
                    _registerButton(),
                    _registerAccountLink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return SizedBox(
      height: _deviceHeight * 0.10,
      child: Text(
        'REGISTER',
        style: GoogleFonts.inter(
            textStyle: const TextStyle(
                color: Color.fromARGB(255, 43, 3, 3), fontSize: 22)),
        // style: GoogleFonts.inter(
        //     textStyle: const TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 22)),
      ),
    );
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
          Text(
            'NAME',
            style: GoogleFonts.sen(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 9, 0, 0), fontSize: 14)),
          ),
          SizedBox(
            width: _deviceWidth * .9,
            child: CustomFormField(
              onSaved: (value) {
                setState(() {
                  _name = value;
                });
              },
              regEx: r".{4,}",
              hintText: "name",
              initialValue: null,
              obscureText: false,
              height: _deviceHeight * .1,
              keytype: TextInputType.visiblePassword,
            ),
          ),
          Text(
            'PHONE NUMBER',
            style: GoogleFonts.sen(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 9, 0, 0), fontSize: 14)),
          ),
          SizedBox(
            width: _deviceWidth * .9,
            child: CustomFormField(
              onSaved: (value) {
                setState(() {
                  _phone = value;
                });
              },
              regEx: r"^(?:[+0]9)?[0-9]{10}$",
              hintText: "phone",
              initialValue: null,
              obscureText: false,
              height: _deviceHeight * .1,
              keytype: TextInputType.phone,
            ),
          ),
          addVerticalSpace(10),
          Text(
            'PASSCODE',
            style: GoogleFonts.sen(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 9, 0, 0), fontSize: 14)),
          ),
          SizedBox(
            width: _deviceWidth * .9,
            child: CustomFormField(
              onSaved: (value) {
                setState(() {
                  _passcode = value;
                });
              },
              regEx: r".{6,}",
              hintText: "* * * * * *",
              initialValue: null,
              obscureText: false,
              height: _deviceHeight * .1,
              keytype: TextInputType.visiblePassword,
            ),
          ),
          addVerticalSpace(10),
          Text(
            'CONFIRM PASSCODE',
            style: GoogleFonts.sen(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 9, 0, 0), fontSize: 14)),
          ),
          SizedBox(
            width: _deviceWidth * .9,
            child: CustomFormField(
              onSaved: (value) {
                setState(() {
                  _confirmpasscode = value;
                });
              },
              regEx: r".{6,}",
              hintText: "* * * * * *",
              initialValue: null,
              obscureText: true,
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
          style: ButtonStyle(
              shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.tertiary)),
          child: const Text("REGISTER"),
          onPressed: () async {
            if (_registerFormKey.currentState!.validate()) {
              _registerFormKey.currentState!.save();
              int numericValue;
              bool okToProceed = _name != "" &&
                  _name != null &&
                  _phone != "" &&
                  _phone != null &&
                  _passcode != "" &&
                  _passcode != null &&
                  _confirmpasscode != "" &&
                  _confirmpasscode != null &&
                  _passcode == _confirmpasscode;
              if (kDebugMode) {
                print("====== REGISTRATION DETAILS =====");
                print("phone: $_phone");
                print("address: $_passcode");
                print("name: $_name");
                print("====== EVENT END =====");
              }
              if (okToProceed) {
                final QuerySnapshot resulta = await _firebase
                    .collection("customers")
                    .where("phone_number", isEqualTo: _phone)
                    .get();
                final List<DocumentSnapshot> documents = resulta.docs;

                if (documents.isNotEmpty) {
                  //exists
                  // if (kDebugMode) {
                  //   print('Exists');
                  // }

                  Get.snackbar('Oops!. ',
                      'Account with this Phone number already exist! Please try with different number',
                      barBlur: 1,
                      backgroundColor: Colors.white,
                      margin: EdgeInsets.all(_deviceHeight * .1),
                      duration: const Duration(seconds: 5),
                      snackPosition: SnackPosition.BOTTOM);
                } else {
                  //not exists
                  String? result =
                      await _auth.registerUserUsingEmailAndPassword(
                          '$_phone@suraskitchen.com',
                          _passcode!,
                          '',
                          '',
                          _name);
                  if (kDebugMode) {
                    print('uid: $result');
                  }
                  final int newid;
                  DateTime now = DateTime.now();
                  DateTime pickedDate = DateTime(now.year, now.month, now.day);
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  // final maxRef = await _firebase
                  //     .collection('customers')
                  //     .orderBy("id", descending: true)
                  //     .limit(1)
                  //     .get();

                  // // if (maxRef.docs[0].data()['id'] is String) {
                  // if (kDebugMode) {
                  //   print('diff:${maxRef.docs[0]}');
                  // }
                  // // }
                  // numericValue = int.parse(maxRef.docs[0].data()['id']);
                  // newid = numericValue + 1;
                  await _firebase.collection('customers').doc(_phone).set(
                    {
                      "name": _name,
                      "phone_number": _phone,
                      "password": _passcode,
                      "dob": "",
                      "created_on": formattedDate,
                      "favourites": [],
                      "notifications": [],
                      "reviews": [],
                      "order_history": [],
                      "order_latest": [],
                      "my_locations": [],
                      "imageurl": "",
                      "my_addresses": [],
                      "active": true,
                    },
                  );
                  Get.snackbar('Congrats!.',
                      'Resgistration has been completed successfully!',
                      barBlur: 1,
                      backgroundColor: Colors.white,
                      margin: EdgeInsets.all(_deviceHeight * .1),
                      duration: const Duration(seconds: 5),
                      snackPosition: SnackPosition.BOTTOM);
                  _navigationService.pushNamed("/home");

                  // OTP Authentication - START
                  // await FirebaseAuth.instance.verifyPhoneNumber(
                  //     phoneNumber: '+91$_phone',
                  //     codeAutoRetrievalTimeout: (verificationId) {
                  //       // log("Auto Retireval timeout");
                  //       if (kDebugMode) {
                  //         print('Auto Retireval timeout');
                  //       }
                  //       Get.snackbar('Warning!.', 'Auto Retireval timeout!',
                  //           barBlur: 1,
                  //           backgroundColor: Colors.white,
                  //           margin: EdgeInsets.all(_deviceHeight * .1),
                  //           duration: const Duration(seconds: 5),
                  //           snackPosition: SnackPosition.BOTTOM);
                  //     },
                  //     verificationCompleted: (phoneAuthCredential) {},
                  //     verificationFailed: (error) {
                  //       if (kDebugMode) {
                  //         print(error.toString());
                  //       }
                  //     },
                  //     codeSent: (verificationId, forceResendingToken) {
                  //       setState(() {
                  //         isloading = false;
                  //       });
                  //       if (kDebugMode) {
                  //         print('i have sent code');
                  //       }
                  //       Get.find<MyController>().verificationId.value =
                  //           verificationId;
                  //       _navigationService.pushReplacedNamed("/verifyotp");
                  //     });
                  // OTP Authentication - END
                }
              } else if (_passcode != _confirmpasscode) {
                Get.snackbar(
                    'Oops!. ', 'Confirm Passcode does not match Passcode',
                    barBlur: 1,
                    backgroundColor: Colors.white,
                    margin: EdgeInsets.all(_deviceHeight * .1),
                    duration: const Duration(seconds: 5),
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.snackbar('Oops!. ', 'Please fill all fields',
                    barBlur: 1,
                    backgroundColor: Colors.white,
                    margin: EdgeInsets.all(_deviceHeight * .1),
                    duration: const Duration(seconds: 5),
                    snackPosition: SnackPosition.BOTTOM);
              }
            } else {}
          }),
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => {
        // _navigationService.pushNamed("/register")
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportNumber() {
    return SizedBox(
      height: _deviceHeight * 0.10,
      child: const Text(
        'Support No:- 72003 43219',
        style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
