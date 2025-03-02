// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/pages/vendorclass.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:cloud_kitchen_2/services/payment_configuration.dart'
    as payment_configurations;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';

class PayMaterialApp extends StatelessWidget {
  const PayMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pay for Flutter Demo',
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
        Locale('de', ''),
      ],
      home: PaySampleApp(),
    );
  }
}

class PaySampleApp extends StatefulWidget {
  const PaySampleApp({super.key});

  @override
  State<PaySampleApp> createState() => _PaySampleAppState();
}

class _PaySampleAppState extends State<PaySampleApp> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  late String total;
  final MyController c = Get.put(MyController());
  late Map<dynamic, dynamic> userdata;
  late List listCarts = [];
  late List listCartsH = [];
  List<VendorSource> listVendorSource = [];

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
    total = c.finalprice;
    userdata = c.profiledata;
    listVendorSource = c.allvendordata;
    // var jsonMap =
    //     c.profiledata['order_history'].map((e) => e.fromJson()).toList();
    // listCarts.add(jsonMap);
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
    debugPrint('in');
  }

  Future<void> onApplePayResult(paymentResult) async {
    debugPrint(paymentResult.toString());
    debugPrint('out');
    var jsonMap = c.fullcartList.map((e) => e.toJson()).toList();
    listCarts.add(jsonMap);
    print(jsonMap);
    // var jsonMapA = c.profiledata['order_history']
    //     .map((e) => Cartlists.fromJson(e))
    //     .toList();
    // late List<Cartlists> cardItem = [];
    // cardItem = c.profiledata['order_history']
    //     .map((e) => cardItem.add(Cartlists(
    //           title: e.title!,
    //           price: e.price!,
    //           qty: e.qty,
    //           url: e.url!,
    //         )))
    //     .toList();
    // print(jsonMapA);
    // var jsonMapB = jsonMapA.map((e) => e.toJson()).toList();
    // listCartsH.add(jsonMapB);
    // print(jsonMapB);
    final VendorSource vendorSource = listVendorSource[0];
    // await FirebaseFirestore.instance
    //     .collection('customers')
    //     .doc(userdata['phone_number'].toString())
    //     .update({"order_latest": jsonMapB, "status": "Open"});
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    final databaseReference = FirebaseFirestore.instance;
    final created = DateTime.now().millisecondsSinceEpoch;
    final orderId = "O$created";
    databaseReference
        .collection('orders')
        // .doc(userdata['phone_number'].toString())
        // .collection(formatted)
        .doc()
        .set(
      {
        "items": jsonMap,
        "status": "Open",
        "user_id": userdata['phone_number'].toString(),
        "order_id": orderId,
        "order_date": formatted,
        "vendor": vendorSource.name,
        "total_amount": double.parse(total)
      },
    );

    // FirebaseFirestore.instance
    //     .collection('orders')
    //     .doc(userdata['phone_number'].toString())
    //     .set(
    //   {"order": jsonMap, "status": "Open", "vendor": vendorSource.name},
    // );
    _navigationService.pushNamed("/orderplaced");
  }

  @override
  Widget build(BuildContext context) {
    List<PaymentItem> paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: total,
        status: PaymentItemStatus.final_price,
      )
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
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
                      const Text('Payment Options'),
                    ],
                  ),
                  addVerticalSpace(16.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: const Image(
                            image: AssetImage(
                                'lib/assets/images/user/logo/LOGO.png'),
                            height: 350,
                          ),
                        ),
                        const Text(
                          'Sura' 's Kitchen',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff333333),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          total,
                          style: const TextStyle(
                            color: Color(0xff777777),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff333333),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'You are about to make the google pay for the above mentioned amount. Kindly verify before proceeding.',
                          style: TextStyle(
                            color: Color(0xff777777),
                            fontSize: 15,
                          ),
                        ),
                        // Example pay button configured using an asset
                        FutureBuilder<PaymentConfiguration>(
                            future: _googlePayConfigFuture,
                            builder: (context, snapshot) => snapshot.hasData
                                ? GooglePayButton(
                                    paymentConfiguration: snapshot.data!,
                                    paymentItems: paymentItems,
                                    type: GooglePayButtonType.buy,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    onPaymentResult: onGooglePayResult,
                                    loadingIndicator: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const Text('Set up error')),
                        // Example pay button configured using a string
                        ApplePayButton(
                          paymentConfiguration:
                              payment_configurations.defaultApplePayConfig,
                          paymentItems: paymentItems,
                          style: ApplePayButtonStyle.black,
                          type: ApplePayButtonType.buy,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: onApplePayResult,
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(height: 15)
                      ],
                    ),
                  ),
                ]),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
