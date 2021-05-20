import 'dart:io';

import 'package:ecoscore/model/food.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'api/open_food_facts_api.dart';
import 'common/extensions.dart';
import 'common/food_widgets.dart';
import 'common/observer_state.dart';
import 'common/widgets.dart';
import 'food_detail_page.dart';
import 'model/foods_state.dart';

class ScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends ObserverState<ScanPage> {
  Barcode? result;
  QRViewController? controller;
  final _listController = ScrollController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodsState = context.watch<FoodsState>();

    return Scaffold(
      body: Stack(
        children: [
          _buildQrView(context, foodsState),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  height: FoodCard.minHeight,
                  child: AutoAnimList(
                    controller: _listController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      const Gap(96),
                      ...foodsState.scannedFoods.reversed.map((food) => Padding(
                            key: ValueKey(food),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              width: FoodCard.minWidth,
                              child: FoodCard(
                                food: food,
                                onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context, FoodsState foodsState) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    final scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 500) ? 250.0 : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        setState(() {
          this.controller = controller;
        });
        controller.scannedDataStream.listen((barcode) async {
          if (result?.code != barcode.code) {
            setState(() {
              result = barcode;
            });

            observeFuture<Food?>(OpenFoodFactsApi.getFood(barcode.code), (food) {
              if (food != null && food.name.isNotEmpty) {
                foodsState.addScannedFood(food);
                _listController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            }, onError: (_) {
              //TODO display snackbar?
            });
          }
        });
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
        cutOutBottomOffset: 48,
      ),
    );
  }
}
