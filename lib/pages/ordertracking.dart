import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_kitchen_2/pages/cartlists.dart';
import 'package:cloud_kitchen_2/services/navigation_service.dart';
import 'package:cloud_kitchen_2/services/utils.dart';
import 'package:cloud_kitchen_2/widgets/mycontroller.dart';
import 'package:flutter/material.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  late double _deviceWidth;
  late double _deviceHeight;
  bool isFinished = false;
  late List<Cartlists> fullCartList;

  // List<StepperData> stepperData = [
  //   StepperData(
  //       title: StepperText(
  //         "Order Placed",
  //         textStyle: const TextStyle(
  //           color: Colors.grey,
  //         ),
  //       ),
  //       subtitle: StepperText("Your order has been placed"),
  //       iconWidget: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: const BoxDecoration(
  //             color: Colors.grey,
  //             borderRadius: BorderRadius.all(Radius.circular(12))),
  //       )),
  //   StepperData(
  //       title: StepperText(
  //         "Preparing",
  //         textStyle: const TextStyle(
  //           color: Colors.grey,
  //         ),
  //       ),
  //       subtitle: StepperText("Your order is being prepared"),
  //       iconWidget: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: const BoxDecoration(
  //             color: Colors.grey,
  //             borderRadius: BorderRadius.all(Radius.circular(12))),
  //         // child: const Icon(Icons.looks_two, color: Colors.white),
  //       )),
  //   StepperData(
  //       title: StepperText("On the way"),
  //       subtitle: StepperText(
  //           "Our delivery executive is on the way to deliver your item"),
  //       iconWidget: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: const BoxDecoration(
  //             color: Colors.green,
  //             borderRadius: BorderRadius.all(Radius.circular(12))),
  //         // child: const Icon(Icons.looks_3, color: Colors.white),
  //       )),
  //   StepperData(
  //       title: StepperText("Delivered",
  //           textStyle: const TextStyle(color: Colors.grey)),
  //       iconWidget: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: const BoxDecoration(
  //             color: Colors.redAccent,
  //             borderRadius: BorderRadius.all(Radius.circular(12))),
  //       )),
  // ];
  String imageurl = 'lib/assets/images/user/icones/left arrow.png';
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  final MyController c = Get.put(MyController());

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    fullCartList = c.fullcartList;
    
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(10), // Image radius
                              child: GestureDetector(
                                child:
                                    Image.asset(imageurl, fit: BoxFit.contain),
                                onTap: () {
                                  _navigationService.goBack();
                                },
                              ),
                            ),
                          ),
                          addHorizontalSpace(15),
                          const Text('Details'),
                        ],
                      ),
                      SizedBox(
                        height: _deviceHeight * .25,
                        child: Image.asset(
                            'lib/assets/images/user/onboading/Frame 1.png',
                            fit: BoxFit.cover),
                      ),
                      SizedBox(
                        height: _deviceHeight * .45,
                        width: _deviceWidth * .9,
                        child: Card(
                          semanticContainer: false,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Adjusts column size to fit content.
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align children to the start (left)
                            children: <Widget>[
                              const Align(
                                alignment: Alignment
                                    .center, // Centers this text horizontally
                                child: Column(
                                  children: [
                                    Text(
                                      '20 Min',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'ESTIMATED DELIVERY TIME',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: SizedBox(
                                  child: AnotherStepper(
                                    stepperList: [
                                      StepperData(
                                          title: StepperText(
                                            "Order Placed",
                                            textStyle: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          subtitle: StepperText(
                                              "Your order has been placed"),
                                          iconWidget: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                          )),
                                      StepperData(
                                          title: StepperText(
                                            "Preparing",
                                            textStyle: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          subtitle: StepperText(
                                              "Your order is being prepared"),
                                          iconWidget: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                            // child: const Icon(Icons.looks_two, color: Colors.white),
                                          )),
                                      StepperData(
                                          title: StepperText("On the way"),
                                          subtitle: StepperText(
                                              "Our delivery executive is on the way to deliver your item"),
                                          iconWidget: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                            // child: const Icon(Icons.looks_3, color: Colors.white),
                                          )),
                                      StepperData(
                                          title: StepperText("Delivered",
                                              textStyle: const TextStyle(
                                                  color: Colors.grey)),
                                          iconWidget: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                          )),
                                    ],
                                    stepperDirection: Axis.vertical,
                                    iconWidth: 20,
                                    iconHeight: 20,
                                    activeBarColor: Colors.green,
                                    inActiveBarColor: Colors.grey.shade300,
                                    inverted: false,
                                    verticalGap: 25,
                                    activeIndex: 1,
                                    barThickness: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )))),
      SizedBox(
        width: _deviceWidth * .8,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blueAccent.shade400),
                foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onSurface),
                overlayColor: WidgetStateProperty.all<Color>(Colors.white)),
            onPressed: () {
              _navigationService.pushNamed("/livetracking");
            },
            child: const Text("LIVE TRACKING")),
      ),
      SizedBox(
        height: _deviceHeight * .1,
        child: Expanded(
          child: Center(
              child: SwipeableButtonView(
            buttonText: 'CALL THE DELIVERY BOY',
            buttonWidget: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
            ),
            activeColor: const Color(0xFF009C41),
            isFinished: isFinished,
            onWaitingProcess: () {
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  isFinished = true;
                });
              });
            },
            onFinish: () async {
              _navigationService.pushNamed("/home");
            },
          )
              // SwipeTo(
              //   child: Container(
              //     height: _deviceHeight * .1,
              //     width: _deviceWidth,
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              //     decoration: const BoxDecoration(
              //         color: Colors.green,
              //         borderRadius: BorderRadius.all(Radius.circular(15))),
              //     child: const Center(
              //         child: Row(
              //       children: [
              //         Icon(
              //           Icons.swipe_right,
              //           size: 50,
              //         ),
              //         Text(
              //           'CALL DELIVERY BOY',
              //           style: TextStyle(fontSize: 16),
              //         ),
              //       ],
              //     )),
              //   ),
              //   onRightSwipe: (details) {
              //     print('Callback from Swipe To Right');
              //   },
              // ),
              ),
        ),
      ),
    ])));
  }
}
