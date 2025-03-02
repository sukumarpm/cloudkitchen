import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/driverclass.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/services/auth_service.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class DriverList extends StatefulWidget {
  const DriverList({super.key});

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  late double _deviceHeight;
  late double _deviceWidth;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  late AuthService _auth;
  List<Driver> listdrivers = [];
  final MyController c = Get.put(MyController());
  List categoryImage = [
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Rahim',
      'phone': '+91 64719 14564',
      'bikenum': 'BH61HY9873',
    },
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Sundar',
      'phone': '+91 33433 36547',
      'bikenum': 'BH61HY9873',
    },
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Arvi',
      'phone': '+91 24556 36547',
      'bikenum': 'BH61HY9873',
    },
    // {
    //   'url': 'lib/assets/images/food/pexels-ella-olsson-572949-1640773.jpg',
    //   'title': 'Snacks',
    //   'price': '+91 64734 36547',
    // },
    {
      'url':
          'https://firebasestorage.googleapis.com/v0/b/cloudkitchen-b3d92.firebasestorage.app/o/images%2F1737685206394001.png?alt=media&token=7640cd6f-a9ab-43d3-8fcd-d5d54981ca4b',
      'name': 'Senthil',
      'phone': '+91 64719 88888',
      'bikenum': 'BH61HY9873',
    },
  ];
  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _auth = _getIt.get<AuthService>();
    listdrivers = c.driveractiveadmin;
    print('listdrivers length:${listdrivers.length}');
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(_deviceHeight * 0.025),
                child: SizedBox(
                  height: _deviceHeight * .8,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(10), // Image radius
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
                              const Text('Drivers'),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                _navigationService.pushNamed('/addnewdriver');
                              },
                              child: const Icon(Icons.add)),
                        ],
                      ),
                      addVerticalSpace(40),
                      Expanded(
                        child: ListView.separated(
                          // <-- SEE HERE
                          itemCount: listdrivers.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              // leading: CircleAvatar(
                              //   backgroundColor: const Color.fromARGB(255, 87, 87, 87),
                              //   radius: 26,
                              //   child: Text("Rs.${categoryImage.getCategory(index)}",
                              //       style: const TextStyle(
                              //           fontSize: 12, color: Colors.yellow)),
                              // ),
                              leading: ClipOval(
                                child:
                                    // (categoryImage.getImage(index) != "")
                                    //     ?
                                    // Image.network(
                                    //     categoryImage.getImage(index),
                                    //     width: 90,
                                    //     height: 70,
                                    //     fit: BoxFit.cover,
                                    //   )

                                    CachedNetworkImage(
                                  imageUrl: listdrivers[index].identidityurl!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 80.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                // : Image.asset(
                                //     'lib/assets/Images/mic1.png',
                                //   ),
                              ),
                              title: Text(listdrivers[index].name!),
                              subtitle: Text(listdrivers[index].phone!),
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.edit_note,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      Driver driverinfo = Driver(
                                        name: listdrivers[index].name,
                                        phone: listdrivers[index].phone,
                                        bikenum: listdrivers[index].bikenum,
                                        identidityurl:
                                            listdrivers[index].identidityurl,
                                        bikeurl: listdrivers[index].bikeurl,
                                        vehmodel: listdrivers[index].vehmodel,
                                        active: listdrivers[index].active,
                                      );
                                      Get.find<MyController>().driverdetails =
                                          driverinfo;
                                      _navigationService
                                          .pushNamed('/editdriver');
                                    },
                                  ),
                                  // GestureDetector(
                                  //   child: const Icon(
                                  //     Icons.delete_outline_outlined,
                                  //     color: Colors.redAccent,
                                  //     size: 30,
                                  //   ),
                                  //   onTap: () {},
                                  // ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            // <-- SEE HERE
                            return const MySeparator(color: Colors.green);
                          },
                        ),
                      ),
                      Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
