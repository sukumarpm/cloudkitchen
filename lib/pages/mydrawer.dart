import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _auth;
  final MyController c = Get.put(MyController());

  @override
  void initState() {
    super.initState();
    _auth = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.lightBlue,
        child: Drawer(
          // backgroundColor: const Color.fromARGB(255, 106, 137, 249),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const DrawerHeader(
                      child: Center(
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 76,
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        _navigationService.pushNamed("/profile");
                      },
                      child: const ListTile(
                        title: Text(
                          "PROFILE",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.person_2_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       _navigationService.pushNamed("/subscription");
                  //     },
                  //     child: const ListTile(
                  //       title: Text(
                  //         "SUBSCRIPTIONS",
                  //         style: TextStyle(
                  //             color: Colors.white, fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: Icon(
                  //         Icons.monetization_on_outlined,
                  //         size: 36,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       _navigationService.pushNamed("/todayprograms");
                  //     },
                  //     child: const ListTile(
                  //       title: Text(
                  //         "TODAY'S PROGRAMMES",
                  //         style: TextStyle(
                  //             color: Colors.white, fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: Icon(
                  //         Icons.library_music_rounded,
                  //         size: 36,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  (c.isAdmin.isTrue)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            onTap: () {
                              _navigationService.pushNamed("/addmanualplans");
                            },
                            child: const ListTile(
                              title: Text(
                                "SUBSCRIBE MANUALLY",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: Icon(
                                Icons.add_business,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 20),
                  //   child: ListTile(
                  //     title: Text("S U B S C R I B E",
                  //         style: TextStyle(color: Colors.white)),
                  //     leading: Icon(Icons.home_filled),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 20),
                  //   child: ListTile(
                  //     title: Text("B I L L I N G"),
                  //     leading: Icon(Icons.home_filled),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 20),
                  //   child: ListTile(
                  //     title: Text("A C C O U N T S"),
                  //     leading: Icon(Icons.home_filled),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 20),
                  //   child: ListTile(
                  //     title: Text("A D M I N"),
                  //     leading: Icon(Icons.home_filled),
                  //   ),
                  // ),
                  (c.isAdmin.isTrue)
                      ? GestureDetector(
                          onTap: () {
                            _navigationService.pushNamed("/stations");
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: ListTile(
                              title: Text(
                                "STATIONS",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: Icon(
                                Icons.settings_applications,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 25),
                child: GestureDetector(
                  onTap: () {
                    _auth.logout();
                    Get.snackbar('Thanks!.', 'You are logged out successfully!',
                        barBlur: 1,
                        backgroundColor: Colors.white,
                        margin: const EdgeInsets.all(20),
                        duration: const Duration(seconds: 5),
                        snackPosition: SnackPosition.BOTTOM);
                    _navigationService.pushReplacedNamed("/login");
                  },
                  child: const ListTile(
                    title: Text("L O G O U T",
                        style: TextStyle(color: Colors.white)),
                    leading: Icon(
                      Icons.logout_rounded,
                      size: 36,
                      color: Colors.red,
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
}
