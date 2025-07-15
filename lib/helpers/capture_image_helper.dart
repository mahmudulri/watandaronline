import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../global controller/languages_controller.dart';

final languagesController = Get.find<LanguagesController>();

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
          languagesController.tr("SUCCESS"),
          languagesController.tr("IMAGE_SAVED_TO_GALLERY"),
        );
      }
    }
  } catch (e) {
    print(e);
  }
}
