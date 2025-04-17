import 'dart:async';

import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class WindowController extends GetxController with WindowListener {
  final isMaximized = false.obs;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() async {
    isMaximized.value = await windowManager.isMaximized();
    windowManager.addListener(this);
  }

  @override
  void onWindowMaximize() {
    isMaximized.value = true;
  }

  @override
  void onWindowUnmaximize() {
    isMaximized.value = false;
  }

  void minimize() => unawaited(windowManager.minimize());

  void close() => unawaited(windowManager.close());

  void toggleMaximize() async {
    final max = await windowManager.isMaximized();
    if (max) {
      unawaited(windowManager.unmaximize());
    } else {
      unawaited(windowManager.maximize());
    }
  }

  @override
  void onClose() {
    windowManager.removeListener(this);
    super.onClose();
  }
}
