import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late double _deviceHeight;
  late double _deviceWidth;
  final _loginFormKey = GlobalKey<FormState>();
  String? _phone;
  String? _passcode;
  bool isDriver = false;
  bool isAdmin = false;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late NavigationService _navigationService;
  late AuthService _auth;
  final GetIt _getIt = GetIt.instance;
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
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            addVerticalSpace(20),
            Text('Login',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800)),
            const Text(
              "Please Login to you existing account",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            addVerticalSpace(
              _deviceHeight * .15,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                height: _deviceHeight * .5,
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
                        _loginForm(),
                        SizedBox(
                          height: _deviceHeight * 0.05,
                        ),
                        // _loginButton(),
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
                    SizedBox(
                      width: _deviceWidth * .8,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.tertiary)),
                          child: const Text("LOGIN"),
                          onPressed: () async {
                            if (_loginFormKey.currentState!.validate()) {
                              _loginFormKey.currentState!.save();

                              if (kDebugMode) {
                                print("====== LOGIN DETAILS =====");
                                print("phone: $_phone");
                                print("address: $_passcode");
                                print("====== EVENT END =====");
                              }

                              final QuerySnapshot resulta = await _firebase
                                  .collection("customers")
                                  .where("phone_number", isEqualTo: _phone)
                                  .get();

                              List<Object?> data = resulta.docs.map((e) {
                                return e.data();
                              }).toList();
                              if (kDebugMode) {
                                print('data:${data.toString()}');
                              }

                              // final List<DocumentSnapshot> documents = resulta.docs;
                              // if (documents.isNotEmpty) {
                              if (data.isNotEmpty) {
                                Map<dynamic, dynamic> userData = data[0] as Map;
                                if (kDebugMode) {
                                  print(
                                      'result - Login 1:${userData['password']}');
                                }
                                if (userData['password'] == _passcode) {
                                  String fakeemail = '$_phone@suraskitchen.com';
                                  bool result =
                                      await _auth.loginUsingEmailAndPassword(
                                          fakeemail, _passcode!, "", "", "");
                                  if (result) {
                                    //get user
                                    final QuerySnapshot resulta =
                                        await _firebase
                                            .collection("admin")
                                            .where("phone", isEqualTo: _phone)
                                            .get();

                                    List<Object?> dataadmin =
                                        resulta.docs.map((e) {
                                      return e.data();
                                    }).toList();
                                    // if (kDebugMode) {
                                    //   print('dataadmin:$dataadmin');
                                    // }
                                    if (dataadmin.isNotEmpty) {
                                      isAdmin = true;
                                      Map<dynamic, dynamic> adminData =
                                          dataadmin[0] as Map;
                                      Get.find<MyController>().isAdmin =
                                          true.obs;
                                      Get.find<MyController>().admindata =
                                          adminData;
                                    }
                                    final QuerySnapshot resultb =
                                        await _firebase
                                            .collection("drivers")
                                            .where("driverphone",
                                                isEqualTo: _phone)
                                            .get();

                                    List<Object?> datadriver =
                                        resultb.docs.map((e) {
                                      return e.data();
                                    }).toList();
                                    // if (kDebugMode) {
                                    //   print('dataadmin:$dataadmin');
                                    // }
                                    if (datadriver.isNotEmpty) {
                                      Map<dynamic, dynamic> driverData =
                                          datadriver[0] as Map;
                                      Get.find<MyController>().isDriver =
                                          true.obs;
                                      Get.find<MyController>().driverdata =
                                          driverData;
                                    } else {
                                      isDriver = false;
                                    }

                                    //get user
                                    Get.find<MyController>().profiledata =
                                        userData;
                                    // Get.snackbar('Welcome!. ', userData['name'] + '!',
                                    //     barBlur: 1,
                                    //     backgroundColor: Colors.white,
                                    //     margin: EdgeInsets.all(_deviceHeight * .1),
                                    //     duration: const Duration(seconds: 5),
                                    //     snackPosition: SnackPosition.BOTTOM);
                                    getfooddetails();
                                    if (isAdmin) {
                                      _navigationService
                                          .pushNamed("/adminhome");
                                    } else if (isDriver) {
                                      _navigationService
                                          .pushNamed("/driverhome");
                                    } else {
                                      _navigationService.pushNamed("/home");
                                    }
                                  } else {
                                    Get.snackbar('Oops!. ',
                                        'Problem logging in now. Please retry after sometime or contact admin.',
                                        barBlur: 1,
                                        backgroundColor: Colors.white,
                                        margin:
                                            EdgeInsets.all(_deviceHeight * .1),
                                        duration: const Duration(seconds: 5),
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                } else {
                                  Get.snackbar('Oops!. ',
                                      'Phone/Password is incorrect. Please retry.',
                                      barBlur: 1,
                                      backgroundColor: Colors.white,
                                      margin:
                                          EdgeInsets.all(_deviceHeight * .1),
                                      duration: const Duration(seconds: 5),
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              } else {
                                Get.snackbar(
                                    'Oops!. ', 'This accout is not registered.',
                                    barBlur: 1,
                                    backgroundColor: Colors.white,
                                    margin: EdgeInsets.all(_deviceHeight * .1),
                                    duration: const Duration(seconds: 5),
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            } else {
                              // if (kDebugMode) {
                              //   print('result : validation error');
                              // }
                            }
                          }),
                    ),
                    _registerAccountLink(),
                    const Text("Or"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'lib/assets/images/user/logo/login screen fb,x,apple/Group 8189.png',
                          fit: BoxFit.contain,
                          height: 62,
                          width: 62,
                        ),
                        Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.contain,
                          height: 82,
                          width: 82,
                        ),
                        Image.asset(
                          'lib/assets/images/user/logo/login screen fb,x,apple/Group 8187.png',
                          fit: BoxFit.contain,
                          height: 62,
                          width: 62,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getfooddetails() async {
    final FirebaseFirestore firebase = FirebaseFirestore.instance;
    final QuerySnapshot resulta =
        await firebase.collection("fmstations").orderBy("free").get();

    List<Object?> data = resulta.docs.map((e) {
      return e.data();
    }).toList();

    if (data.isNotEmpty) {
      Map<dynamic, dynamic> fooditems = data[0] as Map;
      Get.find<MyController>().fooddata = fooditems;
      if (kDebugMode) {
        print('in main: $fooditems');
      }
    }
  }

  Widget _pageTitle() {
    return SizedBox(
      height: _deviceHeight * 0.10,
      child: Text(
        'LOGIN',
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

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              hintText: "+91",
              initialValue: null,
              obscureText: false,
              height: _deviceHeight * .1,
              keytype: TextInputType.emailAddress,
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
              obscureText: true,
              height: _deviceHeight * .1,
              keytype: TextInputType.visiblePassword,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                tristate: false,
                fillColor: const WidgetStatePropertyAll<Color>(
                    Color.fromARGB(255, 248, 251, 244)),
                value: isDriver,
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.0, color: Colors.black54),
                ),
                checkColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    isDriver = value!;
                  });
                },
              ),
              const Text(
                'Login as Driver',
                style: TextStyle(color: Color(0xFF9C9BA6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return TextButton(
      style: style,
      onPressed: () async {
        // int numericValue;
        //           bool okToProceed = nameController.text != "" &&
        //               emailController.text != "" &&
        //               phoneController.text != "" &&
        //               passwordController.text != "" &&
        //               confirmpasswordController.text != "" &&
        //               nameController.text != "";
        //           if (kDebugMode) {
        //             print("====== REGISTRATION DETAILS =====");
        //             print("phone: ${phoneController.text}");
        //             print("address: ${addressController.text}");
        //             print("email: ${emailController.text}");
        //             print("name: ${nameController.text}");
        //             print("====== EVENT END =====");
        //           }
        //           if (okToProceed) {
        //             final QuerySnapshot resulta = await _firebase
        //                 .collection("fmusers")
        //                 .where("email", isEqualTo: emailController.text)
        //                 .get();
        //             final List<DocumentSnapshot> documents = resulta.docs;

        //             if (documents.isNotEmpty) {
        //               //exists
        //               // if (kDebugMode) {
        //               //   print('Exists');
        //               // }

        //               Get.snackbar('Oops!. ',
        //                   'Email id already exist! Please try with different email id',
        //                   barBlur: 1,
        //                   backgroundColor: Colors.white,
        //                   margin: EdgeInsets.all(devHt * .1),
        //                   duration: const Duration(seconds: 5),
        //                   snackPosition: SnackPosition.BOTTOM);
        //             } else {
        //               //not exists
        //               String? result =
        //                   await _auth.registerUserUsingEmailAndPassword(
        //                       emailController.text,
        //                       passController.text,
        //                       phoneController.text,
        //                       addressController.text,
        //                       nameController.text);
        //               // if (kDebugMode) {
        //               //   print('uid: $result');
        //               // }
        //               final int newid;
        //               DateTime now = DateTime.now();
        //               DateTime pickedDate =
        //                   DateTime(now.year, now.month, now.day);
        //               String formattedDate =
        //                   DateFormat('yyyy-MM-dd').format(pickedDate);
        //               final maxRef = await _firebase
        //                   .collection('fmusers')
        //                   .orderBy("id", descending: true)
        //                   .limit(1)
        //                   .get();

        //               // if (maxRef.docs[0].data()['id'] is String) {
        //               //   if (kDebugMode) {
        //               //     print('diff:${maxRef.docs[0].data()['id']}');
        //               //   }
        //               // }
        //               numericValue = int.parse(maxRef.docs[0].data()['id']);
        //               newid = numericValue + 1;
        //               await _firebase
        //                   .collection('fmusers')
        //                   .doc(emailController.text)
        //                   .set(
        //                 {
        //                   "id": newid.toString(),
        //                   "name": nameController.text,
        //                   "email": emailController.text,
        //                   "phone_number": phoneController.text,
        //                   "password": passController.text,
        //                   "dob": "",
        //                   "favourites": [],
        //                   "notifications": [],
        //                   "reviews": [],
        //                   "order_history": [],
        //                   "order_latest": [],
        //                   "my_locations": [],
        //                   "imageurl": "",
        //                   "my_addresses": []
        //                 },
        //               );
        //               Get.snackbar('Congrats!.',
        //                   'Resgistration has been completed successfully!',
        //                   barBlur: 1,
        //                   backgroundColor: Colors.white,
        //                   margin: EdgeInsets.all(devHt * .1),
        //                   duration: const Duration(seconds: 5),
        //                   snackPosition: SnackPosition.BOTTOM);
        //               // _navigationService.pushNamed("/login");
        //               _navigationService.pushReplacedNamed("/login");
        //             }
        //           }
      },
      child: Text(
        'LOGIN',
        style: GoogleFonts.inter(
            textStyle: const TextStyle(color: Colors.white, fontSize: 22)),
      ),
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
              _navigationService.pushNamed("/register");
            },
            child: Text(
              'SIGN UP',
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
