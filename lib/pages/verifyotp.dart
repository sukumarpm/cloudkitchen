import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => VerifyOTPState();
}

class VerifyOTPState extends State<VerifyOTP> {
  late double _deviceHeight;
  late double _deviceWidth;
  final _forgotFormKey = GlobalKey<FormState>();
  String? _email;
  String? _passcode;
  String fullcode = '';
  bool isLoading = false;
  late NavigationService _navigationService;
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
    // _auth = _getIt.get<AuthService>();
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
            addVerticalSpace(100),
            Text('Verify OTP',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800)),
            const Text(
              "We have sent OTP to your registered number",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            addVerticalSpace(
              _deviceHeight * .25,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                height: _deviceHeight * .6,
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
                        _forgotForm(),
                        SizedBox(
                          height: _deviceHeight * 0.05,
                        ),
                        // _forgotButton(),
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
                          child: const Text("VERIFY OTP"),
                          onPressed: () async {
                            try {
                              final cred = PhoneAuthProvider.credential(
                                  verificationId: c.verificationId.value,
                                  smsCode: fullcode);

                              await FirebaseAuth.instance
                                  .signInWithCredential(cred);

                              _navigationService.pushReplacedNamed("/home");
                            } catch (e) {
                              if (kDebugMode) {
                                print(e.toString());
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }),
                    ),
                    // _registerAccountLink(),
                    _supportNumber(),
                    // const Text("Or"),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Image.asset(
                    //       'lib/assets/images/user/logo/login screen fb,x,apple/Group 8189.png',
                    //       fit: BoxFit.contain,
                    //       height: 62,
                    //       width: 62,
                    //     ),
                    //     Image.asset(
                    //       'lib/assets/images/user/logo/login screen fb,x,apple/Group 8188.png',
                    //       fit: BoxFit.contain,
                    //       height: 62,
                    //       width: 62,
                    //     ),
                    //     Image.asset(
                    //       'lib/assets/images/user/logo/login screen fb,x,apple/Group 8187.png',
                    //       fit: BoxFit.contain,
                    //       height: 62,
                    //       width: 62,
                    //     ),
                    //   ],
                    // ),
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
        'SEND CODE',
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

  Widget _forgotForm() {
    return Form(
      key: _forgotFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ENTER OTP',
                style: GoogleFonts.sen(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 9, 0, 0), fontSize: 14)),
              ),
              Text(
                'Resend in 50Sec',
                style: GoogleFonts.sen(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 9, 0, 0), fontSize: 12)),
              ),
            ],
          ),
          addVerticalSpace(20),
          OtpTextField(
            numberOfFields: 6,
            borderColor: Theme.of(context).colorScheme.tertiary,
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) async {
              setState(() {
                isLoading = true;
                fullcode = verificationCode;
              });
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  });
            }, // end onSubmit
          ),
          // SizedBox(
          //   width: _deviceWidth * .9,
          //   child: CustomFormField(
          //     onSaved: (value) {
          //       setState(() {
          //         _email = value;
          //       });
          //     },
          //     regEx:
          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          //     hintText: "+91",
          //     initialValue: null,
          //     obscureText: false,
          //     height: _deviceHeight * .1,
          //     keytype: TextInputType.emailAddress,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _forgotButton() {
    return TextButton(
      style: style,
      onPressed: () async {
        // if (_forgotFormKey.currentState!.validate()) {
        //   _forgotFormKey.currentState!.save();
        //   final QuerySnapshot resulta = await _firebase
        //       .collection("fmusers")
        //       .where("email", isEqualTo: _email)
        //       .get();

        //   List<Object?> data = resulta.docs.map((e) {
        //     return e.data();
        //   }).toList();
        //   // if (kDebugMode) {
        //   //   print('data:$_email');
        //   // }

        //   // final List<DocumentSnapshot> documents = resulta.docs;
        //   // if (documents.isNotEmpty) {
        //   if (data.isNotEmpty) {
        //     Map<dynamic, dynamic> userData = data[0] as Map;
        //     // if (kDebugMode) {
        //     //   print('result - Login 1:$userData');
        //     // }
        //     bool result = await _auth.forgotUsingEmailAndPassword(
        //         _email!, _password!, "", "", "");
        //     // if (kDebugMode) {
        //     //   print('result - Login 2:$result');
        //     // }
        //     if (result) {
        //       //get user
        //       final QuerySnapshot resulta = await _firebase
        //           .collection("adminusers")
        //           .where("email", isEqualTo: _email)
        //           .get();

        //       List<Object?> dataadmin = resulta.docs.map((e) {
        //         return e.data();
        //       }).toList();
        //       // if (kDebugMode) {
        //       //   print('dataadmin:$dataadmin');
        //       // }
        //       if (dataadmin.isNotEmpty) {
        //         Map<dynamic, dynamic> adminData = dataadmin[0] as Map;
        //         Get.find<MyController>().isAdmin = true.obs;
        //         Get.find<MyController>().admindata = adminData;
        //       }
        //       //get user
        //       Get.find<MyController>().profiledata = userData;
        //       // Get.snackbar('Welcome!. ', userData['name'] + '!',
        //       //     barBlur: 1,
        //       //     backgroundColor: Colors.white,
        //       //     margin: EdgeInsets.all(_deviceHeight * .1),
        //       //     duration: const Duration(seconds: 5),
        //       //     snackPosition: SnackPosition.BOTTOM);
        //       _navigationService.pushNamed("/home");
        //     } else {
        //       if (kDebugMode) {
        //         Get.snackbar('Oops!. ', 'This accout is not registered.',
        //             barBlur: 1,
        //             backgroundColor: Colors.white,
        //             margin: EdgeInsets.all(_deviceHeight * .1),
        //             duration: const Duration(seconds: 5),
        //             snackPosition: SnackPosition.BOTTOM);
        //       }
        //     }
        //   } else {
        //     Get.snackbar('Oops!. ', 'This accout is not registered.',
        //         barBlur: 1,
        //         backgroundColor: Colors.white,
        //         margin: EdgeInsets.all(_deviceHeight * .1),
        //         duration: const Duration(seconds: 5),
        //         snackPosition: SnackPosition.BOTTOM);
        //   }
        // } else {
        //   // if (kDebugMode) {
        //   //   print('result : validation error');
        //   // }
        // }
      },
      child: Text(
        'SEND CODE',
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
          Text(
            'SIGN UP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
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
        'Contact Us:- 72003 43219',
        style: TextStyle(
          color: Colors.black45,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
