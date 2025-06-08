import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late double _deviceHeight;
  late double _deviceWidth;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  late AuthService _auth;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _auth = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(10), // Image radius
                        child: GestureDetector(
                          child: Image.asset(
                              'lib/assets/images/user/icones/left arrow.png',
                              fit: BoxFit.contain),
                          onTap: () {
                            _navigationService.goBack();
                          },
                        ),
                      ),
                    ),
                    addHorizontalSpace(15),
                    const Text('User Profile')
                  ],
                ),
                addVerticalSpace(40),
                Container(
                  color: const Color(0xffF6F8FA),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _navigationService.pushNamed('/userpersonalpage');
                            },
                            child: Row(
                              children: [
                                ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        20), // Image radius
                                    child: Image.asset(
                                        'lib/assets/images/admin/icones/personal info.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                addHorizontalSpace(15),
                                const Text('Personal Info'),
                              ],
                            ),
                          ),
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(180 / 360),
                            child: GestureDetector(
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(7), // Image radius
                                  child: Image.asset(
                                      'lib/assets/images/user/icones/left arrow.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              onTap: () {
                                _navigationService
                                    .pushNamed('/userpersonalpage');
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(20), // Image radius
                                  child: Image.asset(
                                      'lib/assets/images/admin/icones/Hotel Addresses.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              addHorizontalSpace(15),
                              const Text('Hotel Addresses'),
                            ],
                          ),
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(180 / 360),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(7), // Image radius
                                child: Image.asset(
                                    'lib/assets/images/user/icones/left arrow.png',
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Container(
                  color: const Color(0xffF6F8FA),
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(20), // Image radius
                                  child: Image.asset(
                                      'lib/assets/images/admin/icones/Withdrawal History.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              addHorizontalSpace(15),
                              const Text('Order History'),
                            ],
                          ),
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(180 / 360),
                            child: GestureDetector(
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(7), // Image radius
                                  child: Image.asset(
                                      'lib/assets/images/user/icones/left arrow.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              onTap: () {
                                _navigationService.pushNamed('/orderhistory');
                              },
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         ClipOval(
                      //           child: SizedBox.fromSize(
                      //             size:
                      //                 const Size.fromRadius(20), // Image radius
                      //             child: Image.asset(
                      //                 'lib/assets/images/admin/icones/Users Details.png',
                      //                 fit: BoxFit.contain),
                      //           ),
                      //         ),
                      //         addHorizontalSpace(15),
                      //         const Text('User Details'),
                      //       ],
                      //     ),
                      //     RotationTransition(
                      //       turns: const AlwaysStoppedAnimation(180 / 360),
                      //       child: ClipOval(
                      //         child: SizedBox.fromSize(
                      //           size: const Size.fromRadius(7), // Image radius
                      //           child: Image.asset(
                      //               'lib/assets/images/user/icones/left arrow.png',
                      //               fit: BoxFit.contain),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Container(
                  color: const Color(0xffF6F8FA),
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(20), // Image radius
                                  child: Image.asset(
                                      'lib/assets/images/admin/icones/User Reviews.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              addHorizontalSpace(15),
                              const Text('User Reviews'),
                            ],
                          ),
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(180 / 360),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(7), // Image radius
                                child: Image.asset(
                                    'lib/assets/images/user/icones/left arrow.png',
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(20), // Image radius
                                  child: Image.asset(
                                      'lib/assets/images/admin/icones/FAQs.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              addHorizontalSpace(15),
                              const Text('FAQs'),
                            ],
                          ),
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(180 / 360),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(7), // Image radius
                                child: Image.asset(
                                    'lib/assets/images/user/icones/left arrow.png',
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              addHorizontalSpace(10),
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(10), // Image radius
                                  child: Image.asset(
                                      'lib/assets/images/admin/icones/Setting.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              addHorizontalSpace(22),
                              const Text('Settings'),
                            ],
                          ),
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(180 / 360),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(7), // Image radius
                                child: Image.asset(
                                    'lib/assets/images/user/icones/left arrow.png',
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                addVerticalSpace(120),
                Container(
                  color: const Color(0xffF6F8FA),
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          addHorizontalSpace(10),
                          // ClipOval(
                          //   child: SizedBox.fromSize(
                          //     size: const Size.fromRadius(10), // Image radius
                          //     child: Image.asset(
                          //         'lib/assets/images/admin/icones/logout 1.png',
                          //         fit: BoxFit.contain),
                          //   ),
                          // ),

                          GestureDetector(
                            onTap: () {
                              _auth.logout();
                              Get.snackbar('Thanks!.',
                                  'You are logged out successfully!',
                                  barBlur: 1,
                                  backgroundColor: Colors.white,
                                  margin: const EdgeInsets.all(20),
                                  duration: const Duration(seconds: 5),
                                  snackPosition: SnackPosition.BOTTOM);
                              _navigationService.pushReplacedNamed("/login");
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  size: 36,
                                  color: Colors.red,
                                ),
                                addHorizontalSpace(20),
                                const Text('Logout'),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1,
                    spreadRadius: -20,
                    offset: Offset(1.0, 0.0),
                  )
                ],
                color: Color(0xffF6F8FA),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(10), // Image radius
                      child: Image.asset(
                          'lib/assets/images/admin/navigation bar/icone.png',
                          fit: BoxFit.contain),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(10), // Image radius
                        child: Image.asset(
                            'lib/assets/images/admin/navigation bar/barger menu.png',
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(10), // Image radius
                        child: Image.asset(
                            'lib/assets/images/user/icones/add.png',
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(10), // Image radius
                        child: Image.asset(
                            'lib/assets/images/admin/navigation bar/notification.png',
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(10), // Image radius
                        child: Image.asset(
                            'lib/assets/images/admin/navigation bar/profile.png',
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
