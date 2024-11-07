import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:watandaronline/controllers/language_controller.dart';

final LanguageController languageController = Get.put(LanguageController());

GlobalKey catpureKey = GlobalKey();

Future<void> capturePng() async {
  try {
    RenderRepaintBoundary boundary =
        catpureKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    if (boundary != null) {
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Save to gallery
        final result = await ImageGallerySaver.saveImage(pngBytes,
            quality: 100, name: "screenshot");
        print(result);
        Get.snackbar(
          languageController.alllanguageData.value.languageData!["SUCCESS"]
              .toString(),
          languageController
              .alllanguageData.value.languageData!["SAVED_IMAGE_TO_GALLERY"]
              .toString(),
        );
      }
    }
  } catch (e) {
    print(e);
  }
}
