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

class AddNewDriver extends StatefulWidget {
  const AddNewDriver({super.key});

  @override
  State<AddNewDriver> createState() => _AddNewDriverState();
}

class _AddNewDriverState extends State<AddNewDriver> {
  late double _deviceHeight;
  late double _deviceWidth;
  String? _itemname;
  String? drivername = '';
  String? driverphone = '';
  bool driverexisting = false;
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
  final String _selectedValuesJson = 'Nothing to show';
  late List<Ingredient> _selectedIngredients;

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
  }

  Future<void> pickimage(int imgnumber) async {
    // if (kDebugMode) {
    //   print('in pickimage');
    // }
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
    _selectedIngredients = [];
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  void dispose() {
    _selectedIngredients.clear();
    super.dispose();
  }

  Future<void> finddriver(String? phone) async {
    //print('phone:$phone');
    final QuerySnapshot resulta = await _firebase
        .collection("drivers")
        .where("driverphone", isEqualTo: phone)
        .get();

    List<Object?> data = resulta.docs.map((e) {
      return e.data();
    }).toList();
    if (kDebugMode) {
      //print('data:${data.toString()}');
    }

    // final List<DocumentSnapshot> documents = resulta.docs;
    // if (documents.isNotEmpty) {
    if (data.isNotEmpty) {
      driverexisting = true;
    }
  }

  Future<void> finduser(String? phone) async {
    print('phone:$phone');
    final QuerySnapshot resulta = await _firebase
        .collection("customers")
        .where("phone_number", isEqualTo: phone)
        .get();

    List<Object?> data = resulta.docs.map((e) {
      return e.data();
    }).toList();
    if (kDebugMode) {
      //print('data:${data.toString()}');
    }

    // final List<DocumentSnapshot> documents = resulta.docs;
    // if (documents.isNotEmpty) {
    if (data.isNotEmpty) {
      Map<dynamic, dynamic> userData = data[0] as Map;
      setState(() {
        drivername = userData['name'];
        driverphone = userData['phone_number'];
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
                                  'ADD DRIVER',
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
                                          print('search: $value');
                                          setState(() {
                                            _itemname = value;
                                          });
                                        },
                                        regEx: r".{3,}",
                                        hintText: "Driver Phone number",
                                        initialValue: null,
                                        obscureText: false,
                                        height: _deviceHeight * .1,
                                        keytype: TextInputType.visiblePassword,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: const Icon(Icons.search_sharp, size: 45),
                                onTap: () async {
                                  _getuseritemkey.currentState!.save();
                                  //print('_itemname:$_itemname');
                                  await finddriver(_itemname);

                                  if (!driverexisting) {
                                    await finduser(_itemname);
                                    if (drivername != '') {
                                      if (context.mounted) {
                                        /// statements after async gap without warning
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const AlertDialog(
                                                title: Text('Nice!'),
                                                content: Text('Driver Found.'),
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
                                                content: Text(
                                                    'Driver does not exist.'),
                                              );
                                            });
                                      }
                                    }
                                  } else {
                                    if (context.mounted) {
                                      /// statements after async gap without warning
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              title: Text('Oops!'),
                                              content: Text(
                                                  'This user is already added as Driver. Please try with another user'),
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
                        drivername != ''
                            ? DottedBorder(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'DRIVER',
                                          style: GoogleFonts.sen(
                                              textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 9, 0, 0),
                                                  fontSize: 14)),
                                        ),
                                        addHorizontalSpace(_deviceWidth * .2),
                                        SizedBox(
                                          width: _deviceWidth * .5,
                                          child: Text(drivername!),
                                        ),
                                      ],
                                    ),
                                    addVerticalSpace(8),
                                    Row(
                                      children: [
                                        Text(
                                          'PHONE',
                                          style: GoogleFonts.sen(
                                              textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 9, 0, 0),
                                                  fontSize: 14)),
                                        ),
                                        addHorizontalSpace(_deviceWidth * .2),
                                        SizedBox(
                                          width: _deviceWidth * .6,
                                          child: Text(driverphone!),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        addVerticalSpace(24),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: [
                        //     Text(
                        //       'UPLOAD ID & VEHICLE PHOTO',
                        //       style: GoogleFonts.sen(
                        //           textStyle: const TextStyle(
                        //               color: Color.fromARGB(255, 9, 0, 0),
                        //               fontSize: 14)),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceAround,
                        //         children: [
                        //           DottedBorder(
                        //             borderType: BorderType.RRect,
                        //             radius: const Radius.circular(12),
                        //             padding: const EdgeInsets.all(6),
                        //             child: imageurlN1 == ''
                        //                 ? (!isLoading
                        //                     ? ClipRRect(
                        //                         borderRadius:
                        //                             const BorderRadius.all(
                        //                                 Radius.circular(12)),
                        //                         child: Container(
                        //                           height: _deviceWidth / 4,
                        //                           width: _deviceWidth / 4,
                        //                           color: Colors.white,
                        //                           child: GestureDetector(
                        //                             onTap: () => {},
                        //                             child: CircleAvatar(
                        //                               backgroundColor:
                        //                                   Colors.blue,
                        //                               radius: 10,
                        //                               child: IconButton(
                        //                                 padding:
                        //                                     EdgeInsets.zero,
                        //                                 icon: const Icon(Icons
                        //                                     .cloud_upload_outlined),
                        //                                 color: Colors.white,
                        //                                 onPressed: () {
                        //                                   pickimage(1);
                        //                                 },
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       )
                        //                     : Container(
                        //                         height: MediaQuery.of(context)
                        //                                 .size
                        //                                 .height *
                        //                             .2,
                        //                         width: double.infinity,
                        //                         decoration: const BoxDecoration(
                        //                           border: Border(
                        //                             top: BorderSide(
                        //                                 color:
                        //                                     Color(0xFF7F7F7F)),
                        //                             left: BorderSide(
                        //                                 color:
                        //                                     Color(0xFF7F7F7F)),
                        //                             right: BorderSide(
                        //                                 color:
                        //                                     Color(0xFF7F7F7F)),
                        //                             bottom: BorderSide(
                        //                                 color:
                        //                                     Color(0xFF7F7F7F)),
                        //                           ),
                        //                         ),
                        //                         child: const Align(
                        //                             alignment: Alignment.center,
                        //                             child: Text('MAP AREA')),
                        //                       ))
                        //                 : CachedNetworkImage(
                        //                     imageUrl: imageurlN1!,
                        //                     imageBuilder:
                        //                         (context, imageProvider) =>
                        //                             Container(
                        //                       width: _deviceWidth / 4,
                        //                       height: _deviceWidth / 4,
                        //                       decoration: BoxDecoration(
                        //                         shape: BoxShape.circle,
                        //                         color: Colors.black,
                        //                         image: DecorationImage(
                        //                             image: imageProvider,
                        //                             fit: BoxFit.cover),
                        //                       ),
                        //                     ),
                        //                     placeholder: (context, url) =>
                        //                         const CircularProgressIndicator(),
                        //                     errorWidget:
                        //                         (context, url, error) =>
                        //                             const Icon(
                        //                       Icons.error,
                        //                       color: Colors.black,
                        //                     ),
                        //                   ),
                        //           ),
                        //           DottedBorder(
                        //             borderType: BorderType.RRect,
                        //             radius: const Radius.circular(12),
                        //             padding: const EdgeInsets.all(6),
                        //             child: imageurlN2 == ''
                        //                 ? ClipRRect(
                        //                     borderRadius:
                        //                         const BorderRadius.all(
                        //                             Radius.circular(12)),
                        //                     child: Container(
                        //                       height: _deviceWidth / 4,
                        //                       width: _deviceWidth / 4,
                        //                       color: Colors.white,
                        //                       child: GestureDetector(
                        //                         onTap: () => {},
                        //                         child: CircleAvatar(
                        //                           backgroundColor: Colors.blue,
                        //                           radius: 10,
                        //                           child: IconButton(
                        //                             padding: EdgeInsets.zero,
                        //                             icon: const Icon(Icons
                        //                                 .cloud_upload_outlined),
                        //                             color: Colors.white,
                        //                             onPressed: () {
                        //                               pickimage(2);
                        //                             },
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   )
                        //                 : CachedNetworkImage(
                        //                     imageUrl: imageurlN2!,
                        //                     imageBuilder:
                        //                         (context, imageProvider) =>
                        //                             Container(
                        //                       width: _deviceWidth / 4,
                        //                       height: _deviceWidth / 4,
                        //                       decoration: BoxDecoration(
                        //                         shape: BoxShape.circle,
                        //                         color: Colors.black,
                        //                         image: DecorationImage(
                        //                             image: imageProvider,
                        //                             fit: BoxFit.cover),
                        //                       ),
                        //                     ),
                        //                     placeholder: (context, url) =>
                        //                         const CircularProgressIndicator(),
                        //                     errorWidget:
                        //                         (context, url, error) =>
                        //                             const Icon(
                        //                       Icons.error,
                        //                       color: Colors.black,
                        //                     ),
                        //                   ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyDisplay(
                                size: 14,
                                text1: 'UPLOAD VERIFICATION DOCUMENTS ',
                                text2: ''),
                          ],
                        ),
                        const MySeparator(color: Colors.green, dashwidth: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const MyDisplay(
                              size: 14,
                              color: Colors.black,
                              text1: 'DRIVER IDENTITY',
                              text2: '',
                            ),

                            // Text(
                            //   'DRIVER IDENTITY',
                            //   style: GoogleFonts.sen(
                            //       textStyle: const TextStyle(
                            //           color: Color.fromARGB(255, 9, 0, 0),
                            //           fontSize: 14)),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    padding: const EdgeInsets.all(6),
                                    child: imageurlN1 == ''
                                        ? (!isLoading
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12)),
                                                child: Container(
                                                  height: _deviceWidth * .3,
                                                  width: _deviceWidth * .3,
                                                  color: Colors.white,
                                                  child: GestureDetector(
                                                    onTap: () => {},
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      radius: 10,
                                                      child: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        icon: const Icon(Icons
                                                            .cloud_upload_outlined),
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          pickimage(1);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .2,
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color:
                                                            Color(0xFF7F7F7F)),
                                                    left: BorderSide(
                                                        color:
                                                            Color(0xFF7F7F7F)),
                                                    right: BorderSide(
                                                        color:
                                                            Color(0xFF7F7F7F)),
                                                    bottom: BorderSide(
                                                        color:
                                                            Color(0xFF7F7F7F)),
                                                  ),
                                                ),
                                                child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text('MAP AREA')),
                                              ))
                                        : Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: imageurlN1!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: _deviceWidth * .8,
                                                  height: _deviceWidth / 2,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(Icons
                                                    .cloud_upload_outlined),
                                                color: Colors.black,
                                                onPressed: () {
                                                  pickimage(1);
                                                },
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Text(
                            //   'VEHICLE',
                            //   style: GoogleFonts.sen(
                            //       textStyle: const TextStyle(
                            //           color: Color.fromARGB(255, 9, 0, 0),
                            //           fontSize: 14)),
                            // ),
                            const MyDisplay(
                              size: 14,
                              color: Colors.black,
                              text1: 'VEHICLE',
                              text2: '',
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    padding: const EdgeInsets.all(6),
                                    child: imageurlN2 == ''
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: Container(
                                              height: _deviceWidth * .3,
                                              width: _deviceWidth * .3,
                                              color: Colors.white,
                                              child: GestureDetector(
                                                onTap: () => {},
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  radius: 10,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(Icons
                                                        .cloud_upload_outlined),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      pickimage(2);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: imageurlN2!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: _deviceWidth * .8,
                                                  height: _deviceWidth / 2,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(Icons
                                                    .cloud_upload_outlined),
                                                color: Colors.black,
                                                onPressed: () {
                                                  pickimage(2);
                                                },
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // addVerticalSpace(16),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyDisplay(
                                  size: 14,
                                  color: Colors.black,
                                  text1: 'VEHICLE DETAILS',
                                  text2: '',
                                ),

                                MySeparator(color: Colors.green, dashwidth: 5),
                                // Text(
                                //   'VEHICLE DETAILS',
                                //   style: GoogleFonts.sen(
                                //       textStyle: const TextStyle(
                                //           color: Color.fromARGB(255, 9, 0, 0),
                                //           fontSize: 14)),
                                // ),
                              ],
                            ),
                            //buildCheck(),
                          ],
                        ),
                        addVerticalSpace(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                ),
                                const MyDisplay(
                                  size: 12,
                                  color: Colors.black,
                                  text1: 'MODEL',
                                  text2: '',
                                ),
                                // Text(
                                //   'MODEL',
                                //   style: GoogleFonts.sen(
                                //       textStyle: const TextStyle(
                                //           color:
                                //               Color.fromARGB(255, 112, 98, 98),
                                //           fontSize: 14)),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: _deviceWidth * .35,
                                    child: CustomFormField(
                                      onSaved: (value) {
                                        setState(() {
                                          _vehiclemodel = value;
                                        });
                                      },
                                      regEx: r".{1,}",
                                      hintText: "TN XX XXXX",
                                      initialValue: null,
                                      obscureText: false,
                                      height: _deviceHeight * .1,
                                      keytype: TextInputType.visiblePassword,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const MyDisplay(
                                  size: 12,
                                  color: Colors.black,
                                  text1: 'NUMBER',
                                  text2: '',
                                ),
                                // Text(
                                //   'NUMBER',
                                //   style: GoogleFonts.sen(
                                //       textStyle: const TextStyle(
                                //           color:
                                //               Color.fromARGB(255, 112, 98, 98),
                                //           fontSize: 14)),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: _deviceWidth * .35,
                                    child: CustomFormField(
                                      onSaved: (value) {
                                        setState(() {
                                          _vehiclenumber = value;
                                        });
                                      },
                                      regEx: r".{1,}",
                                      hintText: "TN XX XXXX",
                                      initialValue: null,
                                      obscureText: false,
                                      height: _deviceHeight * .1,
                                      keytype: TextInputType.visiblePassword,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        addVerticalSpace(16),
                        SizedBox(
                          width: _deviceWidth * .8,
                          child: ElevatedButton(
                              child: const Text("SAVE"),
                              onPressed: () async {
                                if (_additemkey.currentState!.validate()) {
                                  _additemkey.currentState!.save();
                                  bool okToProceed = driverphone != "" &&
                                      drivername != null &&
                                      drivername != "" &&
                                      driverphone != null &&
                                      imageurlN1 != "" &&
                                      imageurlN1 != null &&
                                      imageurlN2 != "" &&
                                      imageurlN2 != null &&
                                      // imageurlN3 != "" &&
                                      // imageurlN3 != null &&
                                      _vehiclenumber != "" &&
                                      _vehiclenumber != null &&
                                      _vehiclemodel != "" &&
                                      _vehiclemodel != null;
                                  if (kDebugMode) {
                                 print(
                                        "====== Add New FOOD ITEM DETAILS =====");
                                    print("driverphone: $driverphone");
                                    print("drivername: $drivername");
                                    print("imageurlN1: $imageurlN1");
                                    print("imageurlN2: $imageurlN2");
                                    // print("imageurlN3: $imageurlN3");
                                    print("isDelivery: $isDelivery");
                                    print("isPickUp: $isPickUp");
                                    print("_vehiclemodel: $_vehiclemodel");
                                    print("_vehiclenumber: $_vehiclenumber");
                                    print("when: $selectedValue");
                                    print(
                                        "_selectedValuesJson: $_selectedValuesJson");
                                  }
                                  if (okToProceed) {
                                    final QuerySnapshot resulta =
                                        await _firebase
                                            .collection("drivers")
                                            .where("driverphone",
                                                isEqualTo: driverphone)
                                            .get();
                                    final List<DocumentSnapshot> documents =
                                        resulta.docs;

                                    if (documents.isNotEmpty) {
                                      //exists
                                      // if (kDebugMode) {
                                      //   print('Exists');
                                      // }

                                      Get.snackbar('Oops!. ',
                                          'Item with this name already exist! Please try to add new driver',
                                          barBlur: 1,
                                          backgroundColor: Colors.white,
                                          margin: EdgeInsets.all(
                                              _deviceHeight * .1),
                                          duration: const Duration(seconds: 5),
                                          snackPosition: SnackPosition.BOTTOM);
                                    } else {
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
                                          .collection('drivers')
                                          .doc(driverphone)
                                          .set(
                                        {
                                          "driver_name": drivername,
                                          "driverphone": driverphone,
                                          "imageurl1": imageurlN1,
                                          "imageurl2": imageurlN2,
                                          // "imageurl3": imageurlN3,
                                          "vehicle_model": _vehiclemodel,
                                          "vehicle_number": _vehiclenumber,
                                          "active": true,
                                        },
                                      );
                                      Get.snackbar('Congrats!.',
                                          'Driver has been added successfully!',
                                          barBlur: 1,
                                          backgroundColor: Colors.white,
                                          margin: EdgeInsets.all(
                                              _deviceHeight * .1),
                                          duration: const Duration(seconds: 5),
                                          snackPosition: SnackPosition.BOTTOM);
                                      _navigationService
                                          .pushNamed("/adminhome");
                                    }
                                  } else {
                                    if (drivername == null ||
                                        drivername == "") {
                                      Get.snackbar('Oops!. ',
                                          'Please search and find the user to make him/her as Driver',
                                          barBlur: 1,
                                          backgroundColor: Colors.white,
                                          margin: EdgeInsets.all(
                                              _deviceHeight * .1),
                                          duration: const Duration(seconds: 5),
                                          snackPosition: SnackPosition.BOTTOM);
                                    } else {
                                      Get.snackbar(
                                          'Oops!. ', 'Please fill all fields',
                                          barBlur: 1,
                                          backgroundColor: Colors.white,
                                          margin: EdgeInsets.all(
                                              _deviceHeight * .1),
                                          duration: const Duration(seconds: 5),
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
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

class ColorItem {
  String name;
  Color color;

  ColorItem(this.name, this.color);
}

/// Mocks fetching language from network API with delay of 500ms.
Future<List<Ingredient>> getIngredients(String query) async {
  await Future.delayed(const Duration(milliseconds: 500), null);
  return <Ingredient>[
    // const Ingredient(name: 'Rice', position: 1),
    // const Ingredient(name: 'Chicken', position: 2),
    // const Ingredient(name: 'Muuton', position: 3),
    // const Ingredient(name: 'Beaf', position: 4),
    // const Ingredient(name: 'Fish', position: 5),
    // const Ingredient(name: 'Garam Masala', position: 6),
    const Ingredient(name: 'Rice'),
    const Ingredient(name: 'Chicken'),
    const Ingredient(name: 'Muuton'),
    const Ingredient(name: 'Beaf'),
    const Ingredient(name: 'Fish'),
    const Ingredient(name: 'Garam Masala'),
  ]
      .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

/// Ingredient Class
class Ingredient extends Taggable {
  ///
  final String name;

  ///
  // final int position;

  /// Creates Ingredient
  const Ingredient({
    required this.name,
    // required this.position,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": "$name"
  }''';
}
