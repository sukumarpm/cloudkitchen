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

import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class OrderPlaced extends StatefulWidget {
  const OrderPlaced({super.key});

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  late double _deviceWidth;
  final MyController c = Get.put(MyController());

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Kitchen'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Image(
              image: AssetImage('lib/assets/images/user/logo/LOGO.png'),
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
            'Rs.${c.finalprice} Paid',
            style: const TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            child: Icon(
              Icons.done_all_sharp,
              size: 35,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () {
              _navigationService.pushNamed("/home");
            },
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text(
              'Order placed successfully!',
              style: TextStyle(
                color: Color(0xff777777),
                fontSize: 24,
              ),
            ),
          ),
          addVerticalSpace(16),
          SizedBox(
            width: _deviceWidth * .8,
            child: ElevatedButton(
                child: const Text("HOME"),
                onPressed: () {
                  _navigationService.pushNamed("/home");
                }),
          ),
          // Example pay button configured using an asset
        ],
      ),
    );
  }
}
