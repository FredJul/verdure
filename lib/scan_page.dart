import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'api/open_food_facts_api.dart';
import 'common/auto_anim_list.dart';
import 'common/extensions.dart';
import 'common/food_widgets.dart';
import 'common/observer_state.dart';
import 'food_detail_page.dart';
import 'model/food.dart';
import 'model/providers.dart';

class ScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends ObserverState<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final _listController = ScrollController();

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
    return Scaffold(
      body: Stack(
        children: [
          _buildQrView(context),
          AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  height: FoodCard.minHeight,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final scannedFoods = ref.watch(scannedFoodsProvider).data;

                      return scannedFoods == null
                          ? Container()
                          : AutoAnimList(
                              controller: _listController,
                              scrollDirection: Axis.horizontal,
                              children: [
                                const Gap(96),
                                ...scannedFoods.value.reversed.map((food) => Padding(
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
                            );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final foodRepository = ref.watch(foodRepositoryProvider).data;

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
                    foodRepository?.value.addScannedFood(food);
                    _listController.animateTo(0, duration: 300.milliseconds, curve: Curves.easeInOut);
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
      },
    );
  }
}
