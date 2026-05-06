import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../../core/utils/app_texts.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.explore360Title.tr()),
        automaticallyImplyLeading: true,
      ),
      body: ModelViewer(
        backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: 'assets/images/medium_house.glb',
        alt: AppTexts.explore360Alt.tr(),
        ar: true,
        arModes: const ['scene-viewer', 'webxr', 'quick-look'],
        autoRotate: true,
        cameraControls: true,
        disableZoom: false,
      ),
    );
  }
}
