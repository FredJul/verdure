import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:dartx/dartx.dart';
import 'package:ecoscore/api/open_food_facts_api.dart';
import 'package:ecoscore/common/auto_anim_list.dart';
import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/common/food_widgets.dart';
import 'package:ecoscore/model/food_repository.dart';
import 'package:ecoscore/model/providers.dart';
import 'package:ecoscore/screens/food_detail_page.dart';
import 'package:ecoscore/translations/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'scanner_line.dart';
import 'scanner_utils.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final foodRepository = ref.watch(foodRepositoryProvider).data;

        return foodRepository == null ? Container() : ScanWidget(foodRepository.value);
      },
    );
  }
}

class ScanWidget extends StatefulWidget {
  const ScanWidget(this._foodRepository);

  final FoodRepository _foodRepository;

  @override
  State<StatefulWidget> createState() => _ScanWidgetState();
}

class _ScanWidgetState extends State<ScanWidget> {
  Barcode? result;
  CameraController? _cameraController;
  final BarcodeDetector _barcodeDetector =
      GoogleVision.instance.barcodeDetector(BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.ean8 | BarcodeFormat.ean13));
  final _listController = ScrollController();
  bool flashEnabled = false;

  @override
  void initState() {
    super.initState();

    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();

    _barcodeDetector.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraController?.value.isInitialized == true)
            NativeDeviceOrientationReader(
              builder: (context) {
                final nativeOrientation = NativeDeviceOrientationReader.orientation(context);
                var deviceOrientation = DeviceOrientation.portraitUp;
                switch (nativeOrientation) {
                  case NativeDeviceOrientation.portraitDown:
                    deviceOrientation = DeviceOrientation.portraitDown;
                    break;
                  case NativeDeviceOrientation.landscapeLeft:
                    deviceOrientation = DeviceOrientation.landscapeRight; // Don't know why it is inversed...
                    break;
                  case NativeDeviceOrientation.landscapeRight:
                    deviceOrientation = DeviceOrientation.landscapeLeft; // Don't know why it is inversed...
                    break;
                  default:
                    break;
                }

                // Block camera rotation on small screens (smartphones) since the whole UI may be blocked as well
                _cameraController?.lockCaptureOrientation(deviceOrientation);

                return Center(
                  child: CameraPreview(
                    _cameraController!,
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) => _onViewFinderTap(details, constraints),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          const ScannerLine(),
          AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(
                  flashEnabled ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (_cameraController != null) {
                    await _cameraController?.setFlashMode(flashEnabled ? FlashMode.off : FlashMode.torch);
                    if (mounted) {
                      setState(() {
                        flashEnabled = !flashEnabled;
                      });
                    }
                  }
                },
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 64),
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
                                ...scannedFoods.value.reversed.map(
                                  (food) => Padding(
                                    key: ValueKey(food),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: SizedBox(
                                      width: FoodCard.minWidth,
                                      child: FoodCard(
                                        food: food,
                                        onTap: () => context.pushScreen(FoodDetailPage(food: food)),
                                      ),
                                    ),
                                  ),
                                ),
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

  void _onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    _cameraController?.setExposurePoint(offset);
    _cameraController?.setFocusPoint(offset);
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      _cameraController = CameraController(
        cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.back),
        Platform.isAndroid ? ResolutionPreset.high : ResolutionPreset.medium,
        enableAudio: false,
      );

      // If the controller is updated then update the UI.
      _cameraController?.addListener(() {
        if (mounted) setState(() {});
      });

      await _cameraController!.initialize();

      // We wait a bit to smooth the screen transition
      await Future<void>.delayed(500.milliseconds);

      if (mounted) {
        await _startStreamingImagesToScanner();
      }
    } on CameraException catch (_) {}
  }

  Future<void> _startStreamingImagesToScanner() async {
    bool isDetecting = false;
    var now = DateTime.now().millisecondsSinceEpoch;

    await _cameraController?.startImageStream((CameraImage image) {
      if (isDetecting || DateTime.now().millisecondsSinceEpoch < now + 500) {
        return;
      }

      isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _barcodeDetector.detectInImage,
        imageRotation: _cameraController?.description.sensorOrientation ?? 0,
      ).then((List<Barcode> barcodes) async {
        final barcode = barcodes.firstOrNull;
        if (mounted && barcode != null && barcode.rawValue != null && result?.rawValue != barcode.rawValue) {
          HapticFeedback.selectionClick();

          setState(() {
            result = barcode;
          });

          try {
            final food = await OpenFoodFactsApi.getFood(barcode.rawValue!);
            if (mounted && food != null && food.name.isNotEmpty) {
              widget._foodRepository.addScannedFood(food);
              _listController.animateTo(0, duration: 300.milliseconds, curve: Curves.easeInOut);
            }
          } catch (_) {
            if (mounted) {
              final snackBar = SnackBar(content: Text(Translation.current.searchError));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        }
      }).whenComplete(() {
        isDetecting = false;
        now = DateTime.now().millisecondsSinceEpoch;
      });
    });
  }
}
