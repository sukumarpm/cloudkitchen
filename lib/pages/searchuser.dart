import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/mydisplay.dart';
import 'package:cloud_kitchen_2/pages/myseparator.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:choice/choice.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  late double _deviceHeight;
  late double _deviceWidth;
  String? _itemname;
  String? username = '';
  String? userphone = '';
  String? userstatus = 'Active';
  bool userexisting = false;
  String? _vehiclemodel;
  String? _vehiclenumber;
  bool isLoading = false;
  String? imageurlN1 = '';
  String? imageurlN2 = '';
  // String? imageurlN3 = '';
  final GetIt _getIt = GetIt.instance;
  final _additemkey = GlobalKey<FormState>();
  final _getuseritemkey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  late NavigationService _navigationService;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  bool isPickUp = false;
  bool isDelivery = false;
  List<String> choices = ['All', 'Breakfast', 'Lunch', 'Dinner'];
  String? selectedValue;
  bool? isUserActive;
  bool? isNamePhone = false;
  bool? isUserBlock = false;
  final String _selectedValuesJson = 'Nothing to show';

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
  }

  Future<void> pickimage(int imgnumber) async {
    if (kDebugMode) {
      print('in pickimage');
    }
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      AlertDialog(
        title: const Text('Selected!'),
        content: Text('failed to pick up image $res'),
      );
      if (res != null) {
        await uploadImageToFirebase(File(res.path), imgnumber);
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'warning',
          message: 'failed to pick up image $e',
          icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
      AlertDialog(
        title: const Text('Warning!'),
        content: Text('failed to pick up image $e'),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadImageToFirebase(File image, int imgnumber) async {
    // setState(() {
    //   isLoding = true;
    // });
    // if (kDebugMode) {
    //   print('in uploadImageToFirebase');
    // }
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("images/${DateTime.now().microsecondsSinceEpoch}.png");
    await reference.putFile(image).whenComplete(() => Get.showSnackbar(
          const GetSnackBar(
            title: 'Info',
            message: 'Image uploaded successfully',
            icon: Icon(Icons.refresh),
            duration: Duration(seconds: 3),
          ),
        ));
    String imageurl = await reference.getDownloadURL();
    // if (kDebugMode) {
    //   print('imageurlN1 - uploaded:$imageurlN1');
    // }
    switch (imgnumber) {
      case 1:
        setState(() {
          imageurlN1 = imageurl;
        });
        break;
      case 2:
        setState(() {
          imageurlN2 = imageurl;
        });
        break;
      // case 3:
      //   setState(() {
      //     imageurlN3 = imageurl;
      //   });
      //   break;
      default:
    }
    setState(() {
      isLoading = true;
    });
    // if (kDebugMode) {
    //   print('imageurl - Add station:$imageurl');
    // }
  }

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> finddriver(String? phone) async {
    print('phone:$phone');
    final QuerySnapshot resulta = await _firebase
        .collection("drivers")
        .where("userphone", isEqualTo: phone)
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
      userexisting = true;
    }
  }

  Future<void> finduser(String? phone) async {
    print('phone:$isNamePhone');
    late QuerySnapshot resulta;
    username = '';
    userphone = '';
    userstatus = 'Active';

    if (isNamePhone == false) {
      resulta = await _firebase
          .collection("customers")
          .where("name", isEqualTo: phone)
          .get();
    } else {
      resulta = await _firebase
          .collection("customers")
          .where("phone_number", isEqualTo: phone)
          .get();
    }

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
      setState(() {
        username = userData['name'];
        userphone = userData['phone_number'];
        userexisting = userData['active'];
        userstatus = userData['active'] == true ? 'Active' : 'Blocked';
      });
    }
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
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _additemkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _navigationService.goBack();
                                  },
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          10), // Image radius
                                      child: Image.asset(
                                          'lib/assets/images/user/icones/left arrow.png',
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                addHorizontalSpace(15),
                                // const Text('Add new driver'),
                                Text(
                                  'SEARCH USER',
                                  style: GoogleFonts.sen(
                                      textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 9, 0, 0),
                                          fontSize: 14)),
                                )
                              ],
                            ),
                            // Text(
                            //   'RESET',
                            //   style: TextStyle(
                            //       color:
                            //           Theme.of(context).colorScheme.tertiary),
                            // )
                          ],
                        ),
                        addVerticalSpace(16.0),
                        ToggleSwitch(
                          minWidth: 120.0,
                          initialLabelIndex: isNamePhone == true ? 1 : 0,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey.shade300,
                          inactiveFgColor: Colors.black,
                          totalSwitches: 2,
                          labels: const ['Name', 'Phone'],
                          icons: const [Icons.book_online, Icons.offline_bolt],
                          activeBgColors: const [
                            [Colors.green],
                            [Colors.green]
                          ],
                          onToggle: (index) {
                            setState(() {
                              isNamePhone = !isNamePhone!;
                              print('switched to: $isNamePhone');
                            });
                          },
                        ),
                        addVerticalSpace(8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyDisplay(
                                size: 14, text1: 'SEARCH USER ', text2: ''),
                          ],
                        ),
                        const MySeparator(color: Colors.green, dashwidth: 5),
                        Form(
                          key: _getuseritemkey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: _deviceWidth * .45,
                                      child: CustomFormField(
                                        onSaved: (value) {
                                          //print('search: $value');
                                          setState(() {
                                            _itemname = value;
                                          });
                                        },
                                        regEx: r".{3,}",
                                        hintText: !isNamePhone!
                                            ? "User Name"
                                            : "Phone Number",
                                        initialValue: null,
                                        obscureText: false,
                                        height: _deviceHeight * .1,
                                        keytype: TextInputType.name,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: const Icon(Icons.search_sharp, size: 45),
                                onTap: () async {
                                  _getuseritemkey.currentState!.save();
                                  print('_itemname:$_itemname');
                                  await finduser(_itemname);
                                  if (username != '') {
                                    if (context.mounted) {
                                      /// statements after async gap without warning
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              title: Text('Nice!'),
                                              content: Text('User Found.'),
                                            );
                                          });
                                    }
                                  } else {
                                    if (context.mounted) {
                                      /// statements after async gap without warning
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              title: Text('Oops!'),
                                              content:
                                                  Text('User does not exist.'),
                                            );
                                          });
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        addVerticalSpace(16),
                        username != ''
                            ? DottedBorder(
                                padding: const EdgeInsets.all(2),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: _deviceWidth * .6,
                                        height: _deviceHeight * .15,
                                        child: Card(
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 5,
                                            shadowColor: Colors.green,
                                            margin: const EdgeInsets.all(10),
                                            child:
                                                // Image.network(
                                                //   fooditem.imageurl1!,
                                                //   fit: BoxFit.cover,
                                                // ),
                                                Column(
                                              children: [
                                                Icon(
                                                  Icons.person_2_sharp,
                                                  size: 40,
                                                  color: Colors.green.shade400,
                                                ),
                                                Text('Name:$username!'),
                                                Text('Phone:$userphone!')
                                              ],
                                            )),
                                      ),
                                      addVerticalSpace(16.0),
                                      ToggleSwitch(
                                        minWidth: 120.0,
                                        initialLabelIndex:
                                            isUserBlock == true ? 1 : 0,
                                        cornerRadius: 20.0,
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey.shade300,
                                        inactiveFgColor: Colors.black,
                                        totalSwitches: 2,
                                        labels: const ['Block', 'Unblock'],
                                        icons: const [
                                          Icons.book_online,
                                          Icons.offline_bolt
                                        ],
                                        activeBgColors: const [
                                          [Colors.green],
                                          [Colors.green]
                                        ],
                                        onToggle: (index) {
                                          setState(() {
                                            isUserBlock = !isUserBlock!;
                                            print('switched to: $isUserBlock');
                                          });
                                        },
                                      ),
                                      addVerticalSpace(24),
                                      Text('Current Status: $userstatus'),
                                      Text(
                                        'New Status: ${isUserBlock! ? 'Active' : 'Blocked'}',
                                        style: TextStyle(
                                            color: isUserBlock!
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        addVerticalSpace(_deviceHeight * .2),
                        SizedBox(
                          width: _deviceWidth * .8,
                          child: ElevatedButton(
                              child: const Text("CONFIRM"),
                              onPressed: () async {
                                if (_additemkey.currentState!.validate()) {
                                  _additemkey.currentState!.save();
                                  bool okToProceed =
                                      userexisting != isUserBlock;
                                  if (kDebugMode) {
                                    print(
                                        "====== Add New FOOD ITEM DETAILS =====");
                                    print("userphone: $userphone");
                                    print("username: $username");
                                    print("userexisting: $userexisting");
                                    print("isUserBlock: $isUserBlock");
                                  }
                                  if (okToProceed) {
                                    //not exists
                                    // String? result = await _auth.registerUserUsingEmailAndPassword(
                                    //     emailController.text,
                                    //     passController.text,
                                    //     _phone,
                                    //     addressController.text,
                                    //     _name.text);
                                    // if (kDebugMode) {
                                    //   print('uid: $result');
                                    // }
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
                                    await _firebase
                                        .collection('customers')
                                        .doc(userphone)
                                        .update(
                                      {"active": isUserBlock},
                                    );
                                    Get.snackbar('Congrats!.',
                                        'User has been updated successfully!',
                                        barBlur: 1,
                                        backgroundColor: Colors.white,
                                        margin:
                                            EdgeInsets.all(_deviceHeight * .1),
                                        duration: const Duration(seconds: 5),
                                        snackPosition: SnackPosition.BOTTOM);
                                    _navigationService.pushNamed("/adminhome");
                                  }
                                } else {
                                  if (username == null || username == "") {
                                    Get.snackbar('Oops!. ',
                                        'Please search and find the correct user',
                                        barBlur: 1,
                                        backgroundColor: Colors.white,
                                        margin:
                                            EdgeInsets.all(_deviceHeight * .1),
                                        duration: const Duration(seconds: 5),
                                        snackPosition: SnackPosition.BOTTOM);
                                  } else {
                                    Get.snackbar('Oops!. ',
                                        'Current and New status are same',
                                        barBlur: 1,
                                        backgroundColor: Colors.white,
                                        margin:
                                            EdgeInsets.all(_deviceHeight * .1),
                                        duration: const Duration(seconds: 5),
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void updateWrapItems1(List<ColorItem> newItems) {
  //   setState(() {
  //     selectedWrapItems1 = newItems;
  //   });
  // }

  // void updateWrapItems2(List<ColorItem> newItems) {
  //   setState(() {
  //     selectedWrapItems2 = newItems;
  //   });
  // }

  // void updateWrapItems3(List<ColorItem> newItems) {
  //   setState(() {
  //     selectedWrapItems3 = newItems;
  //   });
  // }

  // Widget buildCheckboxSection1(
  //     // String title,
  //     CheckboxOrientation orientation,
  //     List<ColorItem> selectedItems,
  //     Function(List<ColorItem>) updateFunction,
  //     List<ColorItem> disabledItems) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
  //     child: Column(
  //       children: <Widget>[
  //         // Text(
  //         //   title,
  //         //   style: const TextStyle(color: Colors.blue, fontSize: 15.0),
  //         // ),
  //         GroupedCheckbox<ColorItem>(
  //           itemList: allItemList2,
  //           checkedItemList: selectedItems,
  //           disabled: disabledItems,
  //           onChanged: (itemList) {
  //             updateFunction(itemList!);
  //           },
  //           orientation: orientation,
  //           checkColor: Colors.black,
  //           activeColor: Colors.lightBlue,
  //           itemWidgetBuilder: (item) => Text(
  //             item.name,
  //             style: TextStyle(color: item.color),
  //           ),
  //         ),
  //         const SizedBox(height: 5.0),
  //         Text(
  //           'Selected Colors: ${selectedItems.map((item) => item.name).join(', ')}',
  //           style: const TextStyle(color: Colors.blue),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget buildCheckboxSection2(
  //     // String title,
  //     CheckboxOrientation orientation,
  //     List<ColorItem> selectedItems,
  //     Function(List<ColorItem>) updateFunction,
  //     List<ColorItem> disabledItems) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
  //     child: Column(
  //       children: <Widget>[
  //         // Text(
  //         //   title,
  //         //   style: const TextStyle(color: Colors.blue, fontSize: 15.0),
  //         // ),
  //         GroupedCheckbox<ColorItem>(
  //           itemList: allItemList2,
  //           checkedItemList: selectedItems,
  //           disabled: disabledItems,
  //           onChanged: (itemList) {
  //             updateFunction(itemList!);
  //           },
  //           orientation: orientation,
  //           checkColor: Colors.black,
  //           activeColor: Colors.lightBlue,
  //           itemWidgetBuilder: (item) => Text(
  //             item.name,
  //             style: TextStyle(color: item.color),
  //           ),
  //         ),
  //         const SizedBox(height: 5.0),
  //         Text(
  //           'Selected Colors: ${selectedItems.map((item) => item.name).join(', ')}',
  //           style: const TextStyle(color: Colors.blue),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget buildCheckboxSection3(
  //     // String title,
  //     CheckboxOrientation orientation,
  //     List<ColorItem> selectedItems,
  //     Function(List<ColorItem>) updateFunction,
  //     List<ColorItem> disabledItems) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
  //     child: Column(
  //       children: <Widget>[
  //         // Text(
  //         //   title,
  //         //   style: const TextStyle(color: Colors.blue, fontSize: 15.0),
  //         // ),
  //         GroupedCheckbox<ColorItem>(
  //           itemList: allItemList2,
  //           checkedItemList: selectedItems,
  //           disabled: disabledItems,
  //           onChanged: (itemList) {
  //             updateFunction(itemList!);
  //           },
  //           orientation: orientation,
  //           checkColor: Colors.black,
  //           activeColor: Colors.lightBlue,
  //           itemWidgetBuilder: (item) => Text(
  //             item.name,
  //             style: TextStyle(color: item.color),
  //           ),
  //         ),
  //         const SizedBox(height: 5.0),
  //         Text(
  //           'Selected Colors: ${selectedItems.map((item) => item.name).join(', ')}',
  //           style: const TextStyle(color: Colors.blue),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildCheck() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Checkbox(
                tristate: false,
                fillColor: const WidgetStatePropertyAll<Color>(
                    Color.fromARGB(255, 248, 251, 244)),
                value: isPickUp,
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.0, color: Colors.black54),
                ),
                checkColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    isPickUp = value!;
                  });
                },
              ),
              const Text(
                'Male',
                style: TextStyle(color: Color(0xFF9C9BA6)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                tristate: false,
                checkColor: Colors.black,
                fillColor: const WidgetStatePropertyAll<Color>(
                    Color.fromARGB(255, 248, 251, 244)),
                value: isDelivery,
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.0, color: Colors.black54),
                ),
                onChanged: (bool? value) {
                  setState(() {
                    isDelivery = value!;
                  });
                },
              ),
              const Text(
                'Female',
                style: TextStyle(color: Color(0xFF9C9BA6)),
              ),
            ],
          ),
        ],
      );
}
