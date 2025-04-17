import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/utils/window_controller.dart';
import 'package:window_manager/window_manager.dart';

class DesktopAppBar extends StatelessWidget {
  DesktopAppBar({super.key});

  final WindowController windowController = Get.find<WindowController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
        onPanStart: (details) {
          windowManager.startDragging();
        },
        onDoubleTap: () async {
          if (await windowManager.isMaximized()) {
            unawaited(windowManager.unmaximize());
          } else {
            unawaited(windowManager.maximize());
          }
        },
        child: Container(
            height: 50,
            color: theme.canvasColor,
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(children: [
                    Image.asset('assets/icons/icon.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text('Harmony Music', style: theme.textTheme.titleMedium),
                  ])),
              const Spacer(),
              Row(children: [
                // Minimize button
                WindowButton(
                    icon: Icons.remove,
                    onPressed: windowController.minimize,
                    hoverColor: Colors.grey.withValues(alpha: 0.2)),

                // Maximize button
                Obx(() => WindowButton(
                      icon: windowController.isMaximized.value
                          ? Icons.filter_none
                          : Icons.crop_square,
                      onPressed: windowController.toggleMaximize,
                      hoverColor: Colors.grey.withValues(alpha: 0.2),
                    )),

                // Close button
                WindowButton(
                    icon: Icons.close,
                    onPressed: windowController.close,
                    hoverColor: Colors.red.withValues(alpha: 0.2)),
                const SizedBox(width: 2),
              ])
            ])));
  }
}

class WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? hoverColor;

  const WindowButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.hoverColor,
  });

  @override
  State<WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<WindowButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: InkWell(
        onTap: widget.onPressed,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: 45,
          height: 45,
          color: isHovering ? widget.hoverColor : Colors.transparent,
          child: Center(
            child: Icon(widget.icon),
          ),
        ),
      ),
    );
  }
}
