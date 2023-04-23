// import 'dart:async';
// import 'package:collectibles/presentation/common_wid/common.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../utils/constant_data/app_colors.dart';

// enum NetworkStatus { online, offline }

// ValueNotifier<bool> isInternetConnectedValueNotifier =
//     ValueNotifier<bool>(false);

// bool dilogShow = false;

// class NetworkStatusService {
//   StreamController<NetworkStatus> networkStatusController =
//       StreamController<NetworkStatus>();
//   Connectivity connectivity = Connectivity();

//   NetworkStatusService() {
//     // check coonectivity

//     connectivity.checkConnectivity().then((value) {
//       if (value == ConnectivityResult.none) {
//         isInternetConnectedValueNotifier.value = false;
//       } else {
//         isInternetConnectedValueNotifier.value = true;
//       }
//     });

//     connectivity.onConnectivityChanged.listen((status) {
//       networkStatusController.add(_getNetworkStatus(status));

//       if (status == ConnectivityResult.mobile ||
//           status == ConnectivityResult.wifi) {
//         isInternetConnectedValueNotifier.value = true;

//         _showDialog(false);
//       } else {
//         isInternetConnectedValueNotifier.value = false;

//         _showDialog(true);
//       }
//     });
//   }

//   NetworkStatus _getNetworkStatus(ConnectivityResult status) {
//     return status == ConnectivityResult.mobile ||
//             status == ConnectivityResult.wifi
//         ? NetworkStatus.online
//         : NetworkStatus.offline;
//   }

//   static Future<bool> checkInternet() async {
//     ConnectivityResult net = await Connectivity().checkConnectivity();

//     if (net == ConnectivityResult.none) {
//       await _showDialog(true);
//     } else {
//       await _showDialog(false);
//     }

//     return true;
//   }
// }

// // dialog func

// Future<void> _showDialog(bool active) async {
//   if (active == false) {
//     if (isInternetConnectedValueNotifier.value == true &&
//         Get.isDialogOpen == true) {
//       Get.back();
//     }
//   } else {
//     if (isInternetConnectedValueNotifier.value == false &&
//         Get.isDialogOpen == false) {
//       await _noInternetDialog();
//     }
//   }
// }

// // no internet dialog

// ValueNotifier<bool> reTryLoading = ValueNotifier<bool>(false);

// Future<void> _noInternetDialog() async {
//   await Get.defaultDialog(
//       onWillPop: () => backPressExit(),
//       barrierDismissible: false,
//       title: "",
//       titlePadding: const EdgeInsets.all(0),
//       content: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.white,
//         ),
//         child: Column(
//           // direction: Axis.vertical,
//           // crossAxisAlignment: WrapCrossAlignment.center,
//           children: [
//             Icon(
//               Icons.wifi_off,
//               size: Get.width * 0.2,
//               color: Colors.grey,
//             ),
//             SizedBox(
//               height: Get.height * 0.02,
//             ),
//             Text(
//               "No Internet!",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                   fontSize: Get.width * 0.05),
//             ),
//             SizedBox(
//               height: Get.height * 0.02,
//             ),
//             Text(
//               "Please check internet connection!",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                   fontSize: Get.width * 0.04),
//             ),
//             SizedBox(
//               height: Get.height * 0.03,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 reTryLoading.value = true;
//                 await Future.delayed(const Duration(seconds: 2), () {});
//                 reTryLoading.value = false;
//               },
//               child: Container(
//                   color: AppColors.primary,
//                   width: Get.width * 0.5,
//                   height: Get.height * 0.06,
//                   alignment: Alignment.center,
//                   child: ValueListenableBuilder<bool>(
//                       valueListenable: reTryLoading,
//                       builder: (_, data, child) {
//                         return Text(
//                           data ? "Loading..." : "RETRY",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               fontSize: Get.width * 0.04),
//                         );
//                       })),
//             )
//           ],
//         ),
//       ));
// }
