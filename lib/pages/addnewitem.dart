import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/custom_form.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:choice/choice.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  late double _deviceHeight;
  late double _deviceWidth;
  String? _itemname;
  String? _itemdescrption;
  String? _itemrate;
  bool isLoading = false;
  String? imageurlN1 = '';
  String? imageurlN2 = '';
  String? imageurlN3 = '';
  final GetIt _getIt = GetIt.instance;
  final _additemkey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  late NavigationService _navigationService;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  bool isPickUp = false;
  bool isDelivery = false;
  List<String> choices = ['All', 'Breakfast', 'Lunch', 'Dinner'];
  String? selectedValue;
  String _selectedValuesJson = 'Nothing to show';
  late List<Ingredient> _selectedIngredients;

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
      case 3:
        setState(() {
          imageurlN3 = imageurl;
        });
        break;
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
                                const Text('Add new items'),
                              ],
                            ),
                            Text(
                              'RESET',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            )
                          ],
                        ),
                        addVerticalSpace(16.0),
                        Choice<String>.inline(
                          clearable: true,
                          value: ChoiceSingle.value(selectedValue),
                          onChanged: ChoiceSingle.onChanged(setSelectedValue),
                          itemCount: choices.length,
                          itemBuilder: (state, i) {
                            return ChoiceChip(
                              selected: state.selected(choices[i]),
                              onSelected: state.onSelected(choices[i]),
                              label: Text(choices[i]),
                              backgroundColor: Colors.white,
                              selectedColor: Colors.transparent,
                              labelStyle: TextStyle(
                                  color: selectedValue == choices[i]
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: selectedValue == choices[i]
                                      ? FontWeight.bold
                                      : FontWeight.w300),
                              checkmarkColor: Colors.amber,
                              avatarBorder: Border.all(color: Colors.black),
                              side: const BorderSide(color: Colors.transparent
                                  // Cor da borda
                                  ),
                            );
                          },
                          listBuilder: ChoiceList.createScrollable(
                            spacing: 10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 25,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ITEM NAME',
                              style: GoogleFonts.sen(
                                  textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 9, 0, 0),
                                      fontSize: 14)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: _deviceWidth * .9,
                                child: CustomFormField(
                                  onSaved: (value) {
                                    setState(() {
                                      _itemname = value;
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
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'UPLOAD PHOTO/VIDEO',
                              style: GoogleFonts.sen(
                                  textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 9, 0, 0),
                                      fontSize: 14)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                  height: _deviceWidth / 4,
                                                  width: _deviceWidth / 4,
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
                                        : CachedNetworkImage(
                                            imageUrl: imageurlN1!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: _deviceWidth / 4,
                                              height: _deviceWidth / 4,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
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
                                  ),
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
                                              height: _deviceWidth / 4,
                                              width: _deviceWidth / 4,
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
                                        : CachedNetworkImage(
                                            imageUrl: imageurlN2!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: _deviceWidth / 4,
                                              height: _deviceWidth / 4,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
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
                                  ),
                                  DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    padding: const EdgeInsets.all(6),
                                    child: imageurlN3 == ''
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: Container(
                                              height: _deviceWidth / 4,
                                              width: _deviceWidth / 4,
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
                                                      pickimage(3);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: imageurlN3!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: _deviceWidth / 4,
                                              height: _deviceWidth / 4,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RATE',
                                  style: GoogleFonts.sen(
                                      textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 9, 0, 0),
                                          fontSize: 14)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: _deviceWidth * .35,
                                    child: CustomFormField(
                                      onSaved: (value) {
                                        setState(() {
                                          _itemrate = value;
                                        });
                                      },
                                      regEx: r".{1,}",
                                      hintText: "Rs.xxx.xx",
                                      initialValue: null,
                                      obscureText: false,
                                      height: _deviceHeight * .1,
                                      keytype: TextInputType.visiblePassword,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            buildCheck(),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text('DETAILS'),
                            SizedBox(
                                width: _deviceWidth * .9,
                                height: _deviceHeight * .2,
                                child: TextFormField(
                                  onSaved: (value) {
                                    setState(() {
                                      _itemdescrption = value;
                                    });
                                  },
                                  cursorColor: Colors.green,
                                  initialValue: null,
                                  style: const TextStyle(color: Colors.black),
                                  obscureText: false,
                                  expands: false,
                                  maxLines: 8,
                                  keyboardType: TextInputType.multiline,
                                  validator: (value) {
                                    return RegExp(r".{4,}").hasMatch(value!)
                                        ? null
                                        : 'Enter a valid value.';
                                  },
                                  decoration: InputDecoration(
                                    fillColor: const Color(0xffE3EBF2),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Item Description',
                                    hintStyle: const TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ))
                          ],
                        ),
                        addVerticalSpace(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'INGREDIENTS',
                              style: GoogleFonts.sen(
                                  textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 9, 0, 0),
                                      fontSize: 14)),
                            ),
                            SingleChildScrollView(
                                child: SizedBox(
                              width: _deviceWidth * .9,
                              child: FlutterTagging<Ingredient>(
                                initialItems: _selectedIngredients,
                                textFieldConfiguration:
                                    const TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color(0xffE3EBF2),
                                    hintText: 'Type to search',
                                    labelText: 'Type to search..',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ),
                                findSuggestions: getIngredients,
                                additionCallback: (value) {
                                  // return Ingredient(
                                  //   name: value,
                                  //   position: 0,
                                  // );
                                  return Ingredient(
                                    name: value,
                                  );
                                },
                                onAdded: (language) {
                                  // api calls here, triggered when add to tag button is pressed
                                  // return Ingredient(
                                  //     name: language.name, position: -1);
                                  return Ingredient(name: language.name);
                                },
                                configureSuggestion: (lang) {
                                  return SuggestionConfiguration(
                                    title: Text(lang.name),
                                    // subtitle: Text(lang.name),
                                    additionWidget: const Chip(
                                      avatar: Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                      ),
                                      label: Text('Add New Tag'),
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                configureChip: (lang) {
                                  return ChipConfiguration(
                                    label: Text(lang.name),
                                    backgroundColor: Colors.green,
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    deleteIconColor: Colors.white,
                                  );
                                },
                                onChanged: () {
                                  setState(() {
                                    _selectedValuesJson = _selectedIngredients
                                        .map<String>(
                                            (lang) => '\n${lang.toJson()}')
                                        .toList()
                                        .toString();
                                    _selectedValuesJson = _selectedValuesJson
                                        .replaceFirst('}]', '}]');
                                  });
                                },
                              ),
                            )),
                            // addVerticalSpace(8),
                            // Text(
                            //   'VEGETABLES & GREENS',
                            //   style: GoogleFonts.sen(
                            //       textStyle: const TextStyle(
                            //           color: Color.fromARGB(255, 9, 0, 0),
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w700)),
                            // ),
                            // addVerticalSpace(8),
                            // SizedBox(
                            //   height: _deviceHeight * .35,
                            //   child: GridView.builder(
                            //     scrollDirection: Axis.vertical,
                            //     itemCount: 13,
                            //     controller: ScrollController(keepScrollOffset: false),
                            //     shrinkWrap: true,
                            //     gridDelegate:
                            //         SliverGridDelegateWithFixedCrossAxisCount(
                            //             crossAxisCount: 3,
                            //             // childAspectRatio: 22 / 30,
                            //             childAspectRatio: _deviceHeight / 400,
                            //             mainAxisSpacing: 1,
                            //             crossAxisSpacing: 1
                            //             // childAspectRatio: 1,
                            //             ),
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return SizedBox(
                            //           height: 16, child: Text("Garlic $index"));
                            //     },
                            //   ),
                            // ),
                          ],
                        ),

                        // InlineChoice<String>.single(
                        //   clearable: true,
                        //   value: selectedValue,
                        //   onChanged: setSelectedValue,
                        //   itemCount: choices.length,
                        //   itemBuilder: (state, i) {
                        //     return ChoiceChip(
                        //       selected: state.selected(choices[i]),
                        //       onSelected: state.onSelected(choices[i]),
                        //       label: Text(choices[i]),
                        //     );
                        //   },
                        //   listBuilder: ChoiceList.createWrapped(
                        //     spacing: 10,
                        //     runSpacing: 10,
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 20,
                        //       vertical: 25,
                        //     ),
                        //   ),
                        // ),
                        addVerticalSpace(16),
                        SizedBox(
                          width: _deviceWidth * .8,
                          child: ElevatedButton(
                              child: const Text("SAVE"),
                              onPressed: () async {
                                if (_additemkey.currentState!.validate()) {
                                  _additemkey.currentState!.save();
                                  bool okToProceed = _itemname != "" &&
                                      _itemname != null &&
                                      _itemdescrption != "" &&
                                      _itemdescrption != null &&
                                      imageurlN1 != "" &&
                                      imageurlN1 != null &&
                                      imageurlN2 != "" &&
                                      imageurlN2 != null &&
                                      imageurlN3 != "" &&
                                      imageurlN3 != null &&
                                      _selectedValuesJson.isNotEmpty &&
                                      _itemrate != "" &&
                                      _itemrate != null;
                                  if (kDebugMode) {
                                    print(
                                        "====== Add New FOOD ITEM DETAILS =====");
                                    print("_itemname: $_itemname");
                                    print("_itemdescrption: $_itemdescrption");
                                    print("imageurlN1: $imageurlN1");
                                    print("imageurlN2: $imageurlN2");
                                    print("imageurlN3: $imageurlN3");
                                    print("isDelivery: $isDelivery");
                                    print("isPickUp: $isPickUp");
                                    print("_itemrate: $_itemrate");
                                    print("when: $selectedValue");
                                    print(
                                        "_selectedValuesJson: $_selectedValuesJson");
                                  }
                                  if (okToProceed) {
                                    final QuerySnapshot resulta =
                                        await _firebase
                                            .collection("fooditems")
                                            .where("item_name",
                                                isEqualTo: _itemname)
                                            .get();
                                    final List<DocumentSnapshot> documents =
                                        resulta.docs;

                                    if (documents.isNotEmpty) {
                                      //exists
                                      // if (kDebugMode) {
                                      //   print('Exists');
                                      // }

                                      Get.snackbar('Oops!. ',
                                          'Item with this name already exist! Please try to add new item',
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
                                          .collection('fooditems')
                                          .doc(_itemname)
                                          .set(
                                        {
                                          "item_name": _itemname,
                                          "item_description": _itemdescrption,
                                          "imageurl1": imageurlN1,
                                          "imageurl2": imageurlN2,
                                          "imageurl3": imageurlN3,
                                          "ingredients": _selectedValuesJson,
                                          "pickup": isPickUp,
                                          "delivery": isDelivery,
                                          "rate": _itemrate,
                                          "when": selectedValue,
                                          "active": true,
                                        },
                                      );
                                      Get.snackbar('Congrats!.',
                                          'Item has been completed successfully!',
                                          barBlur: 1,
                                          backgroundColor: Colors.white,
                                          margin: EdgeInsets.all(
                                              _deviceHeight * .1),
                                          duration: const Duration(seconds: 5),
                                          snackPosition: SnackPosition.BOTTOM);
                                      _navigationService.pushNamed("/home");
                                    }
                                  } else {
                                    Get.snackbar(
                                        'Oops!. ', 'Please fill all fields',
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
                'Pick Up',
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
                'Deliver',
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
